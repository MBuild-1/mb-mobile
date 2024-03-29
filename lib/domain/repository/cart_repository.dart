import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/additionalitem/add_additional_item_parameter.dart';
import '../entity/additionalitem/add_additional_item_response.dart';
import '../entity/additionalitem/additional_item.dart';
import '../entity/additionalitem/additional_item_list_parameter.dart';
import '../entity/additionalitem/change_additional_item_parameter.dart';
import '../entity/additionalitem/change_additional_item_response.dart';
import '../entity/additionalitem/remove_additional_item_parameter.dart';
import '../entity/additionalitem/remove_additional_item_response.dart';
import '../entity/cart/add_host_cart_parameter.dart';
import '../entity/cart/add_host_cart_response.dart';
import '../entity/cart/add_to_cart_parameter.dart';
import '../entity/cart/add_to_cart_response.dart';
import '../entity/cart/cart.dart';
import '../entity/cart/cart_list_parameter.dart';
import '../entity/cart/cart_paging_parameter.dart';
import '../entity/cart/cart_summary.dart';
import '../entity/cart/cart_summary_parameter.dart';
import '../entity/cart/remove_from_cart_directly_parameter.dart';
import '../entity/cart/remove_from_cart_directly_response.dart';
import '../entity/cart/remove_from_cart_parameter.dart';
import '../entity/cart/remove_from_cart_response.dart';
import '../entity/cart/shared_cart_paging_parameter.dart';
import '../entity/cart/take_friend_cart_parameter.dart';
import '../entity/cart/take_friend_cart_response.dart';
import '../entity/cart/update_cart_quantity_parameter.dart';
import '../entity/cart/update_cart_quantity_response.dart';

abstract class CartRepository {
  FutureProcessing<LoadDataResult<PagingDataResult<Cart>>> cartPaging(CartPagingParameter cartPagingParameter);
  FutureProcessing<LoadDataResult<List<Cart>>> cartList(CartListParameter cartListParameter);
  FutureProcessing<LoadDataResult<List<Cart>>> cartListIgnoringLoginError(CartListParameter cartListParameter);
  FutureProcessing<LoadDataResult<PagingDataResult<Cart>>> sharedCartPaging(SharedCartPagingParameter sharedCartPagingParameter);
  FutureProcessing<LoadDataResult<AddToCartResponse>> addToCart(AddToCartParameter addToCartParameter);
  FutureProcessing<LoadDataResult<RemoveFromCartResponse>> removeFromCart(RemoveFromCartParameter removeFromCartParameter);
  FutureProcessing<LoadDataResult<RemoveFromCartDirectlyResponse>> removeFromCartDirectly(RemoveFromCartDirectlyParameter removeFromCartDirectlyParameter);
  FutureProcessing<LoadDataResult<AddHostCartResponse>> addHostCart(AddHostCartParameter addHostCartParameter);
  FutureProcessing<LoadDataResult<TakeFriendCartResponse>> takeFriendCart(TakeFriendCartParameter takeFriendCartParameter);
  FutureProcessing<LoadDataResult<CartSummary>> cartSummary(CartSummaryParameter cartSummaryParameter);
  FutureProcessing<LoadDataResult<List<AdditionalItem>>> additionalItemList(AdditionalItemListParameter additionalItemListParameter);
  FutureProcessing<LoadDataResult<AddAdditionalItemResponse>> addAdditionalItem(AddAdditionalItemParameter addAdditionalItemParameter);
  FutureProcessing<LoadDataResult<ChangeAdditionalItemResponse>> changeAdditionalItem(ChangeAdditionalItemParameter changeAdditionalItemParameter);
  FutureProcessing<LoadDataResult<RemoveAdditionalItemResponse>> removeAdditionalItem(RemoveAdditionalItemParameter removeAdditionalItemParameter);
  FutureProcessing<LoadDataResult<UpdateCartQuantityResponse>> updateCartQuantity(UpdateCartQuantityParameter updateCartQuantityParameter);
}