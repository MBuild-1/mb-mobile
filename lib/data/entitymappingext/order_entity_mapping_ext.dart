import 'package:masterbagasi/data/entitymappingext/additional_item_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/address_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/coupon_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/payment_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/product_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/summary_value_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/user_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/order/createorderversion1point1/create_order_version_1_point_1_response.dart';
import '../../domain/entity/order/createorderversion1point1/responsetype/default_create_order_response_type.dart';
import '../../domain/entity/order/createorderversion1point1/responsetype/no_create_order_response_type.dart';
import '../../domain/entity/order/createorderversion1point1/responsetype/only_warehouse_order_response_type.dart';
import '../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderresponse/add_warehouse_in_order_response.dart';
import '../../domain/entity/order/arrived_order_response.dart';
import '../../domain/entity/order/combined_order.dart';
import '../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderresponse/change_warehouse_in_order_response.dart';
import '../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderresponse/remove_warehouse_in_order_response.dart';
import '../../domain/entity/order/order.dart';
import '../../domain/entity/order/order_address.dart';
import '../../domain/entity/order/order_detail.dart';
import '../../domain/entity/order/order_product.dart';
import '../../domain/entity/order/order_product_detail.dart';
import '../../domain/entity/order/order_product_in_order_shipping.dart';
import '../../domain/entity/order/order_product_inventory.dart';
import '../../domain/entity/order/order_purchasing.dart';
import '../../domain/entity/order/order_shipping.dart';
import '../../domain/entity/order/order_summary.dart';
import '../../domain/entity/order/ordertracking/order_tracking.dart';
import '../../domain/entity/order/ordertracking/order_tracking_detail.dart';
import '../../domain/entity/order/ordertracking/order_tracking_location.dart';
import '../../domain/entity/order/ordertracking/order_tracking_location_address.dart';
import '../../domain/entity/order/ordertransaction/order_transaction_status_code_and_status_message.dart';
import '../../domain/entity/order/ordertransaction/ordertransactionsummary/order_transaction_summary.dart';
import '../../domain/entity/order/ordertransaction/ordertransactionresponse/order_transaction_response.dart';
import '../../domain/entity/order/purchase_direct_response.dart';
import '../../domain/entity/order/repurchase/repurchase_response.dart';
import '../../domain/entity/order/repurchase/responsetype/default_repurchase_response_type.dart';
import '../../domain/entity/order/repurchase/responsetype/no_repurchase_response_type.dart';
import '../../domain/entity/order/repurchase/responsetype/only_warehouse_repurchase_response_type.dart';
import '../../domain/entity/order/support_order_product.dart';
import '../../misc/constant.dart';
import '../../misc/date_util.dart';
import '../../misc/error/message_error.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/response_wrapper.dart';

extension ProductEntityMappingExt on ResponseWrapper {
  List<CombinedOrder> mapFromResponseToCombinedOrderList() {
    return response.map<CombinedOrder>((combinedOrderResponse) => ResponseWrapper(combinedOrderResponse).mapFromResponseToCombinedOrder()).toList();
  }

  PagingDataResult<CombinedOrder> mapFromResponseToCombinedOrderPagingDataResult() {
    return ResponseWrapper(response).mapFromResponseToPagingDataResult(
      (dataResponse) => dataResponse.map<CombinedOrder>(
        (combinedOrderResponse) => ResponseWrapper(combinedOrderResponse).mapFromResponseToCombinedOrder()
      ).toList()
    );
  }

  List<OrderTracking> mapFromResponseToOrderTrackingList() {
    if (response == null) {
      return [];
    }
    return response.map<OrderTracking>(
      (orderTrackingResponse) => ResponseWrapper(orderTrackingResponse).mapFromResponseToOrderTracking()
    ).toList();
  }

  List<OrderTrackingDetail> mapFromResponseToOrderTrackingDetailList() {
    if (response == null) {
      return [];
    }
    return response.map<OrderTrackingDetail>(
      (orderTrackingDetailResponse) => ResponseWrapper(orderTrackingDetailResponse).mapFromResponseToOrderTrackingDetail()
    ).toList();
  }
}

extension OrderDetailEntityMappingExt on ResponseWrapper {
  Order mapFromResponseToSharedCartOrder() {
    dynamic effectiveOrderSummary = response["detail"];
    effectiveOrderSummary ??= response["summary"];
    return Order(
      orderSummary: ResponseWrapper(effectiveOrderSummary).mapFromResponseToOrderSummary(),
      combinedOrder: ResponseWrapper(response).mapFromResponseToCombinedOrder()
    );
  }

  Order mapFromResponseToOrder() {
    dynamic effectiveOrderSummary = response["detail"];
    effectiveOrderSummary ??= response["summary"];
    return Order(
      orderSummary: ResponseWrapper(effectiveOrderSummary).mapFromResponseToOrderSummary(),
      combinedOrder: ResponseWrapper(response["combined_order"]).mapFromResponseToCombinedOrder()
    );
  }

  OrderTracking mapFromResponseToOrderTracking() {
    return OrderTracking(
      id: response["id"],
      orderShippingId: response["order_shipping_id"],
      trackingNumber: response["tracking_number"],
      arrived: response["arrived"],
      weight: ResponseWrapper(response["weight"]).mapFromResponseToDouble()!,
      orderTrackingDetailList: ResponseWrapper(response["event"]).mapFromResponseToOrderTrackingDetailList()
    );
  }

  OrderTrackingDetail mapFromResponseToOrderTrackingDetail() {
    return OrderTrackingDetail(
      timeStamp: ResponseWrapper(response["timestamp"]).mapFromResponseToDateTime(convertIntoLocalTime: false)!,
      orderTrackingLocation: ResponseWrapper(response["location"]).mapFromResponseToOrderTrackingLocation(),
      description: MultiLanguageString(response["description"]),
      pieceIdList: (response["pieceIds"] ?? []).map<String>((pieceId) => pieceId as String).toList()
    );
  }

  OrderTrackingLocation mapFromResponseToOrderTrackingLocation() {
    return OrderTrackingLocation(
      orderTrackingLocationAddress: ResponseWrapper(response["address"]).mapFromResponseToOrderTrackingLocationAddress(),
    );
  }

  OrderTrackingLocationAddress mapFromResponseToOrderTrackingLocationAddress() {
    return OrderTrackingLocationAddress(
      addressLocality: MultiLanguageString(response["addressLocality"]),
    );
  }

  OrderSummary mapFromResponseToOrderSummary() {
    dynamic finalSummaryResponse = response != null ? response["final_summary"] : null;
    return OrderSummary(
      summaryValue: response != null ? ResponseWrapper(response["summary"]).mapFromResponseToSummaryValueList() : [],
      finalSummaryValue: finalSummaryResponse != null ? ResponseWrapper(finalSummaryResponse).mapFromResponseToSummaryValueList() : [],
    );
  }

  CombinedOrder mapFromResponseToCombinedOrder() {
    return CombinedOrder(
      id: response["id"],
      invoiceId: response["invoice_id"],
      userId: response["user_id"],
      orderProductId: response["order_product_id"],
      orderShippingId: response["order_shipping_id"],
      orderCode: response["order_code"],
      couponId: response["voucher_id"],
      picId: response["pic_id"],
      picTakeoverId: response["pic_takeover_id"],
      status: response["status"],
      inStatus: response["in_status"],
      takeoverAt: response["takeover_at"] != null ? ResponseWrapper(response["takeover_at"]).mapFromResponseToDateTime() : null,
      review: response["review"],
      isRemoteArea: response["is_remote_area"] ?? 0,
      isBucket: response["is_bucket"] ?? 0,
      coupon: response["coupon"] != null ? ResponseWrapper(response["coupon"]).mapFromResponseToCoupon() : null,
      user: ResponseWrapper(response["user"]).mapFromResponseToUser(),
      orderProduct: ResponseWrapper(response["order_product"]).mapFromResponseToOrderProduct(),
      orderAddress: response["order_addresses"] != null ? ResponseWrapper(response["order_addresses"]).mapFromResponseToOrderAddress() : null,
      orderShipping: response["order_shipping"] != null ? ResponseWrapper(response["order_shipping"]).mapFromResponseToOrderShipping() : null,
      orderPurchasingList: response["repurchase"] != null ? response["repurchase"].map<OrderPurchasing>(
        (orderPurchasingResponse) => ResponseWrapper(orderPurchasingResponse).mapFromResponseToOrderPurchasing()
      ).toList() : [],
      createdAt: ResponseWrapper(response["created_at"]).mapFromResponseToDateTime()!
    );
  }

  OrderPurchasing mapFromResponseToOrderPurchasing() {
    return OrderPurchasing(
      id: response["id"],
      productEntryId: response["product_entry_id"],
      bundlingId: response["bundling_id"],
      combinedOrderId: response["combined_order_id"],
      buyingPrice: response["buying_price"] ?? 0,
      name: (response["name"] as String?).toEmptyStringNonNull,
      price: response["price"] ?? 0,
      weight: ResponseWrapper(response["weight"]).mapFromResponseToDouble() ?? 0.0,
      quantity: response["quantity"],
      quantityItem: response["quantity_item"],
      totalPrice: response["total_price"],
      totalWeight: ResponseWrapper(response["total_weight"]).mapFromResponseToDouble() ?? 0.0,
    );
  }

  OrderProductInventory mapFromResponseToOrderProductInventory() {
    return OrderProductInventory(
      id: response["id"],
      orderProductId: response["order_product_id"],
      productEntryId: response["product_entry_id"],
      quantity: response["quantity"],
      checkoutPrice: response["checkout_price"] ?? 0,
      defaultQuantity: response["default_quantity"],
      notes: response["notes"],
      status: response["status"],
      productEntry: ResponseWrapper(response["product_entry"]).mapFromResponseToProductEntry([], [])
    );
  }

  OrderProduct mapFromResponseToOrderProduct() {
    return OrderProduct(
      id: response["id"],
      orderId: response["order_id"],
      userAddressId: response["user_address_id"],
      orderDetail: ResponseWrapper(response["order"]).mapFromResponseToOrderDetail(),
      userAddress: response["user_address"] != null ? ResponseWrapper(response["user_address"]).mapFromResponseToAddress() : null,
      orderProductDetailList: response["order_product_list"].map<OrderProductDetail>(
        (orderProductDetailResponse) => ResponseWrapper(orderProductDetailResponse).mapFromResponseToOrderProductDetail()
      ).toList(),
      additionalItemList: ResponseWrapper(response["order_send_to_warehouse_list"]).mapFromResponseToAdditionalItemList(),
      otherOrderProductList: ResponseWrapper(response["other_order_product_list"]).mapFromResponseToAdditionalItemList(),
      otherProductInventoryList: response["product_inventory"].map<OrderProductInventory>(
        (orderProductInventoryResponse) => ResponseWrapper(orderProductInventoryResponse).mapFromResponseToOrderProductInventory()
      ).toList()
    );
  }

  OrderProductInOrderShipping mapFromResponseToOrderProductInOrderShipping() {
    return OrderProductInOrderShipping(
      id: response["id"],
      orderId: response["order_id"],
      userAddressId: response["user_address_id"],
      userAddress: response["user_address"] != null ? ResponseWrapper(response["user_address"]).mapFromResponseToAddress() : null,
      orderProductDetailList: response["order_product_list"].map<OrderProductDetail>(
        (orderProductDetailResponse) => ResponseWrapper(orderProductDetailResponse).mapFromResponseToOrderProductDetail()
      ).toList(),
      additionalItemList: ResponseWrapper(response["order_send_to_warehouse_list"]).mapFromResponseToAdditionalItemList()
    );
  }

  OrderShipping mapFromResponseToOrderShipping() {
    return OrderShipping(
      id: response["id"],
      orderId: response["order_id"],
      orderProductId: response["order_product_id"],
      trackingNumber: response["tracking_number"] ?? "",
      isPaymentTriggered: response["is_payment_triggered"] == 1,
      status: response["status"],
      notes: response["notes"],
      orderDetail: ResponseWrapper(response["order"]).mapFromResponseToOrderDetail(),
      orderProductInOrderShipping: ResponseWrapper(response["order_product"]).mapFromResponseToOrderProductInOrderShipping(),
      orderTrackingList: ResponseWrapper(response["shipment_trackings"]).mapFromResponseToOrderTrackingList()
    );
  }

  OrderDetail mapFromResponseToOrderDetail() {
    return OrderDetail(
      id: response["id"],
      status: response["status"],
      paymentType: response["payment_type"],
      totalPrice: response["total_price"],
      snapToken: (response["snap_token"] as String?).toEmptyStringNonNull,
      realTotalPrice: response["real_total_price"]
    );
  }

  OrderProductDetail mapFromResponseToOrderProductDetail() {
    return OrderProductDetail(
      id: response["id"],
      orderProductId: response["order_product_id"],
      quantity: response["quantity"],
      notes: response["notes"],
      supportOrderProduct: ResponseWrapper(response).mapFromResponseToSupportOrderProduct()
    );
  }

  OrderAddress mapFromResponseToOrderAddress() {
    if (response == null) {
      throw MultiLanguageMessageError(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "No order address.",
          Constant.textInIdLanguageKey: "Tidak ada alamat pemesanan."
        })
      );
    }
    return OrderAddress(
      id: response["id"],
      combinedOrderId: response["combined_order_id"],
      countryId: response["country_id"],
      label: response["label"],
      address: response["address"],
      phoneNumber: response["phone_number"],
      zipCode: response["zip_code"],
      city: response["city"],
      state: response["state"],
      name: response["name"],
      email: response["email"],
      address2: response["address2"],
      country: ResponseWrapper(response["country"]).mapFromResponseToCountry(),
    );
  }

  SupportOrderProduct mapFromResponseToSupportOrderProduct() {
    dynamic productEntry = response["product_entry"];
    dynamic bundling = response["bundling"];
    if (productEntry != null) {
      return ResponseWrapper(productEntry).mapFromResponseToProductEntry([], []);
    } else if (bundling != null) {
      return ResponseWrapper(bundling).mapFromResponseToProductBundle([], []);
    } else {
      throw MessageError(message: "Support order product not suitable");
    }
  }

  CreateOrderVersion1Point1Response mapFromResponseToCreateOrderVersion1Point1Response() {
    return CreateOrderVersion1Point1Response(
      createOrderResponseType: () {
        String message = "";
        if (this is MainStructureResponseWrapper) {
          MainStructureResponseWrapper mainStructureResponseWrapper = this as MainStructureResponseWrapper;
          message = mainStructureResponseWrapper.message.toLowerCase();
        }
        dynamic paymentResponse = response["payment"];
        if (message.contains("create warehouse")) {
          if (response is Map<String, dynamic>) {
            return OnlyWarehouseCreateOrderResponseType(
              combinedOrderId: paymentResponse["combined_order_id"]
            );
          } else if (response is String) {
            return OnlyWarehouseCreateOrderResponseType(
              combinedOrderId: response
            );
          } else {
            return NoCreateOrderResponseType();
          }
        }
        return DefaultCreateOrderResponseType(
          transactionId: paymentResponse["transaction_id"],
          orderId: paymentResponse["order_id"],
          combinedOrderId: paymentResponse["combined_order_id"]
        );
      }()
    );
  }

  RepurchaseResponse mapFromResponseToRepurchaseResponse() {
    return RepurchaseResponse(
      repurchaseResponseType: () {
        String message = "";
        if (this is MainStructureResponseWrapper) {
          MainStructureResponseWrapper mainStructureResponseWrapper = this as MainStructureResponseWrapper;
          message = mainStructureResponseWrapper.message.toLowerCase();
        }
        dynamic paymentResponse = response["payment"];
        if (message.contains("create warehouse")) {
          if (response is Map<String, dynamic>) {
            return OnlyWarehouseRepurchaseResponseType(
              combinedOrderId: paymentResponse["combined_order_id"]
            );
          } else {
            return NoRepurchaseResponseType();
          }
        }
        return DefaultRepurchaseResponseType(
          transactionId: paymentResponse["transaction_id"],
          orderId: paymentResponse["order_id"],
          combinedOrderId: paymentResponse["combined_order_id"]
        );
      }()
    );
  }

  ArrivedOrderResponse mapFromResponseToArrivedOrderResponse() {
    return ArrivedOrderResponse();
  }

  AddWarehouseInOrderResponse mapFromResponseToAddWarehouseInOrderResponse() {
    return AddWarehouseInOrderResponse();
  }

  ChangeWarehouseInOrderResponse mapFromResponseToChangeWarehouseInOrderResponse() {
    return ChangeWarehouseInOrderResponse();
  }

  RemoveWarehouseInOrderResponse mapFromResponseToRemoveWarehouseInOrderResponse() {
    return RemoveWarehouseInOrderResponse();
  }

  OrderTransactionSummary mapFromResponseToOrderTransactionSummary() {
    // List<SummaryValue> orderTransactionSummaryValue = response != null ? ResponseWrapper(response).mapFromResponseToSummaryValueList() : [];
    // if (orderTransactionSummaryValue.isEmpty) {
    //   throw ErrorHelper.generateMultiLanguageDioError(
    //     Constant.multiLanguageMessageErrorPaymentDetail
    //   );
    // }
    return OrderTransactionSummary(
      orderTransactionSummaryValueList: response != null ? ResponseWrapper(response).mapFromResponseToSummaryValueList() : []
    );
  }

  OrderTransactionResponse mapFromResponseToOrderTransactionResponse() {
    dynamic paymentResponse = response["payment"];
    String statusCode = paymentResponse["status_code"];
    String statusMessage = paymentResponse["status_message"];
    if (statusCode.isNotEmptyString) {
      if (statusCode[0] != "2") {
        if (statusCode != "407") {
          throw MultiLanguageMessageError(
            title: MultiLanguageString({
              Constant.textEnUsLanguageKey: "Failed to Load Payment Details",
              Constant.textInIdLanguageKey: "Gagal Memuat Rincian Pembayaran"
            }),
            message: MultiLanguageString({
              Constant.textEnUsLanguageKey: "Please try refresh again.",
              Constant.textInIdLanguageKey: "Silahkan coba refresh kembali."
            }),
            value: OrderTransactionStatusCodeAndStatusMessage(
              statusCode: statusCode,
              statusMessage: statusMessage
            )
          );
        }
      }
    }
    return OrderTransactionResponse(
      paymentStepType: (paymentResponse["payment_step_type"] as String?).toEmptyStringNonNull,
      orderId: paymentResponse["order_id"],
      transactionId: paymentResponse["transaction_id"],
      transactionStatus: paymentResponse["transaction_status"],
      statusCode: statusCode,
      statusMessage: statusMessage,
      grossAmount: ResponseWrapper(paymentResponse["gross_amount"]).mapFromResponseToDouble()!,
      transactionDateTime: DateUtil.convertUtcOffset(
        ResponseWrapper(paymentResponse["transaction_time"]).mapFromResponseToDateTime(
          dateFormat: DateUtil.standardDateFormat,
          convertIntoLocalTime: false
        )!,
        0,
        oldUtcOffset: 7
      ),
      expiryDateTime: DateUtil.convertUtcOffset(
        ResponseWrapper(paymentResponse["expiry_time"]).mapFromResponseToDateTime(
          dateFormat: DateUtil.standardDateFormat,
          convertIntoLocalTime: false
        )!,
        0,
        oldUtcOffset: 7
      ),
      orderTransactionSummary: ResponseWrapper(response["payment_detail"]).mapFromResponseToOrderTransactionSummary(),
      paymentInstructionTransactionSummary: ResponseWrapper(response["payment_instruction"]).mapFromResponseToPaymentInstructionTransactionSummary(),
    );
  }

  PurchaseDirectResponse mapFromResponseToPurchaseDirectResponse() {
    dynamic paymentResponse = response["payment"];
    return PurchaseDirectResponse(
      transactionId: paymentResponse["transaction_id"],
      orderId: paymentResponse["order_id"],
      combinedOrderId: paymentResponse["combined_order_id"]
    );
  }
}