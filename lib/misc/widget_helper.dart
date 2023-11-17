import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../domain/entity/product/productbundle/product_bundle.dart';
import '../presentation/notifier/product_notifier.dart';
import '../presentation/widget/button/add_or_remove_cart_button.dart';
import '../presentation/widget/button/add_or_remove_wishlist_button.dart';
import '../presentation/widget/loaddataresultimplementer/load_data_result_implementer_directly.dart';
import '../presentation/widget/modified_shimmer.dart';
import '../presentation/widget/productbundle/product_bundle_item.dart';
import '../presentation/widget/prompt_indicator.dart';
import 'constant.dart';
import 'constrained_app_bar_return_value.dart';
import 'defaultloaddataresultwidget/main_default_load_data_result_widget.dart';
import 'error/token_empty_error.dart';
import 'errorprovider/error_provider.dart';
import 'injector.dart';
import 'load_data_result.dart';
import 'login_helper.dart';
import 'page_restoration_helper.dart';

class _WidgetHelperImpl {
  Widget buildPromptIndicator({
    required BuildContext context,
    Image? image,
    String? promptTitleText,
    String? promptText,
    String? buttonText,
    VoidCallback? onPressed,
    required PromptIndicatorType promptIndicatorType
  }) {
    return PromptIndicator(
      image: image,
      promptTitleText: promptTitleText,
      promptText: promptText,
      buttonText: buttonText ?? "OK",
      onPressed: onPressed,
      promptIndicatorType: promptIndicatorType
    );
  }

  Widget buildSuccessPromptIndicator({
    required BuildContext context,
    Image? image,
    String? promptTitleText = "Success",
    String? promptText = "This process has been success...",
    String? buttonText,
    VoidCallback? onPressed,
    PromptIndicatorType promptIndicatorType = PromptIndicatorType.vertical
  }) {
    return buildPromptIndicator(
      context: context,
      image: image ?? Image.asset(Constant.imageSuccess),
      promptTitleText: promptTitleText,
      promptText: promptText,
      buttonText: buttonText,
      onPressed: onPressed,
      promptIndicatorType: promptIndicatorType
    );
  }

  Widget buildFailedPromptIndicator({
    required BuildContext context,
    Image? image,
    String? promptTitleText,
    String? promptText,
    String? buttonText,
    VoidCallback? onPressed,
    PromptIndicatorType promptIndicatorType = PromptIndicatorType.vertical
  }) {
    return buildPromptIndicator(
      context: context,
      image: image ?? Image.asset(Constant.imageFailed),
      promptTitleText: promptTitleText,
      promptText: promptText,
      buttonText: buttonText,
      onPressed: onPressed,
      promptIndicatorType: promptIndicatorType
    );
  }

  Widget buildFailedPromptIndicatorFromErrorProvider({
    required BuildContext context,
    required ErrorProvider errorProvider,
    required dynamic e,
    String? buttonText,
    VoidCallback? onPressed,
    PromptIndicatorType promptIndicatorType = PromptIndicatorType.vertical
  }) {
    ErrorProviderResult? errorProviderResult = errorProvider.onGetErrorProviderResult(e);
    return buildPromptIndicator(
      context: context,
      image: errorProviderResult != null ? Image.asset(errorProviderResult.imageAssetUrl.isEmpty ? Constant.imageFailed : errorProviderResult.imageAssetUrl) : null,
      promptTitleText: errorProviderResult?.title,
      promptText: errorProviderResult?.message,
      buttonText: buttonText,
      onPressed: onPressed,
      promptIndicatorType: promptIndicatorType
    );
  }

  double getAppBarAndStatusHeight(AppBar appBar, BuildContext context) {
    return appBar.preferredSize.height + MediaQuery.of(context).viewPadding.top;
  }

  ConstrainedAppBarReturnValue constrainedAppBar({
    required AppBar appBar,
    Widget? appBarWidget,
    required BuildContext context
  }) {
    double appBarAndStatusHeight = WidgetHelper.getAppBarAndStatusHeight(appBar, context);
    return ConstrainedAppBarReturnValue(
      appBar: SizedBox(
        height: appBarAndStatusHeight,
        child: appBarWidget ?? appBar
      ),
      appBarAndStatusHeight: appBarAndStatusHeight,
    );
  }

  Widget checkingLogin(BuildContext context, Widget Function() resultIfHasBeenLogin, ErrorProvider errorProvider, {bool withIndexedStack = false}) {
    Widget notLogin() {
      return Center(
        child: LoadDataResultImplementerDirectlyWithDefault<String>(
          errorProvider: errorProvider,
          loadDataResult: FailedLoadDataResult.throwException(() => throw TokenEmptyError())!,
          onImplementLoadDataResultDirectlyWithDefault: (loadDataResult, errorProvider, defaultLoadDataResultWidget) {
            return defaultLoadDataResultWidget.failedLoadDataResultWithButtonWidget(
              context,
              loadDataResult as FailedLoadDataResult<String>,
              errorProvider,
              failedLoadDataResultConfig: FailedLoadDataResultConfig(
                onPressed: () => PageRestorationHelper.toLoginPage(context, Constant.restorableRouteFuturePush),
                buttonText: "Login".tr
              )
            );
          }
        ),
      );
    }
    bool loginTokenIsNotEmpty = LoginHelper.getTokenWithBearer().result.isNotEmpty;
    if (withIndexedStack) {
      return IndexedStack(
        index: loginTokenIsNotEmpty ? 0 : 1,
        children: [
          resultIfHasBeenLogin(),
          notLogin()
        ],
      );
    }
    if (loginTokenIsNotEmpty) {
      return resultIfHasBeenLogin();
    }
    return notLogin();
  }

  Widget checkVisibility(bool? visibility, Widget Function() resultIfVisibilityIsTrue) {
    if (visibility == null) {
      return const SizedBox();
    }
    if (visibility) {
      return resultIfVisibilityIsTrue();
    }
    return const SizedBox();
  }

  Widget productBundleWishlistAndCartIndicator({
    required ProductBundle productBundle,
    required bool comingSoon,
    required OnAddWishlistWithProductBundle? onAddWishlist,
    required OnRemoveWishlistWithProductBundle? onRemoveWishlist,
    required OnAddCartWithProductBundle? onAddCart,
    required OnRemoveCartWithProductBundle? onRemoveCart,
  }) {
    void onWishlist(void Function(ProductBundle)? onWishlistCallback) {
      if (onWishlistCallback != null) {
        onWishlistCallback(productBundle);
      }
    }
    return Consumer<ProductNotifier>(
      builder: (_, productNotifier, __) {
        LoadDataResult<bool> isAddToWishlist = productNotifier.isAddToWishlist(productBundle);
        LoadDataResult<bool> isAddToCart = productNotifier.isAddToCart(productBundle);
        return Row(
          children: [
            Builder(
              builder: (context) {
                Widget result = AddOrRemoveWishlistButton(
                  onAddWishlist: onAddWishlist != null ? () => onWishlist(onAddWishlist) : null,
                  onRemoveWishlist: onRemoveWishlist != null ? () => onWishlist(onRemoveWishlist) : null,
                  isAddToWishlist: isAddToWishlist.isSuccess ? isAddToWishlist.resultIfSuccess! : false,
                );
                return isAddToWishlist.isSuccess ? result : ModifiedShimmer.fromColors(child: result);
              }
            ),
            SizedBox(width: 1.5.w),
            Builder(
              builder: (context) {
                void Function()? onPressed = !comingSoon ? (onAddCart != null ? () => onAddCart(productBundle) : null) : null;
                Widget result = AddOrRemoveCartButton(
                  onAddCart: onPressed,
                  isAddToCart: isAddToCart.isSuccess ? isAddToCart.resultIfSuccess! : false,
                  isIcon: true,
                  isLoading: !isAddToCart.isSuccess
                );
                return Expanded(
                  child: isAddToCart.isSuccess ? result : ModifiedShimmer.fromColors(child: result)
                );
              }
            )
          ],
        );
      }
    );
  }
}

// ignore: non_constant_identifier_names
var WidgetHelper = _WidgetHelperImpl();