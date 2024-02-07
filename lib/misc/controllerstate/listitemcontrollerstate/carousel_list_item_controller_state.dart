import 'package:flutter/material.dart';

import '../../../presentation/widget/titleanddescriptionitem/title_and_description_item.dart';
import '../../carouselbackground/carousel_background.dart';
import '../../carousellistitemtype/carousel_list_item_type.dart';
import '../../shimmercarousellistitemgenerator/shimmer_carousel_list_item_generator.dart';
import '../../shimmercarousellistitemgenerator/type/shimmer_carousel_list_item_generator_type.dart';
import 'list_item_controller_state.dart';

class CarouselListItemControllerState extends ListItemControllerState {
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? additionalPadding;
  double? betweenTitleDescriptionAndCarouselItemVerticalSpace;
  List<ListItemControllerState> itemListItemControllerState;
  String title;
  TitleInterceptor? titleInterceptor;
  String description;
  DescriptionInterceptor? descriptionInterceptor;
  CarouselBackground? carouselBackground;
  CarouselListItemType? carouselListItemType;

  CarouselListItemControllerState({
    this.padding,
    this.additionalPadding,
    this.betweenTitleDescriptionAndCarouselItemVerticalSpace,
    this.itemListItemControllerState = const [],
    this.title = "",
    this.titleInterceptor,
    this.description = "",
    this.descriptionInterceptor,
    this.carouselBackground,
    this.carouselListItemType
  });
}

class ShimmerCarouselListItemControllerState<G extends ShimmerCarouselListItemGeneratorType> extends ListItemControllerState {
  EdgeInsetsGeometry? padding;
  double? betweenTitleDescriptionAndCarouselItemVerticalSpace;
  bool showTitleShimmer;
  bool showDescriptionShimmer;
  bool showItemShimmer;
  ShimmerCarouselListItemGenerator<G> shimmerCarouselListItemGenerator;

  ShimmerCarouselListItemControllerState({
    this.padding,
    this.betweenTitleDescriptionAndCarouselItemVerticalSpace,
    this.showTitleShimmer = true,
    this.showDescriptionShimmer = true,
    this.showItemShimmer = true,
    required this.shimmerCarouselListItemGenerator
  });
}