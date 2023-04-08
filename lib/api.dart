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

  static Api? _instance;

  String _authToken = '';
  String _refreshToken = '';

  Api._internal() {
    _instance = this;
    AuthRepository().getAuth().then((AuthModel? auth) {
      _authToken = null == auth ? '' : auth.access_token;
      _refreshToken = null == auth ? '' : auth.refresh_token;
    });
  }

  factory Api() => _instance ?? Api._internal();

  // Future<Response> login(Map<String, dynamic> data) async {
  //   return make(method: 'post', uri: '/login', headers: {}, body: data);
  // }
  //
  // Future<Response> register(Map<String, dynamic> data) async {
  //   return make(method: 'post', uri: '/register', headers: {}, body: data);
  // }
  //
  // Future<Response> forgotPassword(Map<String, dynamic> data) async {
  //   return make(method: 'post', uri: '/forgot-password', headers: {}, body: data);
  // }
  //
  // Future<Response> resetPassword(Map<String, dynamic> data) async {
  //   return make(method: 'post', uri: '/reset-password', headers: {}, body: data);
  // }
  //
  // Future<Response> activateProfile(Map<String, dynamic> data) async {
  //   return make(method: 'post', uri: '/activate-profile', headers: {}, body: data);
  // }
  //
  // Future<Response> user(String userId) async {
  //   return make(method: 'get', uri: '/user?userId=' + userId, headers: {});
  // }

  Future<Response> login(Map<String, dynamic> data) async {
    const body = {
      'data': {
        'access_token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiaWQiOiIxIiwiaWF0IjoxNTE2MjM5MDIyfQ.NdmXS9NOiE6j8T1wcPMR_75r5FLrGmjdSoPZN-smTsU',
        'refresh_token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiaWQiOiIxIiwiaWF0IjoxNTE2MjM0ODk3fQ.ddM2LN2IFHdlq3OYbXeWrBH40etmiyoug8TGpEbr0Dw'
      }
    };

    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: body);
    });
  }

  Future<Response> register(Map<String, dynamic> data) async {
    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: {});
    });
  }

  Future<Response> forgotPassword(Map<String, dynamic> data) async {
    const body = {
      'data': {
        'code': 456122,
      }
    };

    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: body);
    });
  }

  Future<Response> resetPassword(Map<String, dynamic> data) async {
    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: {});
    });
  }

  Future<Response> activateProfile(Map<String, dynamic> data) async {
    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: {});
    });
  }

  Future<Response> user() async {
    const body = {
      'data': {'id': 'jhdfj', 'username': 'user N', 'email': 'aaa@mail.ru'}
    };

    // return Future<Response>.delayed(const Duration(seconds: 1), () {
    //   return ErrorResponse(code: 101, message: 'Error');
    // });

    return Future<Response>.delayed(const Duration(seconds: 1), () {
      return SuccessResponse(data: body['data']);
    });
  }

  Future<Response> units() async {
    const body = {
      'data': {
        'units': [
          {
            'id': 'unit-1',
            'order': 1,
            'lessons': [
              {
                'id': 'lesson-1-1',
                'order': 1,
                'name': 'новый1',
                'progress': 0.1,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 4,
                'theory': true,
              },
              {
                'id': 'lesson-1-2',
                'order': 2,
                'name': 'животные',
                'progress': 0.2,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 4,
                'theory': true,
              },
              {
                'id': 'lesson-1-3',
                'order': 3,
                'name': 'работа',
                'progress': 0.0,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 4,
                'theory': false,
              },
              {
                'id': 'lesson-1-4',
                'order': 4,
                'name': 'природа',
                'progress': 0.6,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 5,
                'theory': false,
              },
              {
                'id': 'lesson-1-5',
                'order': 5,
                'name': 'одежда',
                'progress': 0.0,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 0,
                'theory': true,
              },
              {
                'id': 'lesson-1-6',
                'order': 6,
                'name': 'семья',
                'progress': 0.1,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 0,
                'theory': false,
              },
              {
                'id': 'lesson-1-7',
                'order': 7,
                'name': 'животные',
                'progress': 0.2,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 0,
                'theory': true,
              },
              {
                'id': 'lesson-1-8',
                'order': 8,
                'name': 'работа',
                'progress': 0.0,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 5,
                'theory': true,
              },
              {
                'id': 'lesson-1-9',
                'order': 9,
                'name': 'природа',
                'progress': 0.6,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 5,
                'theory': false,
              },
              {
                'id': 'lesson-1-10',
                'order': 10,
                'name': 'одежда',
                'progress': 0.0,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 0,
                'theory': true,
              },
              {
                'id': 'lesson-1-11',
                'order': 11,
                'name': 'семья',
                'progress': 0.1,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-1-12',
                'order': 12,
                'name': 'животные',
                'progress': 0.2,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-1-13',
                'order': 13,
                'name': 'работа',
                'progress': 0.0,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-1-14',
                'order': 14,
                'name': 'природа',
                'progress': 0.6,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-1-15',
                'order': 15,
                'name': 'одежда',
                'progress': 0.0,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
            ]
          },
          {
            'id': 'unit-2',
            'order': 2,
            'lessons': [
              {
                'id': 'lesson-2-1',
                'order': 2,
                'name': 'хобби',
                'progress': 0.1,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-2-2',
                'order': 2,
                'name': 'фильмы',
                'progress': 0.2,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-2-3',
                'order': 3,
                'name': 'невский',
                'progress': 0.0,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-2-4',
                'order': 4,
                'name': 'гачи',
                'progress': 0.5,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-2-5',
                'order': 5,
                'name': 'глаголы',
                'progress': 1.0,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
            ]
          }
        ]
      },
    };

    return Future<Response>.delayed(const Duration(seconds: 1), () {
      return SuccessResponse(data: body['data']);
    });

    return Future<Response>.delayed(const Duration(seconds: 1), () {
      return ErrorResponse(code: 101, message: 'Error');
    });
  }

  Future<bool> refreshAuthTokens() async {
    http.Response response = await request(
        method: 'post',
        uri: '/refresh',
        headers: {'Authorization': 'Bearer' + _refreshToken},
        body: {});

    if (response.isError()) {
      return false;
    }

    SuccessResponse successResponse = response.getSuccessResponse();

    AuthRepository().setAuth(successResponse.data);

    return true;
  }

  Future<Response> make(
      {required String method,
      required String uri,
      required Map<String, String> headers,
      Map<String, dynamic> body = const {},
      bool authorized = true}) async {
    http.Response response;

    if (authorized) {
      headers['Authorization'] = 'Bearer:' + _authToken;
    }

    headers['Content-Type'] = 'application/json; charset=UTF-8;';

    response =
        await request(method: method, uri: uri, headers: headers, body: body);

    if (response.isError()) {
      ErrorResponse error = response.getErrorResponse();

      if (codeErrors[error.code] == ApiErrors.notAuthorized) {
        bool isRefreshed = await refreshAuthTokens();

        if (isRefreshed) {
          response = await request(
              method: method, uri: uri, headers: headers, body: body);

          if (response.isError()) {
            return response.getErrorResponse();
          }

          return response.getSuccessResponse();
        }
      }

      return error;
    }

    return response.getSuccessResponse();
  }

  Future<http.Response> request(
      {required String method,
      required String uri,
      required Map<String, String> headers,
      Map<String, dynamic> body = const {}}) async {
    if ('post' == method) {
      return await http.post(Uri.parse('http://localhost/' + _prefix + uri),
          headers: headers, body: jsonEncode(body));
    } else if ('get' == method) {
      return await http.get(
        Uri.parse('http://localhost/' + _prefix + uri),
        headers: headers,
      );
    } else {
      throw Exception('Invalid method');
    }
  }
}

abstract class Response {}

class ErrorResponse extends Response {
  final int code;
  final String message;
  final Map<String, dynamic>? messages;

  ErrorResponse({required this.code, required this.message, this.messages});
}

class SuccessResponse extends Response {
  final dynamic data;

  SuccessResponse({this.data});
}

extension ApiResponse on http.Response {
  bool isError() {
    if (200 == statusCode) {
      if (!body.contains('data')) {
        return true;
      }

      return false;
    }

    return true;
  }

  ErrorResponse getErrorResponse() {
    if (200 == statusCode) {
      final dynamic response = jsonDecode(body);

      if (response['message'] is String) {
        return ErrorResponse(
            code: response['code'], message: response['message']);
      }

      return ErrorResponse(
          code: response['code'],
          message: response['message'],
          messages: response['messages']);
    }

    return ErrorResponse(code: statusCode, message: 'Network error');
  }

  SuccessResponse getSuccessResponse() {
    return SuccessResponse(data: jsonDecode(body)['data']);
  }
}
