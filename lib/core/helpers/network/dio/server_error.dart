import 'package:dio/dio.dart';

class ServerError implements Exception {
  final int? errorCode;
  final String errorMessage;
  final DioException? dioException;

  ServerError._({
    this.errorCode,
    required this.errorMessage,
    this.dioException,
  });

  /// Factory constructor to create ServerError from a DioException
  factory ServerError.withError(DioException error) {
    return ServerError._(
      dioException: error,
      errorCode: error.response?.statusCode,
      errorMessage: _getErrorMessage(error),
    );
  }

  /// Centralized error message resolver
  static String _getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return "Request was cancelled";

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return "Connection timeout. Please try again.";

      case DioExceptionType.badCertificate:
        return "SSL certificate error";

      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);

      case DioExceptionType.connectionError:
        return "No internet connection. Please check your network.";

      case DioExceptionType.unknown:
      default:
        // For unknown errors (e.g., socket exceptions, parsing issues)
        return error.message ?? "An unexpected error occurred";
    }
  }

  /// Handle HTTP status codes
  static String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return "Bad request";
      case 401:
        return "Unauthorized access. Please log in again.";
      case 403:
        return "Forbidden. You don't have permission.";
      case 404:
        return "Resource not found";
      case 408:
        return "Request timeout";
      case 422:
        return "Validation failed";
      case 429:
        return "Too many requests. Please try again later.";
      case 500:
        return "Internal server error";
      case 502:
        return "Bad gateway";
      case 503:
        return "Service unavailable";
      case 504:
        return "Gateway timeout";
      default:
        return "Something went wrong (Code: $statusCode)";
    }
  }

  @override
  String toString() => 'ServerError($errorCode): $errorMessage';
}
