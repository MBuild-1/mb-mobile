import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/cart/add_to_cart_parameter.dart';
import '../../domain/entity/cart/add_to_cart_response.dart';
import '../../domain/entity/cart/support_cart.dart';
import '../../domain/entity/wishlist/add_wishlist_parameter.dart';
import '../../domain/entity/wishlist/add_wishlist_response.dart';
import '../../domain/entity/wishlist/remove_wishlist_parameter.dart';
import '../../domain/entity/wishlist/remove_wishlist_response.dart';
import '../../domain/entity/wishlist/support_wishlist.dart';
import '../../domain/entity/wishlist/wishlist.dart';
import '../../domain/usecase/add_to_cart_use_case.dart';
import '../../domain/usecase/add_wishlist_use_case.dart';
import '../../domain/usecase/remove_wishlist_use_case.dart';
import '../dialog_helper.dart';
import '../errorprovider/error_provider.dart';
import '../load_data_result.dart';
import '../manager/api_request_manager.dart';
import '../toast_helper.dart';
import '../typedef.dart';
import 'controller_content_delegate.dart';

class WishlistAndCartControllerContentDelegate extends ControllerContentDelegate {
  final AddWishlistUseCase addWishlistUseCase;
  final RemoveWishlistUseCase removeWishlistUseCase;
  final AddToCartUseCase addToCartUseCase;

  WishlistAndCartDelegate? _wishlistAndCartDelegate;
  ApiRequestManager Function()? _onGetApiRequestManager;

  WishlistAndCartControllerContentDelegate({
    required this.addWishlistUseCase,
    required this.removeWishlistUseCase,
    required this.addToCartUseCase
  });

  void addToWishlist(SupportWishlist supportWishlist) async {
    if (_wishlistAndCartDelegate != null && _onGetApiRequestManager != null) {
      ApiRequestManager apiRequestManager = _onGetApiRequestManager!();
      _wishlistAndCartDelegate!.onUnfocusAllWidget();
      _wishlistAndCartDelegate!.onShowAddToWishlistRequestProcessLoadingCallback();
      LoadDataResult<AddWishlistResponse> addWishlistResponseLoadDataResult = await addWishlistUseCase.execute(
        AddWishlistParameter(supportWishlist: supportWishlist)
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('add-to-wishlist').value
      );
      _wishlistAndCartDelegate!.onBack();
      if (addWishlistResponseLoadDataResult.isSuccess) {
        _wishlistAndCartDelegate!.onAddToWishlistRequestProcessSuccessCallback();
      } else {
        _wishlistAndCartDelegate!.onShowAddToWishlistRequestProcessFailedCallback(addWishlistResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  void removeFromWishlist(SupportWishlist supportWishlist) async {
    if (_wishlistAndCartDelegate != null && _onGetApiRequestManager != null) {
      ApiRequestManager apiRequestManager = _onGetApiRequestManager!();
      _wishlistAndCartDelegate!.onUnfocusAllWidget();
      _wishlistAndCartDelegate!.onShowRemoveFromWishlistRequestProcessLoadingCallback();
      LoadDataResult<RemoveWishlistResponse> removeWishlistResponseLoadDataResult = await removeWishlistUseCase.execute(
        RemoveWishlistParameter(wishlistId: "")
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('remove-to-wishlist').value
      );
      _wishlistAndCartDelegate!.onBack();
      if (removeWishlistResponseLoadDataResult.isSuccess) {
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

  void addToCart(SupportCart supportCart) async {
    if (_wishlistAndCartDelegate != null && _onGetApiRequestManager != null) {
      ApiRequestManager apiRequestManager = _onGetApiRequestManager!();
      _wishlistAndCartDelegate!.onUnfocusAllWidget();
      _wishlistAndCartDelegate!.onShowAddCartRequestProcessLoadingCallback();
      LoadDataResult<AddToCartResponse> addToCartResponseLoadDataResult = await addToCartUseCase.execute(
        AddToCartParameter(supportCart: supportCart, quantity: 1)
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('add-to-cart').value
      );
      _wishlistAndCartDelegate!.onBack();
      if (addToCartResponseLoadDataResult.isSuccess) {
        _wishlistAndCartDelegate!.onAddCartRequestProcessSuccessCallback();
      } else {
        _wishlistAndCartDelegate!.onShowAddCartRequestProcessFailedCallback(addToCartResponseLoadDataResult.resultIfFailed);
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
    OnShowRemoveFromWishlistRequestProcessFailedCallback? onRemoveFromToWishlistRequestProcessFailedCallback,
    OnShowAddCartRequestProcessLoadingCallback? onShowAddCartRequestProcessLoadingCallback,
    OnAddCartRequestProcessSuccessCallback? onAddCartRequestProcessSuccessCallback,
    OnShowAddCartRequestProcessFailedCallback? onShowAddCartRequestProcessFailedCallback,
  }) {
    return WishlistAndCartDelegate(
      onUnfocusAllWidget: () => FocusScope.of(onGetBuildContext()).unfocus(),
      onBack: () => Get.back(),
      onShowAddToWishlistRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(onGetBuildContext()),
      onAddToWishlistRequestProcessSuccessCallback: () async {
        ToastHelper.showToast("${"Success add to wishlist".tr}.");
      },
      onShowAddToWishlistRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
        context: onGetBuildContext(),
        errorProvider: onGetErrorProvider(),
        e: e
      ),
      onShowRemoveFromWishlistRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(onGetBuildContext()),
      onRemoveFromWishlistRequestProcessSuccessCallback: (wishlist) async {
        ToastHelper.showToast("${"Success remove to wishlist".tr}.");
      },
      onShowRemoveFromWishlistRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
        context: onGetBuildContext(),
        errorProvider: onGetErrorProvider(),
        e: e
      ),
      onShowAddCartRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(onGetBuildContext()),
      onAddCartRequestProcessSuccessCallback: () async {
        ToastHelper.showToast("${"Success add to cart".tr}.");
      },
      onShowAddCartRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
        context: onGetBuildContext(),
        errorProvider: onGetErrorProvider(),
        e: e
      )
    );
  }
}