import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';
import 'dart:async';

class APIHelper {
  static final Logger _logger = Logger();

  static Future<Map<String, dynamic>> get(String url,
      {Map<String, String>? headers}) async {
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      return _returnResponse(response);
    } catch (e) {
      _logger.d(e);
      rethrow;
    }
  }

  static Map<String, dynamic> _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw "BadRequest : 400";
      case 403:
        throw "ForbiddenResponse : 403";
      case 500:
        throw "ServerError : 500";
      default:
        throw "Something went wrong";
    }
  }
}
