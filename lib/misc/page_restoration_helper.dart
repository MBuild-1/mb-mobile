import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../controller/crop_picture_controller.dart';
import '../controller/reset_password_controller.dart';
import '../presentation/page/accountsecurity/account_security_page.dart';
import '../presentation/page/accountsecurity/change_password_page.dart';
import '../presentation/page/accountsecurity/modify_pin_page.dart';
import '../presentation/page/accountsecurity/personalverification/personal_verification_page.dart';
import '../presentation/page/address_page.dart';
import '../presentation/page/affiliate_page.dart';
import '../presentation/page/cart_page.dart';
import '../presentation/page/chathistory/chat_history_page.dart';
import '../presentation/page/country_delivery_review_media_view_page.dart';
import '../presentation/page/country_delivery_review_page.dart';
import '../presentation/page/coupon_page.dart';
import '../presentation/page/crop_picture_page.dart';
import '../presentation/page/delivery_page.dart';
import '../presentation/page/deliveryreview/delivery_review_page.dart';
import '../presentation/page/edit_profile_page.dart';
import '../presentation/page/favorite_product_brand_page.dart';
import '../presentation/page/forgot_password_page.dart';
import '../presentation/page/getx_page.dart';
import '../presentation/page/help_chat_page.dart';
import '../presentation/page/help_page.dart';
import '../presentation/page/host_cart_page.dart';
import '../presentation/page/inbox_page.dart';
import '../presentation/page/introduction_page.dart';
import '../presentation/page/login_page.dart';
import '../presentation/page/mainmenu/main_menu_page.dart';
import '../presentation/page/modify_address_page.dart';
import '../presentation/page/msme_partner_page.dart';
import '../presentation/page/newspage/news_detail_page.dart';
import '../presentation/page/newspage/news_page.dart';
import '../presentation/page/notification_page.dart';
import '../presentation/page/notification_redirector_page.dart';
import '../presentation/page/order_chat_page.dart';
import '../presentation/page/order_detail_page.dart';
import '../presentation/page/order_page.dart';
import '../presentation/page/payment_instruction_page.dart';
import '../presentation/page/payment_method_page.dart';
import '../presentation/page/pdf_viewer_page.dart';
import '../presentation/page/product_brand_page.dart';
import '../presentation/page/product_bundle_detail_page.dart';
import '../presentation/page/product_bundle_page.dart';
import '../presentation/page/product_category_detail_page.dart';
import '../presentation/page/product_category_page.dart';
import '../presentation/page/product_chat_page.dart';
import '../presentation/page/product_detail_page.dart';
import '../presentation/page/product_discussion_page.dart';
import '../presentation/page/product_entry_page.dart';
import '../presentation/page/register_page.dart';
import '../presentation/page/reset_password_page.dart';
import '../presentation/page/search_page.dart';
import '../presentation/page/shared_cart_page.dart';
import '../presentation/page/videopage/video_page.dart';
import '../presentation/page/web_viewer_page.dart';
import 'constant.dart';
import 'getextended/get_extended.dart';
import 'login_helper.dart';

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

  void toForgotPasswordPage(BuildContext context) {
    PageRestorationHelper.findPageRestorationMixin<ForgotPasswordPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.forgotPasswordPageRestorableRouteFuture.present();
      },
      context: context
    );
  }

  void toMainMenuPage(BuildContext context, PushModeAndTransitionMode pushModeAndTransitionMode) {
    PageRestorationHelper.findPageRestorationMixin<MainMenuPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.mainMenuPageRestorableRouteFuture.present(pushModeAndTransitionMode.toJsonString());
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

  void toProductEntryPage(BuildContext context, ProductEntryPageParameter productEntryPageParameter) {
    PageRestorationHelper.findPageRestorationMixin<ProductEntryPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.productEntryPageRestorableRouteFuture.present(productEntryPageParameter.toEncodeBase64String());
      },
      context: context
    );
  }

  void toProductBundlePage(BuildContext context) {
    PageRestorationHelper.findPageRestorationMixin<ProductBundlePageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.productBundlePageRestorableRouteFuture.present();
      },
      context: context
    );
  }

  void toProductBundleDetailPage(BuildContext context, ProductBundleDetailPageParameter productBundleDetailPageParameter) {
    PageRestorationHelper.findPageRestorationMixin<ProductBundleDetailPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.productBundleDetailPageRestorableRouteFuture.present(
          productBundleDetailPageParameter.toEncodeBase64String()
        );
      },
      context: context
    );
  }

  void toProductDetailPage(BuildContext context, ProductDetailPageParameter productDetailPageParameter) {
    PageRestorationHelper.findPageRestorationMixin<ProductDetailPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.productDetailPageRestorableRouteFuture.present(productDetailPageParameter.toEncodeBase64String());
      },
      context: context
    );
  }

  void toProductBrandPage(BuildContext context, ProductBrandPageParameter productBrandPageParameter) {
    PageRestorationHelper.findPageRestorationMixin<ProductBrandPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.productBrandPageRestorableRouteFuture.present(productBrandPageParameter.toEncodeBase64String());
      },
      context: context
    );
  }

  void toProductCategoryPage(BuildContext context) {
    PageRestorationHelper.findPageRestorationMixin<ProductCategoryPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.productCategoryPageRestorableRouteFuture.present();
      },
      context: context
    );
  }

  void toProductCategoryDetailPage(BuildContext context, String productCategoryId) {
    PageRestorationHelper.findPageRestorationMixin<ProductCategoryDetailPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.productCategoryDetailPageRestorableRouteFuture.present(productCategoryId);
      },
      context: context
    );
  }

  void toCouponPage(BuildContext context, String? couponId) {
    PageRestorationHelper.findPageRestorationMixin<CouponPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.couponPageRestorableRouteFuture.present(couponId.toEmptyStringNonNull);
      },
      context: context
    );
  }

  void toCartPage(BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<CartPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.cartPageRestorableRouteFuture.present();
        },
        context: context
      );
    });
  }

  void toHostCartPage(BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<HostCartPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.hostCartPageRestorableRouteFuture.present();
        },
        context: context
      );
    });
  }

  void toSharedCartPage(BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<SharedCartPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.sharedCartPageRestorableRouteFuture.present();
        },
        context: context
      );
    });
  }

  void toDeliveryPage(BuildContext context, DeliveryPageParameter deliveryPageParameter) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<DeliveryPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.deliveryPageRestorableRouteFuture.present(
            deliveryPageParameter.toEncodeBase64String()
          );
        },
        context: context
      );
    });
  }

  void toWebViewerPage(BuildContext context, Map<String, dynamic> parameter) {
    PageRestorationHelper.findPageRestorationMixin<WebViewerPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        String parameterString = "";
        parameter.forEach((key, value) {
          late String effectiveKey, effectiveValue;
          if (key == Constant.textUrlKey) {
            effectiveKey = Constant.textEncodedUrlKey;
            effectiveValue = base64.encode(utf8.encode(value));
          } else if (key == Constant.textHeaderKey) {
            effectiveKey = Constant.textHeaderKey;
            effectiveValue = base64.encode(utf8.encode(json.encode(value)));
          } else {
            effectiveKey = key;
            effectiveValue = value;
          }
          parameterString += "${parameterString.isEmpty ? "" : "&"}$effectiveKey=$effectiveValue";
        });
        restoration.webViewerPageRestorableRouteFuture.present(Uri.encodeFull("masterbagasi://webviewer?$parameterString"));
      },
      context: context
    );
  }

  void toPdfViewerPage(BuildContext context, Map<String, dynamic> parameter) {
    PageRestorationHelper.findPageRestorationMixin<PdfViewerPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        String parameterString = "";
        parameter.forEach((key, value) {
          late String effectiveKey, effectiveValue;
          if (key == Constant.textUrlKey) {
            effectiveKey = Constant.textEncodedUrlKey;
            effectiveValue = base64.encode(utf8.encode(value));
          } else if (key == Constant.textHeaderKey) {
            effectiveKey = Constant.textHeaderKey;
            effectiveValue = base64.encode(utf8.encode(json.encode(value)));
          } else if (key == Constant.textFileNameKey) {
            effectiveKey = Constant.textFileNameKey;
            effectiveValue = base64.encode(utf8.encode(value));
          } else {
            effectiveKey = key;
            effectiveValue = value;
          }
          parameterString += "${parameterString.isEmpty ? "" : "&"}$effectiveKey=$effectiveValue";
        });
        restoration.pdfViewerPageRestorableRouteFuture.present(Uri.encodeFull("masterbagasi://webviewer?$parameterString"));
      },
      context: context
    );
  }

  void toAddressPage(BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<AddressPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.addressPageRestorableRouteFuture.present();
        },
        context: context
      );
    });
  }

  void toOrderPage(BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<OrderPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.orderPageRestorableRouteFuture.present();
        },
        context: context
      );
    });
  }

  void toOrderDetailPage(BuildContext context, String combinedOrderId) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<OrderDetailPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.orderDetailPageRestorableRouteFuture.present(combinedOrderId);
        },
        context: context
      );
    });
  }

  void toOrderDetailPageWithParameter(BuildContext context, OrderDetailPageParameter orderDetailPageParameter) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<OrderDetailPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.orderDetailPageRestorableRouteFuture.present(
            orderDetailPageParameter.toJsonString()
          );
        },
        context: context
      );
    });
  }

  void toDeliveryReviewPage(BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<DeliveryReviewPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.deliveryReviewPageRestorableRouteFuture.present();
        },
        context: context
      );
    });
  }

  void toFavoriteProductBrandPage(BuildContext context, {PushModeAndTransitionMode? pushModeAndTransitionMode}) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<FavoriteProductBrandPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.favoriteProductBrandPageRestorableRouteFuture.present(pushModeAndTransitionMode?.toJsonString());
        },
        context: context
      );
    });
  }

  void toProductDiscussionPage(BuildContext context, ProductDiscussionPageParameter productDiscussionPageParameter) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<ProductDiscussionPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.productDiscussionPageRestorableRouteFuture.present(
            productDiscussionPageParameter.toEncodeBase64String()
          );
        },
        context: context
      );
    });
  }

  void toModifyAddressPage(BuildContext context, ModifyAddressPageParameter modifyAddressPageParameter) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<ModifyAddressPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.modifyAddressPageRestorableRouteFuture.present(
            modifyAddressPageParameter.toEncodeBase64String()
          );
        },
        context: context
      );
    });
  }

  void toInboxPage(BuildContext context, {InboxPageParameter? inboxPageParameter}) {
    LoginHelper.checkingLogin(context, () {
      InboxPageParameter effectiveInboxPageParameter = inboxPageParameter ?? InboxPageParameter(
        showFaq: true,
        showInboxMenu: true
      );
      PageRestorationHelper.findPageRestorationMixin<InboxPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.inboxPageRestorableRouteFuture.present(
            effectiveInboxPageParameter.toEncodeBase64String()
          );
        },
        context: context
      );
    });
  }

  void toAffiliatePage(BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<AffiliatePageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.affiliatePageRestorableRouteFuture.present();
        },
        context: context
      );
    });
  }

  void toMsmePartnerPage(BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<MsmePartnerPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.msmePartnerPageRestorableRouteFuture.present();
        },
        context: context
      );
    });
  }

  void toCountryDeliveryReviewPage(String countryId, BuildContext context) {
    PageRestorationHelper.findPageRestorationMixin<CountryDeliveryReviewPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.countryDeliveryReviewPageRestorableRouteFuture.present(countryId);
      },
      context: context
    );
  }

  void toSearchPage(BuildContext context) {
    PageRestorationHelper.findPageRestorationMixin<SearchPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.searchPageRestorableRouteFuture.present();
      },
      context: context
    );
  }

  void toHelpPage(BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<HelpPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.helpPageRestorableRouteFuture.present();
        },
        context: context
      );
    });
  }

  void toHelpChatPage(BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<HelpChatPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.helpChatPageRestorableRouteFuture.present();
        },
        context: context
      );
    });
  }

  void toOrderChatPage(String combinedOrderId, BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<OrderChatPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.orderChatPageRestorableRouteFuture.present(combinedOrderId);
        },
        context: context
      );
    });
  }

  void toProductChatPage(String productId, BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<ProductChatPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.productChatPageRestorableRouteFuture.present(productId);
        },
        context: context
      );
    });
  }

  void toCountryDeliveryReviewMediaViewPage(BuildContext context, CountryDeliveryReviewMediaViewPageParameter countryDeliveryReviewMediaViewPageParameter) {
    PageRestorationHelper.findPageRestorationMixin<CountryDeliveryReviewMediaViewPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.countryDeliveryReviewMediaViewPageRestorableRouteFuture.present(
          countryDeliveryReviewMediaViewPageParameter.toEncodeBase64String()
        );
      },
      context: context
    );
  }

  void toNotificationPage(BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<NotificationPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.notificationPageRestorableRouteFuture.present();
        },
        context: context
      );
    });
  }

  void toChatHistoryPage(BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<ChatHistoryPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.chatHistoryPageRestorableRouteFuture.present();
        },
        context: context
      );
    });
  }

  void toVideoPage(BuildContext context, VideoPageParameter videoPageParameter) {
    PageRestorationHelper.findPageRestorationMixin<VideoPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.videoPageRestorableRouteFuture.present(
          videoPageParameter.toEncodeBase64String()
        );
      },
      context: context
    );
  }

  void toNewsPage(BuildContext context) {
    PageRestorationHelper.findPageRestorationMixin<NewsPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.newsPageRestorableRouteFuture.present();
      },
      context: context
    );
  }

  void toNewsDetailPage(BuildContext context, String newsId) {
    PageRestorationHelper.findPageRestorationMixin<NewsDetailPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.newsDetailPageRestorableRouteFuture.present(newsId);
      },
      context: context
    );
  }

  void toAccountSecurityPage(BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<AccountSecurityPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.accountSecurityPageRestorableRouteFuture.present();
        },
        context: context
      );
    });
  }

  void toChangePasswordPage(BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<ChangePasswordPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.changePasswordPageRestorableRouteFuture.present();
        },
        context: context
      );
    });
  }

  void toModifyPinPage(BuildContext context, ModifyPinPageParameter modifyPinPageParameter) {
    PageRestorationHelper.findPageRestorationMixin<ModifyPinPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.modifyPinPageRestorableRouteFuture.present(modifyPinPageParameter.toEncodeBase64String());
      },
      context: context
    );
  }

  void toPersonalVerificationPage(BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<PersonalVerificationPageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.personalVerificationPageRestorableRouteFuture.present();
        },
        context: context
      );
    });
  }

  void toEditProfilePage(BuildContext context) {
    LoginHelper.checkingLogin(context, () {
      PageRestorationHelper.findPageRestorationMixin<EditProfilePageRestorationMixin>(
        onGetxPageRestorationFound: (restoration) {
          restoration.editProfilePageRestorableRouteFuture.present();
        },
        context: context
      );
    });
  }

  void toIntroductionPage(BuildContext context, PushModeAndTransitionMode pushModeAndTransitionMode) {
    PageRestorationHelper.findPageRestorationMixin<IntroductionPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.introductionPageRestorableRouteFuture.present(pushModeAndTransitionMode.toJsonString());
      },
      context: context
    );
  }

  void toNotificationRedirectorPage(BuildContext context, NotificationRedirectorPageParameter notificationRedirectorPageParameter) {
    PageRestorationHelper.findPageRestorationMixin<NotificationRedirectorPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.notificationRedirectorPageRestorableRouteFuture.present(
          notificationRedirectorPageParameter.toJsonString()
        );
      },
      context: context
    );
  }

  void toPaymentMethodPage(BuildContext context, String? paymentMethodSettlingId) {
    PageRestorationHelper.findPageRestorationMixin<PaymentMethodPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.paymentMethodPageRestorableRouteFuture.present(paymentMethodSettlingId);
      },
      context: context
    );
  }

  void toPaymentInstructionPage(BuildContext context) {
    PageRestorationHelper.findPageRestorationMixin<PaymentInstructionPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.paymentInstructionPageRestorableRouteFuture.present();
      },
      context: context
    );
  }

  void toResetPasswordPage(BuildContext context, ResetPasswordPageParameter resetPasswordPageParameter) {
    PageRestorationHelper.findPageRestorationMixin<ResetPasswordPageRestorationMixin>(
      onGetxPageRestorationFound: (restoration) {
        restoration.resetPasswordPageRestorableRouteFuture.present(
          resetPasswordPageParameter.toEncodeBase64String()
        );
      },
      context: context
    );
  }

  PushModeAndTransitionMode parsePushModeAndTransitionMode(String jsonArguments) {
    String pushMode = "";
    bool hasTransition = true;
    try {
      var decodedJson = json.decode(jsonArguments) as Map<String, dynamic>;
      if (decodedJson.containsKey("push_mode")) {
        pushMode = decodedJson["push_mode"];
      }
      if (decodedJson.containsKey("has_transition")) {
        hasTransition = decodedJson["has_transition"] == 1;
      }
    } catch (e) {
      // Not action occurred
    }
    return PushModeAndTransitionMode(
      pushMode: pushMode,
      hasTransition: hasTransition
    );
  }

  RoutePresentationCallback onPresentWithPushModeAndTransitionModeParameter({
    required String Function(NavigatorState, dynamic) onNavigatorRestorablePushAndRemoveUntil,
    required String Function(NavigatorState, dynamic) onNavigatorRestorablePush,
  }) {
    return (NavigatorState navigator, Object? arguments) {
      if (arguments is String) {
        String pushMode = arguments;
        var parsePushModeAndTransitionMode = PageRestorationHelper.parsePushModeAndTransitionMode(arguments);
        pushMode = parsePushModeAndTransitionMode.pushMode;
        if (pushMode == Constant.restorableRouteFuturePushAndRemoveUntil) {
          return onNavigatorRestorablePushAndRemoveUntil(navigator, arguments);
        } else {
          return onNavigatorRestorablePush(navigator, arguments);
        }
      } else {
        return onNavigatorRestorablePush(navigator, arguments);
      }
    };
  }

  Route<T>? getRouteWithPushModeAndTransitionModeParameter<T>({
    required Object? arguments,
    dynamic Function()? onPassingAdditionalArguments,
    Route<T>? Function(GetPageBuilderWithPageName, Object?, dynamic, Duration?)? onInterceptToWithGetPageRouteReturnValue,
    required GetPageBuilderWithPageName Function() onBuildRestorableGetxPageBuilder
  }) {
    bool hasTransition = true;
    if (arguments is String) {
      var parsePushModeAndTransitionMode = PageRestorationHelper.parsePushModeAndTransitionMode(arguments);
      hasTransition = parsePushModeAndTransitionMode.hasTransition;
    }
    var buildRestorableGetxPageBuilderResult = onBuildRestorableGetxPageBuilder();
    var additionalArgumentsResult = onPassingAdditionalArguments != null ? onPassingAdditionalArguments() : null;
    var durationResult = hasTransition ? null : Duration.zero;
    if (onInterceptToWithGetPageRouteReturnValue != null) {
      return onInterceptToWithGetPageRouteReturnValue(
        buildRestorableGetxPageBuilderResult, arguments, additionalArgumentsResult, durationResult
      );
    }
    return GetExtended.toWithGetPageRouteReturnValue<T>(
      buildRestorableGetxPageBuilderResult,
      arguments: additionalArgumentsResult,
      duration: durationResult
    );
  }
}

// ignore: non_constant_identifier_names
final PageRestorationHelper = _PageRestorationHelperImpl();

class PushModeAndTransitionMode {
  String pushMode;
  bool hasTransition;

  PushModeAndTransitionMode({
    required this.pushMode,
    required this.hasTransition
  });
}

extension PushModeAndTransitionModeExt on PushModeAndTransitionMode {
  String toJsonString() {
    return json.encode(toJsonMap());
  }

  Map<String, dynamic> toJsonMap() {
    return <String, dynamic>{
      "push_mode": pushMode,
      "has_transition": hasTransition ? 1 : 0
    };
  }
}