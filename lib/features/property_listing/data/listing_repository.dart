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

  Future<ListingResponse> createListingDraft(ListingCreate data) async {
    final response = await _dio.post(
      '/listings/',
      data: data.toJson(),
    );
    return ListingResponse.fromJson(response.data);
  }

  Future<ListingResponse> updateListing(String id, ListingUpdate data) async {
    final response = await _dio.patch(
      '/listings/$id',
      data: data.toJson(),
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
