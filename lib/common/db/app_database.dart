// lib/common/db/app_database.dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

/// =======================
/// 테이블 정의
/// =======================

class Animals extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()(); // 이름
  TextColumn get species => text().nullable()(); // 종
  TextColumn get sex => text().nullable()(); // Unknown, M, F
  TextColumn get birthDate => text().nullable()(); // ISO8601 (yyyy-mm-dd)
  TextColumn get profileImagePath => text().nullable()(); // 로컬 파일 경로

  IntColumn get colorValue => integer().nullable()(); // 색상 (ARGB 정수값)

  // 아픈지 여부 + 건강 메모
  BoolColumn get isSick =>
      boolean().withDefault(const Constant(false))();
  TextColumn get healthNote => text().nullable()();

  BoolColumn get active =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class Feedings extends Table {
  TextColumn get id => text()();
  TextColumn get animalId => text()();
  TextColumn get at => text()(); // ISO8601
  TextColumn get foodType => text().nullable()();
  RealColumn get amount => real().nullable()();
  TextColumn get unit => text().nullable()(); // ea, g, ml
  TextColumn get supplements => text().nullable()(); // CSV
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Cages extends Table { // 아직 사용하지 않는 테이블
  TextColumn get id => text()();
  TextColumn get name => text()(); // 예: "크레스티드 베이비 1호"
  TextColumn get location => text().nullable()(); // 방 위치 메모
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 개체가 어느 케이지에 사는지 (1:1 전제)
class AnimalCages extends Table { // 아직 사용하지 않는 테이블
  TextColumn get animalId => text()();
  TextColumn get cageId => text()();

  @override
  Set<Column> get primaryKey => {animalId};
}

class CageCleanings extends Table {
  TextColumn get id => text()();
  TextColumn get animalId => text()(); // 어떤 개체 케이지 청소인지
  TextColumn get at => text()(); // ISO8601
  TextColumn get type => text()(); // spot, full 등
  TextColumn get note => text().nullable()(); // 탈피 껍질 제거, 물그릇 청소 등

  @override
  Set<Column> get primaryKey => {id};
}

class MedicationLogs extends Table {
  TextColumn get id => text()();
  TextColumn get animalId => text()();
  TextColumn get at => text()(); // 복용 시각
  TextColumn get medicineName => text()(); // 약 이름
  RealColumn get dose => real().nullable()(); // 용량
  TextColumn get unit => text().nullable()(); // ml, mg, drop 등
  TextColumn get reason => text().nullable()(); // 이유
  TextColumn get note => text().nullable()(); // 부작용, 반응 등

  @override
  Set<Column> get primaryKey => {id};
}

class Weights extends Table {
  TextColumn get id => text()();
  TextColumn get animalId => text()();
  TextColumn get at => text()(); // 측정 시각
  RealColumn get weight => real()(); // 몸무게
  TextColumn get unit =>
      text().withDefault(const Constant('g'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 조인 결과용 DTO
class FeedingWithAnimal {
  final Feeding feeding;
  final Animal? animal;

  FeedingWithAnimal({
    required this.feeding,
    required this.animal,
  });
}

/// =======================
/// 데이터베이스 본체
/// =======================

@DriftDatabase(
  tables: [
    Animals,
    Feedings,
    Cages,
    AnimalCages,
    CageCleanings,
    MedicationLogs,
    Weights,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  @override
  int get schemaVersion => 4; // 스키마 바뀔 때마다 +1

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // 개발 중: 버전 바뀌면 그냥 싹 갈아엎기
          if (from < 4) {
            await m.deleteTable('animals');
            await m.deleteTable('feedings');
            await m.deleteTable('cages');
            await m.deleteTable('animal_cages');
            await m.deleteTable('cage_cleanings');
            await m.deleteTable('medication_logs');
            await m.deleteTable('weights');
            await m.createAll();
          }
        },
      );

  /// 특정 날짜의 급여 + 개체 정보 조인
  Future<List<FeedingWithAnimal>> feedingsWithAnimalFor(
      DateTime day) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    final startIso = start.toIso8601String();
    final endIso = end.toIso8601String();

    final query = select(feedings).join([
      leftOuterJoin(
        animals,
        animals.id.equalsExp(feedings.animalId),
      ),
    ])..where(feedings.at.isBetweenValues(startIso, endIso));

    final rows = await query.get();

    return rows
        .map(
          (r) => FeedingWithAnimal(
            feeding: r.readTable(feedings),
            animal: r.readTableOrNull(animals),
          ),
        )
        .toList();
  }
}

/// =======================
/// 파일 기반 SQLite 오픈
/// =======================
LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'gecko.sqlite'));
    return NativeDatabase(file);
  });
}
