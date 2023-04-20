import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart' hide Notification, Banner;
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../domain/entity/product/product.dart';
import '../../../presentation/widget/carousel_list_item.dart';
import '../../../presentation/widget/colorful_chip_tab_bar.dart';
import '../../../presentation/widget/coupon/horizontal_coupon_item.dart';
import '../../../presentation/widget/coupon/vertical_coupon_item.dart';
import '../../../presentation/widget/icon_title_and_description_list_item.dart';
import '../../../presentation/widget/modifiedassetimage/modified_asset_image.dart';
import '../../../presentation/widget/modifiedcachednetworkimage/modified_cached_network_image.dart';
import '../../../presentation/widget/modified_colorful_divider.dart';
import '../../../presentation/widget/modified_divider.dart';
import '../../../presentation/widget/modified_svg_picture.dart';
import '../../../presentation/widget/modified_tab_bar.dart';
import '../../../presentation/widget/modifiedcachednetworkimage/product_modified_cached_network_image.dart';
import '../../../presentation/widget/news/horizontal_news_item.dart';
import '../../../presentation/widget/news/vertical_news_item.dart';
import '../../../presentation/widget/product/horizontal_product_item.dart';
import '../../../presentation/widget/product/vertical_product_item.dart';
import '../../../presentation/widget/product_bundle_header_list_item.dart';
import '../../../presentation/widget/product_bundle_highlight_list_item.dart';
import '../../../presentation/widget/product_category_header_list_item.dart';
import '../../../presentation/widget/product_detail_brand_list_item.dart';
import '../../../presentation/widget/productbrand/circleproductbrand/horizontal_circle_product_brand_item.dart';
import '../../../presentation/widget/productbrand/circleproductbrand/vertical_circle_product_brand_item.dart';
import '../../../presentation/widget/productbrand/horizontal_product_brand_item.dart';
import '../../../presentation/widget/productbrand/vertical_product_brand_item.dart';
import '../../../presentation/widget/productbundle/horizontal_product_bundle_item.dart';
import '../../../presentation/widget/productbundle/vertical_product_bundle_item.dart';
import '../../../presentation/widget/productcategory/circleproductcategory/horizontal_circle_product_category_item.dart';
import '../../../presentation/widget/productcategory/circleproductcategory/vertical_circle_product_category_item.dart';
import '../../../presentation/widget/productcategory/horizontal_product_category_item.dart';
import '../../../presentation/widget/productcategory/vertical_product_category_item.dart';
import '../../../presentation/widget/prompt_indicator.dart';
import '../../../presentation/widget/shimmer_carousel_item.dart';
import '../../../presentation/widget/titleanddescriptionitem/title_and_description_item.dart';
import '../../../presentation/widget/titledescriptionandcontentitem/title_description_and_content_item.dart';
import '../../../presentation/widget/product_detail_header.dart';
import '../../carouselbackground/asset_carousel_background.dart';
import '../../carouselbackground/carousel_background.dart';
import '../../constant.dart';
import '../../controllerstate/listitemcontrollerstate/carousel_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/check_rates_for_various_countries_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/colorful_chip_tab_bar_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/colorful_divider_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/column_container_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/couponlistitemcontrollerstate/coupon_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/couponlistitemcontrollerstate/horizontal_coupon_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/couponlistitemcontrollerstate/vertical_coupon_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/decorated_container_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/delivery_to_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/deliveryreviewlistitemcontrollerstate/delivery_review_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/deliveryreviewlistitemcontrollerstate/horizontal_delivery_review_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/deliveryreviewlistitemcontrollerstate/vertical_delivery_review_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/dynamic_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/empty_container_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/failed_prompt_indicator_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/icon_title_and_description_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/loading_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/non_expanded_item_in_row_child_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/non_expanded_item_in_row_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/page_keyed_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/product_bundle_header_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/product_bundle_highlight_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/product_category_header_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/product_detail_brand_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/product_detail_header_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/product_detail_image_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productbrandlistitemcontrollerstate/circleproductbrandlistitemcontrollerstate/circle_product_brand_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productbrandlistitemcontrollerstate/circleproductbrandlistitemcontrollerstate/horizontal_circle_product_brand_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productbrandlistitemcontrollerstate/circleproductbrandlistitemcontrollerstate/vertical_circle_product_brand_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productbrandlistitemcontrollerstate/horizontal_product_brand_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productbrandlistitemcontrollerstate/product_brand_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productbrandlistitemcontrollerstate/vertical_product_brand_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productbundlelistitemcontrollerstate/horizontal_product_bundle_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productbundlelistitemcontrollerstate/product_bundle_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productbundlelistitemcontrollerstate/vertical_product_bundle_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productcategorylistitemcontrollerstate/circleproductcategorylistitemcontrollerstate/circle_product_category_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productcategorylistitemcontrollerstate/circleproductcategorylistitemcontrollerstate/horizontal_circle_product_category_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productcategorylistitemcontrollerstate/circleproductcategorylistitemcontrollerstate/vertical_circle_product_category_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productcategorylistitemcontrollerstate/horizontal_product_category_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productcategorylistitemcontrollerstate/product_category_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productcategorylistitemcontrollerstate/vertical_product_category_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productlistitemcontrollerstate/horizontal_product_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productlistitemcontrollerstate/product_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/productlistitemcontrollerstate/vertical_product_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/row_container_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/single_banner_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/spacing_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/tab_bar_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/title_description_and_content_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../../controllerstate/paging_controller_state.dart';
import '../../errorprovider/error_provider.dart';
import '../../injector.dart';
import '../../listitempagingparameterinjection/list_item_paging_parameter_injection.dart';
import '../../typedef.dart';
import '../../widget_helper.dart';
import 'paging_controller_state_paged_child_builder_delegate.dart';

class ListItemPagingControllerStatePagedChildBuilderDelegate<PageKeyType> extends PagingControllerStatePagedChildBuilderDelegate<PageKeyType, ListItemControllerState> {
  final List<ListItemPagingParameterInjection> listItemPagingParameterInjectionList;

  ListItemPagingControllerStatePagedChildBuilderDelegate({
    required PagingControllerState<PageKeyType, ListItemControllerState> pagingControllerState,
    WidgetBuilderWithError? firstPageErrorIndicatorBuilderWithErrorParameter,
    WidgetBuilderWithError? newPageErrorIndicatorBuilderWithErrorParameter,
    WidgetBuilder? firstPageProgressIndicatorBuilder,
    WidgetBuilder? newPageProgressIndicatorBuilder,
    WidgetBuilder? noItemsFoundIndicatorBuilder,
    WidgetBuilder? noMoreItemsIndicatorBuilder,
    bool animateTransitions = false,
    final Duration transitionDuration = const Duration(milliseconds: 250),
    this.listItemPagingParameterInjectionList = const []
  }) : super(
    pagingControllerState: pagingControllerState,
    itemBuilder: (context, item, index) => Container(),
    firstPageErrorIndicatorBuilderWithErrorParameter: firstPageErrorIndicatorBuilderWithErrorParameter ?? (context, e) => WidgetHelper.buildFailedPromptIndicatorFromErrorProvider(
      context: context,
      errorProvider: Injector.locator<ErrorProvider>(),
      e: e
    ),
    newPageErrorIndicatorBuilderWithErrorParameter: firstPageErrorIndicatorBuilderWithErrorParameter ?? (context, e) => WidgetHelper.buildFailedPromptIndicatorFromErrorProvider(
      context: context,
      errorProvider: Injector.locator<ErrorProvider>(),
      e: e,
      promptIndicatorType: PromptIndicatorType.horizontal,
      onPressed: () => pagingControllerState.pagingController.retryLastFailedRequest(),
      buttonText: "Retry".tr
    ),
    firstPageProgressIndicatorBuilder: firstPageProgressIndicatorBuilder,
    newPageProgressIndicatorBuilder: newPageProgressIndicatorBuilder,
    noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder,
    noMoreItemsIndicatorBuilder: noMoreItemsIndicatorBuilder,
  );

  @override
  ItemWidgetBuilder<ListItemControllerState> get itemBuilder => _itemBuilder;

  Widget _itemBuilder<ListItemControllerState>(BuildContext context, ListItemControllerState item, int index) {
    if (item is FailedPromptIndicatorListItemControllerState) {
      return WidgetHelper.buildFailedPromptIndicatorFromErrorProvider(context: context, errorProvider: item.errorProvider, e: item.e);
    } else if (item is CarouselListItemControllerState || item is ShimmerCarouselListItemControllerState) {
      if (item is CarouselListItemControllerState) {
        Widget? backgroundImage;
        double? backgroundImageHeight;
        CarouselBackground? carouselBackground = item.carouselBackground;
        if (carouselBackground is AssetCarouselBackground) {
          backgroundImage = Image.asset(carouselBackground.assetImageName);
          backgroundImageHeight = carouselBackground.imageBackgroundHeight;
        }
        return CarouselListItem(
          padding: item.padding,
          itemList: item.itemListItemControllerState,
          title: item.title,
          titleInterceptor: item.titleInterceptor,
          description: item.description,
          descriptionInterceptor: item.descriptionInterceptor,
          builderWithItem: (context, listItemControllerState) => _itemBuilder(context, listItemControllerState, index),
          backgroundImage: backgroundImage,
          backgroundImageHeight: backgroundImageHeight
        );
      } else if (item is ShimmerCarouselListItemControllerState) {
        return ShimmerCarouselListItem(
          builderWithItem: (context, listItemControllerState) => _itemBuilder(context, listItemControllerState, index),
          padding: item.padding,
          showTitleShimmer: item.showTitleShimmer,
          showDescriptionShimmer: item.showDescriptionShimmer,
          showItemShimmer: item.showItemShimmer,
          shimmerCarouselListItemGenerator: item.shimmerCarouselListItemGenerator,
        );
      } else {
        return Container();
      }
    } else if (item is DefaultVideoCarouselListItemControllerState) {
      return DefaultVideoCarouselListItem(
        defaultVideoListLoadDataResult: item.defaultVideoListLoadDataResult,
      );
    } else if (item is ShortVideoCarouselListItemControllerState) {
      return ShortVideoCarouselListItem(
        shortVideoListLoadDataResult: item.shortVideoListLoadDataResult,
      );
    } else if (item is ProductListItemControllerState) {
      if (item is HorizontalProductListItemControllerState) {
        return HorizontalProductItem(
          productAppearanceData: item.productAppearanceData,
          onAddWishlist: item.onAddWishlist,
          onRemoveWishlist: item.onRemoveWishlist,
        );
      } else if (item is VerticalProductListItemControllerState) {
        if (item is ShimmerVerticalProductListItemControllerState) {
          return ShimmerVerticalProductItem(
            productAppearanceData: item.productAppearanceData,
          );
        } else {
          return VerticalProductItem(
            productAppearanceData: item.productAppearanceData,
            onAddWishlist: item.onAddWishlist,
            onRemoveWishlist: item.onRemoveWishlist,
          );
        }
      } else {
        return Container();
      }
    } else if (item is ProductCategoryListItemControllerState) {
      if (item is HorizontalProductCategoryListItemControllerState) {
        return HorizontalProductCategoryItem(productCategory: item.productCategory);
      } else if (item is VerticalProductCategoryListItemControllerState) {
        if (item is ShimmerVerticalProductCategoryListItemControllerState) {
          return ShimmerVerticalProductCategoryItem(productCategory: item.productCategory);
        } else {
          return VerticalProductCategoryItem(productCategory: item.productCategory);
        }
      } else {
        return Container();
      }
    } else if (item is CircleProductCategoryListItemControllerState) {
      if (item is HorizontalCircleProductCategoryListItemControllerState) {
        return HorizontalCircleProductCategoryItem(productCategory: item.productCategory);
      } else if (item is VerticalCircleProductCategoryListItemControllerState) {
        if (item is ShimmerVerticalCircleProductCategoryListItemControllerState) {
          return ShimmerVerticalCircleProductCategoryItem(productCategory: item.productCategory);
        } else {
          return VerticalCircleProductCategoryItem(productCategory: item.productCategory);
        }
      } else {
        return Container();
      }
    } else if (item is ProductBrandListItemControllerState) {
      if (item is HorizontalProductBrandListItemControllerState) {
        return HorizontalProductBrandItem(productBrand: item.productBrand);
      } else if (item is VerticalProductBrandListItemControllerState) {
        if (item is ShimmerVerticalProductBrandListItemControllerState) {
          return ShimmerVerticalProductBrandItem(productBrand: item.productBrand);
        } else {
          return VerticalProductBrandItem(productBrand: item.productBrand);
        }
      } else {
        return Container();
      }
    } else if (item is CircleProductBrandListItemControllerState) {
      if (item is HorizontalCircleProductBrandListItemControllerState) {
        return HorizontalCircleProductBrandItem(productBrand: item.productBrand);
      } else if (item is VerticalCircleProductBrandListItemControllerState) {
        if (item is ShimmerVerticalCircleProductBrandListItemControllerState) {
          return ShimmerVerticalCircleProductBrandItem(productBrand: item.productBrand);
        } else {
          return VerticalCircleProductBrandItem(productBrand: item.productBrand);
        }
      } else {
        return Container();
      }
    } else if (item is ProductBundleListItemControllerState) {
      if (item is HorizontalProductBundleListItemControllerState) {
        return HorizontalProductBundleItem(
          productBundle: item.productBundle,
          onAddWishlist: item.onAddWishlist,
          onRemoveWishlist: item.onRemoveWishlist,
        );
      } else if (item is VerticalProductBundleListItemControllerState) {
        if (item is ShimmerVerticalProductBundleListItemControllerState) {
          return ShimmerVerticalProductBundleItem(productBundle: item.productBundle);
        } else {
          return VerticalProductBundleItem(
            productBundle: item.productBundle,
            onAddWishlist: item.onAddWishlist,
            onRemoveWishlist: item.onRemoveWishlist,
          );
        }
      } else {
        return Container();
      }
    } else if (item is DeliveryReviewListItemControllerState) {
      if (item is HorizontalDeliveryReviewListItemControllerState) {
        return HorizontalDeliveryReviewItem(
          deliveryReview: item.deliveryReview
        );
      } else if (item is VerticalDeliveryReviewListItemControllerState) {
        if (item is ShimmerVerticalDeliveryReviewListItemControllerState) {
          return ShimmerVerticalDeliveryReviewItem(
            deliveryReview: item.deliveryReview
          );
        } else {
          return VerticalDeliveryReviewItem(
            deliveryReview: item.deliveryReview
          );
        }
      } else {
        return Container();
      }
    } else if (item is NewsListItemControllerState) {
      if (item is HorizontalNewsListItemControllerState) {
        return HorizontalNewsItem(
          news: item.news
        );
      } else if (item is VerticalNewsListItemControllerState) {
        if (item is ShimmerVerticalNewsListItemControllerState) {
          return ShimmerVerticalNewsItem(
            news: item.news
          );
        } else {
          return VerticalNewsItem(
            news: item.news,
          );
        }
      } else {
        return Container();
      }
    } else if (item is LoadingListItemControllerState) {
      return const Center(child: CircularProgressIndicator());
    } else if (item is DynamicListItemControllerState) {
      if (item.listItemControllerState is DynamicListItemControllerState) {
        throw FlutterError("You cannot set DynamicListItemControllerState type in DynamicListItemControllerState's listItemControllerState parameter, because it will causing stack overflow.");
      }
      return item.listItemControllerState != null ? _itemBuilder(context, item.listItemControllerState!, index) : Container();
    } else if (item is RowContainerListItemControllerState) {
      List<Widget> result = [];
      for (var listItemControllerState in item.rowChildListItemControllerState) {
        if (listItemControllerState is RowContainerListItemControllerState) {
          throw FlutterError("You cannot set RowContainerListItemControllerState type in RowContainerListItemControllerState's listItemControllerState parameter, because it will causing stack overflow.");
        }
        Widget rowChild = _itemBuilder(context, listItemControllerState, index);
        if (listItemControllerState is NonExpandedItemInRowControllerState) {
          if (listItemControllerState is NonExpandedItemInRowChildControllerState) {
            result.add(_itemBuilder(context, listItemControllerState.childListItemControllerState, index));
          } else {
            result.add(rowChild);
          }
        } else {
          result.add(Expanded(child: rowChild));
        }
      }
      Widget row = Row(children: result);
      return item.padding != null ? Padding(padding: item.padding!, child: row) : row;
    } else if (item is ColumnContainerListItemControllerState) {
      List<Widget> result = [];
      for (var listItemControllerState in item.columnChildListItemControllerState) {
        if (listItemControllerState is ColumnContainerListItemControllerState) {
          throw FlutterError("You cannot set ColumnContainerListItemControllerState type in ColumnContainerListItemControllerState's listItemControllerState parameter, because it will causing stack overflow.");
        }
        Widget columnChild = _itemBuilder(context, listItemControllerState, index);
        result.add(columnChild);
      }
      Widget column = Column(crossAxisAlignment: CrossAxisAlignment.start, children: result);
      return item.padding != null ? Padding(padding: item.padding!, child: column) : column;
    } else if (item is EmptyContainerListItemControllerState) {
      return Container();
    } else if (item is VirtualSpacingListItemControllerState) {
      return SizedBox(width: item.width, height: item.height ?? Constant.heightSpacingListItem);
    } else if (item is SpacingListItemControllerState) {
      return Container(color: item.color ?? Constant.colorSpacingListItem, width: item.width, height: item.height ?? Constant.heightSpacingListItem);
    } else if (item is DividerListItemControllerState) {
      return ModifiedDivider(
        lineColor: item.lineColor,
        lineHeight: item.lineHeight,
        borderRadius: item.borderRadius
      );
    } else if (item is ColorfulDividerListItemControllerState) {
      return ModifiedColorfulDivider(
        lineColorList: item.lineColorList,
        lineHeight: item.lineHeight,
        borderRadius: item.borderRadius
      );
    } else if (item is TitleAndDescriptionListItemControllerState) {
      if (item is ShimmerTitleAndDescriptionListItemControllerState) {
        return ShimmerTitleAndDescriptionItem(
          title: item.title,
          description: item.description,
          padding: item.padding,
          verticalSpace: item.verticalSpace,
        );
      } else {
        return TitleAndDescriptionItem(
          title: item.title,
          description: item.description,
          padding: item.padding,
          verticalSpace: item.verticalSpace,
          titleAndDescriptionItemInterceptor: item.titleAndDescriptionItemInterceptor,
        );
      }
    } else if (item is TitleDescriptionAndContentListItemControllerState) {
      if (item.content is TitleDescriptionAndContentListItemControllerState) {
        throw FlutterError("You cannot set TitleDescriptionAndContentListItemControllerState type in TitleDescriptionAndContentListItemControllerState's content parameter, because it will causing stack overflow.");
      }
      return TitleDescriptionAndContentItem(
        title: item.title,
        description: item.description,
        builder: (context) => item.content != null ? _itemBuilder(context, item.content!, index) : Container(),
        verticalSpace: item.verticalSpace,
      );
    } else if (item is PageKeyedListItemControllerState) {
      if (item.listItemControllerState is PageKeyedListItemControllerState) {
        throw FlutterError("You cannot set PageKeyedListItemControllerState type in PageKeyedListItemControllerState's listItemControllerState parameter, because it will causing stack overflow.");
      }
      return item.listItemControllerState != null ? _itemBuilder(context, item.listItemControllerState!, index) : Container();
    } else if (item is ColorfulChipTabBarListItemControllerState) {
      return ColorfulChipTabBar(
        colorfulChipTabBarDataList: item.colorfulChipTabBarDataList,
        colorfulChipTabBarController: item.colorfulChipTabBarController,
      );
    } else if (item is ShimmerColorfulChipTabBarListItemControllerState) {
      return const ShimmerColorfulChipTabBar();
    } else if (item is TabBarListItemControllerState) {
      return ModifiedTabBar(
        tabs: item.tabDataList.map<Tab>((tabData) => Tab(
          height: tabData.height,
          text: tabData.text,
          icon: tabData.icon != null ? tabData.icon!(context) : null,
          iconMargin: tabData.iconMargin,
          child: tabData.child != null ? tabData.child!(context) : null,
        )).toList(),
        controller: item.tabController
      );
    } else if (item is BaseProductDetailHeaderListItemControllerState) {
      if (item is ProductDetailHeaderListItemControllerState) {
        return ProductDetailHeader(
          product: item.product,
        );
      } else if (item is ShimmerProductDetailHeaderListItemControllerState){
        return const ShimmerProductDetailHeader();
      } else {
        return Container();
      }
    } else if (item is WidgetSubstitutionListItemControllerState) {
      return item.widgetSubstitution(context, index);
    } else if (item is IconTitleAndDescriptionListItemControllerState) {
      return IconTitleAndDescriptionListItem(
        title: item.title,
        description: item.description,
        titleAndDescriptionItemInterceptor: item.titleAndDescriptionItemInterceptor,
        icon: item.iconListItemControllerState != null ? _itemBuilder(context, item.iconListItemControllerState, index) : null,
        space: item.space,
        verticalSpace: item.verticalSpace,
      );
    } else if (item is PaddingContainerListItemControllerState) {
      return Padding(
        padding: item.padding,
        child: _itemBuilder(context, item.paddingChildListItemControllerState, index)
      );
    } else if (item is DecoratedContainerListItemControllerState) {
      return Container(
        padding: item.padding,
        decoration: item.decoration,
        child: _itemBuilder(context, item.decoratedChildListItemControllerState, index)
      );
    } else if (item is SingleBannerListItemControllerState) {
      return AspectRatio(
        aspectRatio: item.banner.aspectRatio.toDouble(),
        child: ClipRect(
          child: ModifiedCachedNetworkImage(
            imageUrl: item.banner.imageUrl.toEmptyStringNonNull,
          )
        )
      );
    } else if (item is DeliveryToListItemControllerState) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        color: Constant.colorDarkBlue,
        child: Row(
          children: [
            ModifiedSvgPicture.asset(Constant.vectorLocation, color: Colors.white),
            const SizedBox(width: 10),
            Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  const TextSpan(text: "${"Delivered to"} ", style: TextStyle(color: Colors.white)),
                  TextSpan(text: item.location.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ]
              )
            )
          ],
        ),
      );
    } else if (item is CheckRatesForVariousCountriesControllerState) {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: Constant.aspectRatioValueImageCheckRatesForVariousCountries.toDouble(),
            child: ClipRect(
              child: ModifiedAssetImage(
                imageAssetUrl: Constant.imageCheckRatesForVariousCountries,
              )
            )
          ),
          Material(
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem, vertical: 10),
                child: const Align(child: Text("Cek Tarif ke Negara Lainnya"), alignment: Alignment.topLeft)
              )
            )
          )
        ]
      );
    } else if (item is ProductDetailImageListItemControllerState) {
      List<ProductEntry> productEntryList = item.productEntryList;
      int productEntryIndex = item.onGetProductEntryIndex();
      String imageUrl = "";
      if (productEntryList.isNotEmpty && productEntryIndex > -1) {
        ProductEntry productEntry = productEntryList[productEntryIndex];
        List<String> imageUrlList = productEntry.imageUrlList;
        imageUrl = imageUrlList.isNotEmpty ? imageUrlList.first : "";
        if (imageUrlList.isNotEmpty) {
          return ModifiedCarouselSlider.builder(
            itemCount: imageUrlList.length,
            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => Column(
              children: [
                AspectRatio(
                  aspectRatio: Constant.aspectRatioValueProductImage.toDouble(),
                  child: ClipRect(
                    child: ModifiedCachedNetworkImage(
                      imageUrl: imageUrlList[itemIndex],
                    ),
                  )
                ),
              ]
            ),
            options: CarouselOptions(
              aspectRatio: Constant.aspectRatioValueProductImage.toDouble(),
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              enableInfiniteScroll: false,
              autoPlay: true,
              viewportFraction: 1.0,
            ),
            carouselController: CarouselController(),
            modifiedCarouselSliderTopStackWidgetBuilder: (context, pageController) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: Constant.bannerIndicatorAreaHeight,
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: SmoothPageIndicator(
                            controller: pageController,
                            count: imageUrlList.length,
                            effect: ScrollingDotsEffect(
                              dotWidth: 8,
                              dotHeight: 8,
                              dotColor: Colors.white.withOpacity(0.5),
                              activeDotColor: Colors.white
                            ),
                          ),
                        )
                      ),
                    ]
                  )
                ),
              );
            }
          );
        }
      }
      return AspectRatio(
        aspectRatio: Constant.aspectRatioValueProductImage.toDouble(),
        child: ClipRRect(
          child: ProductModifiedCachedNetworkImage(
            imageUrl: imageUrl,
          )
        )
      );
    } else if (item is ProductDetailBrandListItemControllerState) {
      return ProductDetailBrandListItem(
        productBrand: item.productBrand
      );
    } else if (item is ProductCategoryHeaderListItemControllerState) {
      return ProductCategoryHeaderListItem(
        productCategory: item.productCategory,
      );
    } else if (item is ProductBundleHeaderListItemControllerState) {
      return ProductBundleHeaderListItem(
        productBundle: item.productBundle,
      );
    } else if (item is ProductBundleHighlightListItemControllerState) {
      return ProductBundleHighlightListItem(
        productBundle: item.productBundle,
        onAddWishlist: item.onAddWishlist,
        onRemoveWishlist: item.onRemoveWishlist,
      );
    } else if (item is CouponListItemControllerState) {
      if (item is HorizontalCouponListItemControllerState) {
        return HorizontalCouponItem(
          coupon: item.coupon,
          onSelectCoupon: item.onSelectCoupon,
        );
      } else if (item is VerticalCouponListItemControllerState) {
        if (item is ShimmerVerticalCouponListItemControllerState) {
          return ShimmerVerticalCouponItem(
            coupon: item.coupon,
          );
        } else {
          return VerticalCouponItem(
            coupon: item.coupon,
            onSelectCoupon: item.onSelectCoupon,
          );
        }
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  T? _findDesiredListItemPagingParameterInjection<T extends ListItemPagingParameterInjection>() {
    try {
      return listItemPagingParameterInjectionList.firstWhere((element) => element is T) as T;
    } on StateError catch (e) {
      if (e.message == "No element") {
        return null;
      }
      rethrow;
    }
  }
}