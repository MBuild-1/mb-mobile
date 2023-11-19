import 'package:flutter/material.dart';

import 'page_restoration_helper.dart';

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