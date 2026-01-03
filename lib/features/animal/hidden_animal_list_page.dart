import 'package:flutter/cupertino.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/db/app_database.dart';
import '../../main.dart';

class HiddenAnimalListPage extends ConsumerWidget {
  const HiddenAnimalListPage({super.key});

  Stream<List<Animal>> _watchHiddenAnimals(AppDatabase db) {
    return (db.select(db.animals)
          ..where((t) => t.active.equals(false))
          ..orderBy([
            (t) => drift.OrderingTerm(expression: t.name),
          ]))
        .watch();
  }

  Future<void> _restoreAnimal(
    BuildContext context,
    AppDatabase db,
    Animal animal,
  ) async {
    final nav = Navigator.of(context);

    await (db.update(db.animals)
          ..where((t) => t.id.equals(animal.id)))
        .write(
      const AnimalsCompanion(
        active: drift.Value(true),
      ),
    );

    if(!context.mounted) return;

    showCupertinoDialog(
    context: context,
    builder: (dialogCtx) => CupertinoAlertDialog(
        title: const Text('복구 완료'),
        content: Text('\'${animal.name}\' 개체가 복구되었습니다.'),
        actions: [
        CupertinoDialogAction(
            onPressed: () {
            Navigator.of(dialogCtx).pop(); // 다이얼로그 닫기
            nav.pop(); // 이전 페이지로 돌아가기
            },
            child: const Text('확인'),
        ),
        ],
    ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(dbProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('숨김 개체 관리'),
      ),
      child: SafeArea(
        child: StreamBuilder<List<Animal>>(
          stream: _watchHiddenAnimals(db),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CupertinoActivityIndicator());
            }

            final animals = snapshot.data!;
            if (animals.isEmpty) {
              return const Center(
                child: Text(
                  '숨김 처리된 개체가 없습니다.',
                  style: TextStyle(
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
              );
            }

            return ListView.separated(
              itemCount: animals.length,
              separatorBuilder: (_, __) => const SizedBox(height: 1),
              itemBuilder: (context, index) {
                final a = animals[index];
                return CupertinoListTile(
                  title: Text(a.name),
                  subtitle: a.species != null ? Text(a.species!) : null,
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text(
                      '복구',
                      style: TextStyle(
                        color: CupertinoColors.activeBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () async {
                      final ok = await showCupertinoDialog<bool>(
                        context: context,
                        builder: (_) => CupertinoAlertDialog(
                          title: const Text('개체 복구'),
                          content: Text('\'${a.name}\' 개체를 다시 표시할까요?'),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () =>
                                  Navigator.of(context).pop(false),
                              child: const Text('취소'),
                            ),
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              onPressed: () =>
                                  Navigator.of(context).pop(true),
                              child: const Text('복구'),
                            ),
                          ],
                        ),
                      );

                      if (ok == true) {
                        await _restoreAnimal(context, db, a);
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
