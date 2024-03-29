import 'package:dio/dio.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/processing/future_processing.dart';

import '../domain/entity/additionalitem/add_additional_item_parameter.dart';
import '../domain/entity/additionalitem/add_additional_item_response.dart';
import '../domain/entity/additionalitem/additional_item.dart';
import '../domain/entity/additionalitem/additional_item_list_parameter.dart';
import '../domain/entity/additionalitem/change_additional_item.dart';
import '../domain/entity/additionalitem/change_additional_item_parameter.dart';
import '../domain/entity/additionalitem/change_additional_item_response.dart';
import '../domain/entity/additionalitem/remove_additional_item_parameter.dart';
import '../domain/entity/additionalitem/remove_additional_item_response.dart';
import '../domain/entity/cart/cart.dart';
import '../domain/entity/cart/cart_list_parameter.dart';
import '../domain/entity/cart/cart_summary.dart';
import '../domain/entity/cart/cart_summary_parameter.dart';
import '../domain/entity/cart/remove_from_cart_parameter.dart';
import '../domain/entity/cart/remove_from_cart_response.dart';
import '../domain/entity/cart/update_cart_quantity_parameter.dart';
import '../domain/entity/cart/update_cart_quantity_response.dart';
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
import '../domain/usecase/remove_additional_item_use_case.dart';
import '../domain/usecase/remove_from_cart_use_case.dart';
import '../domain/usecase/update_cart_quantity_use_case.dart';
import '../misc/constant.dart';
import '../misc/controllercontentdelegate/shared_cart_controller_content_delegate.dart';
import '../misc/error/message_error.dart';
import '../misc/error/warehouse_empty_error.dart';
import '../misc/load_data_result.dart';
import '../misc/multi_language_string.dart';
import '../misc/typedef.dart';
import 'base_getx_controller.dart';

typedef _OnCartBack = void Function();
typedef _OnShowAddToWishlistRequestProcessLoadingCallback = Future<void> Function();
typedef _OnAddToWishlistRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowAddToWishlistRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowRemoveCartRequestProcessLoadingCallback = Future<void> Function();
typedef _OnRemoveCartRequestProcessSuccessCallback = Future<void> Function(Cart cart);
typedef _OnShowRemoveCartRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowUpdateCartQuantityRequestProcessLoadingCallback = Future<bool> Function();
typedef _OnUpdateCartQuantityRequestProcessSuccessCallback = Future<void> Function(UpdateCartQuantityResponse, Cart);
typedef _OnShowUpdateCartQuantityRequestProcessFailedCallback = Future<void> Function(dynamic e, Cart);
typedef _OnShowRemoveWarehouseRequestProcessLoadingCallback = Future<void> Function();
typedef _OnRemoveWarehouseRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowRemoveWarehouseRequestProcessFailedCallback = Future<void> Function(dynamic e);

class CartController extends BaseGetxController {
  final GetCartListUseCase getCartListUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final GetCartSummaryUseCase getCartSummaryUseCase;
  final GetAdditionalItemUseCase getAdditionalItemUseCase;
  final AddAdditionalItemUseCase addAdditionalItemUseCase;
  final ChangeAdditionalItemUseCase changeAdditionalItemUseCase;
  final RemoveAdditionalItemUseCase removeAdditionalItemUseCase;
  final AddWishlistUseCase addWishlistUseCase;
  final UpdateCartQuantityUseCase updateCartQuantityUseCase;

  CartDelegate? _cartDelegate;
  final SharedCartControllerContentDelegate sharedCartControllerContentDelegate;

  CartController(
    super.controllerManager,
    this.getCartListUseCase,
    this.addToCartUseCase,
    this.removeFromCartUseCase,
    this.getCartSummaryUseCase,
    this.getAdditionalItemUseCase,
    this.addAdditionalItemUseCase,
    this.changeAdditionalItemUseCase,
    this.removeAdditionalItemUseCase,
    this.addWishlistUseCase,
    this.updateCartQuantityUseCase,
    this.sharedCartControllerContentDelegate,
  ) {
    sharedCartControllerContentDelegate.setApiRequestManager(
      () => apiRequestManager
    );
  }

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
    ).map(
      (value) {
        if (value.isEmpty) {
          throw WarehouseEmptyError();
        }
        return value;
      }
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

  CartController setCartDelegate(CartDelegate cartDelegate) {
    _cartDelegate = cartDelegate;
    return this;
  }

  void addToWishlist(SupportWishlist supportWishlist) async {
    if (_cartDelegate != null) {
      _cartDelegate!.onUnfocusAllWidget();
      _cartDelegate!.onShowAddToWishlistRequestProcessLoadingCallback();
      LoadDataResult<AddWishlistResponse> addWishlistResponseLoadDataResult = await addWishlistUseCase.execute(
        AddWishlistParameter(supportWishlist: supportWishlist)
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('add-to-wishlist').value
      );
      _cartDelegate!.onCartBack();
      if (addWishlistResponseLoadDataResult.isSuccess) {
        _cartDelegate!.onAddToWishlistRequestProcessSuccessCallback();
      } else {
        _cartDelegate!.onShowAddToWishlistRequestProcessFailedCallback(addWishlistResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  void removeCart(Cart cart) async {
    if (_cartDelegate != null) {
      _cartDelegate!.onUnfocusAllWidget();
      _cartDelegate!.onShowRemoveCartRequestProcessLoadingCallback();
      LoadDataResult<RemoveFromCartResponse> removeFromCartResponseLoadDataResult = await removeFromCartUseCase.execute(
        RemoveFromCartParameter(cart: cart)
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('remove-from-cart').value
      );
      _cartDelegate!.onCartBack();
      if (removeFromCartResponseLoadDataResult.isSuccess) {
        _cartDelegate!.onRemoveCartRequestProcessSuccessCallback(cart);
      } else {
        _cartDelegate!.onShowRemoveCartRequestProcessFailedCallback(removeFromCartResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  void updateCartQuantity(UpdateCartQuantityParameter updateCartQuantityParameter, Cart cart, void Function(CancelToken) onGetUpdateCartQuantityCancelToken) async {
    if (_cartDelegate != null) {
      _cartDelegate!.onUnfocusAllWidget();
      bool supportBack = await _cartDelegate!.onShowUpdateCartQuantityRequestProcessLoadingCallback();
      CancelToken updateCartQuantityCancelToken = apiRequestManager.addRequestToCancellationPart('update-cart-quantity.${updateCartQuantityParameter.cartId}').value;
      onGetUpdateCartQuantityCancelToken(updateCartQuantityCancelToken);
      LoadDataResult<UpdateCartQuantityResponse> updateCartQuantityResponseLoadDataResult = await updateCartQuantityUseCase.execute(
        updateCartQuantityParameter
      ).future(
        parameter: updateCartQuantityCancelToken
      );
      if (supportBack) {
        _cartDelegate!.onCartBack();
      }
      if (updateCartQuantityResponseLoadDataResult.isFailedBecauseCancellation) {
        return;
      }
      if (updateCartQuantityResponseLoadDataResult.isSuccess) {
        _cartDelegate!.onUpdateCartQuantityRequestProcessSuccessCallback(updateCartQuantityResponseLoadDataResult.resultIfSuccess!, cart);
      } else {
        _cartDelegate!.onShowUpdateCartQuantityRequestProcessFailedCallback(updateCartQuantityResponseLoadDataResult.resultIfFailed, cart);
      }
    }
  }

  void removeWarehouseAdditionalItem(AdditionalItem additionalItem) async {
    if (_cartDelegate != null) {
      _cartDelegate!.onUnfocusAllWidget();
      _cartDelegate!.onShowRemoveCartRequestProcessLoadingCallback();
      LoadDataResult<RemoveAdditionalItemResponse> removeAdditionalItemResponseLoadDataResult = await removeAdditionalItem(
        RemoveAdditionalItemParameter(
          additionalItemId: additionalItem.id
        )
      );
      _cartDelegate!.onCartBack();
      if (removeAdditionalItemResponseLoadDataResult.isFailedBecauseCancellation) {
        return;
      }
      if (removeAdditionalItemResponseLoadDataResult.isSuccess) {
        _cartDelegate!.onRemoveWarehouseRequestProcessSuccessCallback();
      } else {
        _cartDelegate!.onShowRemoveWarehouseRequestProcessFailedCallback(removeAdditionalItemResponseLoadDataResult.resultIfFailed);
      }
    }
  }
}

class CartDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnCartBack onCartBack;
  _OnShowAddToWishlistRequestProcessLoadingCallback onShowAddToWishlistRequestProcessLoadingCallback;
  _OnAddToWishlistRequestProcessSuccessCallback onAddToWishlistRequestProcessSuccessCallback;
  _OnShowAddToWishlistRequestProcessFailedCallback onShowAddToWishlistRequestProcessFailedCallback;
  _OnShowRemoveCartRequestProcessLoadingCallback onShowRemoveCartRequestProcessLoadingCallback;
  _OnRemoveCartRequestProcessSuccessCallback onRemoveCartRequestProcessSuccessCallback;
  _OnShowRemoveCartRequestProcessFailedCallback onShowRemoveCartRequestProcessFailedCallback;
  _OnShowUpdateCartQuantityRequestProcessLoadingCallback onShowUpdateCartQuantityRequestProcessLoadingCallback;
  _OnUpdateCartQuantityRequestProcessSuccessCallback onUpdateCartQuantityRequestProcessSuccessCallback;
  _OnShowUpdateCartQuantityRequestProcessFailedCallback onShowUpdateCartQuantityRequestProcessFailedCallback;
  _OnShowRemoveWarehouseRequestProcessLoadingCallback onShowRemoveWarehouseRequestProcessLoadingCallback;
  _OnRemoveWarehouseRequestProcessSuccessCallback onRemoveWarehouseRequestProcessSuccessCallback;
  _OnShowRemoveWarehouseRequestProcessFailedCallback onShowRemoveWarehouseRequestProcessFailedCallback;

  CartDelegate({
    required this.onUnfocusAllWidget,
    required this.onCartBack,
    required this.onShowAddToWishlistRequestProcessLoadingCallback,
    required this.onAddToWishlistRequestProcessSuccessCallback,
    required this.onShowAddToWishlistRequestProcessFailedCallback,
    required this.onShowRemoveCartRequestProcessLoadingCallback,
    required this.onRemoveCartRequestProcessSuccessCallback,
    required this.onShowRemoveCartRequestProcessFailedCallback,
    required this.onShowUpdateCartQuantityRequestProcessLoadingCallback,
    required this.onUpdateCartQuantityRequestProcessSuccessCallback,
    required this.onShowUpdateCartQuantityRequestProcessFailedCallback,
    required this.onShowRemoveWarehouseRequestProcessLoadingCallback,
    required this.onRemoveWarehouseRequestProcessSuccessCallback,
    required this.onShowRemoveWarehouseRequestProcessFailedCallback
  });
}