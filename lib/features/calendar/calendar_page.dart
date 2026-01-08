import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, StatefulBuilder;
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import 'dart:convert';

import '../animal/animal_list_page.dart';
import '../../common/db/app_database.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart'; // dbProvider 가져오기

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  late final AppDatabase _db;
  final _uuid = const Uuid();

  // 기타 기록 태그 목록
  static const List<String> _miscTags = ['탈피', '건강', '배변', '기타'];
  String _tagFromMeta(String? metaJson) {
    if (metaJson == null || metaJson.isEmpty) return '기타';

    try {
      final map = jsonDecode(metaJson) as Map<String, dynamic>;
      final tag = map['tag']?.toString();
      return (tag == null || tag.isEmpty) ? '기타' : tag;
    } catch (_) {
      return '기타';
    }
  }

  DateTime _focused = DateTime.now();
  DateTime? _selected;

  // 개체 목록 + 현재 선택된 개체 (null = 전체)
  List<Animal> _animals = [];
  String? _selectedAnimalId;

  @override
  void initState() {
    super.initState();
    _db = ref.read(dbProvider);
    _loadAnimals();
  }

  Future<void> _loadAnimals() async {
    final animals = await (_db.select(_db.animals)
          ..where((t) => t.active.equals(true)))
        .get();

    setState(() {
      _animals = animals;
      // 선택돼 있던 아이가 없으면 전체로
      if (_selectedAnimalId != null &&
          !_animals.any((a) => a.id == _selectedAnimalId)) {
        _selectedAnimalId = null;
      }
    });
  }

  @override
  void dispose() {
    // dbProvider 가 관리하므로 close 안 함
    super.dispose();
  }

  Animal? _findAnimalById(String? id) {
    if (id == null) return null;
    try {
      return _animals.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 선택한 날짜 + 선택된 개체에 대한 급여 기록
  Stream<List<Feeding>> _watchFeedingsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final startIso = start.toIso8601String();
    final endIso = end.toIso8601String();

    final query = _db.select(_db.feedings)
      ..where((t) {
        final base = t.at.isBetweenValues(startIso, endIso);
        if (_selectedAnimalId != null) {
          return base & t.animalId.equals(_selectedAnimalId!);
        }
        return base;
      })
      ..orderBy([
        (t) => drift.OrderingTerm(expression: t.at),
      ]);

    return query.watch();
  }

  /// 선택한 날짜 + 선택된 개체에 대한 청소 기록
  Stream<List<CageCleaning>> _watchCleaningsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final startIso = start.toIso8601String();
    final endIso = end.toIso8601String();

    final query = _db.select(_db.cageCleanings)
      ..where((t) {
        final base = t.at.isBetweenValues(startIso, endIso);
        if (_selectedAnimalId != null) {
          return base & t.animalId.equals(_selectedAnimalId!);
        }
        return base;
      })
      ..orderBy([
        (t) => drift.OrderingTerm(expression: t.at),
      ]);

    return query.watch();
  }

  /// 선택한 날짜 + 선택된 개체에 대한 케어 기록
  Stream<List<CareLog>> _watchCareLogsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    final startIso = start.toIso8601String();
    final endIso = end.toIso8601String();

    final q = (_db.select(_db.careLogs)
          ..where((t) => t.at.isBetweenValues(startIso, endIso)));

    // 개체 선택 필터가 있으면 같이 적용
    if (_selectedAnimalId != null) {
      q.where((t) => t.animalId.equals(_selectedAnimalId!));
    }

    // 시간 순 정렬
    q.orderBy([(t) => drift.OrderingTerm(expression: t.at, mode: drift.OrderingMode.desc)]);

    return q.watch();
  }



  /// 상단 필터용 개체 선택 select 박스
  Future<void> _showAnimalFilterSheet() async {
    if (_animals.isEmpty) return;

    final result = await showCupertinoModalPopup<String>(
      context: context,
      builder: (ctx) {
        return CupertinoActionSheet(
          title: const Text('개체 선택'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(ctx).pop('ALL'),
              child: const Text('전체'),
            ),
            for (final a in _animals)
              CupertinoActionSheetAction(
                onPressed: () => Navigator.of(ctx).pop(a.id),
                child: Text(a.name),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('취소'),
          ),
        );
      },
    );

    if (result == null) return; // 취소
    setState(() {
      _selectedAnimalId = result == 'ALL' ? null : result;
    });
  }

  /// 급여 추가 시트 (개체를 시트 안에서 선택)
Future<void> _showAddFeedingSheet(DateTime date) async {
  final foodCtrl = TextEditingController(text: '귀뚜라미');
  final amountCtrl = TextEditingController(text: '5');
  final noteCtrl = TextEditingController();
  String unit = '마리';

 // ✅ 개체가 없으면 안내 후, 바깥 탭으로도 닫히도록
  if (_animals.isEmpty) {
    await showCupertinoDialog(
      context: context,
      barrierDismissible: true, // 🔹 바깥 영역 탭하면 닫힘
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('개체가 없어요'),
        content: const Text('먼저 개체 관리 화면에서 도마뱀을 등록해 주세요.'),
        actions: [
          // 그냥 닫기
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('닫기'),
          ),
          // 개체 관리 화면으로 이동하고 싶으면 이런 버튼도 가능
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(ctx).pop(); // 다이얼로그 닫고
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (_) => AnimalListPage(),
                ),
              );
            },
            child: const Text('개체 등록하러 가기'),
          ),
        ],
      ),
    );
    return;
  }

  // 처음 열 때 기본 선택: 현재 필터 개체 or 첫 번째 개체
  String selectedAnimalId = _selectedAnimalId ?? _animals.first.id;

  await showCupertinoModalPopup(
    context: context,
    builder: (ctx) {
      final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
      final size = MediaQuery.of(ctx).size;

      return AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: StatefulBuilder(
            builder: (ctx, setStateSheet) {
              final selectedAnimalName = _animals
                  .firstWhere(
                    (a) => a.id == selectedAnimalId,
                    orElse: () => _animals.first,
                  )
                  .name;

              return SafeArea(
                top: false,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Container(
                    width: size.width,
                    color: CupertinoColors.systemBackground,
                    child: SingleChildScrollView(
                      // 키보드 올라와도 스크롤 가능
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 상단 바
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 36,
                                  height: 4,
                                  margin:
                                      const EdgeInsets.only(bottom: 8, top: 4),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey3,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),

                            // 제목
                            Center(
                              child: Text(
                                DateFormat.yMMMd('ko_KR').format(date),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 개체 선택
                            const Text(
                              '개체',
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                final result =
                                    await showCupertinoModalPopup<String>(
                                  context: ctx,
                                  builder: (ctx2) {
                                    return CupertinoActionSheet(
                                      title: const Text('개체 선택'),
                                      actions: [
                                        for (final a in _animals)
                                          CupertinoActionSheetAction(
                                            onPressed: () =>
                                                Navigator.of(ctx2).pop(a.id),
                                            child: Text(a.name),
                                          ),
                                      ],
                                      cancelButton:
                                          CupertinoActionSheetAction(
                                        onPressed: () =>
                                            Navigator.of(ctx2).pop(),
                                        child: const Text('취소'),
                                      ),
                                    );
                                  },
                                );

                                if (result != null) {
                                  setStateSheet(() {
                                    selectedAnimalId = result;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey5,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedAnimalName,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const Icon(
                                      CupertinoIcons.chevron_down,
                                      size: 18,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),
                            const Text(
                              '먹이 종류',
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CupertinoTextField(
                              controller: foodCtrl,
                              placeholder: '예: 귀뚜라미, 두비아',
                            ),

                            const SizedBox(height: 12),
                            const Text(
                              '수량',
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CupertinoTextField(
                              controller: amountCtrl,
                              keyboardType: const TextInputType
                                  .numberWithOptions(decimal: true),
                              placeholder: '예: 5',
                            ),

                            const SizedBox(height: 12),
                            const Text(
                              '단위',
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CupertinoSegmentedControl<String>(
                              groupValue: unit,
                              children: const {
                                '마리': Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text('마리'),
                                ),
                                '개수': Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text('개수'),
                                ),
                                'g': Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text('g'),
                                ),
                                'ml': Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text('ml'),
                                ),
                              },
                              onValueChanged: (v) {
                                setStateSheet(() {
                                  unit = v;
                                });
                              },
                            ),

                            const SizedBox(height: 12),
                            const Text(
                              '메모 (선택)',
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CupertinoTextField(
                              controller: noteCtrl,
                              placeholder: '예: 칼슘 같이 급여, 식욕 좋음 등',
                              maxLines: 2,
                            ),

                            const SizedBox(height: 20),

                            // 버튼들
                            Row(
                              children: [
                                Expanded(
                                  child: CupertinoButton(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    color: CupertinoColors.systemGrey5,
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text(
                                      '취소',
                                      style: TextStyle(
                                        color: CupertinoColors.label,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CupertinoButton.filled(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    onPressed: () async {
                                      final amount =
                                          double.tryParse(
                                                  amountCtrl.text.trim()) ??
                                              0;
                                      final now = DateTime.now();
                                      final at = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                        now.hour,
                                        now.minute,
                                      );

                                      await _db
                                          .into(_db.feedings)
                                          .insert(
                                            FeedingsCompanion.insert(
                                              id: _uuid.v4(),
                                              animalId: selectedAnimalId,
                                              at: at.toIso8601String(),
                                              foodType: drift.Value(
                                                  foodCtrl.text.trim()),
                                              amount: drift.Value(amount),
                                              unit: drift.Value(unit),
                                              supplements:
                                                  const drift.Value(null),
                                              note: drift.Value(
                                                noteCtrl.text
                                                        .trim()
                                                        .isEmpty
                                                    ? null
                                                    : noteCtrl.text.trim(),
                                              ),
                                            ),
                                          );

                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text('저장'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );

  foodCtrl.dispose();
  amountCtrl.dispose();
  noteCtrl.dispose();
}

/// 급여 수정 시트 (등록 UI 동일 + 날짜 변경 가능)
Future<void> _showEditFeedingSheet(Feeding feeding) async {
  final foodCtrl = TextEditingController(text: feeding.foodType ?? '');
  final amountCtrl =
      TextEditingController(text: (feeding.amount ?? 0).toString());
  final noteCtrl = TextEditingController(text: feeding.note ?? '');
  String unit = feeding.unit ?? '마리';

  DateTime originalAt =
      DateTime.tryParse(feeding.at) ?? DateTime.now();
  DateTime selectedDate =
      DateTime(originalAt.year, originalAt.month, originalAt.day);

  if (_animals.isEmpty) return;

  String selectedAnimalId = feeding.animalId;
  if (!_animals.any((a) => a.id == selectedAnimalId)) {
    selectedAnimalId = _animals.first.id;
  }

  await showCupertinoModalPopup(
    context: context,
    builder: (ctx) {
      final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
      final size = MediaQuery.of(ctx).size;

      return AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: StatefulBuilder(
            builder: (ctx, setStateSheet) {
              final selectedAnimalName = _animals
                  .firstWhere(
                    (a) => a.id == selectedAnimalId,
                    orElse: () => _animals.first,
                  )
                  .name;

              return SafeArea(
                top: false,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Container(
                    width: size.width,
                    color: CupertinoColors.systemBackground,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 36,
                                  height: 4,
                                  margin:
                                      const EdgeInsets.only(bottom: 8, top: 4),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey3,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                            Center(
                              child: Text(
                                DateFormat.yMMMd('ko_KR').format(selectedDate),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 날짜 선택
                            const Text(
                              '날짜',
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                DateTime tempDate = selectedDate;

                                await showCupertinoModalPopup(
                                  context: context,
                                  builder: (pickerCtx) {
                                    return Container(
                                      color: CupertinoColors.systemBackground,
                                      height: 260,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 200,
                                            child: CupertinoDatePicker(
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                              initialDateTime: selectedDate,
                                              maximumDate: DateTime.now(),
                                              onDateTimeChanged: (d) {
                                                tempDate = d;
                                              },
                                            ),
                                          ),
                                          CupertinoButton(
                                            child: const Text('완료'),
                                            onPressed: () {
                                              Navigator.of(pickerCtx).pop();
                                              setStateSheet(() {
                                                selectedDate = tempDate;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey5,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat.yMMMd('ko_KR')
                                          .format(selectedDate),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const Icon(
                                      CupertinoIcons.calendar,
                                      size: 18,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // 개체 선택
                            const Text(
                              '개체',
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                final result =
                                    await showCupertinoModalPopup<String>(
                                  context: ctx,
                                  builder: (ctx2) {
                                    return CupertinoActionSheet(
                                      title: const Text('개체 선택'),
                                      actions: [
                                        for (final a in _animals)
                                          CupertinoActionSheetAction(
                                            onPressed: () =>
                                                Navigator.of(ctx2).pop(a.id),
                                            child: Text(a.name),
                                          ),
                                      ],
                                      cancelButton:
                                          CupertinoActionSheetAction(
                                        onPressed: () =>
                                            Navigator.of(ctx2).pop(),
                                        child: const Text('취소'),
                                      ),
                                    );
                                  },
                                );

                                if (result != null) {
                                  setStateSheet(() {
                                    selectedAnimalId = result;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey5,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedAnimalName,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const Icon(
                                      CupertinoIcons.chevron_down,
                                      size: 18,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),
                            const Text(
                              '먹이 종류',
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CupertinoTextField(
                              controller: foodCtrl,
                              placeholder: '예: 귀뚜라미, 두비아',
                            ),

                            const SizedBox(height: 12),
                            const Text(
                              '수량',
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CupertinoTextField(
                              controller: amountCtrl,
                              keyboardType: const TextInputType
                                  .numberWithOptions(decimal: true),
                              placeholder: '예: 5',
                            ),

                            const SizedBox(height: 12),
                            const Text(
                              '단위',
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CupertinoSegmentedControl<String>(
                              groupValue: unit,
                              children: const {
                                '마리': Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text('마리'),
                                ),
                                '개수': Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text('개수'),
                                ),
                                'g': Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text('g'),
                                ),
                                'ml': Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text('ml'),
                                ),
                              },
                              onValueChanged: (v) {
                                setStateSheet(() {
                                  unit = v;
                                });
                              },
                            ),

                            const SizedBox(height: 12),
                            const Text(
                              '메모 (선택)',
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CupertinoTextField(
                              controller: noteCtrl,
                              placeholder: '예: 칼슘 같이 급여, 식욕 좋음 등',
                              maxLines: 2,
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Expanded(
                                  child: CupertinoButton(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    color: CupertinoColors.systemGrey5,
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text(
                                      '취소',
                                      style: TextStyle(
                                        color: CupertinoColors.label,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CupertinoButton.filled(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    onPressed: () async {
                                      final amount =
                                          double.tryParse(
                                                  amountCtrl.text.trim()) ??
                                              0;

                                      final updatedAt = DateTime(
                                        selectedDate.year,
                                        selectedDate.month,
                                        selectedDate.day,
                                        originalAt.hour,
                                        originalAt.minute,
                                        originalAt.second,
                                      );

                                      await (_db.update(_db.feedings)
                                            ..where((t) =>
                                                t.id.equals(feeding.id)))
                                          .write(
                                        FeedingsCompanion(
                                          animalId:
                                              drift.Value(selectedAnimalId),
                                          foodType: drift.Value(
                                              foodCtrl.text.trim()),
                                          amount: drift.Value(amount),
                                          unit: drift.Value(unit),
                                          note: drift.Value(
                                            noteCtrl.text
                                                    .trim()
                                                    .isEmpty
                                                ? null
                                                : noteCtrl.text.trim(),
                                          ),
                                          at: drift.Value(
                                              updatedAt.toIso8601String()),
                                        ),
                                      );

                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text('저장'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );

  foodCtrl.dispose();
  amountCtrl.dispose();
  noteCtrl.dispose();
}

/// 케이지 청소 기록 추가 시트
Future<void> _showAddCleaningSheet(DateTime date) async {
  final noteCtrl = TextEditingController();
  String cleaningType = 'full'; // 예: 'full', 'spot', 'water' 같은 값

 // ✅ 개체가 없으면 안내 후, 바깥 탭으로도 닫히도록
  if (_animals.isEmpty) {
    await showCupertinoDialog(
      context: context,
      barrierDismissible: true, // 🔹 바깥 영역 탭하면 닫힘
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('개체가 없어요'),
        content: const Text('먼저 개체 관리 화면에서 도마뱀을 등록해 주세요.'),
        actions: [
          // 그냥 닫기
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('닫기'),
          ),
          // 개체 관리 화면으로 이동하고 싶으면 이런 버튼도 가능
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(ctx).pop(); // 다이얼로그 닫고
              Navigator.of(context).pushNamed('/animals'); // ✏️ 실제 라우트 이름으로 변경
            },
            child: const Text('개체 등록하러 가기'),
          ),
        ],
      ),
    );
    return;
  }

  // 기본 선택 개체: 현재 필터 개체 또는 첫 번째 개체
  String selectedAnimalId = _selectedAnimalId ?? _animals.first.id;

  await showCupertinoModalPopup(
    context: context,
    builder: (ctx) {
      // 🔹 키보드 높이
      final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;

      return Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: StatefulBuilder(
          builder: (ctx, setStateSheet) {
            final selectedAnimalName = _animals
                .firstWhere(
                  (a) => a.id == selectedAnimalId,
                  orElse: () => _animals.first,
                )
                .name;

            return CupertinoActionSheet(
              title: Text(
                DateFormat.yMMMd('ko_KR').format(date),
              ),

              // 🔹 여기 전체를 스크롤 가능 + 최대 높이 제한
              message: ConstrainedBox(
                constraints: BoxConstraints(
                  // 화면 높이의 45% 정도만 사용 (원하면 숫자 조절)
                  maxHeight: MediaQuery.of(ctx).size.height * 0.45,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // 개체 선택
                      const Text(
                        '개체',
                        style: TextStyle(
                          fontSize: 13,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                      const SizedBox(height: 4),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          final result =
                              await showCupertinoModalPopup<String>(
                            context: ctx,
                            builder: (ctx2) {
                              return CupertinoActionSheet(
                                title: const Text('개체 선택'),
                                actions: [
                                  for (final a in _animals)
                                    CupertinoActionSheetAction(
                                      onPressed: () =>
                                          Navigator.of(ctx2).pop(a.id),
                                      child: Text(a.name),
                                    ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  onPressed: () =>
                                      Navigator.of(ctx2).pop(),
                                  child: const Text('취소'),
                                ),
                              );
                            },
                          );

                          if (result != null) {
                            setStateSheet(() {
                              selectedAnimalId = result;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey5,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedAnimalName,
                                style: const TextStyle(fontSize: 15),
                              ),
                              const Icon(
                                CupertinoIcons.chevron_down,
                                size: 18,
                                color: CupertinoColors.systemGrey,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      const Text(
                        '청소 종류',
                        style: TextStyle(
                          fontSize: 13,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                      const SizedBox(height: 4),
                      CupertinoSegmentedControl<String>(
                        groupValue: cleaningType,
                        children: const {
                          'full': Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text('전체 청소'),
                          ),
                          'spot': Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text('부분 청소'),
                          ),
                          'water': Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text('물 교체'),
                          ),
                        },
                        onValueChanged: (v) {
                          setStateSheet(() {
                            cleaningType = v;
                          });
                        },
                      ),

                      const SizedBox(height: 12),
                      const Text(
                        '메모 (선택)',
                        style: TextStyle(
                          fontSize: 13,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                      const SizedBox(height: 4),
                      CupertinoTextField(
                        controller: noteCtrl,
                        placeholder: '예: 바닥재 전체 교체, 유목 세척 등',
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),

              actions: [
                CupertinoActionSheetAction(
                  onPressed: () async {
                    final now = DateTime.now();
                    final at = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      now.hour,
                      now.minute,
                    );

                    await _db.into(_db.cageCleanings).insert(
                          CageCleaningsCompanion.insert(
                            id: const Uuid().v4(),
                            animalId: selectedAnimalId,
                            at: at.toIso8601String(),
                            type: cleaningType, // ✅ 그냥 String
                            note: drift.Value(
                              noteCtrl.text.trim().isEmpty
                                  ? null
                                  : noteCtrl.text.trim(),
                            ),
                          ),
                        );

                    Navigator.of(ctx).pop(); // 시트 닫기
                  },
                  isDefaultAction: true,
                  child: const Text('저장'),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('취소'),
              ),
            );
          },
        ),
      );
    },
  );

  noteCtrl.dispose();
}

/// 케이지 청소 기록 수정 시트 (추가 UI와 동일한 스타일)
Future<void> _showEditCleaningSheet(CageCleaning cleaning) async {
  final noteCtrl = TextEditingController(text: cleaning.note ?? '');
  String cleaningType = cleaning.type; // 'full' | 'spot' | 'water'

  // 기존 날짜/시간
  DateTime originalAt = DateTime.tryParse(cleaning.at) ?? DateTime.now();
  DateTime selectedDate =
      DateTime(originalAt.year, originalAt.month, originalAt.day);

  // 개체 없으면 수정 불가
  if (_animals.isEmpty) return;

  // 기본 개체 선택 (기록에 저장된 animalId)
  String selectedAnimalId = cleaning.animalId;
  if (!_animals.any((a) => a.id == selectedAnimalId)) {
    selectedAnimalId = _animals.first.id;
  }

  await showCupertinoModalPopup(
    context: context,
    builder: (ctx) {
      final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
      final size = MediaQuery.of(ctx).size;

      return AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: StatefulBuilder(
            builder: (ctx, setStateSheet) {
              final selectedAnimalName = _animals
                  .firstWhere(
                    (a) => a.id == selectedAnimalId,
                    orElse: () => _animals.first,
                  )
                  .name;

              return SafeArea(
                top: false,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Container(
                    width: size.width,
                    color: CupertinoColors.systemBackground,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 상단 바
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 36,
                                  height: 4,
                                  margin:
                                      const EdgeInsets.only(bottom: 8, top: 4),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey3,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),

                            // 제목(선택된 날짜)
                            Center(
                              child: Text(
                                DateFormat.yMMMd('ko_KR').format(selectedDate),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 날짜 선택
                            const Text(
                              '날짜',
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                DateTime tempDate = selectedDate;

                                await showCupertinoModalPopup(
                                  context: context,
                                  builder: (pickerCtx) {
                                    return Container(
                                      color: CupertinoColors.systemBackground,
                                      height: 260,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 200,
                                            child: CupertinoDatePicker(
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                              initialDateTime: selectedDate,
                                              maximumDate: DateTime.now(),
                                              onDateTimeChanged: (d) {
                                                tempDate = d;
                                              },
                                            ),
                                          ),
                                          CupertinoButton(
                                            child: const Text('완료'),
                                            onPressed: () {
                                              Navigator.of(pickerCtx).pop();
                                              setStateSheet(() {
                                                selectedDate = tempDate;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey5,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat.yMMMd('ko_KR')
                                          .format(selectedDate),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const Icon(
                                      CupertinoIcons.calendar,
                                      size: 18,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // 개체 선택
                            const Text(
                              '개체',
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                final result =
                                    await showCupertinoModalPopup<String>(
                                  context: ctx,
                                  builder: (ctx2) {
                                    return CupertinoActionSheet(
                                      title: const Text('개체 선택'),
                                      actions: [
                                        for (final a in _animals)
                                          CupertinoActionSheetAction(
                                            onPressed: () =>
                                                Navigator.of(ctx2).pop(a.id),
                                            child: Text(a.name),
                                          ),
                                      ],
                                      cancelButton:
                                          CupertinoActionSheetAction(
                                        onPressed: () =>
                                            Navigator.of(ctx2).pop(),
                                        child: const Text('취소'),
                                      ),
                                    );
                                  },
                                );

                                if (result != null) {
                                  setStateSheet(() {
                                    selectedAnimalId = result;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey5,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedAnimalName,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const Icon(
                                      CupertinoIcons.chevron_down,
                                      size: 18,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // 청소 종류
                            const Text(
                              '청소 종류',
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CupertinoSegmentedControl<String>(
                              groupValue: cleaningType,
                              children: const {
                                'full': Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text('전체 청소'),
                                ),
                                'spot': Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text('부분 청소'),
                                ),
                                'water': Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text('물 교체'),
                                ),
                              },
                              onValueChanged: (v) {
                                setStateSheet(() {
                                  cleaningType = v;
                                });
                              },
                            ),

                            const SizedBox(height: 12),

                            // 메모
                            const Text(
                              '메모 (선택)',
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CupertinoTextField(
                              controller: noteCtrl,
                              placeholder: '예: 바닥재 교체, 유목 세척 등',
                              maxLines: 2,
                            ),

                            const SizedBox(height: 20),

                            // 버튼들
                            Row(
                              children: [
                                Expanded(
                                  child: CupertinoButton(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    color: CupertinoColors.systemGrey5,
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text(
                                      '취소',
                                      style: TextStyle(
                                        color: CupertinoColors.label,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CupertinoButton.filled(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    onPressed: () async {
                                      // 시간은 유지하고 날짜만 교체
                                      final updatedAt = DateTime(
                                        selectedDate.year,
                                        selectedDate.month,
                                        selectedDate.day,
                                        originalAt.hour,
                                        originalAt.minute,
                                        originalAt.second,
                                      );

                                      await (_db.update(_db.cageCleanings)
                                            ..where((t) =>
                                                t.id.equals(cleaning.id)))
                                          .write(
                                        CageCleaningsCompanion(
                                          animalId:
                                              drift.Value(selectedAnimalId),
                                          at: drift.Value(
                                            updatedAt.toIso8601String(),
                                          ),
                                          type: drift.Value(cleaningType),
                                          note: drift.Value(
                                            noteCtrl.text.trim().isEmpty
                                                ? null
                                                : noteCtrl.text.trim(),
                                          ),
                                        ),
                                      );

                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text('저장'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );

  noteCtrl.dispose();
}

/// 개체 선택 팝업 (기타 기록 시, 필요 시에만)
Future<String?> _pickAnimalIdIfNeeded(BuildContext context) async {
  if (_selectedAnimalId != null) return _selectedAnimalId;

  // 전체 기록 모드면 선택 팝업
  String? pickedId;

  await showCupertinoModalPopup(
    context: context,
    builder: (ctx) => CupertinoActionSheet(
      title: const Text('개체 선택'),
      message: const Text('기타 기록을 추가할 개체를 선택해 주세요.'),
      actions: _animals.map((a) {
        return CupertinoActionSheetAction(
          onPressed: () {
            pickedId = a.id;
            Navigator.of(ctx).pop();
          },
          child: Text(a.name),
        );
      }).toList(),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(ctx).pop(),
        child: const Text('취소'),
      ),
    ),
  );

  return pickedId;
}

/// 기타 기록 추가 시트
Future<void> _showAddMiscLogSheet(DateTime selectedDay) async {
  final animalId = await _pickAnimalIdIfNeeded(context);
  if (animalId == null) return;

  final titleCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  String selectedTag = _miscTags.first; // 기본: 탈피

  DateTime selectedAt = DateTime(
    selectedDay.year,
    selectedDay.month,
    selectedDay.day,
    DateTime.now().hour,
    DateTime.now().minute,
  );

  await showCupertinoModalPopup(
    context: context,
    builder: (ctx) {
      final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
      return StatefulBuilder(
        builder: (ctx, setModalState) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Container(
              decoration: const BoxDecoration(
                color: CupertinoColors.systemGroupedBackground,
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 헤더
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '기타 기록 추가',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('닫기'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // 태그
                    const Text(
                      '태그',
                      style: TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _miscTags.map((t) {
                        final isSel = selectedTag == t;
                        return GestureDetector(
                          onTap: () => setModalState(() => selectedTag = t),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSel ? CupertinoColors.activeBlue.withOpacity(0.12) : CupertinoColors.white,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: isSel ? CupertinoColors.activeBlue : CupertinoColors.separator,
                              ),
                            ),
                            child: Text(
                              t,
                              style: TextStyle(
                                fontSize: 13,
                                color: isSel ? CupertinoColors.activeBlue : CupertinoColors.label,
                                fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),

                    // 시간
                    const Text(
                      '시간',
                      style: TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel),
                    ),
                    const SizedBox(height: 6),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        await showCupertinoModalPopup(
                          context: ctx,
                          builder: (timeCtx) => Container(
                            height: 260,
                            color: CupertinoColors.systemBackground,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 200,
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.time,
                                    initialDateTime: selectedAt,
                                    onDateTimeChanged: (d) {
                                      selectedAt = DateTime(
                                        selectedDay.year,
                                        selectedDay.month,
                                        selectedDay.day,
                                        d.hour,
                                        d.minute,
                                      );
                                    },
                                  ),
                                ),
                                CupertinoButton(
                                  onPressed: () {
                                    Navigator.of(timeCtx).pop();
                                    setModalState(() {});
                                  },
                                  child: const Text('완료'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat.Hm('ko_KR').format(selectedAt)),
                          const Icon(CupertinoIcons.time, size: 18, color: CupertinoColors.systemGrey),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 제목(선택)
                    const Text(
                      '제목(선택)',
                      style: TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel),
                    ),
                    const SizedBox(height: 6),
                    CupertinoTextField(
                      controller: titleCtrl,
                      placeholder: '예: 탈피 완료 / 컨디션 좋아 보임',
                    ),
                    const SizedBox(height: 12),

                    // 내용
                    const Text(
                      '내용',
                      style: TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel),
                    ),
                    const SizedBox(height: 6),
                    CupertinoTextField(
                      controller: noteCtrl,
                      placeholder: '간단한 메모를 남겨주세요',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 14),

                    // 저장 버튼
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                        onPressed: () async {
                          final title = titleCtrl.text.trim();
                          final note = noteCtrl.text.trim();

                          if (note.isEmpty && title.isEmpty) {
                            // 아무것도 안 쓰면 저장 안 함
                            Navigator.of(ctx).pop();
                            return;
                          }

                          // metaJson에는 일단 tag만 저장(나중에 확장)
                          final metaJson = '{"tag":"$selectedTag"}';

                          await _db.into(_db.careLogs).insert(
                                CareLogsCompanion.insert(
                                  id: _uuid.v4(),
                                  animalId: animalId,
                                  at: selectedAt.toIso8601String(),
                                  type: 'misc',
                                  title: drift.Value(title.isEmpty ? null : title),
                                  note: drift.Value(note.isEmpty ? null : note),
                                  metaJson: drift.Value(metaJson),
                                ),
                              );

                          if (ctx.mounted) Navigator.of(ctx).pop();
                        },
                        child: const Text('저장'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );

  titleCtrl.dispose();
  noteCtrl.dispose();
}

/// 기록 타입 선택 메소드 (급여/청소)
Future<void> _showAddRecordTypeSheet(DateTime date) async {
  await showCupertinoModalPopup(
    context: context,
    builder: (ctx) {
      return CupertinoActionSheet(
        title: const Text('어떤 기록을 추가할까요?'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(ctx).pop();
              _showAddFeedingSheet(date);
            },
            child: const Text('급여 기록'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(ctx).pop();
              _showAddCleaningSheet(date);
            },
            child: const Text('케이지 청소'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(ctx).pop();
              _showAddMiscLogSheet(date);
            },
            child: const Text('기타 기록'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('취소'),
        ),
      );
    },
  );
}


  Widget _buildDayCell(
    DateTime day, {
    bool isSelected = false,
    bool isToday = false,
  }) {
    final isOutside = day.month != _focused.month;
    final textColor = isOutside
        ? Colors.grey.shade400
        : CupertinoColors.label;

    // 오늘/선택된 날 스타일
    BoxDecoration? decoration;
    if (isSelected) {
      decoration = const BoxDecoration(
        color: CupertinoColors.activeBlue,
        shape: BoxShape.circle,
      );
    } else if (isToday) {
      decoration = BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: CupertinoColors.activeBlue,
          width: 1.7,
        ),
      );
    }

    return FutureBuilder<List<FeedingWithAnimal>>(
      future: _db.feedingsWithAnimalFor(day),
      builder: (context, snapshot) {
        final list = snapshot.data ?? const [];

        // 색깔만 추출
        final colors = list
            .map((e) => e.animal?.colorValue)
            .where((v) => v != null)
            .map((v) => Color(v!))
            .toList();

        final maxDots = 3;
        final displayColors = colors.take(maxDots).toList();

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 날짜 UI (기존 유지)
            Container(
              width: 32,
              height: 32,
              decoration: decoration,
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected
                      ? CupertinoColors.white
                      : textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),

            // 색상 점들
            if (colors.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 최대 3개만 표시
                    for (final c in displayColors)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        width: 8,
                        height: 3,
                        decoration: BoxDecoration(
                          color: c,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                    // 남은 색상 수 표시
                    if (colors.length > maxDots)
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text(
                          '∙∙∙',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        );

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = DateFormat.yMMMM('ko_KR').format(_focused);
    final selectedDay = _selected ?? DateTime.now();
    final currentAnimalName =
        _findAnimalById(_selectedAnimalId)?.name;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,  // ← 이 줄 추가
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 32,
              child: const Icon(CupertinoIcons.chevron_left),
              onPressed: () {
                setState(() {
                  _focused =
                      DateTime(_focused.year, _focused.month - 1, 1);
                });
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 32,
              child: const Icon(CupertinoIcons.chevron_right),
              onPressed: () {
                setState(() {
                  _focused =
                      DateTime(_focused.year, _focused.month + 1, 1);
                });
              },
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // 🔹 개체 필터 select 박스
            if (_animals.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '개체',
                      style: TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: _showAnimalFilterSheet,
                      child: Row(
                        children: [
                          Text(
                            _selectedAnimalId == null
                                ? '전체'
                                : (currentAnimalName ?? '알 수 없음'),
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            CupertinoIcons.chevron_down,
                            size: 16,
                            color: CupertinoColors.systemGrey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // 요일 라벨
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _WeekdayLabel('일', isSunday: true),
                  _WeekdayLabel('월'),
                  _WeekdayLabel('화'),
                  _WeekdayLabel('수'),
                  _WeekdayLabel('목'),
                  _WeekdayLabel('금'),
                  _WeekdayLabel('토', isSaturday: true),
                ],
              ),
            ),
            const SizedBox(height: 4),

            // 캘린더
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2035, 12, 31),
                  focusedDay: _focused,
                  selectedDayPredicate: (d) => isSameDay(d, _selected),
                  onDaySelected: (sel, foc) {
                    setState(() {
                      _selected = sel;
                      _focused = foc;
                    });
                  },
                  onPageChanged: (foc) {
                    setState(() => _focused = foc);
                  },
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  calendarFormat: CalendarFormat.month,
                  daysOfWeekVisible: false,
                  headerVisible: false,
                  rowHeight: 40,
                  // daysOfWeekVisible: 16,
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      return _buildDayCell(day);
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      return _buildDayCell(day, isSelected: true);
                    },
                    todayBuilder: (context, day, focusedDay) {
                      return _buildDayCell(day, isToday: true);
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: CupertinoColors.activeBlue,
                        width: 1.5,
                      ),
                    ),
                    todayTextStyle: const TextStyle(
                      color: CupertinoColors.activeBlue,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: CupertinoColors.activeBlue,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    weekendTextStyle: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                    outsideDaysVisible: true,
                    outsideTextStyle: TextStyle(
                      color: Colors.grey.shade400,
                    ),
                    defaultTextStyle: const TextStyle(
                      color: CupertinoColors.label,
                    ),
                  ),
                ),
              ),
            ),

            // 하단 다이어리 영역 + 섹션 분리(청소/급여)
            SizedBox(
              height: 300, // ✅ 섹션 2개라 기존(180)보다 넉넉하게
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGroupedBackground,
                  border: Border(
                    top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ----------------------------
                    // 상단: 날짜 + 청소아이콘 + +버튼
                    // ----------------------------
                    StreamBuilder<List<CageCleaning>>(
                      stream: _watchCleaningsForDay(selectedDay),
                      builder: (context, snapshot) {
                        final cleanings = snapshot.data ?? const [];
                        final hasCleaning = cleanings.isNotEmpty;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 날짜 + 청소 아이콘
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      DateFormat.yMMMd('ko_KR').format(selectedDay),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (hasCleaning) ...[
                                      const SizedBox(width: 6),
                                      const Icon(
                                        CupertinoIcons.sparkles,
                                        size: 16,
                                        color: CupertinoColors.systemGreen,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _selectedAnimalId == null
                                      ? '전체 기록'
                                      : '기록 · ${currentAnimalName ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: CupertinoColors.secondaryLabel,
                                  ),
                                ),
                              ],
                            ),

                            // + 버튼 (급여/청소 선택 시트)
                            CupertinoButton(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              minSize: 24,
                              onPressed: () => _showAddRecordTypeSheet(selectedDay),
                              child: const Icon(
                                CupertinoIcons.add,
                                size: 22,
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    // ----------------------------
                    // 섹션 2개를 아래 영역에서 스크롤
                    // ----------------------------
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // ============================
                            // 1) 케이지 청소 섹션
                            // ============================
                            _SectionHeader(
                              title: '케이지 청소',
                              icon: CupertinoIcons.sparkles,
                            ),
                            const SizedBox(height: 6),

                            StreamBuilder<List<CageCleaning>>(
                              stream: _watchCleaningsForDay(selectedDay),
                              builder: (context, snapshot) {
                                final items = snapshot.data ?? const [];

                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Center(child: CupertinoActivityIndicator()),
                                  );
                                }

                                if (items.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '청소 기록이 없어요.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: CupertinoColors.secondaryLabel,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: items.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                                  itemBuilder: (context, index) {
                                    final c = items[index];
                                    final at = DateTime.tryParse(c.at) ?? DateTime.now();
                                    final timeStr = DateFormat.Hm('ko_KR').format(at);

                                    final animalName = _findAnimalById(c.animalId)?.name ?? '알 수 없음';

                                    String typeLabel(String t) {
                                      switch (t) {
                                        case 'spot':
                                          return '부분 청소';
                                        case 'water':
                                          return '물 교체';
                                        case 'full':
                                        default:
                                          return '전체 청소';
                                      }
                                    }

                                    final title = '$animalName · ${typeLabel(c.type)}';

                                    return Dismissible(
                                      key: ValueKey(c.id),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.only(right: 16),
                                        color: CupertinoColors.systemRed,
                                        child: const Icon(
                                          CupertinoIcons.delete_solid,
                                          color: CupertinoColors.white,
                                        ),
                                      ),
                                      confirmDismiss: (_) async {
                                        final result = await showCupertinoDialog<bool>(
                                          context: context,
                                          builder: (ctx) => CupertinoAlertDialog(
                                            title: const Text('청소 기록 삭제'),
                                            content: const Text('이 청소 기록을 삭제할까요?'),
                                            actions: [
                                              CupertinoDialogAction(
                                                onPressed: () => Navigator.of(ctx).pop(false),
                                                child: const Text('취소'),
                                              ),
                                              CupertinoDialogAction(
                                                isDestructiveAction: true,
                                                onPressed: () => Navigator.of(ctx).pop(true),
                                                child: const Text('삭제'),
                                              ),
                                            ],
                                          ),
                                        );
                                        return result ?? false;
                                      },
                                      onDismissed: (_) {
                                        (_db.delete(_db.cageCleanings)..where((t) => t.id.equals(c.id))).go();
                                      },
                                      child: GestureDetector(
                                        onTap: () => _showEditCleaningSheet(c),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: CupertinoColors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      title,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    if ((c.note ?? '').trim().isNotEmpty)
                                                      Text(
                                                        c.note!.trim(),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: CupertinoColors.secondaryLabel,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                timeStr,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: CupertinoColors.secondaryLabel,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 14),

                            // ============================
                            // 2) 급여 기록 섹션
                            // ============================
                            _SectionHeader(
                              title: '급여 기록',
                              icon: CupertinoIcons.heart,
                            ),
                            const SizedBox(height: 6),

                            StreamBuilder<List<Feeding>>(
                              stream: _watchFeedingsForDay(selectedDay),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Center(child: CupertinoActivityIndicator()),
                                  );
                                }

                                final items = snapshot.data ?? const [];
                                if (items.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '급여 기록이 없어요.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: CupertinoColors.secondaryLabel,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: items.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                                  itemBuilder: (context, index) {
                                    final f = items[index];
                                    final at = DateTime.tryParse(f.at) ?? DateTime.now();
                                    final timeStr = DateFormat.Hm('ko_KR').format(at);

                                    final animalName = _findAnimalById(f.animalId)?.name;

                                    final title = StringBuffer();
                                    if (animalName != null) title.write('$animalName · ');
                                    title.write('${f.foodType ?? '먹이'} ');
                                    if (f.amount != null) title.write('${f.amount!.toInt()}');
                                    if (f.unit != null) title.write(f.unit);

                                    return Dismissible(
                                      key: ValueKey(f.id),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.only(right: 16),
                                        color: CupertinoColors.systemRed,
                                        child: const Icon(
                                          CupertinoIcons.delete_solid,
                                          color: CupertinoColors.white,
                                        ),
                                      ),
                                      confirmDismiss: (_) async {
                                        final result = await showCupertinoDialog<bool>(
                                          context: context,
                                          builder: (ctx) => CupertinoAlertDialog(
                                            title: const Text('급여 기록 삭제'),
                                            content: const Text('이 급여 기록을 삭제할까요?'),
                                            actions: [
                                              CupertinoDialogAction(
                                                onPressed: () => Navigator.of(ctx).pop(false),
                                                child: const Text('취소'),
                                              ),
                                              CupertinoDialogAction(
                                                isDestructiveAction: true,
                                                onPressed: () => Navigator.of(ctx).pop(true),
                                                child: const Text('삭제'),
                                              ),
                                            ],
                                          ),
                                        );
                                        return result ?? false;
                                      },
                                      onDismissed: (_) {
                                        (_db.delete(_db.feedings)..where((t) => t.id.equals(f.id))).go();
                                      },
                                      child: GestureDetector(
                                        onTap: () => _showEditFeedingSheet(f),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: CupertinoColors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      title.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    if ((f.note ?? '').trim().isNotEmpty)
                                                      Text(
                                                        f.note!.trim(),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: CupertinoColors.secondaryLabel,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                timeStr,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: CupertinoColors.secondaryLabel,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 14),

                            // ============================
                            // 3) 기타(탈피/메모) 섹션
                            // ============================
                            _SectionHeader(
                              title: '기타',
                              icon: CupertinoIcons.pencil_ellipsis_rectangle,
                            ),
                            const SizedBox(height: 6),

                            StreamBuilder<List<CareLog>>(
                              stream: _watchCareLogsForDay(selectedDay),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Center(child: CupertinoActivityIndicator()),
                                  );
                                }

                                final items = snapshot.data ?? const [];
                                if (items.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '기타 기록이 없어요.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: CupertinoColors.secondaryLabel,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                String typeLabel(String t) {
                                  switch (t) {
                                    case 'shed':
                                      return '탈피';
                                    case 'note':
                                    default:
                                      return '메모';
                                  }
                                }

                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: items.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                                  itemBuilder: (context, index) {
                                    final log = items[index];
                                    final at = DateTime.tryParse(log.at) ?? DateTime.now();
                                    final timeStr = DateFormat.Hm('ko_KR').format(at);

                                    final animalName = _findAnimalById(log.animalId)?.name ?? '알 수 없음';
                                    final head = '$animalName · ${typeLabel(log.type)}';

                                    final sub = (log.type == 'note')
                                        ? ((log.title ?? '').trim().isNotEmpty ? log.title!.trim() : (log.note ?? '').trim())
                                        : (log.note ?? '').trim();

                                    return Dismissible(
                                      key: ValueKey(log.id),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.only(right: 16),
                                        color: CupertinoColors.systemRed,
                                        child: const Icon(
                                          CupertinoIcons.delete_solid,
                                          color: CupertinoColors.white,
                                        ),
                                      ),
                                      confirmDismiss: (_) async {
                                        final result = await showCupertinoDialog<bool>(
                                          context: context,
                                          builder: (ctx) => CupertinoAlertDialog(
                                            title: const Text('기록 삭제'),
                                            content: const Text('이 기록을 삭제할까요?'),
                                            actions: [
                                              CupertinoDialogAction(
                                                onPressed: () => Navigator.of(ctx).pop(false),
                                                child: const Text('취소'),
                                              ),
                                              CupertinoDialogAction(
                                                isDestructiveAction: true,
                                                onPressed: () => Navigator.of(ctx).pop(true),
                                                child: const Text('삭제'),
                                              ),
                                            ],
                                          ),
                                        );
                                        return result ?? false;
                                      },
                                      onDismissed: (_) {
                                        (_db.delete(_db.careLogs)..where((t) => t.id.equals(log.id))).go();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: CupertinoColors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    head,
                                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                                  ),
                                                  if (sub.isNotEmpty)
                                                    Text(
                                                      sub,
                                                      style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              timeStr,
                                              style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String text;
  final bool isSunday;
  final bool isSaturday;
  const _WeekdayLabel(this.text,
      {this.isSunday = false, this.isSaturday = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = CupertinoColors.secondaryLabel;
    if (isSunday) color = const Color(0xFFEB5545);
    if (isSaturday) color = CupertinoColors.systemBlue;

    return SizedBox(
      width: (MediaQuery.of(context).size.width - 32) / 7,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: CupertinoColors.secondaryLabel),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.secondaryLabel,
          ),
        ),
      ],
    );
  }
}