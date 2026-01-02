import 'package:dio/dio.dart';
import 'interceptor.dart';

class DioService {
  DioService._internal();

  static final DioService _instance = DioService._internal();

  factory DioService() => _instance;

  late final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.escuelajs.co/api/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(DioInterceptor());
}
