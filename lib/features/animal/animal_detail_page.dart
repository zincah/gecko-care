import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, Color;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import '../../common/db/app_database.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart'; // dbProvider 가져오기

// class AnimalDetailPage extends StatefulWidget {
//   final Animal animal;

//   const AnimalDetailPage({super.key, required this.animal});

//   @override
//   State<AnimalDetailPage> createState() => _AnimalDetailPageState();
// }

class AnimalDetailPage extends ConsumerStatefulWidget {
  final Animal animal;

  const AnimalDetailPage({super.key, required this.animal});

  @override
  ConsumerState<AnimalDetailPage> createState() => _AnimalDetailPageState();
}

// class _AnimalDetailPageState extends State<AnimalDetailPage> {
class _AnimalDetailPageState extends ConsumerState<AnimalDetailPage> {
  late final AppDatabase _db;

  late TextEditingController _nameCtrl;
  late TextEditingController _speciesCtrl;
  DateTime? _birthDate;
  String _sex = 'unknown'; // 'unknown', 'male', 'female'
  String? _profilePath;

  final _picker = ImagePicker();

  int? _colorValue; // ✅ 선택된 색상 값 (Color.value)

  // ✅ 미리 정의해 둘 색상 팔레트
  static const List<Color> _presetColors = [
    Color(0xFF3B82F6), // 파랑
    Color(0xFFEC4899), // 핑크
    Color(0xFFF59E0B), // 주황
    Color(0xFF10B981), // 초록
    Color(0xFF8B5CF6), // 보라
    Color(0xFF6B7280), // 회색
  ];

  @override
  void initState() {
    super.initState();
    _db = ref.read(dbProvider); // main.dart 에 정의된 dbProvider 사용

    _nameCtrl = TextEditingController(text: widget.animal.name);
    _speciesCtrl = TextEditingController(text: widget.animal.species ?? '');

    // sex/birth/profile 초기값 세팅 (nullable이라 null일 수 있음)
    _sex = widget.animal.sex ?? 'unknown';

    if (widget.animal.birthDate != null) {
      _birthDate = DateTime.tryParse(widget.animal.birthDate!);
    }
    _profilePath = widget.animal.profileImagePath;

    _colorValue = widget.animal.colorValue;
  }

  @override
  void dispose() {
    // _db.close();  // dbProvider 사용 시 닫지 않음
    _nameCtrl.dispose();
    _speciesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (picked == null) return;

    setState(() {
      _profilePath = picked.path;
    });
  }

  Future<void> _pickBirthDate() async {
    DateTime temp = _birthDate ?? DateTime.now();

    await showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        return Container(
          height: 260,
          color: CupertinoColors.systemBackground,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  maximumDate: DateTime.now(),
                  initialDateTime: temp,
                  onDateTimeChanged: (d) {
                    temp = d;
                  },
                ),
              ),
              CupertinoButton(
                onPressed: () {
                  setState(() {
                    _birthDate = temp;
                  });
                  Navigator.of(ctx).pop();
                },
                child: const Text('완료'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final species = _speciesCtrl.text.trim();

    await (_db.update(_db.animals)
          ..where((t) => t.id.equals(widget.animal.id)))
        .write(
      AnimalsCompanion(
        name: drift.Value(name.isEmpty ? widget.animal.name : name),
        species: drift.Value(species.isEmpty ? null : species),
        sex: drift.Value(_sex),
        birthDate: drift.Value(
          _birthDate != null
              ? DateFormat('yyyy-MM-dd').format(_birthDate!)
              : null,
        ),
        profileImagePath: drift.Value(_profilePath),
        colorValue: drift.Value(_colorValue),
      ),
    );

    Navigator.of(context).pop(true); // true: 변경되었다는 힌트
  }

  @override
  Widget build(BuildContext context) {
    final birthText = _birthDate != null
        ? DateFormat.yMMMd('ko_KR').format(_birthDate!)
        : '등록되지 않음';

    String sexLabel(String value) {
      switch (value) {
        case 'male':
          return '수컷';
        case 'female':
          return '암컷';
        default:
          return '미상';
      }
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('개체 정보'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 32,
          onPressed: _save,
          child: const Text(
            '저장',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 프로필 사진
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Column(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CupertinoColors.systemGrey5,
                        image: _profilePath != null
                            ? DecorationImage(
                                image: FileImage(File(_profilePath!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _profilePath == null
                          ? const Center(
                              child: Text(
                                '🦎',
                                style: TextStyle(fontSize: 40),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '프로필 사진 변경',
                      style: TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              '이름',
              style: TextStyle(
                fontSize: 13,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
            const SizedBox(height: 4),
            CupertinoTextField(
              controller: _nameCtrl,
              placeholder: '예: 이비키',
            ),
            const SizedBox(height: 16),

            const Text(
              '종',
              style: TextStyle(
                fontSize: 13,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
            const SizedBox(height: 4),
            CupertinoTextField(
              controller: _speciesCtrl,
              placeholder: '예: 밴디드벨벳게코',
            ),
            const SizedBox(height: 24),

            const Text(
              '성별',
              style: TextStyle(
                fontSize: 13,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
            const SizedBox(height: 8),
            CupertinoSegmentedControl<String>(
              groupValue: _sex,
              children: const {
                'unknown': Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text('미상'),
                ),
                'male': Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text('수컷'),
                ),
                'female': Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text('암컷'),
                ),
              },
              onValueChanged: (v) {
                setState(() {
                  _sex = v;
                });
              },
            ),
            const SizedBox(height: 24),

            const Text(
              '출생일',
              style: TextStyle(
                fontSize: 13,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
            const SizedBox(height: 8),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              onPressed: _pickBirthDate,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    birthText,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Icon(
                    CupertinoIcons.calendar,
                    size: 20,
                    color: CupertinoColors.systemGrey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '※ 정확한 부화일이 아니면 대략적인 추정일을 넣어도 괜찮아요.',
              style: TextStyle(
                fontSize: 12,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
            const SizedBox(height: 24),
            // ✅ 캘린더 색상 선택
            const Text(
              '캘린더 색상',
              style: TextStyle(
                fontSize: 13,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: _presetColors.map((color) {
                final bool isSelected = _colorValue == color.value;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _colorValue = color.value;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      border: Border.all(
                        color: isSelected
                            ? CupertinoColors.white
                            : CupertinoColors.separator,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.6),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 6),
            const Text(
              '이 색상은 나중에 달력에서 이 아이의 급여/약 기록을 표시할 때 사용돼요.',
              style: TextStyle(
                fontSize: 11,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
