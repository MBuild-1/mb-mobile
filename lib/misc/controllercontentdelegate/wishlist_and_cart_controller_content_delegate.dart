import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:provider/provider.dart';

import '../../domain/entity/cart/add_to_cart_parameter.dart';
import '../../domain/entity/cart/add_to_cart_response.dart';
import '../../domain/entity/cart/cart.dart';
import '../../domain/entity/cart/cart_list_parameter.dart';
import '../../domain/entity/cart/remove_from_cart_directly_parameter.dart';
import '../../domain/entity/cart/remove_from_cart_directly_response.dart';
import '../../domain/entity/cart/support_cart.dart';
import '../../domain/entity/product/productbundle/product_bundle.dart';
import '../../domain/entity/product/productentry/product_entry.dart';
import '../../domain/entity/wishlist/add_wishlist_parameter.dart';
import '../../domain/entity/wishlist/add_wishlist_response.dart';
import '../../domain/entity/wishlist/remove_wishlist_based_product_parameter.dart';
import '../../domain/entity/wishlist/remove_wishlist_parameter.dart';
import '../../domain/entity/wishlist/remove_wishlist_response.dart';
import '../../domain/entity/wishlist/support_wishlist.dart';
import '../../domain/entity/wishlist/wishlist.dart';
import '../../domain/usecase/add_to_cart_use_case.dart';
import '../../domain/usecase/add_wishlist_use_case.dart';
import '../../domain/usecase/get_cart_list_ignoring_login_error_use_case.dart';
import '../../domain/usecase/remove_from_cart_directly_use_case.dart';
import '../../domain/usecase/remove_from_cart_use_case.dart';
import '../../domain/usecase/remove_wishlist_based_product_use_case.dart';
import '../../domain/usecase/remove_wishlist_use_case.dart';
import '../../presentation/notifier/component_notifier.dart';
import '../../presentation/notifier/notification_notifier.dart';
import '../../presentation/notifier/product_notifier.dart';
import '../dialog_helper.dart';
import '../errorprovider/error_provider.dart';
import '../load_data_result.dart';
import '../main_route_observer.dart';
import '../manager/api_request_manager.dart';
import '../toast_helper.dart';
import '../typedef.dart';
import 'controller_content_delegate.dart';

class WishlistAndCartControllerContentDelegate extends ControllerContentDelegate {
  final GetCartListIgnoringLoginErrorUseCase getCartListIgnoringLoginErrorUseCase;
  final AddWishlistUseCase addWishlistUseCase;
  final RemoveWishlistUseCase removeWishlistUseCase;
  final RemoveWishlistBasedProductUseCase removeWishlistBasedProductUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final RemoveFromCartDirectlyUseCase removeFromCartDirectlyUseCase;

  WishlistAndCartDelegate? _wishlistAndCartDelegate;
  ApiRequestManager Function()? _onGetApiRequestManager;

  WishlistAndCartControllerContentDelegate({
    required this.getCartListIgnoringLoginErrorUseCase,
    required this.addWishlistUseCase,
    required this.removeWishlistUseCase,
    required this.removeWishlistBasedProductUseCase,
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.removeFromCartDirectlyUseCase
  });

  void addToWishlist(SupportWishlist supportWishlist, Future<bool> Function() onCheckingLogin) async {
    if ((await onCheckingLogin())) {
      if (_wishlistAndCartDelegate != null && _onGetApiRequestManager != null) {
        ApiRequestManager apiRequestManager = _onGetApiRequestManager!();
        _wishlistAndCartDelegate!.onUnfocusAllWidget();
        _wishlistAndCartDelegate!.onShowAddToWishlistRequestProcessLoadingCallback();
        LoadDataResult<AddWishlistResponse> addWishlistResponseLoadDataResult = await addWishlistUseCase.execute(
          AddWishlistParameter(supportWishlist: supportWishlist)
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('add-to-wishlist').value
        );
        if (addWishlistResponseLoadDataResult.isSuccess) {
          supportWishlist.hasAddedToWishlist = true;
          _wishlistAndCartDelegate!.onAddToWishlistRequestProcessSuccessCallback();
        } else {
          LoadDataResult<RemoveWishlistResponse> removeWishlistResponseLoadDataResult = await removeWishlistBasedProductUseCase.execute(
            RemoveWishlistBasedProductParameter(productEntryOrProductBundleId: supportWishlist.supportWishlistContentId)
          ).future(
            parameter: apiRequestManager.addRequestToCancellationPart('remove-from-wishlist').value
          );
          if (removeWishlistResponseLoadDataResult.isSuccess) {
            supportWishlist.hasAddedToWishlist = false;
            _wishlistAndCartDelegate!.onRemoveFromWishlistRequestProcessSuccessCallback(
              Wishlist(
                id: "",
                supportWishlist: supportWishlist
              )
            );
          } else {
            _wishlistAndCartDelegate!.onShowRemoveFromWishlistRequestProcessFailedCallback(removeWishlistResponseLoadDataResult.resultIfFailed);
          }
        }
        _wishlistAndCartDelegate!.onBack();
      }
    }
  }

  void removeFromWishlist(SupportWishlist supportWishlist, Future<bool> Function() onCheckingLogin) async {
    if ((await onCheckingLogin())) {
      if (_wishlistAndCartDelegate != null && _onGetApiRequestManager != null) {
        ApiRequestManager apiRequestManager = _onGetApiRequestManager!();
        _wishlistAndCartDelegate!.onUnfocusAllWidget();
        _wishlistAndCartDelegate!.onShowRemoveFromWishlistRequestProcessLoadingCallback();
        LoadDataResult<RemoveWishlistResponse> removeWishlistResponseLoadDataResult = await removeWishlistBasedProductUseCase.execute(
          RemoveWishlistBasedProductParameter(productEntryOrProductBundleId: supportWishlist.supportWishlistContentId)
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('remove-from-wishlist').value
        );
        _wishlistAndCartDelegate!.onBack();
        if (removeWishlistResponseLoadDataResult.isSuccess) {
          supportWishlist.hasAddedToWishlist = false;
          _wishlistAndCartDelegate!.onRemoveFromWishlistRequestProcessSuccessCallback(
            Wishlist(
              id: "",
              supportWishlist: supportWishlist
            )
          );
        } else {
          _wishlistAndCartDelegate!.onShowRemoveFromWishlistRequestProcessFailedCallback(removeWishlistResponseLoadDataResult.resultIfFailed);
        }
      }
    }
  }

  void removeFromWishlistDirectly(Wishlist wishlist, Future<bool> Function() onCheckingLogin) async {
    if ((await onCheckingLogin())) {
      if (_wishlistAndCartDelegate != null && _onGetApiRequestManager != null) {
        ApiRequestManager apiRequestManager = _onGetApiRequestManager!();
        _wishlistAndCartDelegate!.onUnfocusAllWidget();
        _wishlistAndCartDelegate!.onShowRemoveFromWishlistRequestProcessLoadingCallback();
        LoadDataResult<RemoveWishlistResponse> removeWishlistResponseLoadDataResult = await removeWishlistUseCase.execute(
          RemoveWishlistParameter(wishlistId: wishlist.id)
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('remove-from-wishlist-directly').value
        );
        _wishlistAndCartDelegate!.onBack();
        if (removeWishlistResponseLoadDataResult.isSuccess) {
          _wishlistAndCartDelegate!.onRemoveFromWishlistRequestProcessSuccessCallback(wishlist);
        } else {
          _wishlistAndCartDelegate!.onShowRemoveFromWishlistRequestProcessFailedCallback(removeWishlistResponseLoadDataResult.resultIfFailed);
        }
      }
    }
  }

  void addToCart(SupportCart supportCart, Future<bool> Function() onCheckingLogin, {bool canAddMultiple = false}) async {
    if ((await onCheckingLogin())) {
      if (_wishlistAndCartDelegate != null && _onGetApiRequestManager != null) {
        ApiRequestManager apiRequestManager = _onGetApiRequestManager!();
        _wishlistAndCartDelegate!.onUnfocusAllWidget();
        _wishlistAndCartDelegate!.onShowAddCartRequestProcessLoadingCallback();
        void removeFromCartLocalMethod() async {
          LoadDataResult<RemoveFromCartDirectlyResponse> removeFromCartDirectlyResponseLoadDataResult = await removeFromCartDirectlyUseCase.execute(
            RemoveFromCartDirectlyParameter(supportCart: supportCart)
          ).future(
            parameter: apiRequestManager.addRequestToCancellationPart('remove-from-cart').value
          );
          _wishlistAndCartDelegate!.onBack();
          if (removeFromCartDirectlyResponseLoadDataResult.isSuccess) {
            supportCart.hasAddedToCart = false;
            _wishlistAndCartDelegate!.onRemoveCartRequestProcessSuccessCallback();
          } else {
            _wishlistAndCartDelegate!.onShowRemoveCartRequestProcessFailedCallback(removeFromCartDirectlyResponseLoadDataResult.resultIfFailed);
          }
        }
        void addToCartLocalMethod() async {
          LoadDataResult<AddToCartResponse> addToCartResponseLoadDataResult = await addToCartUseCase.execute(
            AddToCartParameter(supportCart: supportCart, quantity: 1)
          ).future(
            parameter: apiRequestManager.addRequestToCancellationPart('add-to-cart').value
          );
          _wishlistAndCartDelegate!.onBack();
          if (addToCartResponseLoadDataResult.isSuccess) {
            supportCart.hasAddedToCart = true;
            _wishlistAndCartDelegate!.onAddCartRequestProcessSuccessCallback();
          } else {
            _wishlistAndCartDelegate!.onShowAddCartRequestProcessFailedCallback(addToCartResponseLoadDataResult.resultIfFailed);
          }
        }
        if (!canAddMultiple) {
          LoadDataResult<List<Cart>> cartListLoadDataResult = await getCartListIgnoringLoginErrorUseCase.execute(
            CartListParameter()
          ).future(
            parameter: apiRequestManager.addRequestToCancellationPart('add-to-cart').value
          );
          if (cartListLoadDataResult.isSuccess) {
            List<Cart> cartList = cartListLoadDataResult.resultIfSuccess!;
            Iterable<Cart> filteredCartIterated = cartList.where((cart) {
              SupportCart iteratedSupportCart = cart.supportCart;
              if (iteratedSupportCart is ProductEntry && supportCart is ProductEntry) {
                return iteratedSupportCart.id == supportCart.id;
              } else if (iteratedSupportCart is ProductBundle && supportCart is ProductBundle) {
                return iteratedSupportCart.id == supportCart.id;
              }
              return false;
            });
            if (filteredCartIterated.isNotEmpty) {
              removeFromCartLocalMethod();
            } else {
              addToCartLocalMethod();
            }
          } else {
            _wishlistAndCartDelegate!.onShowAddCartRequestProcessFailedCallback(cartListLoadDataResult.resultIfFailed);
          }
          return;
        }
        addToCartLocalMethod();
      }
    }
  }

  void removeFromCart(SupportCart supportCart, Future<bool> Function() onCheckingLogin) async {
    if ((await onCheckingLogin())) {
      if (_wishlistAndCartDelegate != null && _onGetApiRequestManager != null) {
        ApiRequestManager apiRequestManager = _onGetApiRequestManager!();
        _wishlistAndCartDelegate!.onUnfocusAllWidget();
        _wishlistAndCartDelegate!.onShowRemoveCartRequestProcessLoadingCallback();
        LoadDataResult<RemoveFromCartDirectlyResponse> removeFromCartDirectlyResponseLoadDataResult = await removeFromCartDirectlyUseCase.execute(
          RemoveFromCartDirectlyParameter(supportCart: supportCart)
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('remove-from-cart').value
        );
        _wishlistAndCartDelegate!.onBack();
        if (removeFromCartDirectlyResponseLoadDataResult.isSuccess) {
          supportCart.hasAddedToCart = false;
          _wishlistAndCartDelegate!.onRemoveCartRequestProcessSuccessCallback();
        } else {
          LoadDataResult<AddToCartResponse> addToCartResponseLoadDataResult = await addToCartUseCase.execute(
            AddToCartParameter(supportCart: supportCart, quantity: 1)
          ).future(
            parameter: apiRequestManager.addRequestToCancellationPart('add-to-cart').value
          );
          if (addToCartResponseLoadDataResult.isSuccess) {
            supportCart.hasAddedToCart = true;
            _wishlistAndCartDelegate!.onAddCartRequestProcessSuccessCallback();
          } else {
            _wishlistAndCartDelegate!.onShowAddCartRequestProcessFailedCallback(addToCartResponseLoadDataResult.resultIfFailed);
          }
        }
      }
    }
  }

  WishlistAndCartControllerContentDelegate setWishlistAndCartDelegate(WishlistAndCartDelegate wishlistAndCartDelegate) {
    _wishlistAndCartDelegate = wishlistAndCartDelegate;
    return this;
  }

  WishlistAndCartControllerContentDelegate setApiRequestManager(ApiRequestManager Function() onGetApiRequestManager) {
    _onGetApiRequestManager = onGetApiRequestManager;
    return this;
  }
}

class WishlistAndCartDelegate {
  OnBack onBack;
  OnUnfocusAllWidget onUnfocusAllWidget;
  OnShowAddToWishlistRequestProcessLoadingCallback onShowAddToWishlistRequestProcessLoadingCallback;
  OnAddToWishlistRequestProcessSuccessCallback onAddToWishlistRequestProcessSuccessCallback;
  OnShowAddToWishlistRequestProcessFailedCallback onShowAddToWishlistRequestProcessFailedCallback;
  OnShowRemoveFromWishlistRequestProcessLoadingCallback onShowRemoveFromWishlistRequestProcessLoadingCallback;
  OnRemoveFromWishlistRequestProcessSuccessCallback onRemoveFromWishlistRequestProcessSuccessCallback;
  OnShowRemoveFromWishlistRequestProcessFailedCallback onShowRemoveFromWishlistRequestProcessFailedCallback;
  OnShowAddCartRequestProcessLoadingCallback onShowAddCartRequestProcessLoadingCallback;
  OnAddCartRequestProcessSuccessCallback onAddCartRequestProcessSuccessCallback;
  OnShowAddCartRequestProcessFailedCallback onShowAddCartRequestProcessFailedCallback;
  OnShowRemoveCartRequestProcessLoadingCallback onShowRemoveCartRequestProcessLoadingCallback;
  OnRemoveCartRequestProcessSuccessCallback onRemoveCartRequestProcessSuccessCallback;
  OnShowRemoveCartRequestProcessFailedCallback onShowRemoveCartRequestProcessFailedCallback;

  WishlistAndCartDelegate({
    required this.onBack,
    required this.onUnfocusAllWidget,
    required this.onShowAddToWishlistRequestProcessLoadingCallback,
    required this.onAddToWishlistRequestProcessSuccessCallback,
    required this.onShowAddToWishlistRequestProcessFailedCallback,
    required this.onShowRemoveFromWishlistRequestProcessLoadingCallback,
    required this.onRemoveFromWishlistRequestProcessSuccessCallback,
    required this.onShowRemoveFromWishlistRequestProcessFailedCallback,
    required this.onShowAddCartRequestProcessLoadingCallback,
    required this.onAddCartRequestProcessSuccessCallback,
    required this.onShowAddCartRequestProcessFailedCallback,
    required this.onShowRemoveCartRequestProcessLoadingCallback,
    required this.onRemoveCartRequestProcessSuccessCallback,
    required this.onShowRemoveCartRequestProcessFailedCallback
  });
}

class WishlistAndCartDelegateFactory {
  WishlistAndCartDelegate generateWishlistAndCartDelegate({
    required BuildContext Function() onGetBuildContext,
    required ErrorProvider Function() onGetErrorProvider,
    OnBack? onBack,
    OnUnfocusAllWidget? onUnfocusAllWidget,
    OnShowAddToWishlistRequestProcessLoadingCallback? onShowAddToWishlistRequestProcessLoadingCallback,
    OnAddToWishlistRequestProcessSuccessCallback? onAddToWishlistRequestProcessSuccessCallback,
    OnShowAddToWishlistRequestProcessFailedCallback? onShowAddToWishlistRequestProcessFailedCallback,
    OnShowRemoveFromWishlistRequestProcessLoadingCallback? onShowRemoveFromWishlistRequestProcessLoadingCallback,
    OnRemoveFromWishlistRequestProcessSuccessCallback? onRemoveFromWishlistRequestProcessSuccessCallback,
    OnShowRemoveFromWishlistRequestProcessFailedCallback? onRemoveFromWishlistRequestProcessFailedCallback,
    OnShowAddCartRequestProcessLoadingCallback? onShowAddCartRequestProcessLoadingCallback,
    OnAddCartRequestProcessSuccessCallback? onAddCartRequestProcessSuccessCallback,
    OnShowAddCartRequestProcessFailedCallback? onShowAddCartRequestProcessFailedCallback,
    OnShowRemoveCartRequestProcessLoadingCallback? onShowRemoveCartRequestProcessLoadingCallback,
    OnRemoveCartRequestProcessSuccessCallback? onRemoveCartRequestProcessSuccessCallback,
    OnShowRemoveCartRequestProcessFailedCallback? onShowRemoveCartRequestProcessFailedCallback
  }) {
    return WishlistAndCartDelegate(
      onUnfocusAllWidget: () => FocusScope.of(onGetBuildContext()).unfocus(),
      onBack: () => Get.back(),
      onShowAddToWishlistRequestProcessLoadingCallback: onShowAddToWishlistRequestProcessLoadingCallback ?? () async => DialogHelper.showLoadingDialog(onGetBuildContext()),
      onAddToWishlistRequestProcessSuccessCallback: onAddToWishlistRequestProcessSuccessCallback ?? () async {
        ToastHelper.showToast("${"Success add to wishlist".tr}.");
        if (MainRouteObserver.onRefreshWishlistInMainMenu != null) {
          MainRouteObserver.onRefreshWishlistInMainMenu!();
        }
      },
      onShowAddToWishlistRequestProcessFailedCallback: onShowAddToWishlistRequestProcessFailedCallback ?? (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
        context: onGetBuildContext(),
        errorProvider: onGetErrorProvider(),
        e: e
      ),
      onShowRemoveFromWishlistRequestProcessLoadingCallback: onShowRemoveFromWishlistRequestProcessLoadingCallback ?? () async => DialogHelper.showLoadingDialog(onGetBuildContext()),
      onRemoveFromWishlistRequestProcessSuccessCallback: onRemoveFromWishlistRequestProcessSuccessCallback ?? (wishlist) async {
        ToastHelper.showToast("${"Success remove to wishlist".tr}.");
      },
      onShowRemoveFromWishlistRequestProcessFailedCallback: onRemoveFromWishlistRequestProcessFailedCallback ?? (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
        context: onGetBuildContext(),
        errorProvider: onGetErrorProvider(),
        e: e
      ),
      onShowAddCartRequestProcessLoadingCallback: onShowAddCartRequestProcessLoadingCallback ?? () async => DialogHelper.showLoadingDialog(onGetBuildContext()),
      onAddCartRequestProcessSuccessCallback: onAddCartRequestProcessSuccessCallback ?? () async {
        if (MainRouteObserver.onRefreshCartInMainMenu != null) {
          MainRouteObserver.onRefreshCartInMainMenu!();
        }
        Provider.of<NotificationNotifier>(onGetBuildContext(), listen: false).loadCartLoadDataResult();
        Provider.of<ComponentNotifier>(onGetBuildContext(), listen: false).updateCart();
        ToastHelper.showToast("${"Success add to cart".tr}.");
      },
      onShowAddCartRequestProcessFailedCallback: onShowAddCartRequestProcessFailedCallback ?? (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
        context: onGetBuildContext(),
        errorProvider: onGetErrorProvider(),
        e: e
      ),
      onShowRemoveCartRequestProcessLoadingCallback: onShowRemoveCartRequestProcessLoadingCallback ?? () async => DialogHelper.showLoadingDialog(onGetBuildContext()),
      onRemoveCartRequestProcessSuccessCallback: onRemoveCartRequestProcessSuccessCallback ?? () async {
        if (MainRouteObserver.onRefreshCartInMainMenu != null) {
          MainRouteObserver.onRefreshCartInMainMenu!();
        }
        Provider.of<NotificationNotifier>(onGetBuildContext(), listen: false).loadCartLoadDataResult();
        Provider.of<ComponentNotifier>(onGetBuildContext(), listen: false).updateCart();
        Provider.of<ProductNotifier>(onGetBuildContext(), listen: false).loadCartList();
      },
      onShowRemoveCartRequestProcessFailedCallback: onShowRemoveCartRequestProcessFailedCallback ?? (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
        context: onGetBuildContext(),
        errorProvider: onGetErrorProvider(),
        e: e
      )
    );
  }
}