import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../domain/entity/additionalitem/add_additional_item_parameter.dart';
import '../domain/entity/additionalitem/add_additional_item_response.dart';
import '../domain/entity/additionalitem/additional_item.dart';
import '../domain/entity/additionalitem/additional_item_list_parameter.dart';
import '../domain/entity/additionalitem/change_additional_item_parameter.dart';
import '../domain/entity/additionalitem/change_additional_item_response.dart';
import '../domain/entity/additionalitem/remove_additional_item_parameter.dart';
import '../domain/entity/additionalitem/remove_additional_item_response.dart';
import '../domain/entity/cart/cart.dart';
import '../domain/entity/cart/cart_list_parameter.dart';
import '../domain/entity/cart/cart_paging_parameter.dart';
import '../domain/entity/cart/cart_summary.dart';
import '../domain/entity/cart/cart_summary_parameter.dart';
import '../domain/entity/cart/remove_from_cart_parameter.dart';
import '../domain/entity/cart/remove_from_cart_response.dart';
import '../domain/entity/wishlist/add_wishlist_parameter.dart';
import '../domain/entity/wishlist/add_wishlist_response.dart';
import '../domain/entity/wishlist/support_wishlist.dart';
import '../domain/usecase/add_additional_item_use_case.dart';
import '../domain/usecase/add_to_cart_use_case.dart';
import '../domain/usecase/add_wishlist_use_case.dart';
import '../domain/usecase/change_additional_item_use_case.dart';
import '../domain/usecase/get_additional_item_use_case.dart';
import '../domain/usecase/get_cart_list_use_case.dart';
import '../domain/usecase/get_cart_summary_use_case.dart';
import '../domain/usecase/get_my_cart_use_case.dart';
import '../domain/usecase/remove_additional_item_use_case.dart';
import '../domain/usecase/remove_from_cart_use_case.dart';
import '../misc/load_data_result.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import '../misc/typedef.dart';
import 'base_getx_controller.dart';

typedef _OnCartBack = void Function();
typedef _OnShowAddToWishlistRequestProcessLoadingCallback = Future<void> Function();
typedef _OnAddToWishlistRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowAddToWishlistRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowRemoveCartRequestProcessLoadingCallback = Future<void> Function();
typedef _OnRemoveCartRequestProcessSuccessCallback = Future<void> Function(Cart cart);
typedef _OnShowRemoveCartRequestProcessFailedCallback = Future<void> Function(dynamic e);

class TakeFriendCartController extends BaseGetxController {
  final GetCartListUseCase getCartListUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final GetCartSummaryUseCase getCartSummaryUseCase;
  final GetAdditionalItemUseCase getAdditionalItemUseCase;
  final AddAdditionalItemUseCase addAdditionalItemUseCase;
  final ChangeAdditionalItemUseCase changeAdditionalItemUseCase;
  final RemoveAdditionalItemUseCase removeAdditionalItemUseCase;
  final AddWishlistUseCase addWishlistUseCase;

  TakeFriendCartDelegate? _takeFriendCartDelegate;

  TakeFriendCartController(
    super.controllerManager,
    this.getCartListUseCase,
    this.addToCartUseCase,
    this.removeFromCartUseCase,
    this.getCartSummaryUseCase,
    this.getAdditionalItemUseCase,
    this.addAdditionalItemUseCase,
    this.changeAdditionalItemUseCase,
    this.removeAdditionalItemUseCase,
    this.addWishlistUseCase
  );

  Future<LoadDataResult<List<Cart>>> getCartList(CartListParameter cartListParameter) {
    return getCartListUseCase.execute(cartListParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("cart").value
    );
  }

  Future<LoadDataResult<CartSummary>> getCartSummary(CartSummaryParameter cartSummaryParameter) {
    return getCartSummaryUseCase.execute(cartSummaryParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("cart-summary").value
    );
  }

  Future<LoadDataResult<List<AdditionalItem>>> getAdditionalItem(AdditionalItemListParameter additionalItemListParameter) {
    return getAdditionalItemUseCase.execute(additionalItemListParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("get-additional-item").value
    );
  }

  Future<LoadDataResult<AddAdditionalItemResponse>> addAdditionalItem(AddAdditionalItemParameter addAdditionalItemParameter) {
    return addAdditionalItemUseCase.execute(addAdditionalItemParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("add-additional-item").value
    );
  }

  Future<LoadDataResult<ChangeAdditionalItemResponse>> changeAdditionalItem(ChangeAdditionalItemParameter changeAdditionalItemParameter) {
    return changeAdditionalItemUseCase.execute(changeAdditionalItemParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("change-additional-item").value
    );
  }

  Future<LoadDataResult<RemoveAdditionalItemResponse>> removeAdditionalItem(RemoveAdditionalItemParameter removeAdditionalItemParameter) {
    return removeAdditionalItemUseCase.execute(removeAdditionalItemParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("remove-additional-item").value
    );
  }

  Future<LoadDataResult<RemoveFromCartResponse>> removeFromCart(Cart cart) {
    return removeFromCartUseCase.execute(RemoveFromCartParameter(cart: cart)).future(
      parameter: apiRequestManager.addRequestToCancellationPart("remove-to-cart").value
    );
  }

  TakeFriendCartController setTakeFriendCartDelegate(TakeFriendCartDelegate takeFriendCartDelegate) {
    _takeFriendCartDelegate = takeFriendCartDelegate;
    return this;
  }

  void addToWishlist(SupportWishlist supportWishlist) async {
    if (_takeFriendCartDelegate != null) {
      _takeFriendCartDelegate!.onUnfocusAllWidget();
      _takeFriendCartDelegate!.onShowAddToWishlistRequestProcessLoadingCallback();
      LoadDataResult<AddWishlistResponse> addWishlistResponseLoadDataResult = await addWishlistUseCase.execute(
        AddWishlistParameter(supportWishlist: supportWishlist)
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('add-to-wishlist').value
      );
      _takeFriendCartDelegate!.onCartBack();
      if (addWishlistResponseLoadDataResult.isSuccess) {
        _takeFriendCartDelegate!.onAddToWishlistRequestProcessSuccessCallback();
      } else {
        _takeFriendCartDelegate!.onShowAddToWishlistRequestProcessFailedCallback(addWishlistResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  void removeCart(Cart cart) async {
    if (_takeFriendCartDelegate != null) {
      _takeFriendCartDelegate!.onUnfocusAllWidget();
      _takeFriendCartDelegate!.onShowRemoveCartRequestProcessLoadingCallback();
      LoadDataResult<RemoveFromCartResponse> removeFromCartResponseLoadDataResult = await removeFromCartUseCase.execute(
        RemoveFromCartParameter(cart: cart)
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('remove-from-cart').value
      );
      _takeFriendCartDelegate!.onCartBack();
      if (removeFromCartResponseLoadDataResult.isSuccess) {
        _takeFriendCartDelegate!.onRemoveCartRequestProcessSuccessCallback(cart);
      } else {
        _takeFriendCartDelegate!.onShowRemoveCartRequestProcessFailedCallback(removeFromCartResponseLoadDataResult.resultIfFailed);
      }
    }
  }
}

class TakeFriendCartDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnCartBack onCartBack;
  _OnShowAddToWishlistRequestProcessLoadingCallback onShowAddToWishlistRequestProcessLoadingCallback;
  _OnAddToWishlistRequestProcessSuccessCallback onAddToWishlistRequestProcessSuccessCallback;
  _OnShowAddToWishlistRequestProcessFailedCallback onShowAddToWishlistRequestProcessFailedCallback;
  _OnShowRemoveCartRequestProcessLoadingCallback onShowRemoveCartRequestProcessLoadingCallback;
  _OnRemoveCartRequestProcessSuccessCallback onRemoveCartRequestProcessSuccessCallback;
  _OnShowRemoveCartRequestProcessFailedCallback onShowRemoveCartRequestProcessFailedCallback;

  TakeFriendCartDelegate({
    required this.onUnfocusAllWidget,
    required this.onCartBack,
    required this.onShowAddToWishlistRequestProcessLoadingCallback,
    required this.onAddToWishlistRequestProcessSuccessCallback,
    required this.onShowAddToWishlistRequestProcessFailedCallback,
    required this.onShowRemoveCartRequestProcessLoadingCallback,
    required this.onRemoveCartRequestProcessSuccessCallback,
    required this.onShowRemoveCartRequestProcessFailedCallback
  });
}