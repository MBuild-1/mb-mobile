import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/order_entity_mapping_ext.dart';
import 'package:masterbagasi/domain/entity/product/product_appearance_data.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../domain/entity/additionalitem/additional_item.dart';
import '../../../domain/entity/cart/cart.dart';
import '../../../domain/entity/cart/support_cart.dart';
import '../../../domain/entity/order/createorderversion1point1/create_order_version_1_point_1_parameter.dart';
import '../../../domain/entity/order/createorderversion1point1/create_order_version_1_point_1_response.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderitem/all_required_fields_warehouse_in_order_item.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderitem/optional_fields_warehouse_in_order_item.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/add_warehouse_in_order_parameter.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/change_warehouse_in_order_parameter.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/modify_warehouse_in_order_parameter.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/remove_warehouse_in_order_parameter.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/support_order_product_id_mixin.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderresponse/add_warehouse_in_order_response.dart';
import '../../../domain/entity/order/arrived_order_request.dart';
import '../../../domain/entity/order/arrived_order_response.dart';
import '../../../domain/entity/order/combined_order.dart';
import '../../../domain/entity/order/create_order_parameter.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderresponse/change_warehouse_in_order_response.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderresponse/modify_warehouse_in_order_response.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderresponse/remove_warehouse_in_order_response.dart';
import '../../../domain/entity/order/order.dart';
import '../../../domain/entity/order/order_based_id_parameter.dart';
import '../../../domain/entity/order/order_paging_parameter.dart';
import '../../../domain/entity/order/ordertransaction/order_transaction_parameter.dart';
import '../../../domain/entity/order/ordertransaction/ordertransactionresponse/order_transaction_response.dart';
import '../../../domain/entity/order/purchase_direct_parameter.dart';
import '../../../domain/entity/order/purchase_direct_response.dart';
import '../../../domain/entity/order/repurchase_parameter.dart';
import '../../../domain/entity/order/shipping_review_order_list_parameter.dart';
import '../../../domain/entity/product/productbundle/product_bundle.dart';
import '../../../misc/error/message_error.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/option_builder.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/processing/dio_http_client_processing.dart';
import '../../../misc/processing/future_processing.dart';
import 'order_data_source.dart';

class DefaultOrderDataSource implements OrderDataSource {
  final Dio dio;

  const DefaultOrderDataSource({
    required this.dio
  });

  dynamic _createOrderData(CreateOrderParameter createOrderParameter) {
    List<Cart> cartList = createOrderParameter.cartList;
    List<AdditionalItem> additionalItemList = createOrderParameter.additionalItemList;
    List<dynamic> orderList = cartList.map(
      (cart) {
        SupportCart supportCart = cart.supportCart;
        String? productEntryId;
        String? bundlingId;
        if (supportCart is ProductEntryAppearanceData) {
          productEntryId = (supportCart as ProductEntryAppearanceData).productEntryId;
        } else if (supportCart is ProductBundle) {
          bundlingId = supportCart.id;
        }
        return {
          "id": cart.id,
          if (productEntryId.isNotEmptyString) "product_entry_id": productEntryId,
          if (bundlingId.isNotEmptyString) "bundling_id": bundlingId,
          "quantity": cart.quantity,
          "notes": cart.notes.isNotEmptyString ? cart.notes : null
        };
      }
    ).toList();
    List<dynamic> sendToWarehouseList = additionalItemList.map(
      (additionalItem) => {
        "id": additionalItem.id,
        "name" : additionalItem.name,
        "price": additionalItem.estimationPrice,
        "weight": additionalItem.estimationWeight,
        "quantity": additionalItem.quantity
      }
    ).toList();
    dynamic data = {
      if (createOrderParameter.address != null) "user_address_id": createOrderParameter.address!.id,
      if (createOrderParameter.couponId.isNotEmptyString) "voucher_id": createOrderParameter.couponId!,
      "order_list": orderList,
      "order_send_to_warehouse_list": sendToWarehouseList
    };
    return data;
  }

  @override
  FutureProcessing<Order> createOrder(CreateOrderParameter createOrderParameter) {
    return DioHttpClientProcessing((cancelToken) {
      dynamic data = _createOrderData(createOrderParameter);
      return dio.post("/user/order", data: data, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<Order>(onMap: (value) => value.wrapResponse().mapFromResponseToOrder());
    });
  }

  @override
  FutureProcessing<CreateOrderVersion1Point1Response> createOrderVersion1Point1(CreateOrderVersion1Point1Parameter createOrderVersion1Point1Parameter) {
    return DioHttpClientProcessing((cancelToken) {
      dynamic data = _createOrderData(createOrderVersion1Point1Parameter);
      if (createOrderVersion1Point1Parameter.settlingId.isNotEmptyString) {
        data["settling_id"] = createOrderVersion1Point1Parameter.settlingId!;
      }
      return dio.post(
        "/order",
        data: data,
        cancelToken: cancelToken,
        options: OptionsBuilder.multipartData().withBaseUrl(
          dio.options.baseUrl.replaceAll("v1", "v1.1")
        ).buildExtended()
      ).map<CreateOrderVersion1Point1Response>(onMap: (value) => value.wrapResponse().mapFromResponseToCreateOrderVersion1Point1Response());
    });
  }

  @override
  FutureProcessing<PurchaseDirectResponse> purchaseDirect(PurchaseDirectParameter purchaseDirectParameter) {
    return DioHttpClientProcessing((cancelToken) {
      dynamic data = {
        "product_entry_id": purchaseDirectParameter.productEntryId,
        "settling_id": purchaseDirectParameter.settlingId,
        if (purchaseDirectParameter.couponId.isNotEmptyString) "voucher_id": purchaseDirectParameter.couponId!,
        "quantity": purchaseDirectParameter.quantity,
        "notes": "",
      };
      return dio.post("/user/order/purchase-direct", data: data, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<PurchaseDirectResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToPurchaseDirectResponse());
    });
  }

  @override
  FutureProcessing<Order> repurchase(RepurchaseParameter repurchaseParameter) {
    return DioHttpClientProcessing((cancelToken) {
      dynamic data = {
        "combined_order_id": repurchaseParameter.combinedOrderId,
      };
      return dio.post("/user/order/repurchase", data: data, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<Order>(onMap: (value) => value.wrapResponse().mapFromResponseToOrder());
    });
  }

  @override
  FutureProcessing<List<CombinedOrder>> shippingReviewOrderList(ShippingReviewOrderListParameter shippingReviewOrderListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/shipping-review/user/review?status=Sampai Tujuan", cancelToken: cancelToken)
        .map<List<CombinedOrder>>(onMap: (value) => value.wrapResponse().mapFromResponseToCombinedOrderList());
    });
  }

  @override
  FutureProcessing<PagingDataResult<CombinedOrder>> orderPaging(OrderPagingParameter orderPagingParameter) {
    return DioHttpClientProcessing((cancelToken) {
      String pageParameterPath = "/?pageNumber=${orderPagingParameter.itemEachPageCount}&page=${orderPagingParameter.page}";
      return dio.get("/user/order$pageParameterPath", queryParameters: orderPagingParameter.status.isEmpty ? {} : {"status": orderPagingParameter.status}, cancelToken: cancelToken)
        .map<PagingDataResult<CombinedOrder>>(onMap: (value) => value.wrapResponse().mapFromResponseToCombinedOrderPagingDataResult());
    });
  }

  @override
  FutureProcessing<Order> orderBasedId(OrderBasedIdParameter orderBasedIdParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/user/order/${orderBasedIdParameter.orderId}", cancelToken: cancelToken)
        .map<Order>(onMap: (value) => value.wrapResponse().mapFromResponseToOrder());
    });
  }

  @override
  FutureProcessing<OrderTransactionResponse> orderTransaction(OrderTransactionParameter orderTransactionParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get(
        "/order/${orderTransactionParameter.orderId}/transaction",
        cancelToken: cancelToken,
        options: OptionsBuilder.withBaseUrl(dio.options.baseUrl.replaceAll("v1", "v1.1")).buildExtended()
      ).map<OrderTransactionResponse>(
        onMap: (value) => value.wrapResponse().mapFromResponseToOrderTransactionResponse()
      );
    });
  }

  @override
  FutureProcessing<ArrivedOrderResponse> arrivedOrder(ArrivedOrderParameter arrivedOrderParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/user/order/arrived/${arrivedOrderParameter.combinedOrderId}", cancelToken: cancelToken)
        .map<ArrivedOrderResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToArrivedOrderResponse());
    });
  }

  @override
  FutureProcessing<ModifyWarehouseInOrderResponse> modifyWarehouseInOrder(ModifyWarehouseInOrderParameter modifyWarehouseInOrderParameter) {
    return DioHttpClientProcessing((cancelToken) {
      Map<String, dynamic> data = {};
      late Future<ModifyWarehouseInOrderResponse> onModifyWarehouseInOrder;
      if (modifyWarehouseInOrderParameter is SupportOrderProductIdMixin) {
        data["order_product_id"] = modifyWarehouseInOrderParameter.orderProductId;
      }
      if (modifyWarehouseInOrderParameter is AddWarehouseInOrderParameter) {
        List<AllRequiredFieldsWarehouseInOrderItem> allRequiredFieldsWarehouseInOrderItemList = modifyWarehouseInOrderParameter.allRequiredFieldsWarehouseInOrderItemList;
        data["other_order_product_list"] = allRequiredFieldsWarehouseInOrderItemList.map<Map<String, dynamic>>((item) => {
          "type": "sendToWH",
          "name" : item.name,
          "price": item.price,
          "weight": item.weight,
          "quantity": item.quantity,
          "notes": item.notes
        }).toList();
        onModifyWarehouseInOrder = dio.post("/user/order/sendtowh", data: data, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
          .map<AddWarehouseInOrderResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToAddWarehouseInOrderResponse());
      } else if (modifyWarehouseInOrderParameter is ChangeWarehouseInOrderParameter) {
        OptionalFieldsWarehouseInOrderItem optionalFieldsWarehouseInOrderItem = modifyWarehouseInOrderParameter.optionalFieldsWarehouseInOrderItem;
        data["_method"] = "PUT";
        data.addAll({
          if (optionalFieldsWarehouseInOrderItem.name.isNotEmptyString) "name" : optionalFieldsWarehouseInOrderItem.name,
          if (optionalFieldsWarehouseInOrderItem.price != null) "price": optionalFieldsWarehouseInOrderItem.price,
          if (optionalFieldsWarehouseInOrderItem.weight != null) "weight": optionalFieldsWarehouseInOrderItem.weight,
          if (optionalFieldsWarehouseInOrderItem.quantity != null) "quantity": optionalFieldsWarehouseInOrderItem.quantity,
          if (optionalFieldsWarehouseInOrderItem.notes.isNotEmptyString) "notes": optionalFieldsWarehouseInOrderItem.notes
        });
        onModifyWarehouseInOrder = dio.post("/user/order/sendtowh/${modifyWarehouseInOrderParameter.id}", data: data, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
          .map<ChangeWarehouseInOrderResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToChangeWarehouseInOrderResponse());
      } else if (modifyWarehouseInOrderParameter is RemoveWarehouseInOrderParameter) {
        onModifyWarehouseInOrder = dio.delete("/user/order/sendtowh/${modifyWarehouseInOrderParameter.warehouseInOrderItemId}", data: data, cancelToken: cancelToken)
          .map<RemoveWarehouseInOrderResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToRemoveWarehouseInOrderResponse());
      } else {
        throw MessageError(message: "Modify warehouse in order parameter is not suitable.");
      }
      return onModifyWarehouseInOrder;
    });
  }
}