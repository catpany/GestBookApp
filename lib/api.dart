import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:sigest/stock/auth.dart';

import 'models/auth.dart';

enum ApiErrors {
  usernameTaken,
  emailTaken,
  validationError,
  emailNotAvailable,
  notActivated,
  userNotFound,
  invalidValue,
  notificationsNotAvailable,
  notAuthorized,
}

class Api {
  static const String _prefix = 'api';

  static Map<int, ApiErrors> codeErrors = {
    104: ApiErrors.usernameTaken,
    105: ApiErrors.emailTaken,
    106: ApiErrors.validationError,
    107: ApiErrors.emailNotAvailable,
    108: ApiErrors.notActivated,
    109: ApiErrors.userNotFound,
    110: ApiErrors.invalidValue,
    111: ApiErrors.notificationsNotAvailable,
    112: ApiErrors.notAuthorized,
  };

  static Future<http.Response> login(Object data) {
    const body = {
      'data': {
        'access_token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiaWQiOiIxIiwiaWF0IjoxNTE2MjM5MDIyfQ.NdmXS9NOiE6j8T1wcPMR_75r5FLrGmjdSoPZN-smTsU',
        'refresh_token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiaWQiOiIxIiwiaWF0IjoxNTE2MjM0ODk3fQ.ddM2LN2IFHdlq3OYbXeWrBH40etmiyoug8TGpEbr0Dw'
      }
    };

    return Future<http.Response>.delayed(const Duration(seconds: 3), () {
      return http.Response(
        jsonEncode(body),
        200,
        request: http.Request('post', Uri.parse('http://localhost/' + _prefix + 'login')),
      );
    });
  }

  static Future<http.Response> register(Object data) {
    const body = {};

    return Future<http.Response>.delayed(const Duration(seconds: 3), () {
      return http.Response(
        jsonEncode(body),
        200,
        request: http.Request('post', Uri.parse('http://localhost/' + _prefix + 'register')),
      );
    });
  }

  static Future<http.Response> forgotPassword(Object data) {
    const body = {
      'data': {
        'code': 456122,
      }
    };

    return Future<http.Response>.delayed(const Duration(seconds: 3), () {
      return http.Response(
        jsonEncode(body),
        200,
        request: http.Request('post', Uri.parse('http://localhost/' + _prefix + 'forgot-password')),
      );
    });
  }

  static Future<http.Response> resetPassword(Object data) {
    const body = {};

    return Future<http.Response>.delayed(const Duration(seconds: 3), () {
      return http.Response(
        jsonEncode(body),
        200,
        request: http.Request('post', Uri.parse('http://localhost/' + _prefix + 'reset-password')),
      );
    });
  }

  static Future<http.Response> activateProfile(Object data) {
    const body = {};

    return Future<http.Response>.delayed(const Duration(seconds: 3), () {
      return http.Response(
        jsonEncode(body),
        200,
        request: http.Request('post', Uri.parse('http://localhost/' + _prefix + 'activate-profile')),
      );
    });
  }

  static Future<http.Response> user(String userId) async {
    AuthModel? auth = await AuthStock().getAuth(userId);
    const body = {
      'username': 'user N',
      'email': 'aaa@mail.ru'
    };

    // return http.get(
    //   Uri.parse('http://localhost/' + _prefix + 'user/$userId'),
    //   headers: {
    //     'Content-Type': 'application/json; charset=UTF-8;',
    //     'Bearer': auth.access_token,
    //   },
    // );

    return Future<http.Response>.delayed(const Duration(seconds: 1), () {
      return http.Response(
        jsonEncode(body),
        200,
        request: http.Request('get', Uri.parse('http://localhost/' + _prefix + 'user-info')),
      );
    });
  }
}

class ErrorResponse {
  final int code;
  final String message;
  final Map<String, dynamic>? messages;

  ErrorResponse({required this.code, required this.message, this.messages});
}

extension ApiResponse on http.Response {
  bool isError() {
    if (200 == statusCode) {
      if (body.contains('code') && body.contains('message')) {
        return true;
      }

       return false;
    }

    return true;
  }

  ErrorResponse getError() {
    if (200 == statusCode) {

      if (body.contains('code') && body.contains('message')) {
        final dynamic response = jsonDecode(body)['data'];

        log(response.toString());
        if (response['message'] is String) {
          return ErrorResponse(code: response['code'], message: response['message']);
        }

        return ErrorResponse(code: response['code'], message: response['message'], messages: response['messages']);
      }

    }

    return ErrorResponse(code: statusCode, message: 'Network error');
  }
}