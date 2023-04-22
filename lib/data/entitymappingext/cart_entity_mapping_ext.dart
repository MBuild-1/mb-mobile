import 'package:masterbagasi/data/entitymappingext/product_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../domain/entity/cart/cart.dart';
import '../../domain/entity/cart/support_cart.dart';
import '../../misc/error/message_error.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/response_wrapper.dart';

extension CartEntityMappingExt on ResponseWrapper {
  List<Cart> mapFromResponseToCartList() {
    return response.map<Cart>((cartResponse) => ResponseWrapper(cartResponse).mapFromResponseToCart()).toList();
  }

  PagingDataResult<Cart> mapFromResponseToCartPaging() {
    return ResponseWrapper(response).mapFromResponseToPagingDataResult(
      (dataResponse) => dataResponse.map<Cart>(
        (cartResponse) => ResponseWrapper(cartResponse).mapFromResponseToCart()
      ).toList()
    );
  }
}

extension CartDetailEntityMappingExt on ResponseWrapper {
  Cart mapFromResponseToCart() {
    return Cart(
      quantity: response["quantity"],
      notes: response["notes"],
      supportCart: ResponseWrapper(response).mapFromResponseToSupportCart()
    );
  }

  SupportCart mapFromResponseToSupportCart() {
    dynamic productEntry = response["product_entry"];
    dynamic bundling = response["bundling"];
    if (productEntry != null) {
      return ResponseWrapper(productEntry).mapFromResponseToProductEntry();
    } else if (bundling != null) {
      return ResponseWrapper(productEntry).mapFromResponseToProductBundle();
    } else {
      throw MessageError(message: "Support cart not suitable");
    }
  }
}