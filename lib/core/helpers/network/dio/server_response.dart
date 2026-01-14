
import 'package:maaportal/core/helpers/network/dio/server_error.dart';

class ServerResponse<T> {
  ServerError? error;

  T? data;
}
