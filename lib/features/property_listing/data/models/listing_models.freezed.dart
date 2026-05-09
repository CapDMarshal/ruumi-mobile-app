// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PropertyTypeResponse _$PropertyTypeResponseFromJson(Map<String, dynamic> json) {
  return _PropertyTypeResponse.fromJson(json);
}

/// @nodoc
mixin _$PropertyTypeResponse {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this PropertyTypeResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PropertyTypeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyTypeResponseCopyWith<PropertyTypeResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyTypeResponseCopyWith<$Res> {
  factory $PropertyTypeResponseCopyWith(
    PropertyTypeResponse value,
    $Res Function(PropertyTypeResponse) then,
  ) = _$PropertyTypeResponseCopyWithImpl<$Res, PropertyTypeResponse>;
  @useResult
  $Res call({String id, String name, String? description});
}

/// @nodoc
class _$PropertyTypeResponseCopyWithImpl<
  $Res,
  $Val extends PropertyTypeResponse
>
    implements $PropertyTypeResponseCopyWith<$Res> {
  _$PropertyTypeResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PropertyTypeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PropertyTypeResponseImplCopyWith<$Res>
    implements $PropertyTypeResponseCopyWith<$Res> {
  factory _$$PropertyTypeResponseImplCopyWith(
    _$PropertyTypeResponseImpl value,
    $Res Function(_$PropertyTypeResponseImpl) then,
  ) = __$$PropertyTypeResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? description});
}

/// @nodoc
class __$$PropertyTypeResponseImplCopyWithImpl<$Res>
    extends _$PropertyTypeResponseCopyWithImpl<$Res, _$PropertyTypeResponseImpl>
    implements _$$PropertyTypeResponseImplCopyWith<$Res> {
  __$$PropertyTypeResponseImplCopyWithImpl(
    _$PropertyTypeResponseImpl _value,
    $Res Function(_$PropertyTypeResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PropertyTypeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(
      _$PropertyTypeResponseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PropertyTypeResponseImpl implements _PropertyTypeResponse {
  const _$PropertyTypeResponseImpl({
    required this.id,
    required this.name,
    this.description,
  });

  factory _$PropertyTypeResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertyTypeResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;

  @override
  String toString() {
    return 'PropertyTypeResponse(id: $id, name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyTypeResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description);

  /// Create a copy of PropertyTypeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyTypeResponseImplCopyWith<_$PropertyTypeResponseImpl>
  get copyWith =>
      __$$PropertyTypeResponseImplCopyWithImpl<_$PropertyTypeResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertyTypeResponseImplToJson(this);
  }
}

abstract class _PropertyTypeResponse implements PropertyTypeResponse {
  const factory _PropertyTypeResponse({
    required final String id,
    required final String name,
    final String? description,
  }) = _$PropertyTypeResponseImpl;

  factory _PropertyTypeResponse.fromJson(Map<String, dynamic> json) =
      _$PropertyTypeResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;

  /// Create a copy of PropertyTypeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyTypeResponseImplCopyWith<_$PropertyTypeResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ListingCreate _$ListingCreateFromJson(Map<String, dynamic> json) {
  return _ListingCreate.fromJson(json);
}

/// @nodoc
mixin _$ListingCreate {
  @JsonKey(name: 'property_type_id')
  String get propertyTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'space_type')
  String get spaceType => throw _privateConstructorUsedError;

  /// Serializes this ListingCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ListingCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListingCreateCopyWith<ListingCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListingCreateCopyWith<$Res> {
  factory $ListingCreateCopyWith(
    ListingCreate value,
    $Res Function(ListingCreate) then,
  ) = _$ListingCreateCopyWithImpl<$Res, ListingCreate>;
  @useResult
  $Res call({
    @JsonKey(name: 'property_type_id') String propertyTypeId,
    @JsonKey(name: 'space_type') String spaceType,
  });
}

/// @nodoc
class _$ListingCreateCopyWithImpl<$Res, $Val extends ListingCreate>
    implements $ListingCreateCopyWith<$Res> {
  _$ListingCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListingCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? propertyTypeId = null, Object? spaceType = null}) {
    return _then(
      _value.copyWith(
            propertyTypeId: null == propertyTypeId
                ? _value.propertyTypeId
                : propertyTypeId // ignore: cast_nullable_to_non_nullable
                      as String,
            spaceType: null == spaceType
                ? _value.spaceType
                : spaceType // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ListingCreateImplCopyWith<$Res>
    implements $ListingCreateCopyWith<$Res> {
  factory _$$ListingCreateImplCopyWith(
    _$ListingCreateImpl value,
    $Res Function(_$ListingCreateImpl) then,
  ) = __$$ListingCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'property_type_id') String propertyTypeId,
    @JsonKey(name: 'space_type') String spaceType,
  });
}

/// @nodoc
class __$$ListingCreateImplCopyWithImpl<$Res>
    extends _$ListingCreateCopyWithImpl<$Res, _$ListingCreateImpl>
    implements _$$ListingCreateImplCopyWith<$Res> {
  __$$ListingCreateImplCopyWithImpl(
    _$ListingCreateImpl _value,
    $Res Function(_$ListingCreateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ListingCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? propertyTypeId = null, Object? spaceType = null}) {
    return _then(
      _$ListingCreateImpl(
        propertyTypeId: null == propertyTypeId
            ? _value.propertyTypeId
            : propertyTypeId // ignore: cast_nullable_to_non_nullable
                  as String,
        spaceType: null == spaceType
            ? _value.spaceType
            : spaceType // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ListingCreateImpl implements _ListingCreate {
  const _$ListingCreateImpl({
    @JsonKey(name: 'property_type_id') required this.propertyTypeId,
    @JsonKey(name: 'space_type') required this.spaceType,
  });

  factory _$ListingCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListingCreateImplFromJson(json);

  @override
  @JsonKey(name: 'property_type_id')
  final String propertyTypeId;
  @override
  @JsonKey(name: 'space_type')
  final String spaceType;

  @override
  String toString() {
    return 'ListingCreate(propertyTypeId: $propertyTypeId, spaceType: $spaceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingCreateImpl &&
            (identical(other.propertyTypeId, propertyTypeId) ||
                other.propertyTypeId == propertyTypeId) &&
            (identical(other.spaceType, spaceType) ||
                other.spaceType == spaceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, propertyTypeId, spaceType);

  /// Create a copy of ListingCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListingCreateImplCopyWith<_$ListingCreateImpl> get copyWith =>
      __$$ListingCreateImplCopyWithImpl<_$ListingCreateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListingCreateImplToJson(this);
  }
}

abstract class _ListingCreate implements ListingCreate {
  const factory _ListingCreate({
    @JsonKey(name: 'property_type_id') required final String propertyTypeId,
    @JsonKey(name: 'space_type') required final String spaceType,
  }) = _$ListingCreateImpl;

  factory _ListingCreate.fromJson(Map<String, dynamic> json) =
      _$ListingCreateImpl.fromJson;

  @override
  @JsonKey(name: 'property_type_id')
  String get propertyTypeId;
  @override
  @JsonKey(name: 'space_type')
  String get spaceType;

  /// Create a copy of ListingCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListingCreateImplCopyWith<_$ListingCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ListingUpdate _$ListingUpdateFromJson(Map<String, dynamic> json) {
  return _ListingUpdate.fromJson(json);
}

/// @nodoc
mixin _$ListingUpdate {
  @JsonKey(name: 'property_type_id')
  String? get propertyTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'space_type')
  String? get spaceType => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_line_1')
  String? get addressLine1 => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'postal_code')
  String? get postalCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_guests')
  int? get maxGuests => throw _privateConstructorUsedError;
  int? get bedrooms => throw _privateConstructorUsedError;
  double? get bathrooms => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_size')
  int? get propertySize => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_price')
  double? get basePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_type')
  String? get bookingType => throw _privateConstructorUsedError;

  /// Serializes this ListingUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ListingUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListingUpdateCopyWith<ListingUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListingUpdateCopyWith<$Res> {
  factory $ListingUpdateCopyWith(
    ListingUpdate value,
    $Res Function(ListingUpdate) then,
  ) = _$ListingUpdateCopyWithImpl<$Res, ListingUpdate>;
  @useResult
  $Res call({
    @JsonKey(name: 'property_type_id') String? propertyTypeId,
    @JsonKey(name: 'space_type') String? spaceType,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'address_line_1') String? addressLine1,
    String? city,
    @JsonKey(name: 'postal_code') String? postalCode,
    @JsonKey(name: 'max_guests') int? maxGuests,
    int? bedrooms,
    double? bathrooms,
    @JsonKey(name: 'property_size') int? propertySize,
    String? title,
    String? description,
    @JsonKey(name: 'base_price') double? basePrice,
    @JsonKey(name: 'booking_type') String? bookingType,
  });
}

/// @nodoc
class _$ListingUpdateCopyWithImpl<$Res, $Val extends ListingUpdate>
    implements $ListingUpdateCopyWith<$Res> {
  _$ListingUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListingUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? propertyTypeId = freezed,
    Object? spaceType = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? addressLine1 = freezed,
    Object? city = freezed,
    Object? postalCode = freezed,
    Object? maxGuests = freezed,
    Object? bedrooms = freezed,
    Object? bathrooms = freezed,
    Object? propertySize = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? basePrice = freezed,
    Object? bookingType = freezed,
  }) {
    return _then(
      _value.copyWith(
            propertyTypeId: freezed == propertyTypeId
                ? _value.propertyTypeId
                : propertyTypeId // ignore: cast_nullable_to_non_nullable
                      as String?,
            spaceType: freezed == spaceType
                ? _value.spaceType
                : spaceType // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            addressLine1: freezed == addressLine1
                ? _value.addressLine1
                : addressLine1 // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            postalCode: freezed == postalCode
                ? _value.postalCode
                : postalCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            maxGuests: freezed == maxGuests
                ? _value.maxGuests
                : maxGuests // ignore: cast_nullable_to_non_nullable
                      as int?,
            bedrooms: freezed == bedrooms
                ? _value.bedrooms
                : bedrooms // ignore: cast_nullable_to_non_nullable
                      as int?,
            bathrooms: freezed == bathrooms
                ? _value.bathrooms
                : bathrooms // ignore: cast_nullable_to_non_nullable
                      as double?,
            propertySize: freezed == propertySize
                ? _value.propertySize
                : propertySize // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            basePrice: freezed == basePrice
                ? _value.basePrice
                : basePrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            bookingType: freezed == bookingType
                ? _value.bookingType
                : bookingType // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ListingUpdateImplCopyWith<$Res>
    implements $ListingUpdateCopyWith<$Res> {
  factory _$$ListingUpdateImplCopyWith(
    _$ListingUpdateImpl value,
    $Res Function(_$ListingUpdateImpl) then,
  ) = __$$ListingUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'property_type_id') String? propertyTypeId,
    @JsonKey(name: 'space_type') String? spaceType,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'address_line_1') String? addressLine1,
    String? city,
    @JsonKey(name: 'postal_code') String? postalCode,
    @JsonKey(name: 'max_guests') int? maxGuests,
    int? bedrooms,
    double? bathrooms,
    @JsonKey(name: 'property_size') int? propertySize,
    String? title,
    String? description,
    @JsonKey(name: 'base_price') double? basePrice,
    @JsonKey(name: 'booking_type') String? bookingType,
  });
}

/// @nodoc
class __$$ListingUpdateImplCopyWithImpl<$Res>
    extends _$ListingUpdateCopyWithImpl<$Res, _$ListingUpdateImpl>
    implements _$$ListingUpdateImplCopyWith<$Res> {
  __$$ListingUpdateImplCopyWithImpl(
    _$ListingUpdateImpl _value,
    $Res Function(_$ListingUpdateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ListingUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? propertyTypeId = freezed,
    Object? spaceType = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? addressLine1 = freezed,
    Object? city = freezed,
    Object? postalCode = freezed,
    Object? maxGuests = freezed,
    Object? bedrooms = freezed,
    Object? bathrooms = freezed,
    Object? propertySize = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? basePrice = freezed,
    Object? bookingType = freezed,
  }) {
    return _then(
      _$ListingUpdateImpl(
        propertyTypeId: freezed == propertyTypeId
            ? _value.propertyTypeId
            : propertyTypeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        spaceType: freezed == spaceType
            ? _value.spaceType
            : spaceType // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        addressLine1: freezed == addressLine1
            ? _value.addressLine1
            : addressLine1 // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        postalCode: freezed == postalCode
            ? _value.postalCode
            : postalCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        maxGuests: freezed == maxGuests
            ? _value.maxGuests
            : maxGuests // ignore: cast_nullable_to_non_nullable
                  as int?,
        bedrooms: freezed == bedrooms
            ? _value.bedrooms
            : bedrooms // ignore: cast_nullable_to_non_nullable
                  as int?,
        bathrooms: freezed == bathrooms
            ? _value.bathrooms
            : bathrooms // ignore: cast_nullable_to_non_nullable
                  as double?,
        propertySize: freezed == propertySize
            ? _value.propertySize
            : propertySize // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        basePrice: freezed == basePrice
            ? _value.basePrice
            : basePrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        bookingType: freezed == bookingType
            ? _value.bookingType
            : bookingType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ListingUpdateImpl implements _ListingUpdate {
  const _$ListingUpdateImpl({
    @JsonKey(name: 'property_type_id') this.propertyTypeId,
    @JsonKey(name: 'space_type') this.spaceType,
    this.latitude,
    this.longitude,
    @JsonKey(name: 'address_line_1') this.addressLine1,
    this.city,
    @JsonKey(name: 'postal_code') this.postalCode,
    @JsonKey(name: 'max_guests') this.maxGuests,
    this.bedrooms,
    this.bathrooms,
    @JsonKey(name: 'property_size') this.propertySize,
    this.title,
    this.description,
    @JsonKey(name: 'base_price') this.basePrice,
    @JsonKey(name: 'booking_type') this.bookingType,
  });

  factory _$ListingUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListingUpdateImplFromJson(json);

  @override
  @JsonKey(name: 'property_type_id')
  final String? propertyTypeId;
  @override
  @JsonKey(name: 'space_type')
  final String? spaceType;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  @JsonKey(name: 'address_line_1')
  final String? addressLine1;
  @override
  final String? city;
  @override
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  @override
  @JsonKey(name: 'max_guests')
  final int? maxGuests;
  @override
  final int? bedrooms;
  @override
  final double? bathrooms;
  @override
  @JsonKey(name: 'property_size')
  final int? propertySize;
  @override
  final String? title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'base_price')
  final double? basePrice;
  @override
  @JsonKey(name: 'booking_type')
  final String? bookingType;

  @override
  String toString() {
    return 'ListingUpdate(propertyTypeId: $propertyTypeId, spaceType: $spaceType, latitude: $latitude, longitude: $longitude, addressLine1: $addressLine1, city: $city, postalCode: $postalCode, maxGuests: $maxGuests, bedrooms: $bedrooms, bathrooms: $bathrooms, propertySize: $propertySize, title: $title, description: $description, basePrice: $basePrice, bookingType: $bookingType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingUpdateImpl &&
            (identical(other.propertyTypeId, propertyTypeId) ||
                other.propertyTypeId == propertyTypeId) &&
            (identical(other.spaceType, spaceType) ||
                other.spaceType == spaceType) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.addressLine1, addressLine1) ||
                other.addressLine1 == addressLine1) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.maxGuests, maxGuests) ||
                other.maxGuests == maxGuests) &&
            (identical(other.bedrooms, bedrooms) ||
                other.bedrooms == bedrooms) &&
            (identical(other.bathrooms, bathrooms) ||
                other.bathrooms == bathrooms) &&
            (identical(other.propertySize, propertySize) ||
                other.propertySize == propertySize) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.bookingType, bookingType) ||
                other.bookingType == bookingType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    propertyTypeId,
    spaceType,
    latitude,
    longitude,
    addressLine1,
    city,
    postalCode,
    maxGuests,
    bedrooms,
    bathrooms,
    propertySize,
    title,
    description,
    basePrice,
    bookingType,
  );

  /// Create a copy of ListingUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListingUpdateImplCopyWith<_$ListingUpdateImpl> get copyWith =>
      __$$ListingUpdateImplCopyWithImpl<_$ListingUpdateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListingUpdateImplToJson(this);
  }
}

abstract class _ListingUpdate implements ListingUpdate {
  const factory _ListingUpdate({
    @JsonKey(name: 'property_type_id') final String? propertyTypeId,
    @JsonKey(name: 'space_type') final String? spaceType,
    final double? latitude,
    final double? longitude,
    @JsonKey(name: 'address_line_1') final String? addressLine1,
    final String? city,
    @JsonKey(name: 'postal_code') final String? postalCode,
    @JsonKey(name: 'max_guests') final int? maxGuests,
    final int? bedrooms,
    final double? bathrooms,
    @JsonKey(name: 'property_size') final int? propertySize,
    final String? title,
    final String? description,
    @JsonKey(name: 'base_price') final double? basePrice,
    @JsonKey(name: 'booking_type') final String? bookingType,
  }) = _$ListingUpdateImpl;

  factory _ListingUpdate.fromJson(Map<String, dynamic> json) =
      _$ListingUpdateImpl.fromJson;

  @override
  @JsonKey(name: 'property_type_id')
  String? get propertyTypeId;
  @override
  @JsonKey(name: 'space_type')
  String? get spaceType;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  @JsonKey(name: 'address_line_1')
  String? get addressLine1;
  @override
  String? get city;
  @override
  @JsonKey(name: 'postal_code')
  String? get postalCode;
  @override
  @JsonKey(name: 'max_guests')
  int? get maxGuests;
  @override
  int? get bedrooms;
  @override
  double? get bathrooms;
  @override
  @JsonKey(name: 'property_size')
  int? get propertySize;
  @override
  String? get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'base_price')
  double? get basePrice;
  @override
  @JsonKey(name: 'booking_type')
  String? get bookingType;

  /// Create a copy of ListingUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListingUpdateImplCopyWith<_$ListingUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ListingResponse _$ListingResponseFromJson(Map<String, dynamic> json) {
  return _ListingResponse.fromJson(json);
}

/// @nodoc
mixin _$ListingResponse {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'host_id')
  int get hostId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_type_id')
  String? get propertyTypeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'space_type')
  String? get spaceType => throw _privateConstructorUsedError; // These fields come back as strings from the API
  @_NumericStringConverter()
  double? get latitude => throw _privateConstructorUsedError;
  @_NumericStringConverter()
  double? get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_line_1')
  String? get addressLine1 => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'postal_code')
  String? get postalCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_guests')
  int? get maxGuests => throw _privateConstructorUsedError;
  int? get bedrooms => throw _privateConstructorUsedError;
  @_NumericStringConverter()
  double? get bathrooms => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_size')
  int? get propertySize => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_price')
  @_NumericStringConverter()
  double? get basePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_type')
  String? get bookingType => throw _privateConstructorUsedError;

  /// Serializes this ListingResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ListingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListingResponseCopyWith<ListingResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListingResponseCopyWith<$Res> {
  factory $ListingResponseCopyWith(
    ListingResponse value,
    $Res Function(ListingResponse) then,
  ) = _$ListingResponseCopyWithImpl<$Res, ListingResponse>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'host_id') int hostId,
    String status,
    @JsonKey(name: 'property_type_id') String? propertyTypeId,
    @JsonKey(name: 'space_type') String? spaceType,
    @_NumericStringConverter() double? latitude,
    @_NumericStringConverter() double? longitude,
    @JsonKey(name: 'address_line_1') String? addressLine1,
    String? city,
    @JsonKey(name: 'postal_code') String? postalCode,
    @JsonKey(name: 'max_guests') int? maxGuests,
    int? bedrooms,
    @_NumericStringConverter() double? bathrooms,
    @JsonKey(name: 'property_size') int? propertySize,
    String? title,
    String? description,
    @JsonKey(name: 'base_price') @_NumericStringConverter() double? basePrice,
    @JsonKey(name: 'booking_type') String? bookingType,
  });
}

/// @nodoc
class _$ListingResponseCopyWithImpl<$Res, $Val extends ListingResponse>
    implements $ListingResponseCopyWith<$Res> {
  _$ListingResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hostId = null,
    Object? status = null,
    Object? propertyTypeId = freezed,
    Object? spaceType = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? addressLine1 = freezed,
    Object? city = freezed,
    Object? postalCode = freezed,
    Object? maxGuests = freezed,
    Object? bedrooms = freezed,
    Object? bathrooms = freezed,
    Object? propertySize = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? basePrice = freezed,
    Object? bookingType = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            hostId: null == hostId
                ? _value.hostId
                : hostId // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            propertyTypeId: freezed == propertyTypeId
                ? _value.propertyTypeId
                : propertyTypeId // ignore: cast_nullable_to_non_nullable
                      as String?,
            spaceType: freezed == spaceType
                ? _value.spaceType
                : spaceType // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            addressLine1: freezed == addressLine1
                ? _value.addressLine1
                : addressLine1 // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            postalCode: freezed == postalCode
                ? _value.postalCode
                : postalCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            maxGuests: freezed == maxGuests
                ? _value.maxGuests
                : maxGuests // ignore: cast_nullable_to_non_nullable
                      as int?,
            bedrooms: freezed == bedrooms
                ? _value.bedrooms
                : bedrooms // ignore: cast_nullable_to_non_nullable
                      as int?,
            bathrooms: freezed == bathrooms
                ? _value.bathrooms
                : bathrooms // ignore: cast_nullable_to_non_nullable
                      as double?,
            propertySize: freezed == propertySize
                ? _value.propertySize
                : propertySize // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            basePrice: freezed == basePrice
                ? _value.basePrice
                : basePrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            bookingType: freezed == bookingType
                ? _value.bookingType
                : bookingType // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ListingResponseImplCopyWith<$Res>
    implements $ListingResponseCopyWith<$Res> {
  factory _$$ListingResponseImplCopyWith(
    _$ListingResponseImpl value,
    $Res Function(_$ListingResponseImpl) then,
  ) = __$$ListingResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'host_id') int hostId,
    String status,
    @JsonKey(name: 'property_type_id') String? propertyTypeId,
    @JsonKey(name: 'space_type') String? spaceType,
    @_NumericStringConverter() double? latitude,
    @_NumericStringConverter() double? longitude,
    @JsonKey(name: 'address_line_1') String? addressLine1,
    String? city,
    @JsonKey(name: 'postal_code') String? postalCode,
    @JsonKey(name: 'max_guests') int? maxGuests,
    int? bedrooms,
    @_NumericStringConverter() double? bathrooms,
    @JsonKey(name: 'property_size') int? propertySize,
    String? title,
    String? description,
    @JsonKey(name: 'base_price') @_NumericStringConverter() double? basePrice,
    @JsonKey(name: 'booking_type') String? bookingType,
  });
}

/// @nodoc
class __$$ListingResponseImplCopyWithImpl<$Res>
    extends _$ListingResponseCopyWithImpl<$Res, _$ListingResponseImpl>
    implements _$$ListingResponseImplCopyWith<$Res> {
  __$$ListingResponseImplCopyWithImpl(
    _$ListingResponseImpl _value,
    $Res Function(_$ListingResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ListingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hostId = null,
    Object? status = null,
    Object? propertyTypeId = freezed,
    Object? spaceType = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? addressLine1 = freezed,
    Object? city = freezed,
    Object? postalCode = freezed,
    Object? maxGuests = freezed,
    Object? bedrooms = freezed,
    Object? bathrooms = freezed,
    Object? propertySize = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? basePrice = freezed,
    Object? bookingType = freezed,
  }) {
    return _then(
      _$ListingResponseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        hostId: null == hostId
            ? _value.hostId
            : hostId // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        propertyTypeId: freezed == propertyTypeId
            ? _value.propertyTypeId
            : propertyTypeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        spaceType: freezed == spaceType
            ? _value.spaceType
            : spaceType // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        addressLine1: freezed == addressLine1
            ? _value.addressLine1
            : addressLine1 // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        postalCode: freezed == postalCode
            ? _value.postalCode
            : postalCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        maxGuests: freezed == maxGuests
            ? _value.maxGuests
            : maxGuests // ignore: cast_nullable_to_non_nullable
                  as int?,
        bedrooms: freezed == bedrooms
            ? _value.bedrooms
            : bedrooms // ignore: cast_nullable_to_non_nullable
                  as int?,
        bathrooms: freezed == bathrooms
            ? _value.bathrooms
            : bathrooms // ignore: cast_nullable_to_non_nullable
                  as double?,
        propertySize: freezed == propertySize
            ? _value.propertySize
            : propertySize // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        basePrice: freezed == basePrice
            ? _value.basePrice
            : basePrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        bookingType: freezed == bookingType
            ? _value.bookingType
            : bookingType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ListingResponseImpl implements _ListingResponse {
  const _$ListingResponseImpl({
    required this.id,
    @JsonKey(name: 'host_id') required this.hostId,
    required this.status,
    @JsonKey(name: 'property_type_id') this.propertyTypeId,
    @JsonKey(name: 'space_type') this.spaceType,
    @_NumericStringConverter() this.latitude,
    @_NumericStringConverter() this.longitude,
    @JsonKey(name: 'address_line_1') this.addressLine1,
    this.city,
    @JsonKey(name: 'postal_code') this.postalCode,
    @JsonKey(name: 'max_guests') this.maxGuests,
    this.bedrooms,
    @_NumericStringConverter() this.bathrooms,
    @JsonKey(name: 'property_size') this.propertySize,
    this.title,
    this.description,
    @JsonKey(name: 'base_price') @_NumericStringConverter() this.basePrice,
    @JsonKey(name: 'booking_type') this.bookingType,
  });

  factory _$ListingResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListingResponseImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'host_id')
  final int hostId;
  @override
  final String status;
  @override
  @JsonKey(name: 'property_type_id')
  final String? propertyTypeId;
  @override
  @JsonKey(name: 'space_type')
  final String? spaceType;
  // These fields come back as strings from the API
  @override
  @_NumericStringConverter()
  final double? latitude;
  @override
  @_NumericStringConverter()
  final double? longitude;
  @override
  @JsonKey(name: 'address_line_1')
  final String? addressLine1;
  @override
  final String? city;
  @override
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  @override
  @JsonKey(name: 'max_guests')
  final int? maxGuests;
  @override
  final int? bedrooms;
  @override
  @_NumericStringConverter()
  final double? bathrooms;
  @override
  @JsonKey(name: 'property_size')
  final int? propertySize;
  @override
  final String? title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'base_price')
  @_NumericStringConverter()
  final double? basePrice;
  @override
  @JsonKey(name: 'booking_type')
  final String? bookingType;

  @override
  String toString() {
    return 'ListingResponse(id: $id, hostId: $hostId, status: $status, propertyTypeId: $propertyTypeId, spaceType: $spaceType, latitude: $latitude, longitude: $longitude, addressLine1: $addressLine1, city: $city, postalCode: $postalCode, maxGuests: $maxGuests, bedrooms: $bedrooms, bathrooms: $bathrooms, propertySize: $propertySize, title: $title, description: $description, basePrice: $basePrice, bookingType: $bookingType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.propertyTypeId, propertyTypeId) ||
                other.propertyTypeId == propertyTypeId) &&
            (identical(other.spaceType, spaceType) ||
                other.spaceType == spaceType) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.addressLine1, addressLine1) ||
                other.addressLine1 == addressLine1) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.maxGuests, maxGuests) ||
                other.maxGuests == maxGuests) &&
            (identical(other.bedrooms, bedrooms) ||
                other.bedrooms == bedrooms) &&
            (identical(other.bathrooms, bathrooms) ||
                other.bathrooms == bathrooms) &&
            (identical(other.propertySize, propertySize) ||
                other.propertySize == propertySize) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.bookingType, bookingType) ||
                other.bookingType == bookingType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    hostId,
    status,
    propertyTypeId,
    spaceType,
    latitude,
    longitude,
    addressLine1,
    city,
    postalCode,
    maxGuests,
    bedrooms,
    bathrooms,
    propertySize,
    title,
    description,
    basePrice,
    bookingType,
  );

  /// Create a copy of ListingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListingResponseImplCopyWith<_$ListingResponseImpl> get copyWith =>
      __$$ListingResponseImplCopyWithImpl<_$ListingResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ListingResponseImplToJson(this);
  }
}

abstract class _ListingResponse implements ListingResponse {
  const factory _ListingResponse({
    required final String id,
    @JsonKey(name: 'host_id') required final int hostId,
    required final String status,
    @JsonKey(name: 'property_type_id') final String? propertyTypeId,
    @JsonKey(name: 'space_type') final String? spaceType,
    @_NumericStringConverter() final double? latitude,
    @_NumericStringConverter() final double? longitude,
    @JsonKey(name: 'address_line_1') final String? addressLine1,
    final String? city,
    @JsonKey(name: 'postal_code') final String? postalCode,
    @JsonKey(name: 'max_guests') final int? maxGuests,
    final int? bedrooms,
    @_NumericStringConverter() final double? bathrooms,
    @JsonKey(name: 'property_size') final int? propertySize,
    final String? title,
    final String? description,
    @JsonKey(name: 'base_price')
    @_NumericStringConverter()
    final double? basePrice,
    @JsonKey(name: 'booking_type') final String? bookingType,
  }) = _$ListingResponseImpl;

  factory _ListingResponse.fromJson(Map<String, dynamic> json) =
      _$ListingResponseImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'host_id')
  int get hostId;
  @override
  String get status;
  @override
  @JsonKey(name: 'property_type_id')
  String? get propertyTypeId;
  @override
  @JsonKey(name: 'space_type')
  String? get spaceType; // These fields come back as strings from the API
  @override
  @_NumericStringConverter()
  double? get latitude;
  @override
  @_NumericStringConverter()
  double? get longitude;
  @override
  @JsonKey(name: 'address_line_1')
  String? get addressLine1;
  @override
  String? get city;
  @override
  @JsonKey(name: 'postal_code')
  String? get postalCode;
  @override
  @JsonKey(name: 'max_guests')
  int? get maxGuests;
  @override
  int? get bedrooms;
  @override
  @_NumericStringConverter()
  double? get bathrooms;
  @override
  @JsonKey(name: 'property_size')
  int? get propertySize;
  @override
  String? get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'base_price')
  @_NumericStringConverter()
  double? get basePrice;
  @override
  @JsonKey(name: 'booking_type')
  String? get bookingType;

  /// Create a copy of ListingResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListingResponseImplCopyWith<_$ListingResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
