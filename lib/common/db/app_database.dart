import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Animals extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()(); // 이름
  TextColumn get species => text().nullable()(); // 종
  TextColumn get sex => text().nullable()(); // Unknown, M, F
  TextColumn get birthDate => text().nullable()(); // ISO8601 (yyyy-mm-dd)
  TextColumn get profileImagePath => text().nullable()(); // 로컬 파일 경로

  IntColumn get colorValue => integer().nullable()(); // 색상 (ARGB 정수값)

  // 🔽 새로 추가
  BoolColumn get isSick =>
      boolean().withDefault(const Constant(false))(); // 아픈지 여부
  TextColumn get healthNote =>
      text().nullable()(); // "입 주변 염증", "기생충 약 복용 중" 등 메모

  BoolColumn get active => boolean().withDefault(const Constant(true))();
  @override
  Set<Column<Object>>? get primaryKey => {id};
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
  Set<Column<Object>>? get primaryKey => {id};
}

class FeedingWithAnimal {
  final Feeding feeding;
  final Animal? animal;

  FeedingWithAnimal({
    required this.feeding,
    required this.animal,
  });
}

class Cages extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();      // 예: "크레스티드 베이비 1호"
  TextColumn get location => text().nullable()(); // 방 위치 메모
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 개체가 어느 케이지에 살고 있는지 (간단하게 1:1만 지원해도 됨)
class AnimalCages extends Table {
  TextColumn get animalId => text()();
  TextColumn get cageId => text()();

  @override
  Set<Column> get primaryKey => {animalId};
}

class CageCleanings extends Table {
  TextColumn get id => text()();
  TextColumn get cageId => text()();   // 어떤 케이지를
  TextColumn get at => text()();       // ISO8601
  TextColumn get type => text()();     // spot, full 등
  TextColumn get note => text().nullable()(); // 탈피 껍질 제거, 물그릇 청소 등

  @override
  Set<Column> get primaryKey => {id};
}

class MedicationLogs extends Table {
  TextColumn get id => text()();
  TextColumn get animalId => text()();
  TextColumn get at => text()();                 // 복용 시각
  TextColumn get medicineName => text()();       // 약 이름
  RealColumn get dose => real().nullable()();    // 용량
  TextColumn get unit => text().nullable()();    // ml, mg, drop 등
  TextColumn get reason => text().nullable()();  // 이유 (기생충, 설사 등)
  TextColumn get note => text().nullable()();    // 부작용, 반응 등

  @override
  Set<Column> get primaryKey => {id};
}

class Weights extends Table {
  TextColumn get id => text()();
  TextColumn get animalId => text()();
  TextColumn get at => text()();          // 측정 시각
  RealColumn get weight => real()();      // 몸무게
  TextColumn get unit => text().withDefault(const Constant('g'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Animals, Feedings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());
  @override
  int get schemaVersion => 3; // 스키마 버전 업 (--> 이거 알아보기..)

  @override
  MigrationStrategy get migration => MigrationStrategy(
        // 처음 DB 생성할 때
        onCreate: (m) async {
          await m.createAll();
        },

        // 버전이 올라갔을 때
        onUpgrade: (m, from, to) async {
          // 개발 중에는 그냥 갈아엎고 새로 생성해도 됨
          // (기존 데이터 다 사라짐)
          await m.deleteTable('animals');  // 테이블 이름들 실제 이름으로
          await m.deleteTable('feedings');
          // 또는 전체 드랍:
          // await m.dropAll();  // drift 2.x 이상에서 지원
          await m.createAll();
        },

        // 필요하다면 onBeforeOpen 도 추가 가능
      );      

    Future<List<FeedingWithAnimal>> feedingsWithAnimalFor(DateTime day) async {
      final start = DateTime(day.year, day.month, day.day);
      final end = start.add(const Duration(days: 1));

      final startIso = start.toIso8601String();
      final endIso = end.toIso8601String();

      final query = select(feedings).join([
        leftOuterJoin(animals, animals.id.equalsExp(feedings.animalId)),
      ])
        ..where(feedings.at.isBetweenValues(startIso, endIso));

      final rows = await query.get();

      return rows.map((r) {
        return FeedingWithAnimal(
          feeding: r.readTable(feedings),
          animal: r.readTableOrNull(animals),
        );
      }).toList();
    }
}

LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'gecko.sqlite'));
    return NativeDatabase(file);
  });
}
