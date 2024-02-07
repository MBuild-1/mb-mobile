import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/domain/usecase/get_favorite_product_brand_use_case.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/product/productbrand/add_to_favorite_product_brand_parameter.dart';
import '../../domain/entity/product/productbrand/add_to_favorite_product_brand_response.dart';
import '../../domain/entity/product/productbrand/favorite_product_brand.dart';
import '../../domain/entity/product/productbrand/favorite_product_brand_list_parameter.dart';
import '../../domain/entity/product/productbrand/product_brand.dart';
import '../../domain/entity/product/productbrand/remove_from_favorite_product_brand_parameter.dart';
import '../../domain/entity/product/productbrand/remove_from_favorite_product_brand_response.dart';
import '../../domain/usecase/add_to_favorite_product_brand_use_case.dart';
import '../../domain/usecase/get_favorite_product_brand_list_use_case.dart';
import '../../domain/usecase/remove_from_favorite_product_brand_use_case.dart';
import '../constant.dart';
import '../dialog_helper.dart';
import '../error/message_error.dart';
import '../errorprovider/error_provider.dart';
import '../load_data_result.dart';
import '../manager/api_request_manager.dart';
import '../multi_language_string.dart';
import '../toast_helper.dart';
import '../typedef.dart';
import 'controller_content_delegate.dart';

class ProductBrandFavoriteControllerContentDelegate extends ControllerContentDelegate {
  final AddToFavoriteProductBrandUseCase addToFavoriteProductBrandUseCase;
  final RemoveFromFavoriteProductBrandUseCase removeFromFavoriteProductBrandUseCase;
  final GetFavoriteProductBrandListUseCase getFavoriteProductBrandListUseCase;

  ProductBrandFavoriteDelegate? _productBrandFavoriteDelegate;
  ApiRequestManager Function()? _onGetApiRequestManager;

  void addToFavoriteProductBrand(ProductBrand productBrand, Future<bool> Function() onCheckingLogin) async {
    if ((await onCheckingLogin())) {
      if (_productBrandFavoriteDelegate != null && _onGetApiRequestManager != null) {
        ApiRequestManager apiRequestManager = _onGetApiRequestManager!();
        _productBrandFavoriteDelegate!.onUnfocusAllWidget();
        _productBrandFavoriteDelegate!.onShowAddToFavoriteProductBrandRequestProcessLoadingCallback();
        LoadDataResult<AddToFavoriteProductBrandResponse> addToFavoriteProductBrandResponseLoadDataResult = await addToFavoriteProductBrandUseCase.execute(
          AddToFavoriteProductBrandParameter(productBrand: productBrand)
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('add-to-favorite').value
        );
        if (addToFavoriteProductBrandResponseLoadDataResult.isSuccess) {
          productBrand.isAddedToFavorite = true;
          _productBrandFavoriteDelegate!.onAddToFavoriteProductBrandRequestProcessSuccessCallback();
        } else {
          _productBrandFavoriteDelegate!.onShowAddToFavoriteProductBrandProcessFailedCallback(addToFavoriteProductBrandResponseLoadDataResult.resultIfFailed);
        }
        _productBrandFavoriteDelegate!.onBack();
      }
    }
  }

  void removeFromFavoriteProductBrand(FavoriteProductBrand favoriteProductBrand, Future<bool> Function() onCheckingLogin) async {
    if ((await onCheckingLogin())) {
      if (_productBrandFavoriteDelegate != null && _onGetApiRequestManager != null) {
        ApiRequestManager apiRequestManager = _onGetApiRequestManager!();
        _productBrandFavoriteDelegate!.onUnfocusAllWidget();
        _productBrandFavoriteDelegate!.onShowRemoveFromFavoriteProductBrandRequestProcessLoadingCallback();
        LoadDataResult<RemoveFromFavoriteProductBrandResponse> removeFromFavoriteProductBrandResponseLoadDataResult = await removeFromFavoriteProductBrandUseCase.execute(
          RemoveFromFavoriteProductBrandParameter(favoriteProductBrand: favoriteProductBrand)
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('remove-from-favorite').value
        );
        _productBrandFavoriteDelegate!.onBack();
        if (removeFromFavoriteProductBrandResponseLoadDataResult.isSuccess) {
          favoriteProductBrand.productBrand.isAddedToFavorite = false;
          _productBrandFavoriteDelegate!.onRemoveFromFavoriteProductBrandRequestProcessSuccessCallback(favoriteProductBrand);
        } else {
          _productBrandFavoriteDelegate!.onShowRemoveFromFavoriteProductBrandProcessFailedCallback(removeFromFavoriteProductBrandResponseLoadDataResult.resultIfFailed);
        }
      }
    }
  }

  void removeFromFavoriteProductBrandBasedProductBrand(ProductBrand productBrand, Future<bool> Function() onCheckingLogin) async {
    if ((await onCheckingLogin())) {
      if (_productBrandFavoriteDelegate != null && _onGetApiRequestManager != null) {
        ApiRequestManager apiRequestManager = _onGetApiRequestManager!();
        _productBrandFavoriteDelegate!.onUnfocusAllWidget();
        _productBrandFavoriteDelegate!.onShowRemoveFromFavoriteProductBrandRequestProcessLoadingCallback();
        LoadDataResult<List<FavoriteProductBrand>> favoriteProductBrandListLoadDataResult = await getFavoriteProductBrandListUseCase.execute(
          FavoriteProductBrandListParameter()
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('favorite-product-brand-list').value
        );
        if (favoriteProductBrandListLoadDataResult.isSuccess) {
          List<FavoriteProductBrand> favoriteProductBrandList = favoriteProductBrandListLoadDataResult.resultIfSuccess!;
          Iterable<FavoriteProductBrand> favoriteProductBrandIterable = favoriteProductBrandList.where((favoriteProductBrand) => favoriteProductBrand.productBrand.id == productBrand.id);
          if (favoriteProductBrandIterable.isNotEmpty) {
            FavoriteProductBrand favoriteProductBrand = favoriteProductBrandIterable.first;
            LoadDataResult<RemoveFromFavoriteProductBrandResponse> removeFromFavoriteProductBrandResponseLoadDataResult = await removeFromFavoriteProductBrandUseCase.execute(
              RemoveFromFavoriteProductBrandParameter(favoriteProductBrand: favoriteProductBrand)
            ).future(
              parameter: apiRequestManager.addRequestToCancellationPart('remove-from-favorite-based-product-brand').value
            );
            _productBrandFavoriteDelegate!.onBack();
            if (removeFromFavoriteProductBrandResponseLoadDataResult.isSuccess) {
              productBrand.isAddedToFavorite = false;
              _productBrandFavoriteDelegate!.onRemoveFromFavoriteProductBrandRequestProcessSuccessCallback(favoriteProductBrand);
            } else {
              _productBrandFavoriteDelegate!.onShowRemoveFromFavoriteProductBrandProcessFailedCallback(removeFromFavoriteProductBrandResponseLoadDataResult.resultIfFailed);
            }
          } else {
            _productBrandFavoriteDelegate!.onBack();
            _productBrandFavoriteDelegate!.onShowRemoveFromFavoriteProductBrandProcessFailedCallback(
              MultiLanguageMessageError(
                title: MultiLanguageString({
                  Constant.textEnUsLanguageKey: "Favorite Product Brand Is Not Found",
                  Constant.textInIdLanguageKey: "Product Brand Favorit Tidak Ditemukan."
                }),
                message: MultiLanguageString({
                  Constant.textEnUsLanguageKey: "For now, favorite product brand is not found.",
                  Constant.textInIdLanguageKey: "Untuk sekarang, product brand favorit tidak ditemukan."
                }),
              )
            );
          }
        } else {
          _productBrandFavoriteDelegate!.onBack();
          _productBrandFavoriteDelegate!.onShowRemoveFromFavoriteProductBrandProcessFailedCallback(favoriteProductBrandListLoadDataResult.resultIfFailed);
        }
      }
    }
  }

  ProductBrandFavoriteControllerContentDelegate setProductBrandFavoriteDelegate(ProductBrandFavoriteDelegate productBrandFavoriteDelegate) {
    _productBrandFavoriteDelegate = productBrandFavoriteDelegate;
    return this;
  }

  ProductBrandFavoriteControllerContentDelegate setApiRequestManager(ApiRequestManager Function() onGetApiRequestManager) {
    _onGetApiRequestManager = onGetApiRequestManager;
    return this;
  }

  ProductBrandFavoriteControllerContentDelegate({
    required this.addToFavoriteProductBrandUseCase,
    required this.removeFromFavoriteProductBrandUseCase,
    required this.getFavoriteProductBrandListUseCase
  });
}

class ProductBrandFavoriteDelegate {
  OnBack onBack;
  OnUnfocusAllWidget onUnfocusAllWidget;
  OnShowAddToFavoriteProductBrandRequestProcessLoadingCallback onShowAddToFavoriteProductBrandRequestProcessLoadingCallback;
  OnAddToFavoriteProductBrandRequestProcessSuccessCallback onAddToFavoriteProductBrandRequestProcessSuccessCallback;
  OnShowAddToFavoriteProductBrandProcessFailedCallback onShowAddToFavoriteProductBrandProcessFailedCallback;
  OnShowRemoveFromFavoriteProductBrandRequestProcessLoadingCallback onShowRemoveFromFavoriteProductBrandRequestProcessLoadingCallback;
  OnRemoveFromFavoriteProductBrandRequestProcessSuccessCallback onRemoveFromFavoriteProductBrandRequestProcessSuccessCallback;
  OnShowRemoveFromFavoriteProductBrandProcessFailedCallback onShowRemoveFromFavoriteProductBrandProcessFailedCallback;

  ProductBrandFavoriteDelegate({
    required this.onBack,
    required this.onUnfocusAllWidget,
    required this.onShowAddToFavoriteProductBrandRequestProcessLoadingCallback,
    required this.onAddToFavoriteProductBrandRequestProcessSuccessCallback,
    required this.onShowAddToFavoriteProductBrandProcessFailedCallback,
    required this.onShowRemoveFromFavoriteProductBrandRequestProcessLoadingCallback,
    required this.onRemoveFromFavoriteProductBrandRequestProcessSuccessCallback,
    required this.onShowRemoveFromFavoriteProductBrandProcessFailedCallback
  });
}

class ProductBrandFavoriteDelegateFactory {
  ProductBrandFavoriteDelegate generateProductBrandFavoriteDelegate({
    required BuildContext Function() onGetBuildContext,
    required ErrorProvider Function() onGetErrorProvider,
    OnBack? onBack,
    OnUnfocusAllWidget? onUnfocusAllWidget,
    OnShowAddToFavoriteProductBrandRequestProcessLoadingCallback? onShowAddToFavoriteProductBrandRequestProcessLoadingCallback,
    OnAddToFavoriteProductBrandRequestProcessSuccessCallback? onAddToFavoriteProductBrandRequestProcessSuccessCallback,
    OnShowAddToFavoriteProductBrandProcessFailedCallback? onShowAddToFavoriteProductBrandProcessFailedCallback,
    OnShowRemoveFromFavoriteProductBrandRequestProcessLoadingCallback? onShowRemoveFromFavoriteProductBrandRequestProcessLoadingCallback,
    OnRemoveFromFavoriteProductBrandRequestProcessSuccessCallback? onRemoveFromFavoriteProductBrandRequestProcessSuccessCallback,
    OnShowRemoveFromFavoriteProductBrandProcessFailedCallback? onShowRemoveFromFavoriteProductBrandProcessFailedCallback
  }) {
    return ProductBrandFavoriteDelegate(
      onUnfocusAllWidget: () => FocusScope.of(onGetBuildContext()).unfocus(),
      onBack: () => Get.back(),
      onShowAddToFavoriteProductBrandRequestProcessLoadingCallback: onShowAddToFavoriteProductBrandRequestProcessLoadingCallback ?? () async => DialogHelper.showLoadingDialog(onGetBuildContext()),
      onAddToFavoriteProductBrandRequestProcessSuccessCallback: onAddToFavoriteProductBrandRequestProcessSuccessCallback ?? () async {
        ToastHelper.showToast("${"Success add to favorite product".tr}.");
      },
      onShowAddToFavoriteProductBrandProcessFailedCallback: onShowAddToFavoriteProductBrandProcessFailedCallback ?? (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
        context: onGetBuildContext(),
        errorProvider: onGetErrorProvider(),
        e: e
      ),
      onShowRemoveFromFavoriteProductBrandRequestProcessLoadingCallback: onShowRemoveFromFavoriteProductBrandRequestProcessLoadingCallback ?? () async => DialogHelper.showLoadingDialog(onGetBuildContext()),
      onRemoveFromFavoriteProductBrandRequestProcessSuccessCallback: onRemoveFromFavoriteProductBrandRequestProcessSuccessCallback ?? (favoriteProductBrand) async {
        ToastHelper.showToast("${"Success remove from favorite product".tr}.");
      },
      onShowRemoveFromFavoriteProductBrandProcessFailedCallback: onShowRemoveFromFavoriteProductBrandProcessFailedCallback ?? (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
        context: onGetBuildContext(),
        errorProvider: onGetErrorProvider(),
        e: e
      ),
    );
  }
}