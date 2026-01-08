// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AnimalsTable extends Animals with TableInfo<$AnimalsTable, Animal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnimalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speciesMeta = const VerificationMeta(
    'species',
  );
  @override
  late final GeneratedColumn<String> species = GeneratedColumn<String>(
    'species',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<String> birthDate = GeneratedColumn<String>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profileImagePathMeta = const VerificationMeta(
    'profileImagePath',
  );
  @override
  late final GeneratedColumn<String> profileImagePath = GeneratedColumn<String>(
    'profile_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSickMeta = const VerificationMeta('isSick');
  @override
  late final GeneratedColumn<bool> isSick = GeneratedColumn<bool>(
    'is_sick',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_sick" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _healthNoteMeta = const VerificationMeta(
    'healthNote',
  );
  @override
  late final GeneratedColumn<String> healthNote = GeneratedColumn<String>(
    'health_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    species,
    sex,
    birthDate,
    profileImagePath,
    colorValue,
    isSick,
    healthNote,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'animals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Animal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('species')) {
      context.handle(
        _speciesMeta,
        species.isAcceptableOrUnknown(data['species']!, _speciesMeta),
      );
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('profile_image_path')) {
      context.handle(
        _profileImagePathMeta,
        profileImagePath.isAcceptableOrUnknown(
          data['profile_image_path']!,
          _profileImagePathMeta,
        ),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    }
    if (data.containsKey('is_sick')) {
      context.handle(
        _isSickMeta,
        isSick.isAcceptableOrUnknown(data['is_sick']!, _isSickMeta),
      );
    }
    if (data.containsKey('health_note')) {
      context.handle(
        _healthNoteMeta,
        healthNote.isAcceptableOrUnknown(data['health_note']!, _healthNoteMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Animal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Animal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      species: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species'],
      ),
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      ),
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_date'],
      ),
      profileImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_image_path'],
      ),
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      ),
      isSick: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_sick'],
      )!,
      healthNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}health_note'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $AnimalsTable createAlias(String alias) {
    return $AnimalsTable(attachedDatabase, alias);
  }
}

class Animal extends DataClass implements Insertable<Animal> {
  final String id;
  final String name;
  final String? species;
  final String? sex;
  final String? birthDate;
  final String? profileImagePath;
  final int? colorValue;
  final bool isSick;
  final String? healthNote;
  final bool active;
  const Animal({
    required this.id,
    required this.name,
    this.species,
    this.sex,
    this.birthDate,
    this.profileImagePath,
    this.colorValue,
    required this.isSick,
    this.healthNote,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || species != null) {
      map['species'] = Variable<String>(species);
    }
    if (!nullToAbsent || sex != null) {
      map['sex'] = Variable<String>(sex);
    }
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<String>(birthDate);
    }
    if (!nullToAbsent || profileImagePath != null) {
      map['profile_image_path'] = Variable<String>(profileImagePath);
    }
    if (!nullToAbsent || colorValue != null) {
      map['color_value'] = Variable<int>(colorValue);
    }
    map['is_sick'] = Variable<bool>(isSick);
    if (!nullToAbsent || healthNote != null) {
      map['health_note'] = Variable<String>(healthNote);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  AnimalsCompanion toCompanion(bool nullToAbsent) {
    return AnimalsCompanion(
      id: Value(id),
      name: Value(name),
      species: species == null && nullToAbsent
          ? const Value.absent()
          : Value(species),
      sex: sex == null && nullToAbsent ? const Value.absent() : Value(sex),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      profileImagePath: profileImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(profileImagePath),
      colorValue: colorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(colorValue),
      isSick: Value(isSick),
      healthNote: healthNote == null && nullToAbsent
          ? const Value.absent()
          : Value(healthNote),
      active: Value(active),
    );
  }

  factory Animal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Animal(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      species: serializer.fromJson<String?>(json['species']),
      sex: serializer.fromJson<String?>(json['sex']),
      birthDate: serializer.fromJson<String?>(json['birthDate']),
      profileImagePath: serializer.fromJson<String?>(json['profileImagePath']),
      colorValue: serializer.fromJson<int?>(json['colorValue']),
      isSick: serializer.fromJson<bool>(json['isSick']),
      healthNote: serializer.fromJson<String?>(json['healthNote']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'species': serializer.toJson<String?>(species),
      'sex': serializer.toJson<String?>(sex),
      'birthDate': serializer.toJson<String?>(birthDate),
      'profileImagePath': serializer.toJson<String?>(profileImagePath),
      'colorValue': serializer.toJson<int?>(colorValue),
      'isSick': serializer.toJson<bool>(isSick),
      'healthNote': serializer.toJson<String?>(healthNote),
      'active': serializer.toJson<bool>(active),
    };
  }

  Animal copyWith({
    String? id,
    String? name,
    Value<String?> species = const Value.absent(),
    Value<String?> sex = const Value.absent(),
    Value<String?> birthDate = const Value.absent(),
    Value<String?> profileImagePath = const Value.absent(),
    Value<int?> colorValue = const Value.absent(),
    bool? isSick,
    Value<String?> healthNote = const Value.absent(),
    bool? active,
  }) => Animal(
    id: id ?? this.id,
    name: name ?? this.name,
    species: species.present ? species.value : this.species,
    sex: sex.present ? sex.value : this.sex,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    profileImagePath: profileImagePath.present
        ? profileImagePath.value
        : this.profileImagePath,
    colorValue: colorValue.present ? colorValue.value : this.colorValue,
    isSick: isSick ?? this.isSick,
    healthNote: healthNote.present ? healthNote.value : this.healthNote,
    active: active ?? this.active,
  );
  Animal copyWithCompanion(AnimalsCompanion data) {
    return Animal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      species: data.species.present ? data.species.value : this.species,
      sex: data.sex.present ? data.sex.value : this.sex,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      profileImagePath: data.profileImagePath.present
          ? data.profileImagePath.value
          : this.profileImagePath,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      isSick: data.isSick.present ? data.isSick.value : this.isSick,
      healthNote: data.healthNote.present
          ? data.healthNote.value
          : this.healthNote,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Animal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('species: $species, ')
          ..write('sex: $sex, ')
          ..write('birthDate: $birthDate, ')
          ..write('profileImagePath: $profileImagePath, ')
          ..write('colorValue: $colorValue, ')
          ..write('isSick: $isSick, ')
          ..write('healthNote: $healthNote, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    species,
    sex,
    birthDate,
    profileImagePath,
    colorValue,
    isSick,
    healthNote,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Animal &&
          other.id == this.id &&
          other.name == this.name &&
          other.species == this.species &&
          other.sex == this.sex &&
          other.birthDate == this.birthDate &&
          other.profileImagePath == this.profileImagePath &&
          other.colorValue == this.colorValue &&
          other.isSick == this.isSick &&
          other.healthNote == this.healthNote &&
          other.active == this.active);
}

class AnimalsCompanion extends UpdateCompanion<Animal> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> species;
  final Value<String?> sex;
  final Value<String?> birthDate;
  final Value<String?> profileImagePath;
  final Value<int?> colorValue;
  final Value<bool> isSick;
  final Value<String?> healthNote;
  final Value<bool> active;
  final Value<int> rowid;
  const AnimalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.species = const Value.absent(),
    this.sex = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.profileImagePath = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.isSick = const Value.absent(),
    this.healthNote = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnimalsCompanion.insert({
    required String id,
    required String name,
    this.species = const Value.absent(),
    this.sex = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.profileImagePath = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.isSick = const Value.absent(),
    this.healthNote = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Animal> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? species,
    Expression<String>? sex,
    Expression<String>? birthDate,
    Expression<String>? profileImagePath,
    Expression<int>? colorValue,
    Expression<bool>? isSick,
    Expression<String>? healthNote,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (species != null) 'species': species,
      if (sex != null) 'sex': sex,
      if (birthDate != null) 'birth_date': birthDate,
      if (profileImagePath != null) 'profile_image_path': profileImagePath,
      if (colorValue != null) 'color_value': colorValue,
      if (isSick != null) 'is_sick': isSick,
      if (healthNote != null) 'health_note': healthNote,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnimalsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? species,
    Value<String?>? sex,
    Value<String?>? birthDate,
    Value<String?>? profileImagePath,
    Value<int?>? colorValue,
    Value<bool>? isSick,
    Value<String?>? healthNote,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return AnimalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      sex: sex ?? this.sex,
      birthDate: birthDate ?? this.birthDate,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      colorValue: colorValue ?? this.colorValue,
      isSick: isSick ?? this.isSick,
      healthNote: healthNote ?? this.healthNote,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (species.present) {
      map['species'] = Variable<String>(species.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<String>(birthDate.value);
    }
    if (profileImagePath.present) {
      map['profile_image_path'] = Variable<String>(profileImagePath.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (isSick.present) {
      map['is_sick'] = Variable<bool>(isSick.value);
    }
    if (healthNote.present) {
      map['health_note'] = Variable<String>(healthNote.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnimalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('species: $species, ')
          ..write('sex: $sex, ')
          ..write('birthDate: $birthDate, ')
          ..write('profileImagePath: $profileImagePath, ')
          ..write('colorValue: $colorValue, ')
          ..write('isSick: $isSick, ')
          ..write('healthNote: $healthNote, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FeedingsTable extends Feedings with TableInfo<$FeedingsTable, Feeding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _animalIdMeta = const VerificationMeta(
    'animalId',
  );
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
    'animal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<String> at = GeneratedColumn<String>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodTypeMeta = const VerificationMeta(
    'foodType',
  );
  @override
  late final GeneratedColumn<String> foodType = GeneratedColumn<String>(
    'food_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplementsMeta = const VerificationMeta(
    'supplements',
  );
  @override
  late final GeneratedColumn<String> supplements = GeneratedColumn<String>(
    'supplements',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    animalId,
    at,
    foodType,
    amount,
    unit,
    supplements,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feedings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Feeding> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('animal_id')) {
      context.handle(
        _animalIdMeta,
        animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('food_type')) {
      context.handle(
        _foodTypeMeta,
        foodType.isAcceptableOrUnknown(data['food_type']!, _foodTypeMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('supplements')) {
      context.handle(
        _supplementsMeta,
        supplements.isAcceptableOrUnknown(
          data['supplements']!,
          _supplementsMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Feeding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Feeding(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      animalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}animal_id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}at'],
      )!,
      foodType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_type'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      supplements: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplements'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $FeedingsTable createAlias(String alias) {
    return $FeedingsTable(attachedDatabase, alias);
  }
}

class Feeding extends DataClass implements Insertable<Feeding> {
  final String id;
  final String animalId;
  final String at;
  final String? foodType;
  final double? amount;
  final String? unit;
  final String? supplements;
  final String? note;
  const Feeding({
    required this.id,
    required this.animalId,
    required this.at,
    this.foodType,
    this.amount,
    this.unit,
    this.supplements,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['animal_id'] = Variable<String>(animalId);
    map['at'] = Variable<String>(at);
    if (!nullToAbsent || foodType != null) {
      map['food_type'] = Variable<String>(foodType);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || supplements != null) {
      map['supplements'] = Variable<String>(supplements);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  FeedingsCompanion toCompanion(bool nullToAbsent) {
    return FeedingsCompanion(
      id: Value(id),
      animalId: Value(animalId),
      at: Value(at),
      foodType: foodType == null && nullToAbsent
          ? const Value.absent()
          : Value(foodType),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      supplements: supplements == null && nullToAbsent
          ? const Value.absent()
          : Value(supplements),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Feeding.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Feeding(
      id: serializer.fromJson<String>(json['id']),
      animalId: serializer.fromJson<String>(json['animalId']),
      at: serializer.fromJson<String>(json['at']),
      foodType: serializer.fromJson<String?>(json['foodType']),
      amount: serializer.fromJson<double?>(json['amount']),
      unit: serializer.fromJson<String?>(json['unit']),
      supplements: serializer.fromJson<String?>(json['supplements']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'animalId': serializer.toJson<String>(animalId),
      'at': serializer.toJson<String>(at),
      'foodType': serializer.toJson<String?>(foodType),
      'amount': serializer.toJson<double?>(amount),
      'unit': serializer.toJson<String?>(unit),
      'supplements': serializer.toJson<String?>(supplements),
      'note': serializer.toJson<String?>(note),
    };
  }

  Feeding copyWith({
    String? id,
    String? animalId,
    String? at,
    Value<String?> foodType = const Value.absent(),
    Value<double?> amount = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<String?> supplements = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => Feeding(
    id: id ?? this.id,
    animalId: animalId ?? this.animalId,
    at: at ?? this.at,
    foodType: foodType.present ? foodType.value : this.foodType,
    amount: amount.present ? amount.value : this.amount,
    unit: unit.present ? unit.value : this.unit,
    supplements: supplements.present ? supplements.value : this.supplements,
    note: note.present ? note.value : this.note,
  );
  Feeding copyWithCompanion(FeedingsCompanion data) {
    return Feeding(
      id: data.id.present ? data.id.value : this.id,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      at: data.at.present ? data.at.value : this.at,
      foodType: data.foodType.present ? data.foodType.value : this.foodType,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      supplements: data.supplements.present
          ? data.supplements.value
          : this.supplements,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Feeding(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('at: $at, ')
          ..write('foodType: $foodType, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('supplements: $supplements, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, animalId, at, foodType, amount, unit, supplements, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Feeding &&
          other.id == this.id &&
          other.animalId == this.animalId &&
          other.at == this.at &&
          other.foodType == this.foodType &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.supplements == this.supplements &&
          other.note == this.note);
}

class FeedingsCompanion extends UpdateCompanion<Feeding> {
  final Value<String> id;
  final Value<String> animalId;
  final Value<String> at;
  final Value<String?> foodType;
  final Value<double?> amount;
  final Value<String?> unit;
  final Value<String?> supplements;
  final Value<String?> note;
  final Value<int> rowid;
  const FeedingsCompanion({
    this.id = const Value.absent(),
    this.animalId = const Value.absent(),
    this.at = const Value.absent(),
    this.foodType = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.supplements = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FeedingsCompanion.insert({
    required String id,
    required String animalId,
    required String at,
    this.foodType = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.supplements = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       animalId = Value(animalId),
       at = Value(at);
  static Insertable<Feeding> custom({
    Expression<String>? id,
    Expression<String>? animalId,
    Expression<String>? at,
    Expression<String>? foodType,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<String>? supplements,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (animalId != null) 'animal_id': animalId,
      if (at != null) 'at': at,
      if (foodType != null) 'food_type': foodType,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (supplements != null) 'supplements': supplements,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FeedingsCompanion copyWith({
    Value<String>? id,
    Value<String>? animalId,
    Value<String>? at,
    Value<String?>? foodType,
    Value<double?>? amount,
    Value<String?>? unit,
    Value<String?>? supplements,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return FeedingsCompanion(
      id: id ?? this.id,
      animalId: animalId ?? this.animalId,
      at: at ?? this.at,
      foodType: foodType ?? this.foodType,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      supplements: supplements ?? this.supplements,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (at.present) {
      map['at'] = Variable<String>(at.value);
    }
    if (foodType.present) {
      map['food_type'] = Variable<String>(foodType.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (supplements.present) {
      map['supplements'] = Variable<String>(supplements.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedingsCompanion(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('at: $at, ')
          ..write('foodType: $foodType, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('supplements: $supplements, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CagesTable extends Cages with TableInfo<$CagesTable, Cage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, location, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $CagesTable createAlias(String alias) {
    return $CagesTable(attachedDatabase, alias);
  }
}

class Cage extends DataClass implements Insertable<Cage> {
  final String id;
  final String name;
  final String? location;
  final String? note;
  const Cage({required this.id, required this.name, this.location, this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  CagesCompanion toCompanion(bool nullToAbsent) {
    return CagesCompanion(
      id: Value(id),
      name: Value(name),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Cage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cage(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      location: serializer.fromJson<String?>(json['location']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'location': serializer.toJson<String?>(location),
      'note': serializer.toJson<String?>(note),
    };
  }

  Cage copyWith({
    String? id,
    String? name,
    Value<String?> location = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => Cage(
    id: id ?? this.id,
    name: name ?? this.name,
    location: location.present ? location.value : this.location,
    note: note.present ? note.value : this.note,
  );
  Cage copyWithCompanion(CagesCompanion data) {
    return Cage(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      location: data.location.present ? data.location.value : this.location,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cage(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, location, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cage &&
          other.id == this.id &&
          other.name == this.name &&
          other.location == this.location &&
          other.note == this.note);
}

class CagesCompanion extends UpdateCompanion<Cage> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> location;
  final Value<String?> note;
  final Value<int> rowid;
  const CagesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.location = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CagesCompanion.insert({
    required String id,
    required String name,
    this.location = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Cage> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? location,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (location != null) 'location': location,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CagesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? location,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return CagesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CagesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnimalCagesTable extends AnimalCages
    with TableInfo<$AnimalCagesTable, AnimalCage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnimalCagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _animalIdMeta = const VerificationMeta(
    'animalId',
  );
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
    'animal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cageIdMeta = const VerificationMeta('cageId');
  @override
  late final GeneratedColumn<String> cageId = GeneratedColumn<String>(
    'cage_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [animalId, cageId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'animal_cages';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnimalCage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('animal_id')) {
      context.handle(
        _animalIdMeta,
        animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('cage_id')) {
      context.handle(
        _cageIdMeta,
        cageId.isAcceptableOrUnknown(data['cage_id']!, _cageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cageIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {animalId};
  @override
  AnimalCage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnimalCage(
      animalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}animal_id'],
      )!,
      cageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cage_id'],
      )!,
    );
  }

  @override
  $AnimalCagesTable createAlias(String alias) {
    return $AnimalCagesTable(attachedDatabase, alias);
  }
}

class AnimalCage extends DataClass implements Insertable<AnimalCage> {
  final String animalId;
  final String cageId;
  const AnimalCage({required this.animalId, required this.cageId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['animal_id'] = Variable<String>(animalId);
    map['cage_id'] = Variable<String>(cageId);
    return map;
  }

  AnimalCagesCompanion toCompanion(bool nullToAbsent) {
    return AnimalCagesCompanion(
      animalId: Value(animalId),
      cageId: Value(cageId),
    );
  }

  factory AnimalCage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnimalCage(
      animalId: serializer.fromJson<String>(json['animalId']),
      cageId: serializer.fromJson<String>(json['cageId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'animalId': serializer.toJson<String>(animalId),
      'cageId': serializer.toJson<String>(cageId),
    };
  }

  AnimalCage copyWith({String? animalId, String? cageId}) => AnimalCage(
    animalId: animalId ?? this.animalId,
    cageId: cageId ?? this.cageId,
  );
  AnimalCage copyWithCompanion(AnimalCagesCompanion data) {
    return AnimalCage(
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      cageId: data.cageId.present ? data.cageId.value : this.cageId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnimalCage(')
          ..write('animalId: $animalId, ')
          ..write('cageId: $cageId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(animalId, cageId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnimalCage &&
          other.animalId == this.animalId &&
          other.cageId == this.cageId);
}

class AnimalCagesCompanion extends UpdateCompanion<AnimalCage> {
  final Value<String> animalId;
  final Value<String> cageId;
  final Value<int> rowid;
  const AnimalCagesCompanion({
    this.animalId = const Value.absent(),
    this.cageId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnimalCagesCompanion.insert({
    required String animalId,
    required String cageId,
    this.rowid = const Value.absent(),
  }) : animalId = Value(animalId),
       cageId = Value(cageId);
  static Insertable<AnimalCage> custom({
    Expression<String>? animalId,
    Expression<String>? cageId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (animalId != null) 'animal_id': animalId,
      if (cageId != null) 'cage_id': cageId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnimalCagesCompanion copyWith({
    Value<String>? animalId,
    Value<String>? cageId,
    Value<int>? rowid,
  }) {
    return AnimalCagesCompanion(
      animalId: animalId ?? this.animalId,
      cageId: cageId ?? this.cageId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (cageId.present) {
      map['cage_id'] = Variable<String>(cageId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnimalCagesCompanion(')
          ..write('animalId: $animalId, ')
          ..write('cageId: $cageId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CageCleaningsTable extends CageCleanings
    with TableInfo<$CageCleaningsTable, CageCleaning> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CageCleaningsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _animalIdMeta = const VerificationMeta(
    'animalId',
  );
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
    'animal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<String> at = GeneratedColumn<String>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, animalId, at, type, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cage_cleanings';
  @override
  VerificationContext validateIntegrity(
    Insertable<CageCleaning> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('animal_id')) {
      context.handle(
        _animalIdMeta,
        animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CageCleaning map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CageCleaning(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      animalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}animal_id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}at'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $CageCleaningsTable createAlias(String alias) {
    return $CageCleaningsTable(attachedDatabase, alias);
  }
}

class CageCleaning extends DataClass implements Insertable<CageCleaning> {
  final String id;
  final String animalId;
  final String at;
  final String type;
  final String? note;
  const CageCleaning({
    required this.id,
    required this.animalId,
    required this.at,
    required this.type,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['animal_id'] = Variable<String>(animalId);
    map['at'] = Variable<String>(at);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  CageCleaningsCompanion toCompanion(bool nullToAbsent) {
    return CageCleaningsCompanion(
      id: Value(id),
      animalId: Value(animalId),
      at: Value(at),
      type: Value(type),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory CageCleaning.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CageCleaning(
      id: serializer.fromJson<String>(json['id']),
      animalId: serializer.fromJson<String>(json['animalId']),
      at: serializer.fromJson<String>(json['at']),
      type: serializer.fromJson<String>(json['type']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'animalId': serializer.toJson<String>(animalId),
      'at': serializer.toJson<String>(at),
      'type': serializer.toJson<String>(type),
      'note': serializer.toJson<String?>(note),
    };
  }

  CageCleaning copyWith({
    String? id,
    String? animalId,
    String? at,
    String? type,
    Value<String?> note = const Value.absent(),
  }) => CageCleaning(
    id: id ?? this.id,
    animalId: animalId ?? this.animalId,
    at: at ?? this.at,
    type: type ?? this.type,
    note: note.present ? note.value : this.note,
  );
  CageCleaning copyWithCompanion(CageCleaningsCompanion data) {
    return CageCleaning(
      id: data.id.present ? data.id.value : this.id,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      at: data.at.present ? data.at.value : this.at,
      type: data.type.present ? data.type.value : this.type,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CageCleaning(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('at: $at, ')
          ..write('type: $type, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, animalId, at, type, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CageCleaning &&
          other.id == this.id &&
          other.animalId == this.animalId &&
          other.at == this.at &&
          other.type == this.type &&
          other.note == this.note);
}

class CageCleaningsCompanion extends UpdateCompanion<CageCleaning> {
  final Value<String> id;
  final Value<String> animalId;
  final Value<String> at;
  final Value<String> type;
  final Value<String?> note;
  final Value<int> rowid;
  const CageCleaningsCompanion({
    this.id = const Value.absent(),
    this.animalId = const Value.absent(),
    this.at = const Value.absent(),
    this.type = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CageCleaningsCompanion.insert({
    required String id,
    required String animalId,
    required String at,
    required String type,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       animalId = Value(animalId),
       at = Value(at),
       type = Value(type);
  static Insertable<CageCleaning> custom({
    Expression<String>? id,
    Expression<String>? animalId,
    Expression<String>? at,
    Expression<String>? type,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (animalId != null) 'animal_id': animalId,
      if (at != null) 'at': at,
      if (type != null) 'type': type,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CageCleaningsCompanion copyWith({
    Value<String>? id,
    Value<String>? animalId,
    Value<String>? at,
    Value<String>? type,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return CageCleaningsCompanion(
      id: id ?? this.id,
      animalId: animalId ?? this.animalId,
      at: at ?? this.at,
      type: type ?? this.type,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (at.present) {
      map['at'] = Variable<String>(at.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CageCleaningsCompanion(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('at: $at, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationLogsTable extends MedicationLogs
    with TableInfo<$MedicationLogsTable, MedicationLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _animalIdMeta = const VerificationMeta(
    'animalId',
  );
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
    'animal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<String> at = GeneratedColumn<String>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicineNameMeta = const VerificationMeta(
    'medicineName',
  );
  @override
  late final GeneratedColumn<String> medicineName = GeneratedColumn<String>(
    'medicine_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<double> dose = GeneratedColumn<double>(
    'dose',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    animalId,
    at,
    medicineName,
    dose,
    unit,
    reason,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('animal_id')) {
      context.handle(
        _animalIdMeta,
        animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('medicine_name')) {
      context.handle(
        _medicineNameMeta,
        medicineName.isAcceptableOrUnknown(
          data['medicine_name']!,
          _medicineNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicineNameMeta);
    }
    if (data.containsKey('dose')) {
      context.handle(
        _doseMeta,
        dose.isAcceptableOrUnknown(data['dose']!, _doseMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      animalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}animal_id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}at'],
      )!,
      medicineName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medicine_name'],
      )!,
      dose: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}dose'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $MedicationLogsTable createAlias(String alias) {
    return $MedicationLogsTable(attachedDatabase, alias);
  }
}

class MedicationLog extends DataClass implements Insertable<MedicationLog> {
  final String id;
  final String animalId;
  final String at;
  final String medicineName;
  final double? dose;
  final String? unit;
  final String? reason;
  final String? note;
  const MedicationLog({
    required this.id,
    required this.animalId,
    required this.at,
    required this.medicineName,
    this.dose,
    this.unit,
    this.reason,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['animal_id'] = Variable<String>(animalId);
    map['at'] = Variable<String>(at);
    map['medicine_name'] = Variable<String>(medicineName);
    if (!nullToAbsent || dose != null) {
      map['dose'] = Variable<double>(dose);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  MedicationLogsCompanion toCompanion(bool nullToAbsent) {
    return MedicationLogsCompanion(
      id: Value(id),
      animalId: Value(animalId),
      at: Value(at),
      medicineName: Value(medicineName),
      dose: dose == null && nullToAbsent ? const Value.absent() : Value(dose),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory MedicationLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationLog(
      id: serializer.fromJson<String>(json['id']),
      animalId: serializer.fromJson<String>(json['animalId']),
      at: serializer.fromJson<String>(json['at']),
      medicineName: serializer.fromJson<String>(json['medicineName']),
      dose: serializer.fromJson<double?>(json['dose']),
      unit: serializer.fromJson<String?>(json['unit']),
      reason: serializer.fromJson<String?>(json['reason']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'animalId': serializer.toJson<String>(animalId),
      'at': serializer.toJson<String>(at),
      'medicineName': serializer.toJson<String>(medicineName),
      'dose': serializer.toJson<double?>(dose),
      'unit': serializer.toJson<String?>(unit),
      'reason': serializer.toJson<String?>(reason),
      'note': serializer.toJson<String?>(note),
    };
  }

  MedicationLog copyWith({
    String? id,
    String? animalId,
    String? at,
    String? medicineName,
    Value<double?> dose = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<String?> reason = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => MedicationLog(
    id: id ?? this.id,
    animalId: animalId ?? this.animalId,
    at: at ?? this.at,
    medicineName: medicineName ?? this.medicineName,
    dose: dose.present ? dose.value : this.dose,
    unit: unit.present ? unit.value : this.unit,
    reason: reason.present ? reason.value : this.reason,
    note: note.present ? note.value : this.note,
  );
  MedicationLog copyWithCompanion(MedicationLogsCompanion data) {
    return MedicationLog(
      id: data.id.present ? data.id.value : this.id,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      at: data.at.present ? data.at.value : this.at,
      medicineName: data.medicineName.present
          ? data.medicineName.value
          : this.medicineName,
      dose: data.dose.present ? data.dose.value : this.dose,
      unit: data.unit.present ? data.unit.value : this.unit,
      reason: data.reason.present ? data.reason.value : this.reason,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationLog(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('at: $at, ')
          ..write('medicineName: $medicineName, ')
          ..write('dose: $dose, ')
          ..write('unit: $unit, ')
          ..write('reason: $reason, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, animalId, at, medicineName, dose, unit, reason, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationLog &&
          other.id == this.id &&
          other.animalId == this.animalId &&
          other.at == this.at &&
          other.medicineName == this.medicineName &&
          other.dose == this.dose &&
          other.unit == this.unit &&
          other.reason == this.reason &&
          other.note == this.note);
}

class MedicationLogsCompanion extends UpdateCompanion<MedicationLog> {
  final Value<String> id;
  final Value<String> animalId;
  final Value<String> at;
  final Value<String> medicineName;
  final Value<double?> dose;
  final Value<String?> unit;
  final Value<String?> reason;
  final Value<String?> note;
  final Value<int> rowid;
  const MedicationLogsCompanion({
    this.id = const Value.absent(),
    this.animalId = const Value.absent(),
    this.at = const Value.absent(),
    this.medicineName = const Value.absent(),
    this.dose = const Value.absent(),
    this.unit = const Value.absent(),
    this.reason = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationLogsCompanion.insert({
    required String id,
    required String animalId,
    required String at,
    required String medicineName,
    this.dose = const Value.absent(),
    this.unit = const Value.absent(),
    this.reason = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       animalId = Value(animalId),
       at = Value(at),
       medicineName = Value(medicineName);
  static Insertable<MedicationLog> custom({
    Expression<String>? id,
    Expression<String>? animalId,
    Expression<String>? at,
    Expression<String>? medicineName,
    Expression<double>? dose,
    Expression<String>? unit,
    Expression<String>? reason,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (animalId != null) 'animal_id': animalId,
      if (at != null) 'at': at,
      if (medicineName != null) 'medicine_name': medicineName,
      if (dose != null) 'dose': dose,
      if (unit != null) 'unit': unit,
      if (reason != null) 'reason': reason,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? animalId,
    Value<String>? at,
    Value<String>? medicineName,
    Value<double?>? dose,
    Value<String?>? unit,
    Value<String?>? reason,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return MedicationLogsCompanion(
      id: id ?? this.id,
      animalId: animalId ?? this.animalId,
      at: at ?? this.at,
      medicineName: medicineName ?? this.medicineName,
      dose: dose ?? this.dose,
      unit: unit ?? this.unit,
      reason: reason ?? this.reason,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (at.present) {
      map['at'] = Variable<String>(at.value);
    }
    if (medicineName.present) {
      map['medicine_name'] = Variable<String>(medicineName.value);
    }
    if (dose.present) {
      map['dose'] = Variable<double>(dose.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationLogsCompanion(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('at: $at, ')
          ..write('medicineName: $medicineName, ')
          ..write('dose: $dose, ')
          ..write('unit: $unit, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeightsTable extends Weights with TableInfo<$WeightsTable, Weight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _animalIdMeta = const VerificationMeta(
    'animalId',
  );
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
    'animal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<String> at = GeneratedColumn<String>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('g'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, animalId, at, weight, unit];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weights';
  @override
  VerificationContext validateIntegrity(
    Insertable<Weight> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('animal_id')) {
      context.handle(
        _animalIdMeta,
        animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Weight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Weight(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      animalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}animal_id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}at'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
    );
  }

  @override
  $WeightsTable createAlias(String alias) {
    return $WeightsTable(attachedDatabase, alias);
  }
}

class Weight extends DataClass implements Insertable<Weight> {
  final String id;
  final String animalId;
  final String at;
  final double weight;
  final String unit;
  const Weight({
    required this.id,
    required this.animalId,
    required this.at,
    required this.weight,
    required this.unit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['animal_id'] = Variable<String>(animalId);
    map['at'] = Variable<String>(at);
    map['weight'] = Variable<double>(weight);
    map['unit'] = Variable<String>(unit);
    return map;
  }

  WeightsCompanion toCompanion(bool nullToAbsent) {
    return WeightsCompanion(
      id: Value(id),
      animalId: Value(animalId),
      at: Value(at),
      weight: Value(weight),
      unit: Value(unit),
    );
  }

  factory Weight.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Weight(
      id: serializer.fromJson<String>(json['id']),
      animalId: serializer.fromJson<String>(json['animalId']),
      at: serializer.fromJson<String>(json['at']),
      weight: serializer.fromJson<double>(json['weight']),
      unit: serializer.fromJson<String>(json['unit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'animalId': serializer.toJson<String>(animalId),
      'at': serializer.toJson<String>(at),
      'weight': serializer.toJson<double>(weight),
      'unit': serializer.toJson<String>(unit),
    };
  }

  Weight copyWith({
    String? id,
    String? animalId,
    String? at,
    double? weight,
    String? unit,
  }) => Weight(
    id: id ?? this.id,
    animalId: animalId ?? this.animalId,
    at: at ?? this.at,
    weight: weight ?? this.weight,
    unit: unit ?? this.unit,
  );
  Weight copyWithCompanion(WeightsCompanion data) {
    return Weight(
      id: data.id.present ? data.id.value : this.id,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      at: data.at.present ? data.at.value : this.at,
      weight: data.weight.present ? data.weight.value : this.weight,
      unit: data.unit.present ? data.unit.value : this.unit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Weight(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('at: $at, ')
          ..write('weight: $weight, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, animalId, at, weight, unit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Weight &&
          other.id == this.id &&
          other.animalId == this.animalId &&
          other.at == this.at &&
          other.weight == this.weight &&
          other.unit == this.unit);
}

class WeightsCompanion extends UpdateCompanion<Weight> {
  final Value<String> id;
  final Value<String> animalId;
  final Value<String> at;
  final Value<double> weight;
  final Value<String> unit;
  final Value<int> rowid;
  const WeightsCompanion({
    this.id = const Value.absent(),
    this.animalId = const Value.absent(),
    this.at = const Value.absent(),
    this.weight = const Value.absent(),
    this.unit = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeightsCompanion.insert({
    required String id,
    required String animalId,
    required String at,
    required double weight,
    this.unit = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       animalId = Value(animalId),
       at = Value(at),
       weight = Value(weight);
  static Insertable<Weight> custom({
    Expression<String>? id,
    Expression<String>? animalId,
    Expression<String>? at,
    Expression<double>? weight,
    Expression<String>? unit,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (animalId != null) 'animal_id': animalId,
      if (at != null) 'at': at,
      if (weight != null) 'weight': weight,
      if (unit != null) 'unit': unit,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeightsCompanion copyWith({
    Value<String>? id,
    Value<String>? animalId,
    Value<String>? at,
    Value<double>? weight,
    Value<String>? unit,
    Value<int>? rowid,
  }) {
    return WeightsCompanion(
      id: id ?? this.id,
      animalId: animalId ?? this.animalId,
      at: at ?? this.at,
      weight: weight ?? this.weight,
      unit: unit ?? this.unit,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (at.present) {
      map['at'] = Variable<String>(at.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightsCompanion(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('at: $at, ')
          ..write('weight: $weight, ')
          ..write('unit: $unit, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CareLogsTable extends CareLogs with TableInfo<$CareLogsTable, CareLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CareLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _animalIdMeta = const VerificationMeta(
    'animalId',
  );
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
    'animal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<String> at = GeneratedColumn<String>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metaJsonMeta = const VerificationMeta(
    'metaJson',
  );
  @override
  late final GeneratedColumn<String> metaJson = GeneratedColumn<String>(
    'meta_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    animalId,
    at,
    type,
    title,
    note,
    metaJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'care_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CareLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('animal_id')) {
      context.handle(
        _animalIdMeta,
        animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('meta_json')) {
      context.handle(
        _metaJsonMeta,
        metaJson.isAcceptableOrUnknown(data['meta_json']!, _metaJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CareLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CareLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      animalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}animal_id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}at'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      metaJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meta_json'],
      ),
    );
  }

  @override
  $CareLogsTable createAlias(String alias) {
    return $CareLogsTable(attachedDatabase, alias);
  }
}

class CareLog extends DataClass implements Insertable<CareLog> {
  final String id;
  final String animalId;
  final String at;
  final String type;
  final String? title;
  final String? note;
  final String? metaJson;
  const CareLog({
    required this.id,
    required this.animalId,
    required this.at,
    required this.type,
    this.title,
    this.note,
    this.metaJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['animal_id'] = Variable<String>(animalId);
    map['at'] = Variable<String>(at);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || metaJson != null) {
      map['meta_json'] = Variable<String>(metaJson);
    }
    return map;
  }

  CareLogsCompanion toCompanion(bool nullToAbsent) {
    return CareLogsCompanion(
      id: Value(id),
      animalId: Value(animalId),
      at: Value(at),
      type: Value(type),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      metaJson: metaJson == null && nullToAbsent
          ? const Value.absent()
          : Value(metaJson),
    );
  }

  factory CareLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CareLog(
      id: serializer.fromJson<String>(json['id']),
      animalId: serializer.fromJson<String>(json['animalId']),
      at: serializer.fromJson<String>(json['at']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String?>(json['title']),
      note: serializer.fromJson<String?>(json['note']),
      metaJson: serializer.fromJson<String?>(json['metaJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'animalId': serializer.toJson<String>(animalId),
      'at': serializer.toJson<String>(at),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String?>(title),
      'note': serializer.toJson<String?>(note),
      'metaJson': serializer.toJson<String?>(metaJson),
    };
  }

  CareLog copyWith({
    String? id,
    String? animalId,
    String? at,
    String? type,
    Value<String?> title = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> metaJson = const Value.absent(),
  }) => CareLog(
    id: id ?? this.id,
    animalId: animalId ?? this.animalId,
    at: at ?? this.at,
    type: type ?? this.type,
    title: title.present ? title.value : this.title,
    note: note.present ? note.value : this.note,
    metaJson: metaJson.present ? metaJson.value : this.metaJson,
  );
  CareLog copyWithCompanion(CareLogsCompanion data) {
    return CareLog(
      id: data.id.present ? data.id.value : this.id,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      at: data.at.present ? data.at.value : this.at,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
      metaJson: data.metaJson.present ? data.metaJson.value : this.metaJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CareLog(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('at: $at, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('metaJson: $metaJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, animalId, at, type, title, note, metaJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CareLog &&
          other.id == this.id &&
          other.animalId == this.animalId &&
          other.at == this.at &&
          other.type == this.type &&
          other.title == this.title &&
          other.note == this.note &&
          other.metaJson == this.metaJson);
}

class CareLogsCompanion extends UpdateCompanion<CareLog> {
  final Value<String> id;
  final Value<String> animalId;
  final Value<String> at;
  final Value<String> type;
  final Value<String?> title;
  final Value<String?> note;
  final Value<String?> metaJson;
  final Value<int> rowid;
  const CareLogsCompanion({
    this.id = const Value.absent(),
    this.animalId = const Value.absent(),
    this.at = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.metaJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CareLogsCompanion.insert({
    required String id,
    required String animalId,
    required String at,
    required String type,
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.metaJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       animalId = Value(animalId),
       at = Value(at),
       type = Value(type);
  static Insertable<CareLog> custom({
    Expression<String>? id,
    Expression<String>? animalId,
    Expression<String>? at,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? note,
    Expression<String>? metaJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (animalId != null) 'animal_id': animalId,
      if (at != null) 'at': at,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (metaJson != null) 'meta_json': metaJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CareLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? animalId,
    Value<String>? at,
    Value<String>? type,
    Value<String?>? title,
    Value<String?>? note,
    Value<String?>? metaJson,
    Value<int>? rowid,
  }) {
    return CareLogsCompanion(
      id: id ?? this.id,
      animalId: animalId ?? this.animalId,
      at: at ?? this.at,
      type: type ?? this.type,
      title: title ?? this.title,
      note: note ?? this.note,
      metaJson: metaJson ?? this.metaJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (at.present) {
      map['at'] = Variable<String>(at.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (metaJson.present) {
      map['meta_json'] = Variable<String>(metaJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CareLogsCompanion(')
          ..write('id: $id, ')
          ..write('animalId: $animalId, ')
          ..write('at: $at, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('metaJson: $metaJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AnimalsTable animals = $AnimalsTable(this);
  late final $FeedingsTable feedings = $FeedingsTable(this);
  late final $CagesTable cages = $CagesTable(this);
  late final $AnimalCagesTable animalCages = $AnimalCagesTable(this);
  late final $CageCleaningsTable cageCleanings = $CageCleaningsTable(this);
  late final $MedicationLogsTable medicationLogs = $MedicationLogsTable(this);
  late final $WeightsTable weights = $WeightsTable(this);
  late final $CareLogsTable careLogs = $CareLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    animals,
    feedings,
    cages,
    animalCages,
    cageCleanings,
    medicationLogs,
    weights,
    careLogs,
  ];
}

typedef $$AnimalsTableCreateCompanionBuilder =
    AnimalsCompanion Function({
      required String id,
      required String name,
      Value<String?> species,
      Value<String?> sex,
      Value<String?> birthDate,
      Value<String?> profileImagePath,
      Value<int?> colorValue,
      Value<bool> isSick,
      Value<String?> healthNote,
      Value<bool> active,
      Value<int> rowid,
    });
typedef $$AnimalsTableUpdateCompanionBuilder =
    AnimalsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> species,
      Value<String?> sex,
      Value<String?> birthDate,
      Value<String?> profileImagePath,
      Value<int?> colorValue,
      Value<bool> isSick,
      Value<String?> healthNote,
      Value<bool> active,
      Value<int> rowid,
    });

class $$AnimalsTableFilterComposer
    extends Composer<_$AppDatabase, $AnimalsTable> {
  $$AnimalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileImagePath => $composableBuilder(
    column: $table.profileImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSick => $composableBuilder(
    column: $table.isSick,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get healthNote => $composableBuilder(
    column: $table.healthNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AnimalsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnimalsTable> {
  $$AnimalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileImagePath => $composableBuilder(
    column: $table.profileImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSick => $composableBuilder(
    column: $table.isSick,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get healthNote => $composableBuilder(
    column: $table.healthNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AnimalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnimalsTable> {
  $$AnimalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get species =>
      $composableBuilder(column: $table.species, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<String> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get profileImagePath => $composableBuilder(
    column: $table.profileImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSick =>
      $composableBuilder(column: $table.isSick, builder: (column) => column);

  GeneratedColumn<String> get healthNote => $composableBuilder(
    column: $table.healthNote,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$AnimalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnimalsTable,
          Animal,
          $$AnimalsTableFilterComposer,
          $$AnimalsTableOrderingComposer,
          $$AnimalsTableAnnotationComposer,
          $$AnimalsTableCreateCompanionBuilder,
          $$AnimalsTableUpdateCompanionBuilder,
          (Animal, BaseReferences<_$AppDatabase, $AnimalsTable, Animal>),
          Animal,
          PrefetchHooks Function()
        > {
  $$AnimalsTableTableManager(_$AppDatabase db, $AnimalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnimalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnimalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnimalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> species = const Value.absent(),
                Value<String?> sex = const Value.absent(),
                Value<String?> birthDate = const Value.absent(),
                Value<String?> profileImagePath = const Value.absent(),
                Value<int?> colorValue = const Value.absent(),
                Value<bool> isSick = const Value.absent(),
                Value<String?> healthNote = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnimalsCompanion(
                id: id,
                name: name,
                species: species,
                sex: sex,
                birthDate: birthDate,
                profileImagePath: profileImagePath,
                colorValue: colorValue,
                isSick: isSick,
                healthNote: healthNote,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> species = const Value.absent(),
                Value<String?> sex = const Value.absent(),
                Value<String?> birthDate = const Value.absent(),
                Value<String?> profileImagePath = const Value.absent(),
                Value<int?> colorValue = const Value.absent(),
                Value<bool> isSick = const Value.absent(),
                Value<String?> healthNote = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnimalsCompanion.insert(
                id: id,
                name: name,
                species: species,
                sex: sex,
                birthDate: birthDate,
                profileImagePath: profileImagePath,
                colorValue: colorValue,
                isSick: isSick,
                healthNote: healthNote,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AnimalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnimalsTable,
      Animal,
      $$AnimalsTableFilterComposer,
      $$AnimalsTableOrderingComposer,
      $$AnimalsTableAnnotationComposer,
      $$AnimalsTableCreateCompanionBuilder,
      $$AnimalsTableUpdateCompanionBuilder,
      (Animal, BaseReferences<_$AppDatabase, $AnimalsTable, Animal>),
      Animal,
      PrefetchHooks Function()
    >;
typedef $$FeedingsTableCreateCompanionBuilder =
    FeedingsCompanion Function({
      required String id,
      required String animalId,
      required String at,
      Value<String?> foodType,
      Value<double?> amount,
      Value<String?> unit,
      Value<String?> supplements,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$FeedingsTableUpdateCompanionBuilder =
    FeedingsCompanion Function({
      Value<String> id,
      Value<String> animalId,
      Value<String> at,
      Value<String?> foodType,
      Value<double?> amount,
      Value<String?> unit,
      Value<String?> supplements,
      Value<String?> note,
      Value<int> rowid,
    });

class $$FeedingsTableFilterComposer
    extends Composer<_$AppDatabase, $FeedingsTable> {
  $$FeedingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get animalId => $composableBuilder(
    column: $table.animalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodType => $composableBuilder(
    column: $table.foodType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplements => $composableBuilder(
    column: $table.supplements,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FeedingsTableOrderingComposer
    extends Composer<_$AppDatabase, $FeedingsTable> {
  $$FeedingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get animalId => $composableBuilder(
    column: $table.animalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodType => $composableBuilder(
    column: $table.foodType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplements => $composableBuilder(
    column: $table.supplements,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FeedingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeedingsTable> {
  $$FeedingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get animalId =>
      $composableBuilder(column: $table.animalId, builder: (column) => column);

  GeneratedColumn<String> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get foodType =>
      $composableBuilder(column: $table.foodType, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get supplements => $composableBuilder(
    column: $table.supplements,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$FeedingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FeedingsTable,
          Feeding,
          $$FeedingsTableFilterComposer,
          $$FeedingsTableOrderingComposer,
          $$FeedingsTableAnnotationComposer,
          $$FeedingsTableCreateCompanionBuilder,
          $$FeedingsTableUpdateCompanionBuilder,
          (Feeding, BaseReferences<_$AppDatabase, $FeedingsTable, Feeding>),
          Feeding,
          PrefetchHooks Function()
        > {
  $$FeedingsTableTableManager(_$AppDatabase db, $FeedingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> animalId = const Value.absent(),
                Value<String> at = const Value.absent(),
                Value<String?> foodType = const Value.absent(),
                Value<double?> amount = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> supplements = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeedingsCompanion(
                id: id,
                animalId: animalId,
                at: at,
                foodType: foodType,
                amount: amount,
                unit: unit,
                supplements: supplements,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String animalId,
                required String at,
                Value<String?> foodType = const Value.absent(),
                Value<double?> amount = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> supplements = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeedingsCompanion.insert(
                id: id,
                animalId: animalId,
                at: at,
                foodType: foodType,
                amount: amount,
                unit: unit,
                supplements: supplements,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FeedingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FeedingsTable,
      Feeding,
      $$FeedingsTableFilterComposer,
      $$FeedingsTableOrderingComposer,
      $$FeedingsTableAnnotationComposer,
      $$FeedingsTableCreateCompanionBuilder,
      $$FeedingsTableUpdateCompanionBuilder,
      (Feeding, BaseReferences<_$AppDatabase, $FeedingsTable, Feeding>),
      Feeding,
      PrefetchHooks Function()
    >;
typedef $$CagesTableCreateCompanionBuilder =
    CagesCompanion Function({
      required String id,
      required String name,
      Value<String?> location,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$CagesTableUpdateCompanionBuilder =
    CagesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> location,
      Value<String?> note,
      Value<int> rowid,
    });

class $$CagesTableFilterComposer extends Composer<_$AppDatabase, $CagesTable> {
  $$CagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CagesTableOrderingComposer
    extends Composer<_$AppDatabase, $CagesTable> {
  $$CagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CagesTable> {
  $$CagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$CagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CagesTable,
          Cage,
          $$CagesTableFilterComposer,
          $$CagesTableOrderingComposer,
          $$CagesTableAnnotationComposer,
          $$CagesTableCreateCompanionBuilder,
          $$CagesTableUpdateCompanionBuilder,
          (Cage, BaseReferences<_$AppDatabase, $CagesTable, Cage>),
          Cage,
          PrefetchHooks Function()
        > {
  $$CagesTableTableManager(_$AppDatabase db, $CagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CagesCompanion(
                id: id,
                name: name,
                location: location,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> location = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CagesCompanion.insert(
                id: id,
                name: name,
                location: location,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CagesTable,
      Cage,
      $$CagesTableFilterComposer,
      $$CagesTableOrderingComposer,
      $$CagesTableAnnotationComposer,
      $$CagesTableCreateCompanionBuilder,
      $$CagesTableUpdateCompanionBuilder,
      (Cage, BaseReferences<_$AppDatabase, $CagesTable, Cage>),
      Cage,
      PrefetchHooks Function()
    >;
typedef $$AnimalCagesTableCreateCompanionBuilder =
    AnimalCagesCompanion Function({
      required String animalId,
      required String cageId,
      Value<int> rowid,
    });
typedef $$AnimalCagesTableUpdateCompanionBuilder =
    AnimalCagesCompanion Function({
      Value<String> animalId,
      Value<String> cageId,
      Value<int> rowid,
    });

class $$AnimalCagesTableFilterComposer
    extends Composer<_$AppDatabase, $AnimalCagesTable> {
  $$AnimalCagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get animalId => $composableBuilder(
    column: $table.animalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cageId => $composableBuilder(
    column: $table.cageId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AnimalCagesTableOrderingComposer
    extends Composer<_$AppDatabase, $AnimalCagesTable> {
  $$AnimalCagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get animalId => $composableBuilder(
    column: $table.animalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cageId => $composableBuilder(
    column: $table.cageId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AnimalCagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnimalCagesTable> {
  $$AnimalCagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get animalId =>
      $composableBuilder(column: $table.animalId, builder: (column) => column);

  GeneratedColumn<String> get cageId =>
      $composableBuilder(column: $table.cageId, builder: (column) => column);
}

class $$AnimalCagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnimalCagesTable,
          AnimalCage,
          $$AnimalCagesTableFilterComposer,
          $$AnimalCagesTableOrderingComposer,
          $$AnimalCagesTableAnnotationComposer,
          $$AnimalCagesTableCreateCompanionBuilder,
          $$AnimalCagesTableUpdateCompanionBuilder,
          (
            AnimalCage,
            BaseReferences<_$AppDatabase, $AnimalCagesTable, AnimalCage>,
          ),
          AnimalCage,
          PrefetchHooks Function()
        > {
  $$AnimalCagesTableTableManager(_$AppDatabase db, $AnimalCagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnimalCagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnimalCagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnimalCagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> animalId = const Value.absent(),
                Value<String> cageId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnimalCagesCompanion(
                animalId: animalId,
                cageId: cageId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String animalId,
                required String cageId,
                Value<int> rowid = const Value.absent(),
              }) => AnimalCagesCompanion.insert(
                animalId: animalId,
                cageId: cageId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AnimalCagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnimalCagesTable,
      AnimalCage,
      $$AnimalCagesTableFilterComposer,
      $$AnimalCagesTableOrderingComposer,
      $$AnimalCagesTableAnnotationComposer,
      $$AnimalCagesTableCreateCompanionBuilder,
      $$AnimalCagesTableUpdateCompanionBuilder,
      (
        AnimalCage,
        BaseReferences<_$AppDatabase, $AnimalCagesTable, AnimalCage>,
      ),
      AnimalCage,
      PrefetchHooks Function()
    >;
typedef $$CageCleaningsTableCreateCompanionBuilder =
    CageCleaningsCompanion Function({
      required String id,
      required String animalId,
      required String at,
      required String type,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$CageCleaningsTableUpdateCompanionBuilder =
    CageCleaningsCompanion Function({
      Value<String> id,
      Value<String> animalId,
      Value<String> at,
      Value<String> type,
      Value<String?> note,
      Value<int> rowid,
    });

class $$CageCleaningsTableFilterComposer
    extends Composer<_$AppDatabase, $CageCleaningsTable> {
  $$CageCleaningsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get animalId => $composableBuilder(
    column: $table.animalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CageCleaningsTableOrderingComposer
    extends Composer<_$AppDatabase, $CageCleaningsTable> {
  $$CageCleaningsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get animalId => $composableBuilder(
    column: $table.animalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CageCleaningsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CageCleaningsTable> {
  $$CageCleaningsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get animalId =>
      $composableBuilder(column: $table.animalId, builder: (column) => column);

  GeneratedColumn<String> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$CageCleaningsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CageCleaningsTable,
          CageCleaning,
          $$CageCleaningsTableFilterComposer,
          $$CageCleaningsTableOrderingComposer,
          $$CageCleaningsTableAnnotationComposer,
          $$CageCleaningsTableCreateCompanionBuilder,
          $$CageCleaningsTableUpdateCompanionBuilder,
          (
            CageCleaning,
            BaseReferences<_$AppDatabase, $CageCleaningsTable, CageCleaning>,
          ),
          CageCleaning,
          PrefetchHooks Function()
        > {
  $$CageCleaningsTableTableManager(_$AppDatabase db, $CageCleaningsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CageCleaningsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CageCleaningsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CageCleaningsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> animalId = const Value.absent(),
                Value<String> at = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CageCleaningsCompanion(
                id: id,
                animalId: animalId,
                at: at,
                type: type,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String animalId,
                required String at,
                required String type,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CageCleaningsCompanion.insert(
                id: id,
                animalId: animalId,
                at: at,
                type: type,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CageCleaningsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CageCleaningsTable,
      CageCleaning,
      $$CageCleaningsTableFilterComposer,
      $$CageCleaningsTableOrderingComposer,
      $$CageCleaningsTableAnnotationComposer,
      $$CageCleaningsTableCreateCompanionBuilder,
      $$CageCleaningsTableUpdateCompanionBuilder,
      (
        CageCleaning,
        BaseReferences<_$AppDatabase, $CageCleaningsTable, CageCleaning>,
      ),
      CageCleaning,
      PrefetchHooks Function()
    >;
typedef $$MedicationLogsTableCreateCompanionBuilder =
    MedicationLogsCompanion Function({
      required String id,
      required String animalId,
      required String at,
      required String medicineName,
      Value<double?> dose,
      Value<String?> unit,
      Value<String?> reason,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$MedicationLogsTableUpdateCompanionBuilder =
    MedicationLogsCompanion Function({
      Value<String> id,
      Value<String> animalId,
      Value<String> at,
      Value<String> medicineName,
      Value<double?> dose,
      Value<String?> unit,
      Value<String?> reason,
      Value<String?> note,
      Value<int> rowid,
    });

class $$MedicationLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationLogsTable> {
  $$MedicationLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get animalId => $composableBuilder(
    column: $table.animalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicineName => $composableBuilder(
    column: $table.medicineName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MedicationLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationLogsTable> {
  $$MedicationLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get animalId => $composableBuilder(
    column: $table.animalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicineName => $composableBuilder(
    column: $table.medicineName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicationLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationLogsTable> {
  $$MedicationLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get animalId =>
      $composableBuilder(column: $table.animalId, builder: (column) => column);

  GeneratedColumn<String> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get medicineName => $composableBuilder(
    column: $table.medicineName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get dose =>
      $composableBuilder(column: $table.dose, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$MedicationLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationLogsTable,
          MedicationLog,
          $$MedicationLogsTableFilterComposer,
          $$MedicationLogsTableOrderingComposer,
          $$MedicationLogsTableAnnotationComposer,
          $$MedicationLogsTableCreateCompanionBuilder,
          $$MedicationLogsTableUpdateCompanionBuilder,
          (
            MedicationLog,
            BaseReferences<_$AppDatabase, $MedicationLogsTable, MedicationLog>,
          ),
          MedicationLog,
          PrefetchHooks Function()
        > {
  $$MedicationLogsTableTableManager(
    _$AppDatabase db,
    $MedicationLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> animalId = const Value.absent(),
                Value<String> at = const Value.absent(),
                Value<String> medicineName = const Value.absent(),
                Value<double?> dose = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationLogsCompanion(
                id: id,
                animalId: animalId,
                at: at,
                medicineName: medicineName,
                dose: dose,
                unit: unit,
                reason: reason,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String animalId,
                required String at,
                required String medicineName,
                Value<double?> dose = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationLogsCompanion.insert(
                id: id,
                animalId: animalId,
                at: at,
                medicineName: medicineName,
                dose: dose,
                unit: unit,
                reason: reason,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MedicationLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationLogsTable,
      MedicationLog,
      $$MedicationLogsTableFilterComposer,
      $$MedicationLogsTableOrderingComposer,
      $$MedicationLogsTableAnnotationComposer,
      $$MedicationLogsTableCreateCompanionBuilder,
      $$MedicationLogsTableUpdateCompanionBuilder,
      (
        MedicationLog,
        BaseReferences<_$AppDatabase, $MedicationLogsTable, MedicationLog>,
      ),
      MedicationLog,
      PrefetchHooks Function()
    >;
typedef $$WeightsTableCreateCompanionBuilder =
    WeightsCompanion Function({
      required String id,
      required String animalId,
      required String at,
      required double weight,
      Value<String> unit,
      Value<int> rowid,
    });
typedef $$WeightsTableUpdateCompanionBuilder =
    WeightsCompanion Function({
      Value<String> id,
      Value<String> animalId,
      Value<String> at,
      Value<double> weight,
      Value<String> unit,
      Value<int> rowid,
    });

class $$WeightsTableFilterComposer
    extends Composer<_$AppDatabase, $WeightsTable> {
  $$WeightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get animalId => $composableBuilder(
    column: $table.animalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeightsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightsTable> {
  $$WeightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get animalId => $composableBuilder(
    column: $table.animalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightsTable> {
  $$WeightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get animalId =>
      $composableBuilder(column: $table.animalId, builder: (column) => column);

  GeneratedColumn<String> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);
}

class $$WeightsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightsTable,
          Weight,
          $$WeightsTableFilterComposer,
          $$WeightsTableOrderingComposer,
          $$WeightsTableAnnotationComposer,
          $$WeightsTableCreateCompanionBuilder,
          $$WeightsTableUpdateCompanionBuilder,
          (Weight, BaseReferences<_$AppDatabase, $WeightsTable, Weight>),
          Weight,
          PrefetchHooks Function()
        > {
  $$WeightsTableTableManager(_$AppDatabase db, $WeightsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> animalId = const Value.absent(),
                Value<String> at = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeightsCompanion(
                id: id,
                animalId: animalId,
                at: at,
                weight: weight,
                unit: unit,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String animalId,
                required String at,
                required double weight,
                Value<String> unit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeightsCompanion.insert(
                id: id,
                animalId: animalId,
                at: at,
                weight: weight,
                unit: unit,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeightsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightsTable,
      Weight,
      $$WeightsTableFilterComposer,
      $$WeightsTableOrderingComposer,
      $$WeightsTableAnnotationComposer,
      $$WeightsTableCreateCompanionBuilder,
      $$WeightsTableUpdateCompanionBuilder,
      (Weight, BaseReferences<_$AppDatabase, $WeightsTable, Weight>),
      Weight,
      PrefetchHooks Function()
    >;
typedef $$CareLogsTableCreateCompanionBuilder =
    CareLogsCompanion Function({
      required String id,
      required String animalId,
      required String at,
      required String type,
      Value<String?> title,
      Value<String?> note,
      Value<String?> metaJson,
      Value<int> rowid,
    });
typedef $$CareLogsTableUpdateCompanionBuilder =
    CareLogsCompanion Function({
      Value<String> id,
      Value<String> animalId,
      Value<String> at,
      Value<String> type,
      Value<String?> title,
      Value<String?> note,
      Value<String?> metaJson,
      Value<int> rowid,
    });

class $$CareLogsTableFilterComposer
    extends Composer<_$AppDatabase, $CareLogsTable> {
  $$CareLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get animalId => $composableBuilder(
    column: $table.animalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metaJson => $composableBuilder(
    column: $table.metaJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CareLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $CareLogsTable> {
  $$CareLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get animalId => $composableBuilder(
    column: $table.animalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metaJson => $composableBuilder(
    column: $table.metaJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CareLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CareLogsTable> {
  $$CareLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get animalId =>
      $composableBuilder(column: $table.animalId, builder: (column) => column);

  GeneratedColumn<String> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get metaJson =>
      $composableBuilder(column: $table.metaJson, builder: (column) => column);
}

class $$CareLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CareLogsTable,
          CareLog,
          $$CareLogsTableFilterComposer,
          $$CareLogsTableOrderingComposer,
          $$CareLogsTableAnnotationComposer,
          $$CareLogsTableCreateCompanionBuilder,
          $$CareLogsTableUpdateCompanionBuilder,
          (CareLog, BaseReferences<_$AppDatabase, $CareLogsTable, CareLog>),
          CareLog,
          PrefetchHooks Function()
        > {
  $$CareLogsTableTableManager(_$AppDatabase db, $CareLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CareLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CareLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CareLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> animalId = const Value.absent(),
                Value<String> at = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> metaJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CareLogsCompanion(
                id: id,
                animalId: animalId,
                at: at,
                type: type,
                title: title,
                note: note,
                metaJson: metaJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String animalId,
                required String at,
                required String type,
                Value<String?> title = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> metaJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CareLogsCompanion.insert(
                id: id,
                animalId: animalId,
                at: at,
                type: type,
                title: title,
                note: note,
                metaJson: metaJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CareLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CareLogsTable,
      CareLog,
      $$CareLogsTableFilterComposer,
      $$CareLogsTableOrderingComposer,
      $$CareLogsTableAnnotationComposer,
      $$CareLogsTableCreateCompanionBuilder,
      $$CareLogsTableUpdateCompanionBuilder,
      (CareLog, BaseReferences<_$AppDatabase, $CareLogsTable, CareLog>),
      CareLog,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AnimalsTableTableManager get animals =>
      $$AnimalsTableTableManager(_db, _db.animals);
  $$FeedingsTableTableManager get feedings =>
      $$FeedingsTableTableManager(_db, _db.feedings);
  $$CagesTableTableManager get cages =>
      $$CagesTableTableManager(_db, _db.cages);
  $$AnimalCagesTableTableManager get animalCages =>
      $$AnimalCagesTableTableManager(_db, _db.animalCages);
  $$CageCleaningsTableTableManager get cageCleanings =>
      $$CageCleaningsTableTableManager(_db, _db.cageCleanings);
  $$MedicationLogsTableTableManager get medicationLogs =>
      $$MedicationLogsTableTableManager(_db, _db.medicationLogs);
  $$WeightsTableTableManager get weights =>
      $$WeightsTableTableManager(_db, _db.weights);
  $$CareLogsTableTableManager get careLogs =>
      $$CareLogsTableTableManager(_db, _db.careLogs);
}
