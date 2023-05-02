import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/order_entity_mapping_ext.dart';
import 'package:masterbagasi/domain/entity/product/product_appearance_data.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../domain/entity/additionalitem/additional_item.dart';
import '../../../domain/entity/cart/cart.dart';
import '../../../domain/entity/cart/support_cart.dart';
import '../../../domain/entity/order/create_order_parameter.dart';
import '../../../domain/entity/order/order.dart';
import '../../../domain/entity/product/productbundle/product_bundle.dart';
import '../../../misc/option_builder.dart';
import '../../../misc/processing/dio_http_client_processing.dart';
import '../../../misc/processing/future_processing.dart';
import 'order_data_source.dart';

class DefaultOrderDataSource implements OrderDataSource {
  final Dio dio;

  const DefaultOrderDataSource({
    required this.dio
  });

  @override
  FutureProcessing<Order> createOrder(CreateOrderParameter createOrderParameter) {
    return DioHttpClientProcessing((cancelToken) {
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
            "product_entry_id": productEntryId,
            "bundling_id": bundlingId,
            "quantity": cart.quantity,
            if (cart.notes.isNotEmptyString) "notes": cart.notes
          };
        }
      ).toList();
      List<dynamic> sendToWarehouseList = additionalItemList.map(
        (additionalItem) => {
          "name" : additionalItem.name,
          "price": additionalItem.estimationPrice,
          "weight": additionalItem.estimationWeight,
          "quantity": additionalItem.quantity
        }
      ).toList();
      dynamic data = {
        if (createOrderParameter.coupon != null) "coupon_id": createOrderParameter.coupon!.id,
        "order_list": orderList,
        "order_send_to_warehouse_list": sendToWarehouseList
      };
      return dio.post("user/order", data: data, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<Order>(onMap: (value) => value.wrapResponse().mapFromResponseToOrder());
    });
  }
}