import 'package:flutter/material.dart';

import '../domain/entity/order/createorderversion1point1/create_order_version_1_point_1_response.dart';
import '../domain/entity/order/createorderversion1point1/responsetype/create_order_response_type.dart';
import '../domain/entity/order/createorderversion1point1/responsetype/paypal_create_order_response_type.dart';
import '../domain/entity/order/createorderversion1point1/responsetype/with_combined_order_id_create_order_response_type.dart';
import 'navigation_helper.dart';

class _OrderHelperImpl {
  void createOrderFromVersion1Point1Response(BuildContext context, CreateOrderVersion1Point1Response createOrderVersion1Point1Response) {
    CreateOrderResponseType createOrderResponseType = createOrderVersion1Point1Response.createOrderResponseType;
    print("createOrderResponseType: $createOrderResponseType");
    if (createOrderResponseType is PaypalCreateOrderResponseType) {
      NavigationHelper.navigationToPaypalPaymentProcessAfterPurchaseProcess(
        context, createOrderResponseType.approveLink
      );
      return;
    }
    String combinedOrderId = "";
    if (createOrderResponseType is WithCombinedOrderIdCreateOrderResponseType) {
      WithCombinedOrderIdCreateOrderResponseType withCombinedOrderIdCreateOrderResponseType = createOrderResponseType as WithCombinedOrderIdCreateOrderResponseType;
      combinedOrderId = withCombinedOrderIdCreateOrderResponseType.combinedOrderId;
    }
    NavigationHelper.navigationAfterPurchaseProcessWithCombinedOrderIdParameter(context, combinedOrderId);
  }
}

// ignore: non_constant_identifier_names
final _OrderHelperImpl OrderHelper = _OrderHelperImpl();