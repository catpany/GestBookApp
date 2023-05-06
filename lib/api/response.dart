import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

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

const Map<int, ApiErrors> codeErrors = {
  104: ApiErrors.usernameTaken,
  105: ApiErrors.emailTaken,
  106: ApiErrors.validationError,
  107: ApiErrors.emailNotAvailable,
  108: ApiErrors.notActivated,
  109: ApiErrors.userNotFound,
  110: ApiErrors.invalidValue,
  111: ApiErrors.notificationsNotAvailable,
  401: ApiErrors.notAuthorized,
};

abstract class Response {}

class ErrorResponse extends Response {
  final int code;
  final String message;
  final dynamic messages;

  ErrorResponse({required this.code, required this.message, this.messages});
}

class SuccessResponse extends Response {
  final dynamic data;
  final int? page;
  final int? perPage;
  final int? total;

  SuccessResponse({this.data, this.page, this.perPage, this.total});
}

extension ApiResponse on http.Response {
  bool isError() {
    if (200 == statusCode) {
      log(body);
      if ('' != body && null == jsonDecode(body)['data']) {
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
          message: '',
          messages: response['message']);
    }

    return ErrorResponse(code: statusCode, message: 'Network error');
  }

  SuccessResponse getSuccessResponse() {
    dynamic data = jsonDecode(body);
    return SuccessResponse(data: body.isEmpty ? '' : data['data'], page: data['page'], total: data['total'], perPage: data['per_page']);
  }
}