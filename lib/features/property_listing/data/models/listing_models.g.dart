// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PropertyTypeResponseImpl _$$PropertyTypeResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PropertyTypeResponseImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$$PropertyTypeResponseImplToJson(
  _$PropertyTypeResponseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
};

_$ListingCreateImpl _$$ListingCreateImplFromJson(Map<String, dynamic> json) =>
    _$ListingCreateImpl(
      propertyTypeId: json['property_type_id'] as String,
      spaceType: json['space_type'] as String,
    );

Map<String, dynamic> _$$ListingCreateImplToJson(_$ListingCreateImpl instance) =>
    <String, dynamic>{
      'property_type_id': instance.propertyTypeId,
      'space_type': instance.spaceType,
    };

_$ListingUpdateImpl _$$ListingUpdateImplFromJson(Map<String, dynamic> json) =>
    _$ListingUpdateImpl(
      propertyTypeId: json['property_type_id'] as String?,
      spaceType: json['space_type'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      addressLine1: json['address_line_1'] as String?,
      city: json['city'] as String?,
      postalCode: json['postal_code'] as String?,
      maxGuests: (json['max_guests'] as num?)?.toInt(),
      bedrooms: (json['bedrooms'] as num?)?.toInt(),
      bathrooms: (json['bathrooms'] as num?)?.toDouble(),
      propertySize: (json['property_size'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      basePrice: (json['base_price'] as num?)?.toDouble(),
      bookingType: json['booking_type'] as String?,
    );

Map<String, dynamic> _$$ListingUpdateImplToJson(_$ListingUpdateImpl instance) =>
    <String, dynamic>{
      'property_type_id': instance.propertyTypeId,
      'space_type': instance.spaceType,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address_line_1': instance.addressLine1,
      'city': instance.city,
      'postal_code': instance.postalCode,
      'max_guests': instance.maxGuests,
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'property_size': instance.propertySize,
      'title': instance.title,
      'description': instance.description,
      'base_price': instance.basePrice,
      'booking_type': instance.bookingType,
    };

_$ListingResponseImpl _$$ListingResponseImplFromJson(
  Map<String, dynamic> json,
) => _$ListingResponseImpl(
  id: json['id'] as String,
  hostId: (json['host_id'] as num).toInt(),
  status: json['status'] as String,
  propertyTypeId: json['property_type_id'] as String?,
  spaceType: json['space_type'] as String?,
  latitude: const _NumericStringConverter().fromJson(json['latitude']),
  longitude: const _NumericStringConverter().fromJson(json['longitude']),
  addressLine1: json['address_line_1'] as String?,
  city: json['city'] as String?,
  postalCode: json['postal_code'] as String?,
  maxGuests: (json['max_guests'] as num?)?.toInt(),
  bedrooms: (json['bedrooms'] as num?)?.toInt(),
  bathrooms: const _NumericStringConverter().fromJson(json['bathrooms']),
  propertySize: (json['property_size'] as num?)?.toInt(),
  title: json['title'] as String?,
  description: json['description'] as String?,
  basePrice: const _NumericStringConverter().fromJson(json['base_price']),
  bookingType: json['booking_type'] as String?,
);

Map<String, dynamic> _$$ListingResponseImplToJson(
  _$ListingResponseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'host_id': instance.hostId,
  'status': instance.status,
  'property_type_id': instance.propertyTypeId,
  'space_type': instance.spaceType,
  'latitude': const _NumericStringConverter().toJson(instance.latitude),
  'longitude': const _NumericStringConverter().toJson(instance.longitude),
  'address_line_1': instance.addressLine1,
  'city': instance.city,
  'postal_code': instance.postalCode,
  'max_guests': instance.maxGuests,
  'bedrooms': instance.bedrooms,
  'bathrooms': const _NumericStringConverter().toJson(instance.bathrooms),
  'property_size': instance.propertySize,
  'title': instance.title,
  'description': instance.description,
  'base_price': const _NumericStringConverter().toJson(instance.basePrice),
  'booking_type': instance.bookingType,
};
