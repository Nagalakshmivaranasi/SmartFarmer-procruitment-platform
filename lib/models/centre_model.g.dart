// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'centre_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCentreModelCollection on Isar {
  IsarCollection<CentreModel> get centreModels => this.collection();
}

const CentreModelSchema = CollectionSchema(
  name: r'CentreModel',
  id: 7650678971383665974,
  properties: {
    r'capacity': PropertySchema(
      id: 0,
      name: r'capacity',
      type: IsarType.long,
    ),
    r'centreId': PropertySchema(
      id: 1,
      name: r'centreId',
      type: IsarType.string,
    ),
    r'centreName': PropertySchema(
      id: 2,
      name: r'centreName',
      type: IsarType.string,
    ),
    r'district': PropertySchema(
      id: 3,
      name: r'district',
      type: IsarType.string,
    ),
    r'state': PropertySchema(
      id: 4,
      name: r'state',
      type: IsarType.string,
    )
  },
  estimateSize: _centreModelEstimateSize,
  serialize: _centreModelSerialize,
  deserialize: _centreModelDeserialize,
  deserializeProp: _centreModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'centreId': IndexSchema(
      id: -3244273602824268092,
      name: r'centreId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'centreId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'state': IndexSchema(
      id: 7917036384617311412,
      name: r'state',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'state',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'district': IndexSchema(
      id: 4102361732179188505,
      name: r'district',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'district',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _centreModelGetId,
  getLinks: _centreModelGetLinks,
  attach: _centreModelAttach,
  version: '3.1.0+1',
);

int _centreModelEstimateSize(
  CentreModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.centreId.length * 3;
  bytesCount += 3 + object.centreName.length * 3;
  bytesCount += 3 + object.district.length * 3;
  bytesCount += 3 + object.state.length * 3;
  return bytesCount;
}

void _centreModelSerialize(
  CentreModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.capacity);
  writer.writeString(offsets[1], object.centreId);
  writer.writeString(offsets[2], object.centreName);
  writer.writeString(offsets[3], object.district);
  writer.writeString(offsets[4], object.state);
}

CentreModel _centreModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CentreModel(
    capacity: reader.readLong(offsets[0]),
    centreId: reader.readString(offsets[1]),
    centreName: reader.readString(offsets[2]),
    district: reader.readString(offsets[3]),
    state: reader.readString(offsets[4]),
  );
  object.id = id;
  return object;
}

P _centreModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _centreModelGetId(CentreModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _centreModelGetLinks(CentreModel object) {
  return [];
}

void _centreModelAttach(
    IsarCollection<dynamic> col, Id id, CentreModel object) {
  object.id = id;
}

extension CentreModelByIndex on IsarCollection<CentreModel> {
  Future<CentreModel?> getByCentreId(String centreId) {
    return getByIndex(r'centreId', [centreId]);
  }

  CentreModel? getByCentreIdSync(String centreId) {
    return getByIndexSync(r'centreId', [centreId]);
  }

  Future<bool> deleteByCentreId(String centreId) {
    return deleteByIndex(r'centreId', [centreId]);
  }

  bool deleteByCentreIdSync(String centreId) {
    return deleteByIndexSync(r'centreId', [centreId]);
  }

  Future<List<CentreModel?>> getAllByCentreId(List<String> centreIdValues) {
    final values = centreIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'centreId', values);
  }

  List<CentreModel?> getAllByCentreIdSync(List<String> centreIdValues) {
    final values = centreIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'centreId', values);
  }

  Future<int> deleteAllByCentreId(List<String> centreIdValues) {
    final values = centreIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'centreId', values);
  }

  int deleteAllByCentreIdSync(List<String> centreIdValues) {
    final values = centreIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'centreId', values);
  }

  Future<Id> putByCentreId(CentreModel object) {
    return putByIndex(r'centreId', object);
  }

  Id putByCentreIdSync(CentreModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'centreId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCentreId(List<CentreModel> objects) {
    return putAllByIndex(r'centreId', objects);
  }

  List<Id> putAllByCentreIdSync(List<CentreModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'centreId', objects, saveLinks: saveLinks);
  }
}

extension CentreModelQueryWhereSort
    on QueryBuilder<CentreModel, CentreModel, QWhere> {
  QueryBuilder<CentreModel, CentreModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CentreModelQueryWhere
    on QueryBuilder<CentreModel, CentreModel, QWhereClause> {
  QueryBuilder<CentreModel, CentreModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterWhereClause> centreIdEqualTo(
      String centreId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'centreId',
        value: [centreId],
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterWhereClause> centreIdNotEqualTo(
      String centreId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'centreId',
              lower: [],
              upper: [centreId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'centreId',
              lower: [centreId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'centreId',
              lower: [centreId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'centreId',
              lower: [],
              upper: [centreId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterWhereClause> stateEqualTo(
      String state) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'state',
        value: [state],
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterWhereClause> stateNotEqualTo(
      String state) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'state',
              lower: [],
              upper: [state],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'state',
              lower: [state],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'state',
              lower: [state],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'state',
              lower: [],
              upper: [state],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterWhereClause> districtEqualTo(
      String district) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'district',
        value: [district],
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterWhereClause> districtNotEqualTo(
      String district) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'district',
              lower: [],
              upper: [district],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'district',
              lower: [district],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'district',
              lower: [district],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'district',
              lower: [],
              upper: [district],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CentreModelQueryFilter
    on QueryBuilder<CentreModel, CentreModel, QFilterCondition> {
  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> capacityEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'capacity',
        value: value,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      capacityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'capacity',
        value: value,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      capacityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'capacity',
        value: value,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> capacityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'capacity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> centreIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'centreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      centreIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'centreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      centreIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'centreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> centreIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'centreId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      centreIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'centreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      centreIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'centreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      centreIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'centreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> centreIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'centreId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      centreIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'centreId',
        value: '',
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      centreIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'centreId',
        value: '',
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      centreNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'centreName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      centreNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'centreName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      centreNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'centreName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      centreNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'centreName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      centreNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'centreName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      centreNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'centreName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      centreNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'centreName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      centreNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'centreName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      centreNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'centreName',
        value: '',
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      centreNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'centreName',
        value: '',
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> districtEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      districtGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      districtLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> districtBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'district',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      districtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      districtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      districtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> districtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'district',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      districtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'district',
        value: '',
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      districtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'district',
        value: '',
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> stateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      stateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> stateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> stateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'state',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> stateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> stateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> stateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> stateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'state',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition> stateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: '',
      ));
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterFilterCondition>
      stateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'state',
        value: '',
      ));
    });
  }
}

extension CentreModelQueryObject
    on QueryBuilder<CentreModel, CentreModel, QFilterCondition> {}

extension CentreModelQueryLinks
    on QueryBuilder<CentreModel, CentreModel, QFilterCondition> {}

extension CentreModelQuerySortBy
    on QueryBuilder<CentreModel, CentreModel, QSortBy> {
  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> sortByCapacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacity', Sort.asc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> sortByCapacityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacity', Sort.desc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> sortByCentreId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centreId', Sort.asc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> sortByCentreIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centreId', Sort.desc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> sortByCentreName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centreName', Sort.asc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> sortByCentreNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centreName', Sort.desc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> sortByDistrict() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'district', Sort.asc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> sortByDistrictDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'district', Sort.desc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> sortByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> sortByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }
}

extension CentreModelQuerySortThenBy
    on QueryBuilder<CentreModel, CentreModel, QSortThenBy> {
  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> thenByCapacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacity', Sort.asc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> thenByCapacityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacity', Sort.desc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> thenByCentreId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centreId', Sort.asc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> thenByCentreIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centreId', Sort.desc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> thenByCentreName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centreName', Sort.asc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> thenByCentreNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centreName', Sort.desc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> thenByDistrict() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'district', Sort.asc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> thenByDistrictDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'district', Sort.desc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> thenByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QAfterSortBy> thenByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }
}

extension CentreModelQueryWhereDistinct
    on QueryBuilder<CentreModel, CentreModel, QDistinct> {
  QueryBuilder<CentreModel, CentreModel, QDistinct> distinctByCapacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'capacity');
    });
  }

  QueryBuilder<CentreModel, CentreModel, QDistinct> distinctByCentreId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'centreId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QDistinct> distinctByCentreName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'centreName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QDistinct> distinctByDistrict(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'district', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CentreModel, CentreModel, QDistinct> distinctByState(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'state', caseSensitive: caseSensitive);
    });
  }
}

extension CentreModelQueryProperty
    on QueryBuilder<CentreModel, CentreModel, QQueryProperty> {
  QueryBuilder<CentreModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CentreModel, int, QQueryOperations> capacityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'capacity');
    });
  }

  QueryBuilder<CentreModel, String, QQueryOperations> centreIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'centreId');
    });
  }

  QueryBuilder<CentreModel, String, QQueryOperations> centreNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'centreName');
    });
  }

  QueryBuilder<CentreModel, String, QQueryOperations> districtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'district');
    });
  }

  QueryBuilder<CentreModel, String, QQueryOperations> stateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'state');
    });
  }
}
