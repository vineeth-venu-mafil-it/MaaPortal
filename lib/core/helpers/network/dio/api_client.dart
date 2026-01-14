import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:retrofit/retrofit.dart';

import '../api_endpoints.dart';
import 'api_service.dart';
import 'interceptors.dart';

import 'server_error.dart';

class ApiClient {
  late final Dio _dio;
  late final ApiService _apiService;
  final Logger _logger = Logger();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndPoints.baseUrlUat,
        connectTimeout: const Duration(minutes: 60),
        receiveTimeout: const Duration(minutes: 60),
        sendTimeout: const Duration(minutes: 60),
      ),
    );

    _dio.interceptors.addAll([
      AppInterceptor(),
      LoggingInterceptor(),
    ]);

    _apiService = ApiService(_dio);
  }

  /// Getter for the ApiService instance
  ApiService get apiService => _apiService;

  /// Generic method to make API calls with error handling
  Future<T> makeRequest<T>(
      Future<HttpResponse<T>> Function(ApiService) apiCall) async {
    try {
      final response = await apiCall(_apiService);
      return response.data;
    } on DioException catch (e) {
      _logger.e('API Error: ${e.message}',
          error: e, stackTrace: StackTrace.current);
      throw ServerError.withError(e);
    } catch (e, stackTrace) {
      _logger.e('Unexpected Error: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
