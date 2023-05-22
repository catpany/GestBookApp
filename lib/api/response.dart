import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as http;

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
      if (null != data && (null != data['code'] && null != data['message'] )) {
        return true;
      }

      return false;
    }

    return true;
  }

  ErrorResponse getErrorResponse() {
    log(statusMessage.toString());
    log(statusCode.toString());
    if (200 == statusCode) {
      if (data['message'] is String) {
        return ErrorResponse(
            code: data['code'], message: data['message']);
      }

      return ErrorResponse(
          code: data['code'],
          message: '',
          messages: data['message']);
    }

    log('Network error');
    log(statusCode.toString());
    return ErrorResponse(code: statusCode ?? 500, message: data['message'] ?? 'Network error');
  }

  SuccessResponse getSuccessResponse() {
    return SuccessResponse(data: data?['data'], page: data?['page'], total: data?['total'], perPage: data?['per_page']);
  }
}