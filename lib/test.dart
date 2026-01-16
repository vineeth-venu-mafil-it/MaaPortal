import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PledgeInvWrapper extends StatelessWidget {
  final double? width;
  final double? height;
  final String? token;
  const PledgeInvWrapper({super.key, this.width, this.height, this.token});

  @override
  Widget build(BuildContext context) {
    return PledgeInvPage(
      width: width,
      height: height,
      token: token,
    );
  }
}

class PledgeInvPage extends StatelessWidget {
  final double? width;
  final double? height;
  final String? token;
  const PledgeInvPage({super.key, this.width, this.height, this.token});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => PledgeInvController(curToken: token ?? ''),
        child: Consumer<PledgeInvController>(
          builder: (context, provider, child) {
            if (provider.resError != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  CustomAlertDialog.showCustomAlertDialog(
                    context: context,
                    title: "Alert",
                    message: provider.resError!,
                    clearAction: () {
                      provider.clearError();
                    },
                  );
                }
              });
            }
            return SizedBox();
          },
        ));
  }
}

class PledgeInvController extends ChangeNotifier {
  final _apiService = NetworkApiServices();
  String? resError;
  String? token;
  String baseUrl =
      'https://uatapp.manappuram.net/AuditInspectionApi/api/GetInspectionData/';
  PledgeInvController({required String curToken}) {
    token = curToken;
    _initialize();
  }
  Future<void> _initialize() async {

    await accessCheck1();
  }

  Future<void> accessCheck1() async {
    try {
      final String p_flag = 'PROC_PO_AUDIT_MAIN';
      final String p_pagevalue = "425*173";
      final String p_paravalue = '1';
      final response = await _apiService
          .getApi("$baseUrl/$p_flag/$p_pagevalue/$p_paravalue", token: token);

      if (response == null || response['status'] != 200) {
        resError = 'api works';
        return;
      }

      if (response == null || response['status'] == 401) {
        resError = 'Session expired. Please login again.';

        return;
      }
    } catch (e) {
      if (kDebugMode) print("Failed: $e");
    }
  }

  void _scheduleNotifyListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hasListeners) {
        notifyListeners();
      }
    });
  }

  void clearError() {
    resError = null;

    notifyListeners();
  }
}

class AppExceptions implements Exception {
  final _message;
  final _prefix;

  AppExceptions([this._message, this._prefix]);

  @override
  String toString() {
    return '$_prefix$_message';
  }
}

class InternetException extends AppExceptions {
  InternetException([String? message]) : super(message, 'No internet');
}

class RequestTimeOut extends AppExceptions {
  RequestTimeOut([String? message]) : super(message, 'Request Time out');
}

class ServerException extends AppExceptions {
  ServerException([String? message]) : super(message, 'Internal server error');
}

class InvalidUrlException extends AppExceptions {
  InvalidUrlException([String? message]) : super(message, 'Invalid Url');
}

class FetchDataException extends AppExceptions {
  FetchDataException([String? message]) : super(message, '');
}

abstract class BaseApiServices {
  Future<dynamic> getApi(String url);

  Future<dynamic> postApi(dynamic data, String url);

  Future<dynamic> postMultipartApi(
      String url, Map<String, String> fields, List<http.MultipartFile> files);
}

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(String url, {String? token}) async {
    if (kDebugMode) {
      print(url);
    }

    dynamic responseJson;
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    return responseJson;
  }

  @override
  Future<dynamic> postApi(var data, String url, {String? token}) async {
    if (kDebugMode) {
      print(url);
      print(data);
    }

    dynamic responseJson;
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: headers,
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future<dynamic> postMultipartApi(String url, Map<String, String> fields,
      List<http.MultipartFile> files) async {
    if (kDebugMode) {
      print(url);
    }

    dynamic responseJson;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Content-Type'] = 'application/json';
      fields.forEach((key, value) {
        request.fields[key] = value;
      });
      request.files.addAll(files);

      var response = await request.send();

      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      responseJson = jsonDecode(responseString);

      if (response.statusCode == 200) {
        return responseJson;
      } else {
        throw FetchDataException(
            'Error occurred while communicating with server ${response.statusCode}');
      }
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return {'status': 200, 'data': responseJson};
      case 400:
        dynamic responseJson = jsonDecode(response.body);
        return {'status': 400, 'data': responseJson};
      case 401:
        dynamic responseJson = jsonDecode(response.body);
        return {'status': 401, 'data': responseJson};
      case 500:
        dynamic responseJson = jsonDecode(response.body);
        return {'status': 500, 'data': responseJson};
      default:
        throw FetchDataException(
            'Error occurred status code:${response.statusCode}');
    }
  }
}

class CustomAlertDialog {
  static void showCustomAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? cancelText,
    final VoidCallback? onCancelPressed,
    final VoidCallback? clearAction,
  }) {
    final FocusNode focusNode = FocusNode();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 12),
            ),
          ),
          content: Container(
            constraints: const BoxConstraints(
              maxWidth: 300,
              maxHeight: 100,
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KeyboardListener(
                  focusNode: focusNode,
                  autofocus: true,
                  onKeyEvent: (event) {
                    if (event is KeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.enter) {
                      Navigator.of(context).pop(); // Add this line
                      if (onCancelPressed != null) {
                        onCancelPressed();
                      }
                    }
                  },
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Add this line
                      if (onCancelPressed != null) {
                        onCancelPressed();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        cancelText ?? 'Ok',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontFamily: "poppinsSemiBold",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ).then((_) {
      if (clearAction != null) {
        clearAction();
      }
      focusNode.dispose();
    });
  }
}
