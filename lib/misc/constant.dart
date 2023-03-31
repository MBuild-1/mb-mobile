import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'aspect_ratio_value.dart';

class _ConstantImpl {
  String get restorableRouteFuturePush => "restorable-route-future-push";
  String get restorableRouteFuturePushAndRemoveUntil => "restorable-route-future-and-remove-until";

  String get baseImagesAssetsPath => "assets/images/";
  String _getImagesAssets(String imageAssetsPath) => "$baseImagesAssetsPath$imageAssetsPath";
  String get imageIntroduction1 => _getImagesAssets("introduction_1.png");
  String get imageIntroduction2 => _getImagesAssets("introduction_2.png");
  String get imageIntroduction3 => _getImagesAssets("introduction_3.png");
  String get imageLogoSuperIndo => _getImagesAssets("logo_superindo.png");
  String get imageSuccess => _getImagesAssets("success.png");
  String get imageFailed => _getImagesAssets("failed.png");
  String get imageNoInternet => imageFailed;
  String get imageLogin => _getImagesAssets("login.png");
  String get imageStar => _getImagesAssets("star.png");
  String get imageCheckRatesForVariousCountries => _getImagesAssets("check_rates_for_various_countries.png");
  String get imageProductPlaceholder => _getImagesAssets("product_placeholder.png");

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

  Color get colorYellow => const Color.fromRGBO(244, 184, 43, 1);
  Color get colorRed => const Color.fromRGBO(255, 86, 76, 1);
  Color get colorRedDanger => const Color.fromRGBO(203, 58, 49, 1);
  Color get colorGrey => const Color.fromRGBO(174, 174, 174, 1);
  Color get colorGrey2 => const Color.fromRGBO(213, 213, 213, 1);
  Color get colorGrey3 => const Color.fromRGBO(179, 179, 179, 1);
  Color get colorGrey4 => const Color.fromRGBO(244, 244, 244, 1);
  Color get colorGrey5 => const Color.fromRGBO(235, 235, 235, 1);
  Color get colorSurfaceGrey => const Color.fromRGBO(247, 247, 247, 1);
  Color get colorDarkGrey => const Color.fromRGBO(105, 105, 105, 1);
  Color get colorBrown => const Color.fromRGBO(191, 105, 25, 1);
  Color get colorSuccessGreen => const Color.fromRGBO(67, 147, 108, 1);
  Color get colorDarkBlack => const Color.fromRGBO(57, 57, 57, 1);
  Color get colorSurfaceBlue => const Color.fromRGBO(209, 233, 238, 1);
  Color get colorDarkBlue => const Color.fromRGBO(37, 37, 140, 1);

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
  Color get colorFeedbackDateText => colorGrey;
  Color get colorLike => colorRed;
  Color get colorDiscount => colorBrown;
  Color get colorSelectedFilterButton => colorSurfaceBlue;
  Color get colorButtonGradient1 => const Color.fromRGBO(16, 16, 91, 1);
  Color get colorButtonGradient2 => const Color.fromRGBO(255, 66, 0, 1);
  Color get colorButtonGradient3 => const Color.fromRGBO(0, 169, 234, 1);

  double get heightSpacingListItem => (1.5).h;
  double get paddingListItem => 4.w;
  double get spacingListItem => 2.w;
  double get iconSpacing => 7.w;
  BorderRadius get inputBorderRadius => BorderRadius.circular(16.0);
  double get inputBorderWidth => 1.5;
  int get dummyLoadingTimeInSeconds => 1;
  double get bannerMarginTopHeight => 130.0;
  double get bannerIndicatorAreaHeight => 40.0;

  AspectRatioValue get aspectRatioValueProductImage => AspectRatioValue(width: 1.0, height: 1.0);
  AspectRatioValue get aspectRatioValueImageCheckRatesForVariousCountries => AspectRatioValue(width: 360.0, height: 118.0);
  AspectRatioValue get aspectRatioValueBrandImage => AspectRatioValue(width: 332.0, height: 75.62);
  AspectRatioValue get aspectRatioValueProductBundleArea => AspectRatioValue(width: 350.0, height: 198.0);
  AspectRatioValue get aspectRatioValueProductBundleImage => AspectRatioValue(width: 246.94, height: 176.94);

  String get settingHiveTable => 'setting_hive_table';
  String get settingHiveTableKey => 'setting_hive_table_key';
  String get languageSettingHiveTableKey => 'setting_language_hive_table_key';
  String get hasVisitedIntroductionPageHiveTableKey => 'has_visited_introduction_hive_table_key';
  String get textIdKey => 'id';
  String get textTypeKey => 'type';
  String get textUrlKey => 'url';
  String get textEncodedUrlKey => 'encoded-url';
  String get textEmpty => "(${"Empty".tr})";
  String get textLoading => "Loading".tr;
  String get textEnUsLanguageKey => "en_US";
  String get textInIdLanguageKey => "in_ID";
}

// ignore: non_constant_identifier_names
final Constant = _ConstantImpl();