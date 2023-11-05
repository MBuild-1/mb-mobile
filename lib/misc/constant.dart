import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'aspect_ratio_value.dart';
import 'color_helper.dart';
import 'multi_language_string.dart';

class _ConstantImpl {
  String get restorableRouteFuturePush => "restorable-route-future-push";
  String get restorableRouteFuturePushAndRemoveUntil => "restorable-route-future-and-remove-until";

  String get baseImagesAssetsPath => "assets/images/";
  String _getImagesAssets(String imageAssetsPath) => "$baseImagesAssetsPath$imageAssetsPath";
  String get imageIntroduction1 => _getImagesAssets("introduction_1.png");
  String get imageIntroduction2 => _getImagesAssets("introduction_2.png");
  String get imageIntroduction3 => _getImagesAssets("introduction_3.png");
  String get imageIntroduction4 => _getImagesAssets("introduction_4.png");
  String get imageMasterbagasi => _getImagesAssets("masterbagasi.png");
  String get imageBringingHappiness => _getImagesAssets("bringing_happiness.png");
  String get imageSuccess => _getImagesAssets("success.png");
  String get imageFailed => _getImagesAssets("under_maintenance.png");
  String get imageNoInternet => imageFailed;
  String get imageLogin => _getImagesAssets("login.png");
  String get imageStar => _getImagesAssets("star.png");
  String get imageStarPlaceholder => _getImagesAssets("star_placeholder.png");
  String get imageCheckRatesForVariousCountries => _getImagesAssets("check_rates_for_various_countries.png");
  String get imageProductPlaceholder => _getImagesAssets("product_placeholder.png");
  String get imageKitchenContainsIndonesia => _getImagesAssets("kitchen_contains_indonesia.png");
  String get imagePatternHomeMainMenuAppBar => _getImagesAssets("pattern_home_main_menu_app_bar.png");
  String get imagePatternFeedMainMenuAppBar => _getImagesAssets("pattern_feed_main_menu_app_bar.png");
  String get imagePatternExploreNusantaraMainMenuAppBar => _getImagesAssets("pattern_explore_nusantara_main_menu_app_bar.png");
  String get imagePatternWishlistMainMenuAppBar => _getImagesAssets("pattern_wishlist_main_menu_app_bar.png");
  String get imagePatternMenuMainMenuAppBar => _getImagesAssets("pattern_menu_main_menu_app_bar.png");
  String get imagePatternGrey => _getImagesAssets("pattern_grey.png");
  String get imagePatternGrey2 => _getImagesAssets("pattern_grey_2.png");
  String get imagePatternGrey3 => _getImagesAssets("pattern_grey_3.png");
  String get imagePatternBlue => _getImagesAssets("pattern_blue.png");
  String get imagePatternLightBlue => _getImagesAssets("pattern_light_blue.png");
  String get imagePatternOrange => _getImagesAssets("pattern_orange.png");
  String get imagePatternBlackSquare => _getImagesAssets("pattern_black_square.png");
  String get imageProductViralBackground => _getImagesAssets("product_viral_background.jpeg");
  String get imageCoupon => _getImagesAssets("coupon.png");
  String get imageAffiliate => _getImagesAssets("affiliate.png");
  String get imageMsmePartner => _getImagesAssets("msme_partner.png");
  String get imageHelpMessage => _getImagesAssets("help_message.png");
  String get imageBadgeBlue => _getImagesAssets("badge_blue.png");
  String get imageBadgeOrange => _getImagesAssets("badge_orange.png");
  String get imagePersonalVerification => _getImagesAssets("personal_verification.png");
  String get imageSelectedBeautyBrand => _getImagesAssets("selected_beauty_brand.png");
  String get imageEmptyError => _getImagesAssets("empty_error.png");
  String get imageEmptyErrorAddress => _getImagesAssets("empty_error_address.png");
  String get imageEmptyErrorCart => _getImagesAssets("empty_error_cart.png");
  String get imageEmptyErrorSend => _getImagesAssets("empty_error_send.png");
  String get imageEmptyErrorTransaction => _getImagesAssets("empty_error_transaction.png");
  String get imageEmptyErrorWishlist => _getImagesAssets("empty_error_wishlist.png");

  String get baseVectorsAssetsPath => "assets/vectors/";
  String _getVectorsAssets(String vectorAssetsPath) => "$baseVectorsAssetsPath$vectorAssetsPath";
  String get vectorLocation => _getVectorsAssets("location.svg");
  String get vectorHomeSelected => _getVectorsAssets("mainmenu/home_selected.svg");
  String get vectorHomeUnselected => _getVectorsAssets("mainmenu/home_unselected.svg");
  String get vectorFeedSelected => _getVectorsAssets("mainmenu/feed_selected.svg");
  String get vectorFeedUnselected => _getVectorsAssets("mainmenu/feed_unselected.svg");
  String get vectorExploreSelected => _getVectorsAssets("mainmenu/explore_selected.svg");
  String get vectorExploreUnselected => _getVectorsAssets("mainmenu/explore_unselected.svg");
  String get vectorWishlistSelected => _getVectorsAssets("mainmenu/wishlist_selected.svg");
  String get vectorWishlistUnselected => _getVectorsAssets("mainmenu/wishlist_unselected.svg");
  String get vectorMenuSelected => _getVectorsAssets("mainmenu/menu_selected.svg");
  String get vectorMenuUnselected => _getVectorsAssets("mainmenu/menu_unselected.svg");
  String get vectorLove => _getVectorsAssets("love.svg");
  String get vectorTrash => _getVectorsAssets("trash.svg");
  String get vectorBag => _getVectorsAssets("bag.svg");
  String get vectorBagBlack => _getVectorsAssets("bag_black.svg");
  String get vectorCart => _getVectorsAssets("cart.svg");
  String get vectorInbox => _getVectorsAssets("inbox.svg");
  String get vectorNotification => _getVectorsAssets("notification.svg");
  String get vectorMinusCircle => _getVectorsAssets("minus_circle.svg");
  String get vectorPlusCircle => _getVectorsAssets("plus_circle.svg");
  String get vectorArrow => _getVectorsAssets("arrow.svg");
  String get vectorDiscount => _getVectorsAssets("discount.svg");
  String get vectorWishlist => _getVectorsAssets("wishlist.svg");
  String get vectorTransactionList => _getVectorsAssets("transaction_list.svg");
  String get vectorDeliveryShipping => _getVectorsAssets("delivery_shipping.svg");
  String get vectorFavoriteBrand => _getVectorsAssets("favorite_brand.svg");
  String get vectorProductDiscussion => _getVectorsAssets("product_discussion.svg");
  String get vectorInbox2 => _getVectorsAssets("inbox_2.svg");
  String get vectorSupportMessage => _getVectorsAssets("support_message.svg");
  String get vectorAddressList => _getVectorsAssets("address_list.svg");
  String get vectorAccountSecurity => _getVectorsAssets("account_security.svg");
  String get vectorNotificationConfiguration => _getVectorsAssets("notification_configuration.svg");
  String get vectorAccountPrivacy => _getVectorsAssets("account_privacy.svg");
  String get vectorLogout => _getVectorsAssets("logout.svg");
  String get vectorShare => _getVectorsAssets("share.svg");
  String get vectorCoupon => _getVectorsAssets("coupon.svg");
  String get vectorOrderBag => _getVectorsAssets("order_bag.svg");
  String get vectorIsRunningOrder => _getVectorsAssets("is_running_order.svg");
  String get vectorWaitingForPaymentOrder => _getVectorsAssets("waiting_for_payment_order.svg");
  String get vectorCheckYourContributionDeliveryReviewFullReview => _getVectorsAssets("check_your_contribution_delivery_review_full_review.svg");
  String get vectorCheckYourContributionDeliveryReviewPhotoAndVideo => _getVectorsAssets("check_your_contribution_delivery_review_photo_and_video.svg");
  String get vectorCheckYourContributionDeliveryReviewRating => _getVectorsAssets("check_your_contribution_delivery_review_rating.svg");
  String get vectorCameraOutline => _getVectorsAssets("camera_outline.svg");
  String get vectorTripleLines => _getVectorsAssets("triple_lines.svg");
  String get vectorChat => _getVectorsAssets("chat.svg");
  String get vectorDeliveryReview2 => _getVectorsAssets("delivery_review_2.svg");
  String get vectorProductDiscussion2 => _getVectorsAssets("product_discussion_2.svg");
  String get vectorDirectChat => _getVectorsAssets("direct_chat.svg");
  String get vectorSendMessage => _getVectorsAssets("send_message.svg");
  String get vectorStep1WaitingConfirmation => _getVectorsAssets("step_1_waiting_confirmation.svg");
  String get vectorStep1WaitingConfirmationGreyscale => _getVectorsAssets("step_1_waiting_confirmation_greyscale.svg");
  String get vectorStep2IsBeingProcessed => _getVectorsAssets("step_2_is_being_processed.svg");
  String get vectorStep2IsBeingProcessedGreyscale => _getVectorsAssets("step_2_is_being_processed_greyscale.svg");
  String get vectorStep3ReadyToSend => _getVectorsAssets("step_3_ready_to_send.svg");
  String get vectorStep3ReadyToSendGreyscale => _getVectorsAssets("step_3_ready_to_send_greyscale.svg");
  String get vectorStep4IsSending => _getVectorsAssets("step_4_is_sending.svg");
  String get vectorStep4IsSendingGreyscale => _getVectorsAssets("step_4_is_sending_greyscale.svg");
  String get vectorStep5IsArrived => _getVectorsAssets("step_5_is_arrived.svg");
  String get vectorStep5IsArrivedGreyscale => _getVectorsAssets("step_5_is_arrived_greyscale.svg");
  String get vectorPinLock => _getVectorsAssets("pin_lock.svg");
  String get vectorNotificationIconCart => _getVectorsAssets("notification_icon_cart.svg");
  String get vectorNotificationIconInbox => _getVectorsAssets("notification_icon_inbox.svg");
  String get vectorNotificationIconNotif => _getVectorsAssets("notification_icon_notif.svg");
  String get vectorAboutMasterbagasi => _getVectorsAssets("about_masterbagasi.svg");
  String get vectorTermsAndConditions => _getVectorsAssets("terms_and_conditions.svg");
  String get vectorPrivacyPolicy => _getVectorsAssets("privacy_policy.svg");
  String get vectorIntellectualPropertyRights => _getVectorsAssets("intellectual_property_rights.svg");
  String get vectorReviewThisApplication => _getVectorsAssets("review_this_application.svg");

  Color get colorYellow => const Color.fromRGBO(244, 184, 43, 1);
  Color get colorLightRed => const Color.fromRGBO(255, 236, 230, 1);
  Color get colorRed => const Color.fromRGBO(255, 86, 76, 1);
  Color get colorRedDanger => const Color.fromRGBO(203, 58, 49, 1);
  Color get colorGrey => const Color.fromRGBO(174, 174, 174, 1);
  Color get colorGrey2 => const Color.fromRGBO(213, 213, 213, 1);
  Color get colorGrey3 => const Color.fromRGBO(179, 179, 179, 1);
  Color get colorGrey4 => const Color.fromRGBO(244, 244, 244, 1);
  Color get colorGrey5 => const Color.fromRGBO(235, 235, 235, 1);
  Color get colorGrey6 => const Color.fromRGBO(209, 211, 217, 1);
  Color get colorGrey7 => const Color.fromRGBO(110, 110, 110, 1);
  Color get colorGrey8 => ColorHelper.convertFromAlphaEnabledToNonAlphaEnabledColor(
    const Color.fromRGBO(44, 44, 44, 0.4)
  );
  Color get colorGrey9 => ColorHelper.convertFromAlphaEnabledToNonAlphaEnabledColor(
    const Color.fromRGBO(0, 0, 0, 0.2)
  );
  Color get colorSurfaceGrey => const Color.fromRGBO(247, 247, 247, 1);
  Color get colorDarkGrey => const Color.fromRGBO(105, 105, 105, 1);
  Color get colorBrown => const Color.fromRGBO(191, 105, 25, 1);
  Color get colorSuccessGreen => const Color.fromRGBO(67, 147, 108, 1);
  Color get colorSuccessLightGreen => const Color.fromRGBO(199, 246, 212, 1);
  Color get colorDarkBlack => const Color.fromRGBO(57, 57, 57, 1);
  Color get colorSurfaceBlue => const Color.fromRGBO(209, 233, 238, 1);
  Color get colorDarkBlue => const Color.fromRGBO(37, 37, 140, 1);
  Color get colorDarkBlue2 => const Color.fromRGBO(32, 107, 126, 1);
  Color get colorLightBlue => const Color.fromRGBO(199, 239, 251, 1);
  Color get colorLightBlue2 => const Color.fromRGBO(238, 245, 255, 1);
  Color get colorLightOrange => const Color.fromRGBO(255, 208, 191, 1);

  Color get colorMain => const Color.fromRGBO(255, 66, 0, 1);
  Color get colorDarkMain => colorMain;
  Color get colorNonActiveDotIndicator => colorSurfaceBlue;
  Color get colorDivider => colorGrey2;
  Color get colorBottomNavigationBarIconAndLabel => colorGrey2;
  Color get colorSpacingListItem => const Color.fromRGBO(245, 245, 245, 1);
  Color get colorTitleUserDetail => const Color.fromRGBO(142, 142, 142, 1);
  Color get colorProductItemDiscountOrNormal => const Color.fromRGBO(142, 142, 142, 1);
  Color get colorProductItemBorder => const Color.fromRGBO(201, 201, 201, 1);
  Color get colorProductItemSold => colorGrey;
  Color get colorProductItemReview => colorGrey;
  Color colorTrainingPreEmploymentChip(BuildContext context) => Theme.of(context).colorScheme.primary;
  Color get colorDefaultChip => const Color.fromRGBO(201, 201, 201, 1);
  Color get colorTitle => colorDarkBlack;
  Color get colorHyperlink => const Color.fromRGBO(50, 103, 227, 1);
  Color get colorTextFieldBorder => const Color.fromRGBO(220, 220, 220, 1);
  Color get colorPasswordObscurer => const Color.fromRGBO(41, 45, 50, 1);
  Color get colorPlaceholder => const Color.fromRGBO(201, 201, 201, 1);
  Color get colorBaseShimmer => const Color.fromRGBO(201, 201, 201, 1);
  Color get colorHighlightShimmer => const Color.fromRGBO(142, 142, 142, 1);
  Color get colorTabUnselected => colorGrey;
  Color get colorBarBackground => colorGrey4;
  Color get colorWishlistButton => colorGrey4;
  Color get colorWishlistIcon => colorGrey3;
  Color get colorActiveWishlistIcon => colorMain;
  Color get colorFeedbackDateText => colorGrey;
  Color get colorLike => colorRed;
  Color get colorDiscount => colorBrown;
  Color get colorSelectedFilterButton => colorSurfaceBlue;
  Color get colorButtonGradient1 => const Color.fromRGBO(16, 16, 91, 1);
  Color get colorButtonGradient2 => const Color.fromRGBO(255, 66, 0, 1);
  Color get colorButtonGradient3 => const Color.fromRGBO(0, 169, 234, 1);

  Gradient get buttonGradient => SweepGradient(
    stops: const [0, 0.25, 0.25, 0.5, 0.5, 1],
    colors: [Constant.colorButtonGradient1, Constant.colorButtonGradient1, Constant.colorButtonGradient2, Constant.colorButtonGradient2, Constant.colorButtonGradient3, Constant.colorButtonGradient3],
  );

  Gradient get buttonGradient2 => SweepGradient(
    stops: const [0, 0.25, 0.25, 0.5, 0.5, 1],
    colors: [Constant.colorButtonGradient1, Constant.colorButtonGradient1, Constant.colorButtonGradient3, Constant.colorButtonGradient3, Constant.colorButtonGradient2, Constant.colorButtonGradient2],
  );

  Gradient get buttonGradient3 => LinearGradient(
    stops: const [1],
    colors: [Constant.colorGrey7]
  );

  double get heightSpacingListItem => 1.h;
  double get paddingListItem => 4.w;
  double get spacingListItem => 2.w;
  double get iconSpacing => 7.w;
  BorderRadius get inputBorderRadius => BorderRadius.circular(5.0);
  double get inputBorderWidth => 1.5;
  int get dummyLoadingTimeInSeconds => 1;
  double get bannerMarginTopHeight => 130.0;
  double get bannerIndicatorAreaHeight => 40.0;

  AspectRatioValue get aspectRatioValueProductImage => AspectRatioValue(width: 1.0, height: 1.0);
  AspectRatioValue get aspectRatioValueImageCheckRatesForVariousCountries => AspectRatioValue(width: 360.0, height: 118.0);
  AspectRatioValue get aspectRatioValueBrandImage => AspectRatioValue(width: 332.0, height: 75.62);
  AspectRatioValue get aspectRatioValueProductBundleArea => AspectRatioValue(width: 350.0, height: 198.0);
  AspectRatioValue get aspectRatioValueProductBundleImage => AspectRatioValue(width: 246.94, height: 176.94);
  AspectRatioValue get aspectRatioValueShortVideo => AspectRatioValue(width: 254.0, height: 466.0);
  AspectRatioValue get aspectRatioValueDefaultVideo => AspectRatioValue(width: 16.0, height: 9.0);
  AspectRatioValue get aspectRatioValueNewsThumbnail => AspectRatioValue(width: 16.0, height: 9.0);
  AspectRatioValue get aspectRatioValueProductEntryHeader => AspectRatioValue(width: 360.0, height: 109.0);
  AspectRatioValue get aspectRatioValueExploreNusantaraBackground => AspectRatioValue(width: 361.0, height: 248.0);
  AspectRatioValue get aspectRatioValueExploreNusantaraBanner => AspectRatioValue(width: 361.0, height: 248.0);
  AspectRatioValue get aspectRatioValueExploreNusantaraIcon => AspectRatioValue(width: 544.0, height: 408.0);
  AspectRatioValue get aspectRatioValueTransparentBanner => AspectRatioValue(width: 2500.0, height: 986.0);
  AspectRatioValue get aspectRatioValueHomepageBanner => AspectRatioValue(width: 2126.0, height: 1181.0);
  AspectRatioValue get aspectRatioValueShippingPriceBanner => AspectRatioValue(width: 692.0, height: 456.0);
  AspectRatioValue get aspectRatioValueSponsorBanner => AspectRatioValue(width: 360.0, height: 270.0);
  AspectRatioValue get aspectRatioValueCountryDeliveryReviewCountryBackground => AspectRatioValue(width: 360.0, height: 109.0);

  MultiLanguageString get multiLanguageStringIsViral => MultiLanguageString({
    textEnUsLanguageKey: "Is Viral",
    textInIdLanguageKey: "Lagi Viral"
  });
  MultiLanguageString get multiLanguageStringOtherFromThisBrand => MultiLanguageString({
    Constant.textEnUsLanguageKey: "Other From This Brand",
    Constant.textInIdLanguageKey: "Lainnya Dari Brand Ini"
  });
  MultiLanguageString get multiLanguageStringOtherChosenForYou => MultiLanguageString({
    Constant.textEnUsLanguageKey: "Other Chosen For You",
    Constant.textInIdLanguageKey: "Pilihan Lainnya Untukmu"
  });
  MultiLanguageString get multiLanguageStringOtherInThisCategory => MultiLanguageString({
    Constant.textEnUsLanguageKey: "Other In This Category",
    Constant.textInIdLanguageKey: "Lainnya Di Kategory Ini"
  });
  MultiLanguageString get multiLanguageStringFromYourSearch => MultiLanguageString({
    Constant.textEnUsLanguageKey: "From Your Search",
    Constant.textInIdLanguageKey: "Dari Pencarianmu"
  });
  MultiLanguageString get multiLanguageStringOtherInterestedProductBrand => MultiLanguageString({
    Constant.textEnUsLanguageKey: "Other Interested Brand",
    Constant.textInIdLanguageKey: "Brand Menarik Lainnya"
  });
  MultiLanguageString get multiLanguageStringSelectedFashionBrands => MultiLanguageString({
    Constant.textEnUsLanguageKey: "Selected Fashion Brands",
    Constant.textInIdLanguageKey: "Brand Fesyen Pilihan"
  });
  MultiLanguageString get multiLanguageStringChoiceBeautyBrand => MultiLanguageString({
    Constant.textEnUsLanguageKey: "Choice Beauty Brand",
    Constant.textInIdLanguageKey: "Brand Kecantikan Pilihan"
  });

  String get settingHiveTable => 'setting_hive_table';
  String get settingHiveTableKey => 'setting_hive_table_key';
  String get languageSettingHiveTableKey => 'setting_language_hive_table_key';
  String get hasVisitedIntroductionPageHiveTableKey => 'has_visited_introduction_hive_table_key';
  String get tempLoginDataWhileInputPinHiveTableKey => 'temp_login_data_while_input_pin_hive_table_key';
  String get textIdKey => 'id';
  String get textTypeKey => 'type';
  String get textUrlKey => 'url';
  String get textEncodedUrlKey => 'encoded-url';
  String get textEmpty => "(${"Empty".tr})";
  String get textLoading => "Loading".tr;
  String get textEnUsLanguageKey => "en_US";
  String get textInIdLanguageKey => "in_ID";
  String get textTermAndConditionsUrl => "https://m.masterbagasi.com/terms-and-conditions";
  String get textPrivacyPolicyUrl => "https://m.masterbagasi.com/privacy-policy";

  String get carouselKeyIndonesianCategoryProduct => "carousel_key_indonesian_category_product";
  String get carouselKeyIndonesianOriginalBrand => "carousel_key_indonesian_original_brand";
  String get carouselKeyIsViral => "carousel_key_is_viral";
  String get carouselKeyProductSponsor => "carousel_key_product_sponsor";
  String get carouselKeySnackForLyingAround => "carousel_key_snack_for_lying_around";
  String get carouselKeyProductBundleHighlight => "carousel_key_product_bundle_highlight";
  String get carouselKeyBestSellingInMasterBagasi => "carousel_key_best_selling_in_master_bagasi";
  String get carouselKeySelectedFashionBrands => "carousel_key_selected_fashion_brands";
  String get carouselKeyChoiceBeautyBrand => "carousel_key_choice_beauty_brand";
  String get carouselKeyCoffeeAndTeaOriginIndonesia => "carousel_key_coffee_and_tea_origin_indonesia";
  String get carouselKeyBeautyProductIndonesia => "carousel_key_beauty_product_indonesia";
  String get carouselKeyFashionProductIndonesia => "carousel_key_fashion_product_indonesia";
  String get carouselKeyReadyToEatStreetFoodStyle => "carousel_key_ready_to_eat_street_food_style";
  String get carouselKeyOnlyForYou => "carousel_key_only_for_you";
  String get carouselKeyDeliveryReview => "carousel_key_delivery_review";
  String get carouselKeyNews => "carousel_key_news";
  String get carouselKeyShortMyCart => "carousel_key_short_my_cart";
  String get carouselKeyProductDetailOtherFromThisBrand => "carousel_key_product_detail_other_from_this_brand";
  String get carouselKeyProductDetailOtherChosenForYou => "carousel_key_product_detail_other_chosen_for_you";
  String get carouselKeyProductDetailOtherInThisCategory => "carousel_key_product_detail_other_in_this_category";
  String get carouselKeyProductDetailFromYourSearch => "carousel_key_product_detail_from_your_search";
  String get carouselKeyProductDetailOtherInterestedBrand => "carousel_key_product_detail_other_interested_brand";

  String get transparentBannerKeyKitchenContents => "transparent_banner_key_kitchen_contents";
  String get transparentBannerKeyHandycrafts => "transparent_banner_key_handycrafts";
  String get transparentBannerKeyMultipleHomepage => "transparent_banner_key_multiple_homepage";
  String get transparentBannerKeyMultipleShippingPrice => "transparent_banner_key_multiple_shipping_price";
  String get transparentBannerKeySponsor => "transparent_banner_key_sponsor";

  String get subPageKeyHomeMainMenu => "sub_page_key_home_main_menu";
  String get subPageKeyFeedMainMenu => "sub_page_key_feed_main_menu";
  String get subPageKeyExploreNusantaraMainMenu => "sub_page_key_explore_nusantara_main_menu";
  String get subPageKeyWishlistMainMenu => "sub_page_key_wishlist_main_menu";
  String get subPageKeyMenuMainMenu => "sub_page_key_menu_main_menu";
  String get addToCartTypeProductEntry => "add_to_cart_type_product_entry";
  String get addToCartTypeProductBundle => "add_to_cart_type_product_bundle";
}

// ignore: non_constant_identifier_names
final Constant = _ConstantImpl();