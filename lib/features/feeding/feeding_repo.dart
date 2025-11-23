// lib/features/feeding/feeding_repo.dart
import 'package:drift/drift.dart';
import '../../common/db/app_database.dart';
import 'package:uuid/uuid.dart';

class FeedingRepo {
  FeedingRepo(this.db);
  final AppDatabase db;
  final _uuid = const Uuid();

  Future<void> quickSave({
    required String animalId,
    DateTime? at,
    String foodType = 'cricket',
    double amount = 5,
    String unit = 'ea',
    List<String> supplements = const [],
    String note = '',
  }) async {
    await db.into(db.feedings).insert(
      FeedingsCompanion.insert(
        id: _uuid.v4(),
        animalId: animalId,
        at: (at ?? DateTime.now()).toIso8601String(),
        foodType: Value(foodType),
        amount: Value(amount),
        unit: Value(unit),
        supplements: Value(supplements.join(',')),
        note: Value(note),
      ),
    );
  }
}
