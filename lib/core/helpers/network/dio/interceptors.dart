import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kDebugMode) {
      return handler.next(options);
    }

    debugPrint(
        '┌────────────────────────────────────────────────────────────────────');
    debugPrint('│ REQUEST → ${options.method.toUpperCase()} ${options.uri}');
    debugPrint(
        '├────────────────────────────────────────────────────────────────────');
    debugPrint('│ Headers:');
    options.headers.forEach((key, value) => debugPrint('│   $key: $value'));

    if (options.queryParameters.isNotEmpty) {
      debugPrint('│ Query Parameters:');
      options.queryParameters
          .forEach((key, value) => debugPrint('│   $key: $value'));
    }

    if (options.data != null) {
      debugPrint('│ Body:');
      debugPrint(_prettyJson(options.data));
    }

    debugPrint(
        '└────────────────────────────────────────────────────────────────────');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!kDebugMode) {
      return handler.next(response);
    }

    debugPrint(
        '┌────────────────────────────────────────────────────────────────────');
    debugPrint(
        '│ RESPONSE ← ${response.statusCode} ${response.requestOptions.uri}');
    debugPrint(
        '├────────────────────────────────────────────────────────────────────');

    if (response.data != null) {
      debugPrint('│ Response Body:');
      debugPrint(_prettyJson(response.data));
    } else {
      debugPrint('│ (No response body)');
    }

    debugPrint(
        '└────────────────────────────────────────────────────────────────────');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!kDebugMode) {
      return handler.next(err);
    }

    debugPrint(
        '┌────────────────────────────────────────────────────────────────────');
    debugPrint('│ ERROR → ${err.type}');
    debugPrint('│ Message: ${err.message}');
    debugPrint(
        '│ Request: ${err.requestOptions.method} ${err.requestOptions.uri}');

    if (err.response != null) {
      final resp = err.response!;
      debugPrint('│ Status: ${resp.statusCode} ${resp.statusMessage}');
      debugPrint('│ Response Body:');
      debugPrint(_prettyJson(resp.data));
    } else {
      debugPrint('│ No response (Connection failed, timeout, or cancelled)');
    }

    debugPrint(
        '└────────────────────────────────────────────────────────────────────');
    handler.next(err);
  }

  /// Safely pretty-print JSON with proper indentation
  String _prettyJson(dynamic data) {
    try {
      if (data is String) {
        // If it's already a JSON string, try parsing it first
        data = jsonDecode(data);
      }
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (e) {
      return data.toString();
    }
  }
}

class AppInterceptor extends Interceptor {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Common headers
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    // Read token asynchronously
    String? token = await _getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      debugPrint('Bearer Token Added: $token');
    } else {
      // Optional: remove Authorization header if token is missing
      options.headers.remove('Authorization');
    }

    handler.next(options);
  }

  Future<String?> _getToken() async {
    try {
      return await _storage.read(key: 'auth_token');
    } catch (e) {
      debugPrint('Error reading token: $e');
      return null;
    }
  }
}
