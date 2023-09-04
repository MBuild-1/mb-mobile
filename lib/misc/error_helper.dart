import 'package:dio/dio.dart';

import 'constant.dart';
import 'error/empty_error.dart';
import 'error/not_found_error.dart';
import 'error/please_login_first_error.dart';

class _ErrorHelperImpl {
  DioError generatePleaseLoginFirstDioError(dynamic e) {
    Response<dynamic>? newResponse = e.response;
    if (newResponse != null) {
      Map<String, dynamic> newResponseData = newResponse.data;
      dynamic message = newResponseData["meta"]["message"];
      if (message is String) {
        String messageString = message;
        if (messageString.toLowerCase().contains("please login first")) {
          newResponseData["meta"]["message"] = {
            Constant.textEnUsLanguageKey: messageString,
            Constant.textInIdLanguageKey: "Silahkan Login Terlebih Dahulu!"
          };
        }
      }
    }
    return DioError(
      requestOptions: e.requestOptions,
      response: e.response,
      type: e.type,
      error: e.error
    );
  }

  Error generatePleaseLoginFirstError(dynamic e) {
    DioError newDioError = generatePleaseLoginFirstDioError(e);
    dynamic message = newDioError.response?.data["meta"]["message"];
    if (message is Map<String, dynamic>) {
      if (message[Constant.textEnUsLanguageKey].toLowerCase().contains("please login first")) {
        return PleaseLoginFirstError();
      }
    }
    return NotFoundError();
  }

  Error generateEmptyError(dynamic e) {
    bool checkingEmpty(String lowerCaseMessage) => lowerCaseMessage.contains("is empty") || lowerCaseMessage.contains("empty");
    DioError dioError = generatePleaseLoginFirstDioError(e);
    dynamic message = dioError.response?.data["meta"]["message"];
    if (message is Map<String, dynamic>) {
      if (checkingEmpty(message[Constant.textEnUsLanguageKey].toLowerCase())) {
        return EmptyError();
      }
    } else if (message is String) {
      if (checkingEmpty(message.toLowerCase())) {
        return EmptyError();
      }
    }
    return NotFoundError();
  }
}

// ignore: non_constant_identifier_names
final _ErrorHelperImpl ErrorHelper = _ErrorHelperImpl();