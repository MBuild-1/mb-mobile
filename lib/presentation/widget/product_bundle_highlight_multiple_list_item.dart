import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../domain/entity/product/productbundle/product_bundle.dart';
import '../../misc/constant.dart';
import 'modified_carousel_slider.dart';
import 'product_bundle_highlight_list_item.dart';
import 'productbundle/product_bundle_item.dart';

class ProductBundleHighlightMultipleListItem extends StatelessWidget {
  final List<ProductBundle> productBundleList;
  final OnAddWishlistWithProductBundle? onAddWishlist;
  final OnRemoveWishlistWithProductBundle? onRemoveWishlist;
  final OnAddCartWithProductBundle? onAddCart;
  final OnRemoveCartWithProductBundle? onRemoveCart;

  const ProductBundleHighlightMultipleListItem({
    super.key,
    required this.productBundleList,
    this.onAddWishlist,
    this.onRemoveWishlist,
    this.onAddCart,
    this.onRemoveCart
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0.0,
          top: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(0.4)
                )
              ]
            )
          ),
        ),
        ModifiedCarouselSlider.builder(
          itemCount: productBundleList.length,
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => Column(
            children: [
              AspectRatio(
                aspectRatio: Constant.aspectRatioValueProductBundleArea.toDouble(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: ProductBundleHighlightListItem(
                    productBundle: productBundleList[itemIndex],
                    onAddWishlist: onAddWishlist,
                    onRemoveWishlist: onRemoveWishlist,
                    onAddCart: onAddCart,
                    onRemoveCart: onRemoveCart,
                    hasBackground: false,
                  ),
                ),
              ),
            ]
          ),
          options: CarouselOptions(
            aspectRatio: Constant.aspectRatioValueProductBundleArea.toDouble(),
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
                          count: productBundleList.length,
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
        ),
      ],
    );
  }
}