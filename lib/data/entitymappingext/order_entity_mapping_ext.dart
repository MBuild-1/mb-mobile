import 'package:masterbagasi/data/entitymappingext/additional_item_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/address_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/coupon_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/product_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/user_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../domain/entity/order/combined_order.dart';
import '../../domain/entity/order/order.dart';
import '../../domain/entity/order/order_detail.dart';
import '../../domain/entity/order/order_product.dart';
import '../../domain/entity/order/order_product_detail.dart';
import '../../domain/entity/order/order_summary.dart';
import '../../domain/entity/order/support_order_product.dart';
import '../../misc/error/message_error.dart';
import '../../misc/response_wrapper.dart';

extension OrderDetailEntityMappingExt on ResponseWrapper {
  Order mapFromResponseToOrder() {
    return Order(
      orderSummary: ResponseWrapper(response["summary"]).mapFromResponseToOrderSummary(),
      combinedOrder: ResponseWrapper(response["combined_order"]).mapFromResponseToCombinedOrder(),
    );
  }

  OrderSummary mapFromResponseToOrderSummary() {
    return OrderSummary(
      name: response["name"],
      type: response["type"],
      value: response["value"],
      coupon: response["coupon"] != null ? ResponseWrapper(response["coupon"]).mapFromResponseToCoupon() : null
    );
  }

  CombinedOrder mapFromResponseToCombinedOrder() {
    return CombinedOrder(
      id: response["id"],
      userId: response["user_id"],
      orderProductId: response["order_product_id"],
      orderShippingId: response["order_shipping_id"],
      orderCode: response["order_code"],
      couponId: response["coupon_id"],
      picId: response["pic_id"],
      picTakeoverId: response["pic_takeover_id"],
      status: response["status"],
      takeoverAt: response["takeover_at"] != null ? ResponseWrapper(response["takeover_at"]).mapFromResponseToDateTime() : null,
      review: response["review"],
      coupon: response["coupon"],
      user: ResponseWrapper(response["user"]).mapFromResponseToUser(),
      orderProduct: ResponseWrapper(response["order_product"]).mapFromResponseToOrderProduct(),
    );
  }

  OrderProduct mapFromResponseToOrderProduct() {
    return OrderProduct(
      id: response["id"],
      orderId: response["order_id"],
      userAddressId: response["user_address_id"],
      orderDetail: ResponseWrapper(response["order"]).mapFromResponseToOrderDetail(),
      userAddress: ResponseWrapper(response["user_address"]).mapFromResponseToAddress(),
      orderProductDetailList: response["order_product_list"].map<OrderProductDetail>(
        (orderProductDetailResponse) => ResponseWrapper(orderProductDetailResponse).mapFromResponseToOrderProductDetail()
      ).toList(),
      additionalItemList: ResponseWrapper(response["order_send_to_warehouse_list"]).mapFromResponseToAdditionalItemList()
    );
  }

  OrderDetail mapFromResponseToOrderDetail() {
    return OrderDetail(
      id: response["id"],
      status: response["status"],
      paymentType: response["payment_type"],
      totalPrice: response["total_price"],
      snapToken: response["snap_token"],
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

  SupportOrderProduct mapFromResponseToSupportOrderProduct() {
    dynamic productEntry = response["product_entry"];
    dynamic bundling = response["bundling"];
    if (productEntry != null) {
      return ResponseWrapper(productEntry).mapFromResponseToProductEntry();
    } else if (bundling != null) {
      return ResponseWrapper(bundling).mapFromResponseToProductBundle();
    } else {
      throw MessageError(message: "Support order product not suitable");
    }
  }
}