import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Response;
import 'package:masterbagasi/misc/ext/error_provider_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../constant.dart';
import '../error/cart_empty_error.dart';
import '../error/coming_soon_error.dart';
import '../error/empty_error.dart';
import '../error/message_error.dart';
import '../error/not_found_error.dart';
import '../error/search_not_found_error.dart';
import '../error/token_empty_error.dart';
import '../error/validation_error.dart';
import '../error/warehouse_empty_error.dart';
import '../error_helper.dart';
import '../multi_language_string.dart';
import 'error_provider.dart';

class DefaultErrorProvider extends ErrorProvider {
  @override
  ErrorProviderResult? onGetErrorProviderResult(e) {
    if (e is DioError) {
      return _handlingDioError(e);
    } else if (e is NotFoundError) {
      return ErrorProviderResult(
        title: "Not Found",
        message: e.message
      );
    } else if (e is ValidationError) {
      return ErrorProviderResult(
        title: e.message,
        message: e.message
      );
    } else if (e is MessageError) {
      return ErrorProviderResult(
        title: e.title,
        message: e.message
      );
    } else if (e is MultiLanguageMessageError) {
      return ErrorProviderResult(
        title: e.title.toStringNonNull,
        message: e.message.toStringNonNull,
        imageAssetUrl: e.imageAssetUrl
      );
    } else if (e is CartEmptyError) {
      return _cartIsEmptyErrorProvider(null);
    } else if (e is WarehouseEmptyError) {
      return _warehouseIsEmptyErrorProvider(null);
    } else if (e is SearchNotFoundError) {
      return _searchNotFoundError();
    } else if (e is TokenEmptyError) {
      return ErrorProviderResult(
        title: "You Are Not Login".tr,
        message: "Please login through below button".tr,
        imageAssetUrl: Constant.imageHaveToLogin
      );
    } else if (e is ComingSoonError) {
      return ErrorProviderResult(
        title: "",
        message: "",
        imageAssetUrl: Constant.imageComingSoon
      );
    } else if (e is PlatformException) {
      return ErrorProviderResult(
        title: "${"Something Failed".tr} (${e.code})",
        message: "${e.message}"
      );
    } else {
      return ErrorProviderResult(
        title: "Something Failed".tr,
        message: e.toString()
      );
    }
  }

  ErrorProviderResult _cartIsEmptyErrorProvider(MultiLanguageString? messageMultiLanguageString) {
    late MultiLanguageString effectiveMessageMultiLanguageString;
    if (messageMultiLanguageString != null) {
      effectiveMessageMultiLanguageString = messageMultiLanguageString;
    } else {
      effectiveMessageMultiLanguageString = MultiLanguageString({
        Constant.textEnUsLanguageKey: "Now cart is empty. Please select the product first.",
        Constant.textInIdLanguageKey: "Untuk sekarang keranjangnya kosong."
      });
    }
    return onGetErrorProviderResult(
      MultiLanguageMessageError(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Cart Is Empty",
          Constant.textInIdLanguageKey: "Keranjang Kosong"
        }),
        message: effectiveMessageMultiLanguageString,
        imageAssetUrl: Constant.imageEmptyErrorCart
      )
    ).toErrorProviderResultNonNull();
  }

  ErrorProviderResult _warehouseIsEmptyErrorProvider(MultiLanguageString? messageMultiLanguageString) {
    late MultiLanguageString effectiveMessageMultiLanguageString;
    if (messageMultiLanguageString != null) {
      effectiveMessageMultiLanguageString = messageMultiLanguageString;
    } else {
      effectiveMessageMultiLanguageString = MultiLanguageString({
        Constant.textEnUsLanguageKey: "For now, item in personal stuffs is empty.",
        Constant.textInIdLanguageKey: "Untuk sekarang, barang di barang pribadi kosong.",
      });
    }
    return onGetErrorProviderResult(
      MultiLanguageMessageError(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Item in Personal Stuffs Is Empty",
          Constant.textInIdLanguageKey: "Barang di Barang Pribadi Kosong",
        }),
        message: effectiveMessageMultiLanguageString,
        imageAssetUrl: Constant.imageEmptyErrorCart
      )
    ).toErrorProviderResultNonNull();
  }

  ErrorProviderResult? _searchNotFoundError() {
    return onGetErrorProviderResult(
      MultiLanguageMessageError(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "Search Not Found",
          Constant.textInIdLanguageKey: "Pencarian Tidak Ditemukan"
        }),
        message: MultiLanguageString({
          Constant.textEnUsLanguageKey: "For now search not found.",
          Constant.textInIdLanguageKey: "Untuk sekarang pencarian tidak ditemukan."
        }),
      )
    ).toErrorProviderResultNonNull();
  }

  ErrorProviderResult _handlingDioError(DioError e) {
    DioErrorType dioErrorType = e.type;
    if (dioErrorType == DioErrorType.other) {
      return ErrorProviderResult(
        title: "Internet Connection Problem".tr,
        message: "${"There is a problem in internet connection".tr}.",
        imageAssetUrl: Constant.imageNoInternet
      );
    } else if (dioErrorType == DioErrorType.connectTimeout) {
      return ErrorProviderResult(
        title: "Internet Connection Timeout".tr,
        message: "${"The connection of internet has been timeout".tr}.",
        imageAssetUrl: Constant.imageNoInternet
      );
    } else if (dioErrorType == DioErrorType.sendTimeout) {
      return ErrorProviderResult(
        title: "Internet Connection Send Timeout".tr,
        message: "${"The connection of internet has been timeout while sending".tr}.",
        imageAssetUrl: Constant.imageNoInternet
      );
    } else if (dioErrorType == DioErrorType.receiveTimeout) {
      return ErrorProviderResult(
        title: "Internet Connection Receive Timeout".tr,
        message: "${"The connection of internet has been timeout while receiving".tr}.",
        imageAssetUrl: Constant.imageNoInternet
      );
    } else if (dioErrorType == DioErrorType.cancel) {
      return ErrorProviderResult(
        title: "Request Canceled".tr,
        message: "${"Request has been canceled".tr}.",
        imageAssetUrl: Constant.imageFailed
      );
    } else if (dioErrorType == DioErrorType.response) {
      ErrorProviderResult elseResponseDecision() {
        Response<dynamic>? response = e.response;
        dynamic responseData = response?.data;
        if (responseData is Map) {
          dynamic errorMeta = responseData['meta'];
          dynamic errors = responseData['data'];
          if (errors != null) {
            if (errors is Map) {
              Map<String, dynamic> errorsMap = errors as Map<String, dynamic>;
              String errorMessage = "";
              void addErrorMessage(dynamic errorMessageContent) {
                errorMessage += "${(errorMessage.isEmptyString ? "" : "\r\n")}$errorMessageContent";
              }
              for (var errorValue in errorsMap.values) {
                if (errorValue is List) {
                  for (var errorValueContent in errorValue) {
                    addErrorMessage(errorValueContent);
                  }
                } else {
                  addErrorMessage(errorValue);
                }
              }
              return ErrorProviderResult(
                title: "Request Failed".tr,
                message: errorMessage.toStringNonNullWithCustomText(text: "(${"No Message".tr})"),
                imageAssetUrl: Constant.imageFailed
              );
            } else if (errors is List) {
              if (errors.isEmpty) {
                if (errorMeta is Map) {
                  String title = "Request Failed".tr;
                  String message = "No Message".tr;
                  if (errorMeta.containsKey('title')) {
                    title = MultiLanguageString(errorMeta['title']).toEmptyStringNonNull;
                  }
                  if (errorMeta.containsKey('message')) {
                    message = MultiLanguageString(errorMeta['message']).toEmptyStringNonNull;
                  }
                  return ErrorProviderResult(
                    title: title,
                    message: message,
                    imageAssetUrl: Constant.imageFailed
                  );
                }
              }
            }
            return ErrorProviderResult(
              title: "${"Request Failed".tr} (${e.response?.statusCode})",
              message: "(${"No Message".tr})",
              imageAssetUrl: Constant.imageFailed
            );
          } else {
            String? message = responseData['message'] != null ? responseData['message']!.toString() : null;
            return ErrorProviderResult(
              title: "Request Failed".tr,
              message: !message.isEmptyString ? message! : "(${"No Message".tr})",
              imageAssetUrl: Constant.imageFailed
            );
          }
        } else {
          String effectiveResponse = responseData is String ? responseData.substring(0, responseData.length > 500 ? 500 : responseData.length) : responseData;
          return ErrorProviderResult(
            title: "${"Request Failed".tr} (${e.response?.statusCode})",
            message: !effectiveResponse.isEmptyString ? effectiveResponse : "(${"No Message".tr})",
            imageAssetUrl: Constant.imageFailed
          );
        }
      }
      int? statusCode = e.response?.statusCode;
      if (statusCode == 404) {
        Response<dynamic>? response = e.response;
        dynamic responseData = response?.data;
        if (responseData is Map) {
          dynamic errorMeta = responseData['meta'];
          if (errorMeta is Map) {
            return ErrorProviderResult(
              title: "Not Found".tr,
              message: MultiLanguageString(errorMeta["message"]).toEmptyStringNonNull,
              imageAssetUrl: Constant.imageFailed
            );
          }
        }
        return ErrorProviderResult(
          title: "Not Found".tr,
          message: "${"Request not found (404)".tr}.",
          imageAssetUrl: Constant.imageFailed
        );
      } else if (statusCode == 400) {
        ErrorProviderResult notFound() {
          Error error = ErrorHelper.generateEmptyError(e);
          if (error is EmptyError) {
            late String imageAssetUrl;
            EmptyErrorType emptyErrorType = error.emptyErrorType;
            if (emptyErrorType == EmptyErrorType.addressEmpty) {
              imageAssetUrl = Constant.imageEmptyErrorAddress;
            } else if (emptyErrorType == EmptyErrorType.cartEmpty) {
              imageAssetUrl = Constant.imageEmptyErrorCart;
            } else if (emptyErrorType == EmptyErrorType.sendEmpty) {
              imageAssetUrl = Constant.imageEmptyErrorSend;
            } else if (emptyErrorType == EmptyErrorType.transactionEmpty) {
              imageAssetUrl = Constant.imageEmptyErrorTransaction;
            } else if (emptyErrorType == EmptyErrorType.wishlistEmpty) {
              imageAssetUrl = Constant.imageEmptyErrorWishlist;
            } else if (emptyErrorType == EmptyErrorType.notificationEmpty) {
              imageAssetUrl = Constant.imageEmptyErrorTransaction;
            } else {
              imageAssetUrl = Constant.imageEmptyError;
            }
            return elseResponseDecision()
              ..imageAssetUrl = imageAssetUrl;
          }
          return elseResponseDecision();
        }
        Response<dynamic>? response = e.response;
        dynamic responseData = response?.data;
        if (responseData is Map) {
          dynamic errorMeta = responseData['meta'];
          if (errorMeta is Map) {
            String dataCartNotFoundLowerCase = "data cart not found";
            dynamic message = errorMeta["message"];
            ErrorProviderResult defaultChecking() {
              if (message.toString().toLowerCase().contains(dataCartNotFoundLowerCase)) {
                return _cartIsEmptyErrorProvider(null);
              } else {
                return notFound();
              }
            }
            if (message is Map) {
              MultiLanguageString effectiveMessageMultiLanguageString = MultiLanguageString(message);
              dynamic effectiveValue = message["value"];
              if (effectiveValue != null) {
                if (effectiveValue.toLowerCase().contains(dataCartNotFoundLowerCase)) {
                  return _cartIsEmptyErrorProvider(effectiveMessageMultiLanguageString);
                } else {
                  return notFound();
                }
              } else {
                return defaultChecking();
              }
            } else {
              return defaultChecking();
            }
          }
        }
        return notFound();
      } else if (statusCode == 500) {
        Response<dynamic>? response = e.response;
        dynamic responseData = response?.data;
        if (responseData is Map) {
          if (responseData.containsKey("message")) {
            dynamic message = responseData["message"];
            if (message is String) {
              if (message.toLowerCase().contains("midtrans api is returning api error")) {
                return onGetErrorProviderResult(
                  MultiLanguageMessageError(
                    title: MultiLanguageString({
                      Constant.textEnUsLanguageKey: "Failed to Make Payment",
                      Constant.textInIdLanguageKey: "Gagal Membuat Pembayaran"
                    }),
                    message: MultiLanguageString({
                      Constant.textEnUsLanguageKey: "Please try again.",
                      Constant.textInIdLanguageKey: "Silahkan coba lagi."
                    }),
                  )
                ).toErrorProviderResultNonNull();
              }
            }
          }
        }
        return ErrorProviderResult(
          title: "Internal Server Error".tr,
          message: "${"Something has internal server error".tr}.",
          imageAssetUrl: Constant.imageFailed
        );
      } else {
        return elseResponseDecision();
      }
    } else {
      return ErrorProviderResult(
        title: "Something Wrong".tr,
        message: "${"Something wrong related with internet connection".tr}.",
        imageAssetUrl: Constant.imageFailed
      );
    }
  }
}