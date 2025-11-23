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
