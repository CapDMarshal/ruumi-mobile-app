import 'package:freezed_annotation/freezed_annotation.dart';

part 'listing_models.freezed.dart';
part 'listing_models.g.dart';

// ---------------------------------------------------------------------------
// Converters — the API returns latitude, longitude, bathrooms, and base_price
// as JSON strings (e.g. "3.1390") even though they are numeric values.
// These converters handle both String and num inputs gracefully.
// ---------------------------------------------------------------------------

class _NumericStringConverter implements JsonConverter<double?, Object?> {
  const _NumericStringConverter();

  @override
  double? fromJson(Object? json) {
    if (json == null) return null;
    if (json is num) return json.toDouble();
    if (json is String) return double.tryParse(json);
    return null;
  }

  @override
  Object? toJson(double? value) => value;
}

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------

@freezed
class PropertyTypeResponse with _$PropertyTypeResponse {
  const factory PropertyTypeResponse({
    required String id,
    required String name,
    String? description,
  }) = _PropertyTypeResponse;

  factory PropertyTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$PropertyTypeResponseFromJson(json);
}

@freezed
class ListingCreate with _$ListingCreate {
  const factory ListingCreate({
    @JsonKey(name: 'property_type_id') required String propertyTypeId,
    @JsonKey(name: 'space_type') required String spaceType,
  }) = _ListingCreate;

  factory ListingCreate.fromJson(Map<String, dynamic> json) =>
      _$ListingCreateFromJson(json);
}

@freezed
class ListingUpdate with _$ListingUpdate {
  const factory ListingUpdate({
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
  }) = _ListingUpdate;

  factory ListingUpdate.fromJson(Map<String, dynamic> json) =>
      _$ListingUpdateFromJson(json);
}

@freezed
class ListingResponse with _$ListingResponse {
  const factory ListingResponse({
    required String id,
    @JsonKey(name: 'host_id') required int hostId,
    required String status,
    @JsonKey(name: 'property_type_id') String? propertyTypeId,
    @JsonKey(name: 'space_type') String? spaceType,
    // These fields come back as strings from the API
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
  }) = _ListingResponse;

  factory ListingResponse.fromJson(Map<String, dynamic> json) =>
      _$ListingResponseFromJson(json);
}
