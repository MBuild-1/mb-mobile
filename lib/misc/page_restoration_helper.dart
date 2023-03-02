import 'package:flutter/material.dart';

import '../controller/crop_picture_controller.dart';
import '../presentation/page/crop_picture_page.dart';
import '../presentation/page/getx_page.dart';
import '../presentation/page/login_page.dart';
import '../presentation/page/product_detail_page.dart';
import '../presentation/page/product_page.dart';
import '../presentation/page/register_page.dart';

class _PageRestorationHelperImpl {
  bool _checkingPageRestorationMixin<T extends GetxPageRestoration>({
    required Widget checkingWidget,
    required void Function(T) onGetxPageRestorationFound,
    required BuildContext context
  }) {
    if (checkingWidget is RestorableGetxPage) {
      RestorableGetxPage widget = checkingWidget;
      GetxPageRestoration restoration = widget.getPageRestoration(context);
      if (restoration is T) {
        onGetxPageRestorationFound(restoration);
        return false;
      }
      return true;
    }
    return true;
  }

  void findPageRestorationMixin<T extends GetxPageRestoration>({
    required void Function(T) onGetxPageRestorationFound,
    required BuildContext context
  }) {
    if (_checkingPageRestorationMixin(checkingWidget: context.widget, onGetxPageRestorationFound: onGetxPageRestorationFound, context: context)) {
      context.visitAncestorElements((element) {
        return _checkingPageRestorationMixin(checkingWidget: element.widget, onGetxPageRestorationFound: onGetxPageRestorationFound, context: context);
      });
    }
  }

  void toLoginPage(BuildContext context, String restorableRouteFuturePushParameter) {
    PageRestorationHelper.findPageRestorationMixin<LoginPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.loginPageRestorableRouteFuture.present(restorableRouteFuturePushParameter);
      },
      context: context
    );
  }

  void toRegisterPage(BuildContext context) {
    PageRestorationHelper.findPageRestorationMixin<RegisterPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.registerPageRestorableRouteFuture.present();
      },
      context: context
    );
  }

  void toProductPage(BuildContext context) {
    PageRestorationHelper.findPageRestorationMixin<ProductPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.productPageRestorableRouteFuture.present();
      },
      context: context
    );
  }

  void toProductDetailPage(String productDetailEndpoint, BuildContext context) {
    PageRestorationHelper.findPageRestorationMixin<ProductDetailPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.productDetailPageRestorableRouteFuture.present(productDetailEndpoint);
      },
      context: context
    );
  }

  void toCropPicturePage(BuildContext context, CropPictureParameter cropPictureParameter) {
    PageRestorationHelper.findPageRestorationMixin<CropPicturePageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.cropPicturePageRestorableRouteFuture.present(
          cropPictureParameter.toEncodeBase64String()
        );
      },
      context: context
    );
  }
}

// ignore: non_constant_identifier_names
final PageRestorationHelper = _PageRestorationHelperImpl();