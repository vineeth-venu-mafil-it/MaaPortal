import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'app_exceptions.dart';
import 'base_soap_api_service.dart';

class NetworkSoapApiServices extends BaseSoapApiServices {
  @override
  Future<dynamic> postSoapRequest(String url, String soapBody) async {
    if (kDebugMode) {
      print('SOAP Endpoint: $url');

      print('SOAP Request: $soapBody');
    }

    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers:_getHeaders(),
        body: soapBody,
      );

      responseJson = returnSoapResponse(response);
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
  Future<dynamic> getSoapRequest(String url) async {
    if (kDebugMode) {
      print('SOAP GET Endpoint: $url');
    }

    dynamic responseJson;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers:_getHeaders(),
      );

      responseJson = returnSoapResponse(response);
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
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/iciciimpsstatus',
      'Accept': 'text/xml',
    };
  }


  dynamic returnSoapResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final xmlDoc = xml.XmlDocument.parse(response.body);
        return {'status': 200, 'data': xmlDoc.toXmlString(pretty: true)};
      case 400:
        final xmlDoc = xml.XmlDocument.parse(response.body);
        return {'status': 400, 'data': xmlDoc.toXmlString(pretty: true)};
      case 401:
        final xmlDoc = xml.XmlDocument.parse(response.body);
        return {'status': 401, 'data': xmlDoc.toXmlString(pretty: true)};
      case 500:
        final xmlDoc = xml.XmlDocument.parse(response.body);
        return {'status': 500, 'data': xmlDoc.toXmlString(pretty: true)};
      default:
        throw FetchDataException(
            'Error occurred status code:${response.statusCode}');
    }
  }
}
