import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import 'animal_detail_page.dart';
import '../../common/db/app_database.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart'; // dbProvider 가져오기

// class AnimalListPage extends StatefulWidget {
//   const AnimalListPage({super.key});

//   @override
//   State<AnimalListPage> createState() => _AnimalListPageState();
// }

class AnimalListPage extends ConsumerStatefulWidget {
  const AnimalListPage({super.key});

  @override
  ConsumerState<AnimalListPage> createState() => _AnimalListPageState();
}

// class _AnimalListPageState extends State<AnimalListPage> {
class _AnimalListPageState extends ConsumerState<AnimalListPage> {
  late final AppDatabase _db;
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _db = ref.read(dbProvider); // main.dart 에 정의된 dbProvider 사용
  }

  @override
  void dispose() {
    // _db.close();  // dbProvider 사용 시 닫지 않음
    super.dispose();
  }

  /// 활성 개체 목록 스트림
  Stream<List<Animal>> _watchActiveAnimals() {
    final query = (_db.select(_db.animals)
      ..where((t) => t.active.equals(true))
      ..orderBy([(t) => drift.OrderingTerm(expression: t.name),
      ]));
    return query.watch();
  }

  /// 개체 추가 시트
  Future<void> _showAddAnimalSheet() async {
    final nameCtrl = TextEditingController();
    final speciesCtrl = TextEditingController(text: 'Crested Gecko');

    await showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return AnimatedPadding(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: bottomInset),
          child: CupertinoActionSheet(
            title: const Text('새 개체 추가'),
            message: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    '이름',
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                  const SizedBox(height: 4),
                  CupertinoTextField(
                    controller: nameCtrl,
                    placeholder: '예: 비키',
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '종 (선택)',
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                  const SizedBox(height: 4),
                  CupertinoTextField(
                    controller: speciesCtrl,
                    placeholder: '예: Crested Gecko',
                  ),
                ],
              ),
            actions: [
              CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () async {
                  final name = nameCtrl.text.trim();
                  final species = speciesCtrl.text.trim();

                  if (name.isEmpty) {
                    // 간단 검증: 이름이 없으면 무시
                    Navigator.of(ctx).pop();
                    return;
                  }

                  await _db.into(_db.animals).insert(
                        AnimalsCompanion.insert(
                          id: _uuid.v4(),
                          name: name,
                          species: drift.Value(
                            species.isEmpty ? null : species,
                          ),
                        ),
                      );

                  Navigator.of(ctx).pop();
                },
                child: const Text('저장'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('취소'),
            ),
          )
        );
      },
    );

    nameCtrl.dispose();
    speciesCtrl.dispose();
  }

  /// 개체 비활성화 (삭제 대신 active=false)
  Future<void> _deactivateAnimal(Animal animal) async {
    await (_db.update(_db.animals)
          ..where((t) => t.id.equals(animal.id)))
        .write(
      const AnimalsCompanion(
        active: drift.Value(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('개체 관리'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 32,
          child: const Icon(CupertinoIcons.add),
          onPressed: _showAddAnimalSheet,
        ),
      ),
      child: SafeArea(
        child: StreamBuilder<List<Animal>>(
          stream: _watchActiveAnimals(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }

            final animals = snapshot.data ?? const [];

            if (animals.isEmpty) {
              return const Center(
                child: Text(
                  '아직 등록된 개체가 없어요.\n오른쪽 위 + 버튼으로 추가해 주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
              );
            }

            return ListView.separated(
              itemCount: animals.length,
              separatorBuilder: (_, __) => Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              itemBuilder: (context, index) {
                final a = animals[index];
                return Dismissible(
                  key: ValueKey(a.id),
                  background: Container(
                    color: CupertinoColors.systemRed,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(
                      CupertinoIcons.delete_solid,
                      color: CupertinoColors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async {
                    bool? result = await showCupertinoDialog<bool>(
                      context: context,
                      builder: (ctx) => CupertinoAlertDialog(
                        title: const Text('개체 숨기기'),
                        content: Text('\'${a.name}\' 개체를 목록에서 숨길까요?'),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text('취소'),
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text('숨기기'),
                          ),
                        ],
                      ),
                    );
                    return result ?? false;
                  },
                  onDismissed: (_) => _deactivateAnimal(a),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => AnimalDetailPage(animal: a),
                        ),
                      );
                    },
                  child: Container(
                    color: CupertinoColors.systemBackground,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        // 왼쪽 이모지/아이콘 (임시)
                        const Text(
                          '🦎',
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (a.species != null)
                                Text(
                                  a.species!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: CupertinoColors.secondaryLabel,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Icon(
                          CupertinoIcons.chevron_forward,
                          size: 18,
                          color: CupertinoColors.systemGrey,
                        ),
                      ],
                    ),
                  ),
                ),
              );},
            );
          },
        ),
      ),
    );
  }
}
