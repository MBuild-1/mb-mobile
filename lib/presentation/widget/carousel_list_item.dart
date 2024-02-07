import 'package:flutter/material.dart' hide Banner;
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import '../../misc/carousellistitemtype/carousel_list_item_type.dart';
import '../../misc/carousellistitemtype/default_carousel_list_item_type.dart';
import '../../misc/carousellistitemtype/tile_carousel_list_item_Type.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/shimmercarousellistitemgenerator/shimmer_carousel_list_item_generator.dart';
import '../../misc/shimmercarousellistitemgenerator/type/shimmer_carousel_list_item_generator_type.dart';
import '../../misc/typedef.dart';
import 'horizontal_scalable.dart';
import 'modified_shimmer.dart';
import 'titleanddescriptionitem/title_and_description_item.dart';

class CarouselListItem<T> extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? additionalPadding;
  final double? betweenTitleDescriptionAndCarouselItemVerticalSpace;
  final String title;
  final TitleInterceptor? titleInterceptor;
  final String description;
  final DescriptionInterceptor? descriptionInterceptor;
  final List<T> itemList;
  final WidgetBuilderWithItem<T> builderWithItem;
  final Widget? backgroundImage;
  final double? backgroundImageHeight;
  final CarouselListItemType? carouselListItemType;

  const CarouselListItem({
    Key? key,
    this.padding,
    this.additionalPadding,
    this.betweenTitleDescriptionAndCarouselItemVerticalSpace,
    this.title = "",
    this.titleInterceptor,
    this.description = "",
    this.descriptionInterceptor,
    required this.itemList,
    required this.builderWithItem,
    this.backgroundImage,
    this.backgroundImageHeight,
    this.carouselListItemType
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _InnerCarouselListItem<T>(
      padding: padding,
      additionalPadding: additionalPadding,
      betweenTitleDescriptionAndCarouselItemVerticalSpace: betweenTitleDescriptionAndCarouselItemVerticalSpace,
      title: title,
      titleInterceptor: titleInterceptor,
      description: description,
      descriptionInterceptor: descriptionInterceptor,
      itemList: itemList,
      builderWithItem: builderWithItem,
      backgroundImage: backgroundImage,
      backgroundImageHeight: backgroundImageHeight,
      carouselListItemType: carouselListItemType
    );
  }
}

class ShimmerCarouselListItem<G extends ShimmerCarouselListItemGeneratorType> extends StatelessWidget {
  final WidgetBuilderWithItem<ListItemControllerState> builderWithItem;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? additionalPadding;
  final double? betweenTitleDescriptionAndCarouselItemVerticalSpace;
  final bool showTitleShimmer;
  final bool showDescriptionShimmer;
  final bool showItemShimmer;
  final ShimmerCarouselListItemGenerator<G> shimmerCarouselListItemGenerator;
  final Widget? backgroundImage;

  const ShimmerCarouselListItem({
    Key? key,
    required this.builderWithItem,
    this.padding,
    this.additionalPadding,
    this.betweenTitleDescriptionAndCarouselItemVerticalSpace,
    required this.showTitleShimmer,
    required this.showDescriptionShimmer,
    required this.showItemShimmer,
    required this.shimmerCarouselListItemGenerator,
    this.backgroundImage
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ModifiedShimmer.fromColors(
        child: _InnerCarouselListItem<ListItemControllerState>(
          padding: padding,
          additionalPadding: additionalPadding,
          betweenTitleDescriptionAndCarouselItemVerticalSpace: betweenTitleDescriptionAndCarouselItemVerticalSpace,
          title: showTitleShimmer ? "Dummy Title" : "",
          description: showDescriptionShimmer ? "Dummy Description" : "",
          itemList: List<ListItemControllerState>.generate(10, (index) {
            return shimmerCarouselListItemGenerator.onGenerateListItemValue();
          }),
          builderWithItem: builderWithItem,
        )
      )
    );
  }
}

class _InnerCarouselListItem<T> extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? additionalPadding;
  final double? betweenTitleDescriptionAndCarouselItemVerticalSpace;
  final String title;
  final TitleInterceptor? titleInterceptor;
  final String description;
  final DescriptionInterceptor? descriptionInterceptor;
  final List<T> itemList;
  final WidgetBuilderWithItem<T> builderWithItem;
  final Widget? backgroundImage;
  final double? backgroundImageHeight;
  final CarouselListItemType? carouselListItemType;

  const _InnerCarouselListItem({
    Key? key,
    this.padding,
    this.additionalPadding,
    this.betweenTitleDescriptionAndCarouselItemVerticalSpace,
    required this.title,
    this.titleInterceptor,
    required this.description,
    this.descriptionInterceptor,
    required this.itemList,
    required this.builderWithItem,
    this.backgroundImage,
    this.backgroundImageHeight,
    this.carouselListItemType
  }) : super(key: key);

  @override
  State<_InnerCarouselListItem<T>> createState() => _InnerCarouselListItemState<T>();
}

class _InnerCarouselListItemState<T> extends State<_InnerCarouselListItem<T>> with AutomaticKeepAliveClientMixin<_InnerCarouselListItem<T>> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    double? verticalSpace = widget.betweenTitleDescriptionAndCarouselItemVerticalSpace;
    double? left;
    double? top;
    double? right;
    double? bottom;
    if (widget.padding is EdgeInsets) {
      EdgeInsets edgeInsets = widget.padding as EdgeInsets;
      left = edgeInsets.left;
      top = edgeInsets.top;
      right = edgeInsets.right;
      bottom = edgeInsets.bottom;
    } else if (widget.padding is EdgeInsetsDirectional) {
      EdgeInsetsDirectional edgeInsetsDirectional = widget.padding as EdgeInsetsDirectional;
      left = edgeInsetsDirectional.start;
      top = edgeInsetsDirectional.top;
      right = edgeInsetsDirectional.end;
      bottom = edgeInsetsDirectional.bottom;
    }
    bool hasBackgroundImage = widget.backgroundImage != null;
    double effectiveBackgroundImageHeight = widget.backgroundImageHeight ?? 200;
    return Stack(
      children: [
        if (hasBackgroundImage && effectiveBackgroundImageHeight > 0.0)
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(),
            width: double.infinity,
            height: effectiveBackgroundImageHeight,
            child: FittedBox(
              fit: BoxFit.cover,
              child: widget.backgroundImage,
            )
          ),
        Builder(
          builder: (context) {
            Widget result = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasBackgroundImage)
                  SizedBox(height: Constant.paddingListItem),
                TitleAndDescriptionItem(
                  padding: EdgeInsets.only(
                    left: left ?? Constant.paddingListItem,
                    top: top ?? Constant.paddingListItem,
                    right: right ?? Constant.paddingListItem,
                  ),
                  title: widget.title,
                  titleInterceptor: widget.titleInterceptor,
                  description: widget.description,
                  descriptionInterceptor: widget.descriptionInterceptor,
                  verticalSpace: 0.3.h,
                ),
                if (!widget.title.isEmptyString || !widget.description.isEmptyString)
                  SizedBox(height: verticalSpace ?? Constant.paddingListItem),
                Builder(
                  builder: (BuildContext context) {
                    CarouselListItemType? carouselListItemType = widget.carouselListItemType;
                    if (carouselListItemType is TileCarouselListItemType) {
                      double spacing = 10.0;
                      double count = 2;
                      return SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: widget.itemList.take(4).map<Widget>((item) {
                            Widget result = widget.builderWithItem(context, item);
                            if (result is HorizontalScalable) {
                              double width = (MediaQuery.of(context).size.width - (2 * Constant.paddingListItem) - (spacing * (count - 1))) / count;
                              (result as HorizontalScalable).horizontalScalableValue.scalableItemWidth = width;
                            }
                            return result;
                          }).toList(),
                        ),
                      );
                    }
                    double leftAdditional = 0.0;
                    double rightAdditional = 0.0;
                    EdgeInsetsGeometry? effectiveAdditionalPadding;
                    if (carouselListItemType is DefaultCarouselListItemType) {
                      effectiveAdditionalPadding = carouselListItemType.additionalPadding;
                    } else {
                      effectiveAdditionalPadding = widget.additionalPadding;
                    }
                    if (effectiveAdditionalPadding is EdgeInsets) {
                      EdgeInsets edgeInsets = effectiveAdditionalPadding;
                      leftAdditional = edgeInsets.left;
                      rightAdditional = edgeInsets.right;
                    } else if (effectiveAdditionalPadding is EdgeInsetsDirectional) {
                      EdgeInsetsDirectional edgeInsetsDirectional = effectiveAdditionalPadding;
                      leftAdditional = edgeInsetsDirectional.start;
                      rightAdditional = edgeInsetsDirectional.end;
                    }
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(
                        left: (left ?? Constant.paddingListItem) + leftAdditional,
                        right: (right ?? Constant.paddingListItem) + rightAdditional,
                      ),
                      child: Builder(
                        builder: (context) {
                          List<Widget> itemMap = [];
                          int i = 0;
                          while (i < widget.itemList.length) {
                            if (i > 0) {
                              itemMap.add(SizedBox(width: 3.w));
                            }
                            itemMap.add(widget.builderWithItem(context, widget.itemList[i]));
                            i++;
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: itemMap,
                          );
                        },
                      )
                    );
                  }
                ),
                SizedBox(height: bottom ?? Constant.paddingListItem),
                if (hasBackgroundImage)
                  SizedBox(height: Constant.paddingListItem)
              ],
            );
            if (effectiveBackgroundImageHeight <= 0.0) {
              if (widget.backgroundImage is Image) {
                Image backgroundImage = widget.backgroundImage as Image;
                result = Container(
                  child: result,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: backgroundImage.image,
                      fit: BoxFit.cover
                    )
                  ),
                );
              }
            }
            return result;
          }
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}