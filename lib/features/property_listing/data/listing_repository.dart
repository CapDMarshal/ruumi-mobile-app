import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import 'models/listing_models.dart';

part 'listing_repository.g.dart';

@riverpod
ListingRepository listingRepository(Ref ref) {
  return ListingRepository(ref.watch(dioProvider));
}

class ListingRepository {
  final Dio _dio;

  ListingRepository(this._dio);

  Future<List<PropertyTypeResponse>> getPropertyTypes() async {
    final response = await _dio.get('/property-types/');
    final List<dynamic> data = response.data;
    return data.map((e) => PropertyTypeResponse.fromJson(e)).toList();
  }

  /// Fetches all listings. Pass [hostId] to filter by host (My Listings screen).
  Future<List<ListingResponse>> getListings({int? hostId, int limit = 100, int offset = 0}) async {
    final response = await _dio.get(
      '/listings/',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        if (hostId != null) 'host_id': hostId,
      },
    );
    final List<dynamic> data = response.data;
    return data.map((e) => ListingResponse.fromJson(e)).toList();
  }

  Future<ListingResponse> createListingDraft(ListingCreate data) async {
    final response = await _dio.post(
      '/listings/',
      data: data.toJson(),
    );
    return ListingResponse.fromJson(response.data);
  }

  Future<ListingResponse> updateListing(String id, ListingUpdate data) async {
    // Strip null values — the PATCH endpoint uses partial updates and
    // rejects fields that are explicitly null.
    final payload = Map<String, dynamic>.fromEntries(
      data.toJson().entries.where((e) => e.value != null),
    );
    final response = await _dio.patch(
      '/listings/$id',
      data: payload,
    );
    return ListingResponse.fromJson(response.data);
  }

  Future<ListingResponse> publishListing(String id) async {
    final response = await _dio.post(
      '/listings/$id/publish',
    );
    return ListingResponse.fromJson(response.data);
  }
}
