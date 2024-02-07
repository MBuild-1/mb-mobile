import 'package:masterbagasi/data/entitymappingext/product_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/summary_value_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../domain/entity/cart/add_to_cart_response.dart';
import '../../domain/entity/cart/cart.dart';
import '../../domain/entity/cart/cart_summary.dart';
import '../../domain/entity/cart/remove_from_cart_directly_response.dart';
import '../../domain/entity/cart/remove_from_cart_response.dart';
import '../../domain/entity/cart/support_cart.dart';
import '../../domain/entity/cart/update_cart_quantity_response.dart';
import '../../domain/entity/wishlist/wishlist.dart';
import '../../misc/error/message_error.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/response_wrapper.dart';

extension CartEntityMappingExt on ResponseWrapper {
  List<Cart> mapFromResponseToCartList(List<Wishlist> wishlistList, List<Cart> cartList) {
    return response.map<Cart>((cartResponse) => ResponseWrapper(cartResponse).mapFromResponseToCart(wishlistList, cartList)).toList();
  }

  PagingDataResult<Cart> mapFromResponseToCartPaging(List<Wishlist> wishlistList, List<Cart> cartList) {
    return ResponseWrapper(response).mapFromResponseToPagingDataResult(
      (dataResponse) => dataResponse.map<Cart>(
        (cartResponse) => ResponseWrapper(cartResponse).mapFromResponseToCart(wishlistList, cartList)
      ).toList()
    );
  }
}

extension CartDetailEntityMappingExt on ResponseWrapper {
  Cart mapFromResponseToCart(List<Wishlist> wishlistList, List<Cart> cartList) {
    return Cart(
      id: response["id"],
      quantity: response["quantity"],
      notes: response["notes"],
      supportCart: ResponseWrapper(response).mapFromResponseToSupportCart(wishlistList, cartList)
    );
  }

  SupportCart mapFromResponseToSupportCart(List<Wishlist> wishlistList, List<Cart> cartList) {
    dynamic productEntry = response["product_entry"];
    dynamic bundling = response["bundling"];
    if (productEntry != null) {
      return ResponseWrapper(productEntry).mapFromResponseToProductEntry(wishlistList, cartList);
    } else if (bundling != null) {
      return ResponseWrapper(bundling).mapFromResponseToProductBundle(wishlistList, cartList);
    } else {
      throw MessageError(message: "Support cart not suitable");
    }
  }

  AddToCartResponse mapFromResponseToAddToCartResponse() {
    return AddToCartResponse();
  }

  RemoveFromCartResponse mapFromResponseToRemoveFromCartResponse() {
    return RemoveFromCartResponse();
  }

  RemoveFromCartDirectlyResponse mapFromResponseToRemoveFromCartDirectlyResponse() {
    return RemoveFromCartDirectlyResponse();
  }

  CartSummary mapFromResponseToCartSummary() {
    return CartSummary(
      summaryValue: ResponseWrapper(response["summary"]).mapFromResponseToSummaryValueList(),
      finalSummaryValue: ResponseWrapper(response["final_summary"]).mapFromResponseToSummaryValueList(),
    );
  }

  UpdateCartQuantityResponse mapFromResponseToUpdateCartQuantityResponse() {
    return UpdateCartQuantityResponse();
  }
}