import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/presentation/page/product_bundle_detail_page.dart';

import '../controller/reset_password_controller.dart';
import '../presentation/page/modaldialogpage/check_rates_for_various_countries_modal_dialog_page.dart';
import '../presentation/page/product_detail_page.dart';
import '../presentation/page/product_entry_page.dart';
import '../presentation/page/reset_password_page.dart';
import 'dialog_helper.dart';
import 'error/message_error.dart';
import 'page_restoration_helper.dart';
import 'string_util.dart';

class _NotificationRedirectorHelperImpl {
  Map<String, void Function(dynamic, BuildContext)> get notificationRedirectorMap => <String, void Function(dynamic, BuildContext)>{
    "chat-help": (data, context) {
      PageRestorationHelper.toHelpChatPage(context);
    },
    "chat-order": (data, context) {
      if (data is Map<String, dynamic>) {
        if (data.containsKey("data")) {
          String combinedOrderId = data["data"]["id"];
          PageRestorationHelper.toOrderChatPage(combinedOrderId, context);
        }
      }
    },
    "chat-product": (data, context) {
      if (data is Map<String, dynamic>) {
        if (data.containsKey("data")) {
          String productId = data["data"]["id"];
          PageRestorationHelper.toProductChatPage(productId, context);
        }
      }
    },
    "brand-favorite": (data, context) {
      PageRestorationHelper.toFavoriteProductBrandPage(context);
    },
    "checkout": (data, context) {
      if (data is Map<String, dynamic>) {
        if (data.containsKey("data")) {
          String combinedOrderId = data["data"]["id"];
          PageRestorationHelper.toOrderDetailPage(context, combinedOrderId);
        }
      }
    },
    "bucket-request": (data, context) {
      PageRestorationHelper.toSharedCartPage(context);
    },
    "bucket-approved": (data, context) {
      PageRestorationHelper.toSharedCartPage(context);
    },
    "bucket-rejected": (data, context) {
      PageRestorationHelper.toSharedCartPage(context);
    },
    "bucket-checkout": (data, context) {
      if (data is Map<String, dynamic>) {
        if (data.containsKey("data")) {
          String combinedOrderId = data["data"]["id"];
          PageRestorationHelper.toOrderDetailPage(context, combinedOrderId);
        }
      }
    },
    "product-category": (data, context) {
      if (data is Map<String, dynamic>) {
        if (data.containsKey("data")) {
          String categorySlug = data["data"]["category"];
          PageRestorationHelper.toProductEntryPage(
            context,
            ProductEntryPageParameter(
              productEntryParameterMap: {
                "category": categorySlug
              }
            )
          );
        }
      }
    },
    "product-brand": (data, context) {
      if (data is Map<String, dynamic>) {
        if (data.containsKey("data")) {
          String categorySlug = data["data"]["brand"];
          PageRestorationHelper.toProductEntryPage(
            context,
            ProductEntryPageParameter(
              productEntryParameterMap: {
                "brand": categorySlug
              }
            )
          );
        }
      }
    },
    "product-detail": (data, context) {
      if (data is Map<String, dynamic>) {
        if (data.containsKey("data")) {
          PageRestorationHelper.toProductDetailPage(
            context,
            StringUtil.encodeBase64StringFromJson(data["data"]).toProductDetailPageParameter()
          );
        }
      }
    },
    "product-bundle-detail": (data, context) {
      if (data is Map<String, dynamic>) {
        if (data.containsKey("data")) {
          PageRestorationHelper.toProductBundleDetailPage(
            context,
            StringUtil.encodeBase64StringFromJson(data["data"]).toProductBundleDetailPageParameter()
          );
        }
      }
    },
    "order": (data, context) {
      if (data is Map<String, dynamic>) {
        PageRestorationHelper.toOrderPage(context);
      }
    },
    "order-detail": (data, context) {
      if (data is Map<String, dynamic>) {
        if (data.containsKey("data")) {
          String combinedOrderId = data["data"]["combined_order_id"];
          PageRestorationHelper.toOrderDetailPage(
            context,
            combinedOrderId
          );
        }
      }
    },
    "reset-password": (data, context) {
      if (data is Map<String, dynamic>) {
        if (data.containsKey("data")) {
          dynamic dataValue = data["data"];
          String code = dataValue["code"];
          String? type = dataValue["type"];
          String? value = dataValue["value"];
          PageRestorationHelper.toResetPasswordPage(
            context,
            ResetPasswordPageParameter(
              code: code,
              resetPasswordPageParameterType: () {
                if (type == "email") {
                  return EmailResetPasswordPageParameterType();
                } else if (type == "whatsapp-phone-number") {
                  return WhatsappPhoneNumberResetPasswordPageParameterType(
                    phoneNumber: value!
                  );
                }
                throw MessageError(title: "Reset password page parameter type is not suitable");
              }()
            )
          );
        }
      }
    },
    "check-rates-for-various-countries": (data, context) async {
      if (data is Map<String, dynamic>) {
        if (data.containsKey("data")) {
          dynamic dataValue = data["data"];
          String countryCode = dataValue["country_code"];
          await DialogHelper.showModalDialogPage<String, String>(
            context: context,
            modalDialogPageBuilder: (context, parameter) => CheckRatesForVariousCountriesModalDialogPage(
              checkRatesForVariousCountriesModalDialogPageParameter: CheckRatesForVariousCountriesModalDialogPageParameter(
                countryCode: countryCode,
                onGotoCountryDeliveryReview: (countryId) {
                  PageRestorationHelper.toCountryDeliveryReviewPage(
                    countryId, context
                  );
                },
              )
            ),
          );
          Get.back();
        }
      }
    }
  };
}

class NotificationRedirectorParameter {
  void Function(dynamic, BuildContext) onRedirect;
  bool isDisplayNotificationWhileInForeground;

  NotificationRedirectorParameter({
    required this.onRedirect,
    required this.isDisplayNotificationWhileInForeground
  });
}

// ignore: non_constant_identifier_names
final _NotificationRedirectorHelperImpl NotificationRedirectorHelper = _NotificationRedirectorHelperImpl();