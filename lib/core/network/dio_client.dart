import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../exceptions/api_exception.dart';

part 'dio_client.g.dart';

@riverpod
Dio dio(Ref ref) {
  final options = BaseOptions(
    baseUrl: 'https://propertylisting-oyjm.onrender.com/api/v1/',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  final dio = Dio(options);

  dio.interceptors.add(InterceptorsWrapper(
    onError: (DioException e, handler) {

      
      // Optionally we could throw customException, but for now we just pass the DioException
      // Downstream repositories can catch DioException and rethrow ApiException
      return handler.next(e);
    },
  ));

  return dio;
}
