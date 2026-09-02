// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBookingModelCollection on Isar {
  IsarCollection<BookingModel> get bookingModels => this.collection();
}

const BookingModelSchema = CollectionSchema(
  name: r'BookingModel',
  id: 643181679485769242,
  properties: {
    r'bookingDate': PropertySchema(
      id: 0,
      name: r'bookingDate',
      type: IsarType.dateTime,
    ),
    r'bookingId': PropertySchema(
      id: 1,
      name: r'bookingId',
      type: IsarType.string,
    ),
    r'centreId': PropertySchema(
      id: 2,
      name: r'centreId',
      type: IsarType.string,
    ),
    r'centreName': PropertySchema(
      id: 3,
      name: r'centreName',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'crop': PropertySchema(
      id: 5,
      name: r'crop',
      type: IsarType.string,
    ),
    r'farmerId': PropertySchema(
      id: 6,
      name: r'farmerId',
      type: IsarType.string,
    ),
    r'farmerName': PropertySchema(
      id: 7,
      name: r'farmerName',
      type: IsarType.string,
    ),
    r'paymentStatus': PropertySchema(
      id: 8,
      name: r'paymentStatus',
      type: IsarType.string,
    ),
    r'quantityQuintal': PropertySchema(
      id: 9,
      name: r'quantityQuintal',
      type: IsarType.double,
    ),
    r'slotTime': PropertySchema(
      id: 10,
      name: r'slotTime',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 11,
      name: r'status',
      type: IsarType.string,
    ),
    r'token': PropertySchema(
      id: 12,
      name: r'token',
      type: IsarType.string,
    )
  },
  estimateSize: _bookingModelEstimateSize,
  serialize: _bookingModelSerialize,
  deserialize: _bookingModelDeserialize,
  deserializeProp: _bookingModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'bookingId': IndexSchema(
      id: 4804924406505946939,
      name: r'bookingId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'bookingId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'farmerId': IndexSchema(
      id: -2038338479119917631,
      name: r'farmerId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'farmerId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'centreId': IndexSchema(
      id: -3244273602824268092,
      name: r'centreId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'centreId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'bookingDate': IndexSchema(
      id: -5790137373829985556,
      name: r'bookingDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'bookingDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'token': IndexSchema(
      id: -5898650166254967271,
      name: r'token',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'token',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _bookingModelGetId,
  getLinks: _bookingModelGetLinks,
  attach: _bookingModelAttach,
  version: '3.1.0+1',
);

int _bookingModelEstimateSize(
  BookingModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bookingId.length * 3;
  bytesCount += 3 + object.centreId.length * 3;
  bytesCount += 3 + object.centreName.length * 3;
  bytesCount += 3 + object.crop.length * 3;
  bytesCount += 3 + object.farmerId.length * 3;
  bytesCount += 3 + object.farmerName.length * 3;
  bytesCount += 3 + object.paymentStatus.length * 3;
  bytesCount += 3 + object.slotTime.length * 3;
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.token.length * 3;
  return bytesCount;
}

void _bookingModelSerialize(
  BookingModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.bookingDate);
  writer.writeString(offsets[1], object.bookingId);
  writer.writeString(offsets[2], object.centreId);
  writer.writeString(offsets[3], object.centreName);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeString(offsets[5], object.crop);
  writer.writeString(offsets[6], object.farmerId);
  writer.writeString(offsets[7], object.farmerName);
  writer.writeString(offsets[8], object.paymentStatus);
  writer.writeDouble(offsets[9], object.quantityQuintal);
  writer.writeString(offsets[10], object.slotTime);
  writer.writeString(offsets[11], object.status);
  writer.writeString(offsets[12], object.token);
}

BookingModel _bookingModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BookingModel(
    bookingDate: reader.readDateTime(offsets[0]),
    bookingId: reader.readString(offsets[1]),
    centreId: reader.readString(offsets[2]),
    centreName: reader.readString(offsets[3]),
    createdAt: reader.readDateTime(offsets[4]),
    crop: reader.readString(offsets[5]),
    farmerId: reader.readString(offsets[6]),
    farmerName: reader.readString(offsets[7]),
    paymentStatus: reader.readStringOrNull(offsets[8]) ?? 'Pending',
    quantityQuintal: reader.readDouble(offsets[9]),
    slotTime: reader.readString(offsets[10]),
    status: reader.readString(offsets[11]),
    token: reader.readStringOrNull(offsets[12]) ?? '',
  );
  object.id = id;
  return object;
}

P _bookingModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset) ?? 'Pending') as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bookingModelGetId(BookingModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bookingModelGetLinks(BookingModel object) {
  return [];
}

void _bookingModelAttach(
    IsarCollection<dynamic> col, Id id, BookingModel object) {
  object.id = id;
}

extension BookingModelByIndex on IsarCollection<BookingModel> {
  Future<BookingModel?> getByBookingId(String bookingId) {
    return getByIndex(r'bookingId', [bookingId]);
  }

  BookingModel? getByBookingIdSync(String bookingId) {
    return getByIndexSync(r'bookingId', [bookingId]);
  }

  Future<bool> deleteByBookingId(String bookingId) {
    return deleteByIndex(r'bookingId', [bookingId]);
  }

  bool deleteByBookingIdSync(String bookingId) {
    return deleteByIndexSync(r'bookingId', [bookingId]);
  }

  Future<List<BookingModel?>> getAllByBookingId(List<String> bookingIdValues) {
    final values = bookingIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'bookingId', values);
  }

  List<BookingModel?> getAllByBookingIdSync(List<String> bookingIdValues) {
    final values = bookingIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'bookingId', values);
  }

  Future<int> deleteAllByBookingId(List<String> bookingIdValues) {
    final values = bookingIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'bookingId', values);
  }

  int deleteAllByBookingIdSync(List<String> bookingIdValues) {
    final values = bookingIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'bookingId', values);
  }

  Future<Id> putByBookingId(BookingModel object) {
    return putByIndex(r'bookingId', object);
  }

  Id putByBookingIdSync(BookingModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'bookingId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByBookingId(List<BookingModel> objects) {
    return putAllByIndex(r'bookingId', objects);
  }

  List<Id> putAllByBookingIdSync(List<BookingModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'bookingId', objects, saveLinks: saveLinks);
  }

  Future<BookingModel?> getByToken(String token) {
    return getByIndex(r'token', [token]);
  }

  BookingModel? getByTokenSync(String token) {
    return getByIndexSync(r'token', [token]);
  }

  Future<bool> deleteByToken(String token) {
    return deleteByIndex(r'token', [token]);
  }

  bool deleteByTokenSync(String token) {
    return deleteByIndexSync(r'token', [token]);
  }

  Future<List<BookingModel?>> getAllByToken(List<String> tokenValues) {
    final values = tokenValues.map((e) => [e]).toList();
    return getAllByIndex(r'token', values);
  }

  List<BookingModel?> getAllByTokenSync(List<String> tokenValues) {
    final values = tokenValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'token', values);
  }

  Future<int> deleteAllByToken(List<String> tokenValues) {
    final values = tokenValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'token', values);
  }

  int deleteAllByTokenSync(List<String> tokenValues) {
    final values = tokenValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'token', values);
  }

  Future<Id> putByToken(BookingModel object) {
    return putByIndex(r'token', object);
  }

  Id putByTokenSync(BookingModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'token', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByToken(List<BookingModel> objects) {
    return putAllByIndex(r'token', objects);
  }

  List<Id> putAllByTokenSync(List<BookingModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'token', objects, saveLinks: saveLinks);
  }
}

extension BookingModelQueryWhereSort
    on QueryBuilder<BookingModel, BookingModel, QWhere> {
  QueryBuilder<BookingModel, BookingModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhere> anyBookingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'bookingDate'),
      );
    });
  }
}

extension BookingModelQueryWhere
    on QueryBuilder<BookingModel, BookingModel, QWhereClause> {
  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> bookingIdEqualTo(
      String bookingId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookingId',
        value: [bookingId],
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause>
      bookingIdNotEqualTo(String bookingId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookingId',
              lower: [],
              upper: [bookingId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookingId',
              lower: [bookingId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookingId',
              lower: [bookingId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookingId',
              lower: [],
              upper: [bookingId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> farmerIdEqualTo(
      String farmerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'farmerId',
        value: [farmerId],
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause>
      farmerIdNotEqualTo(String farmerId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'farmerId',
              lower: [],
              upper: [farmerId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'farmerId',
              lower: [farmerId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'farmerId',
              lower: [farmerId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'farmerId',
              lower: [],
              upper: [farmerId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> centreIdEqualTo(
      String centreId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'centreId',
        value: [centreId],
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause>
      centreIdNotEqualTo(String centreId) {
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

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause>
      bookingDateEqualTo(DateTime bookingDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookingDate',
        value: [bookingDate],
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause>
      bookingDateNotEqualTo(DateTime bookingDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookingDate',
              lower: [],
              upper: [bookingDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookingDate',
              lower: [bookingDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookingDate',
              lower: [bookingDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookingDate',
              lower: [],
              upper: [bookingDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause>
      bookingDateGreaterThan(
    DateTime bookingDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookingDate',
        lower: [bookingDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause>
      bookingDateLessThan(
    DateTime bookingDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookingDate',
        lower: [],
        upper: [bookingDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause>
      bookingDateBetween(
    DateTime lowerBookingDate,
    DateTime upperBookingDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookingDate',
        lower: [lowerBookingDate],
        includeLower: includeLower,
        upper: [upperBookingDate],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> tokenEqualTo(
      String token) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'token',
        value: [token],
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> tokenNotEqualTo(
      String token) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'token',
              lower: [],
              upper: [token],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'token',
              lower: [token],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'token',
              lower: [token],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'token',
              lower: [],
              upper: [token],
              includeUpper: false,
            ));
      }
    });
  }
}

extension BookingModelQueryFilter
    on QueryBuilder<BookingModel, BookingModel, QFilterCondition> {
  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      bookingDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      bookingDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      bookingDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      bookingDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookingDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      bookingIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      bookingIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      bookingIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      bookingIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookingId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      bookingIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bookingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      bookingIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bookingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      bookingIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bookingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      bookingIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bookingId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      bookingIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookingId',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      bookingIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bookingId',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      centreIdEqualTo(
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      centreIdBetween(
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      centreIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'centreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      centreIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'centreId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      centreIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'centreId',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      centreIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'centreId',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      centreNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'centreName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      centreNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'centreName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      centreNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'centreName',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      centreNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'centreName',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> cropEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'crop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      cropGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'crop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> cropLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'crop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> cropBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'crop',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      cropStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'crop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> cropEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'crop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> cropContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'crop',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> cropMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'crop',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      cropIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'crop',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      cropIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'crop',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'farmerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'farmerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'farmerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'farmerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'farmerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'farmerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'farmerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'farmerId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'farmerId',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'farmerId',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'farmerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'farmerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'farmerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'farmerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'farmerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'farmerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'farmerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'farmerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'farmerName',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      farmerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'farmerName',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      paymentStatusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      paymentStatusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      paymentStatusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      paymentStatusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      paymentStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      paymentStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      paymentStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      paymentStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paymentStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      paymentStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      paymentStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'paymentStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      quantityQuintalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantityQuintal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      quantityQuintalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quantityQuintal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      quantityQuintalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quantityQuintal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      quantityQuintalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quantityQuintal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      slotTimeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slotTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      slotTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slotTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      slotTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slotTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      slotTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slotTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      slotTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slotTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      slotTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slotTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      slotTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slotTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      slotTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slotTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      slotTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slotTime',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      slotTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slotTime',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> statusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> tokenEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'token',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      tokenGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'token',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> tokenLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'token',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> tokenBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'token',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      tokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'token',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> tokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'token',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> tokenContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'token',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> tokenMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'token',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      tokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'token',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      tokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'token',
        value: '',
      ));
    });
  }
}

extension BookingModelQueryObject
    on QueryBuilder<BookingModel, BookingModel, QFilterCondition> {}

extension BookingModelQueryLinks
    on QueryBuilder<BookingModel, BookingModel, QFilterCondition> {}

extension BookingModelQuerySortBy
    on QueryBuilder<BookingModel, BookingModel, QSortBy> {
  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByBookingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingDate', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      sortByBookingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingDate', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByBookingId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingId', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByBookingIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingId', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByCentreId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centreId', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByCentreIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centreId', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByCentreName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centreName', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      sortByCentreNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centreName', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByCrop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'crop', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByCropDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'crop', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByFarmerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmerId', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByFarmerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmerId', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByFarmerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmerName', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      sortByFarmerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmerName', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByPaymentStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      sortByPaymentStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      sortByQuantityQuintal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantityQuintal', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      sortByQuantityQuintalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantityQuintal', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortBySlotTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slotTime', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortBySlotTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slotTime', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.desc);
    });
  }
}

extension BookingModelQuerySortThenBy
    on QueryBuilder<BookingModel, BookingModel, QSortThenBy> {
  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByBookingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingDate', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      thenByBookingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingDate', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByBookingId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingId', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByBookingIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingId', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByCentreId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centreId', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByCentreIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centreId', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByCentreName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centreName', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      thenByCentreNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centreName', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByCrop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'crop', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByCropDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'crop', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByFarmerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmerId', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByFarmerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmerId', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByFarmerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmerName', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      thenByFarmerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmerName', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByPaymentStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      thenByPaymentStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      thenByQuantityQuintal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantityQuintal', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      thenByQuantityQuintalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantityQuintal', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenBySlotTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slotTime', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenBySlotTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slotTime', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.desc);
    });
  }
}

extension BookingModelQueryWhereDistinct
    on QueryBuilder<BookingModel, BookingModel, QDistinct> {
  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByBookingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookingDate');
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByBookingId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookingId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByCentreId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'centreId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByCentreName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'centreName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByCrop(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'crop', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByFarmerId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'farmerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByFarmerName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'farmerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByPaymentStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentStatus',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct>
      distinctByQuantityQuintal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quantityQuintal');
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctBySlotTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slotTime', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByToken(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'token', caseSensitive: caseSensitive);
    });
  }
}

extension BookingModelQueryProperty
    on QueryBuilder<BookingModel, BookingModel, QQueryProperty> {
  QueryBuilder<BookingModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BookingModel, DateTime, QQueryOperations> bookingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookingDate');
    });
  }

  QueryBuilder<BookingModel, String, QQueryOperations> bookingIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookingId');
    });
  }

  QueryBuilder<BookingModel, String, QQueryOperations> centreIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'centreId');
    });
  }

  QueryBuilder<BookingModel, String, QQueryOperations> centreNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'centreName');
    });
  }

  QueryBuilder<BookingModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BookingModel, String, QQueryOperations> cropProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'crop');
    });
  }

  QueryBuilder<BookingModel, String, QQueryOperations> farmerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'farmerId');
    });
  }

  QueryBuilder<BookingModel, String, QQueryOperations> farmerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'farmerName');
    });
  }

  QueryBuilder<BookingModel, String, QQueryOperations> paymentStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentStatus');
    });
  }

  QueryBuilder<BookingModel, double, QQueryOperations>
      quantityQuintalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quantityQuintal');
    });
  }

  QueryBuilder<BookingModel, String, QQueryOperations> slotTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slotTime');
    });
  }

  QueryBuilder<BookingModel, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<BookingModel, String, QQueryOperations> tokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'token');
    });
  }
}
