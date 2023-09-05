import 'package:dio/dio.dart';

import 'constant.dart';
import 'error/empty_error.dart';
import 'error/message_error.dart';
import 'error/not_found_error.dart';
import 'error/please_login_first_error.dart';

class _ErrorHelperImpl {
  DioError generateMultiLanguageDioError(MultiLanguageMessageError multiLanguageMessageError) {
    RequestOptions requestOptions = RequestOptions(
      path: ''
    );
    dynamic titleValue = multiLanguageMessageError.title.value;
    dynamic messageValue = multiLanguageMessageError.message.value;
    dynamic titleResponse;
    dynamic messageResponse;
    if (titleValue is Map) {
      titleResponse = {
        Constant.textEnUsLanguageKey: titleValue[Constant.textEnUsLanguageKey],
        Constant.textInIdLanguageKey: titleValue[Constant.textInIdLanguageKey],
      };
    } else {
      titleResponse = titleValue;
    }
    if (messageValue is Map) {
      messageResponse = {
        Constant.textEnUsLanguageKey: messageValue[Constant.textEnUsLanguageKey],
        Constant.textInIdLanguageKey: messageValue[Constant.textInIdLanguageKey],
      };
    } else {
      messageResponse = messageValue;
    }
    Response<dynamic>? newResponse = Response(
      requestOptions: requestOptions,
      data: <String, dynamic>{
        "meta": {
          "code": 400,
          "status": "error",
          "title": titleResponse,
          "message": messageResponse
        },
        "data": []
      },
      statusCode: 400
    );
    return DioError(
      requestOptions: requestOptions,
      response: newResponse,
      type: DioErrorType.response,
      error: null
    );
  }

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
    bool checkingEmpty(String lowerCaseMessage) => lowerCaseMessage.contains("is empty") || lowerCaseMessage.contains("empty") || lowerCaseMessage.contains("not found");
    EmptyError generateEmptyErrorResult(String lowerCaseMessage) {
      EmptyErrorType emptyErrorType = EmptyErrorType.defaultEmpty;
      if (lowerCaseMessage.contains("address")) {
        emptyErrorType = EmptyErrorType.addressEmpty;
      } else if (lowerCaseMessage.contains("cart")) {
        emptyErrorType = EmptyErrorType.cartEmpty;
      } else if (lowerCaseMessage.contains("send")) {
        emptyErrorType = EmptyErrorType.sendEmpty;
      } else if (lowerCaseMessage.contains("order")) {
        emptyErrorType = EmptyErrorType.transactionEmpty;
      } else if (lowerCaseMessage.contains("wishlist")) {
        emptyErrorType = EmptyErrorType.wishlistEmpty;
      }
      return EmptyError(
        emptyErrorType: emptyErrorType
      );
    }
    DioError dioError = generatePleaseLoginFirstDioError(e);
    dynamic message = dioError.response?.data["meta"]["message"];
    if (message is Map<String, dynamic>) {
      String value = message[Constant.textEnUsLanguageKey].toLowerCase();
      if (checkingEmpty(value)) {
        return generateEmptyErrorResult(value);
      }
    } else if (message is String) {
      String value = message.toLowerCase();
      if (checkingEmpty(value)) {
        return generateEmptyErrorResult(value);
      }
    }
    return NotFoundError();
  }
}

// ignore: non_constant_identifier_names
final _ErrorHelperImpl ErrorHelper = _ErrorHelperImpl();