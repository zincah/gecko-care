import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, StatefulBuilder;
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

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

  // 개체가 하나도 없으면 안내
  if (_animals.isEmpty) {
    await showCupertinoDialog(
      context: context,
      builder: (ctx) => const CupertinoAlertDialog(
        title: Text('개체가 없어요'),
        content: Text('먼저 개체 관리 화면에서 도마뱀을 등록해 주세요.'),
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

            // 하단 다이어리 영역 + 추가 버튼
            SizedBox(
              height: 220,
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
                    // 날짜 / "급여 기록" 타이틀 + +버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.yMMMd('ko_KR').format(selectedDay),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selectedAnimalId == null
                                  ? '급여 기록 · 전체'
                                  : '급여 기록 · ${currentAnimalName ?? ''}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                          ],
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          minSize: 24,
                          onPressed: () => _showAddFeedingSheet(selectedDay),
                          child: const Icon(
                            CupertinoIcons.add,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: StreamBuilder<List<Feeding>>(
                        stream: _watchFeedingsForDay(selectedDay),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CupertinoActivityIndicator(),
                            );
                          }
                          final items = snapshot.data ?? const [];

                          if (items.isEmpty) {
                            return const Center(
                              child: Text(
                                '이 날짜에는 아직 급여 기록이 없어요.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: CupertinoColors.secondaryLabel,
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 6),
                            itemBuilder: (context, index) {
                              final f = items[index];
                              final at = DateTime.tryParse(f.at) ??
                                  DateTime.now();
                              final timeStr =
                                  DateFormat.Hm('ko_KR').format(at);

                              // 🔹 항상 개체 이름을 붙여서 보여주기
                              final animalName =
                                  _findAnimalById(f.animalId)?.name;

                              final title = StringBuffer();
                              if (animalName != null) {
                                title.write('$animalName · ');
                              }
                              title.write('${f.foodType ?? '먹이'} ');
                              if (f.amount != null) {
                                title.write('${f.amount!.toInt()}');
                              }
                              if (f.unit != null) {
                                title.write(f.unit);
                              }

                              return Dismissible(
                                key: ValueKey(f.id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding:
                                      const EdgeInsets.only(right: 16),
                                  color: CupertinoColors.systemRed,
                                  child: const Icon(
                                    CupertinoIcons.delete_solid,
                                    color: CupertinoColors.white,
                                  ),
                                ),
                                confirmDismiss: (_) async {
                                  final result =
                                      await showCupertinoDialog<bool>(
                                    context: context,
                                    builder: (ctx) =>
                                        CupertinoAlertDialog(
                                      title: const Text('급여 기록 삭제'),
                                      content: const Text(
                                          '이 급여 기록을 삭제할까요?'),
                                      actions: [
                                        CupertinoDialogAction(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(false),
                                          child: const Text('취소'),
                                        ),
                                        CupertinoDialogAction(
                                          isDestructiveAction: true,
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(true),
                                          child: const Text('삭제'),
                                        ),
                                      ],
                                    ),
                                  );
                                  return result ?? false;
                                },
                                onDismissed: (_) {
                                  (_db.delete(_db.feedings)
                                        ..where((t) =>
                                            t.id.equals(f.id)))
                                      .go();
                                },
                                child: GestureDetector(
                                  onTap: () async {
                                    _showEditFeedingSheet(f);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.white,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              title.toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                    FontWeight.w500,
                                              ),
                                            ),
                                            if ((f.note ?? '').isNotEmpty)
                                              Text(
                                                f.note!,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: CupertinoColors
                                                      .secondaryLabel,
                                                ),
                                              ),
                                          ],
                                        ),
                                        Text(
                                          timeStr,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color:
                                                CupertinoColors.secondaryLabel,
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
