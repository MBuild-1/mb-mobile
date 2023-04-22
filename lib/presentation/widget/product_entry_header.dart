import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../misc/constant.dart';
import '../../misc/error/message_error.dart';
import '../../misc/productentryheaderbackground/asset_product_entry_header_background.dart';
import '../../misc/productentryheaderbackground/network_product_entry_header_background.dart';
import '../../misc/productentryheaderbackground/product_entry_header_background.dart';
import 'button/custombutton/sized_outline_gradient_button.dart';
import 'modifiedcachednetworkimage/product_entry_header_modified_cached_network_image.dart';

typedef OnProductEntryTitleTap = void Function();

class ProductEntryHeader extends StatelessWidget {
  final Widget Function(TextStyle) title;
  final OnProductEntryTitleTap? onProductEntryTitleTap;
  final ProductEntryHeaderBackground productEntryHeaderBackground;

  const ProductEntryHeader({
    super.key,
    required this.title,
    this.onProductEntryTitleTap,
    required this.productEntryHeaderBackground
  });

  @override
  Widget build(BuildContext context) {
    TextStyle getDefaultTextStyle() {
      return TextStyle(
        color: Constant.colorDarkBlue,
        fontWeight: FontWeight.bold
      );
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: AspectRatio(
        aspectRatio: Constant.aspectRatioValueProductEntryHeader.toDouble(),
        child: Stack(
          children: [
            Builder(
              builder: (context) {
                if (productEntryHeaderBackground is AssetProductEntryHeaderBackground) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          (productEntryHeaderBackground as AssetProductEntryHeaderBackground).assetImageName,
                        )
                      )
                    ),
                  );
                } else if (productEntryHeaderBackground is NetworkProductEntryHeaderBackground) {
                  return ProductEntryHeaderModifiedCachedNetworkImage(
                    imageUrl: (productEntryHeaderBackground as NetworkProductEntryHeaderBackground).imageUrl,
                  );
                } else {
                  throw MessageError(title: "ProductEntryHeaderBackground is not suitable");
                }
              },
            ),
            Positioned(
              left: Constant.paddingListItem,
              bottom: Constant.paddingListItem,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IgnorePointer(
                        child: ExcludeFocus(
                          child: SizedOutlineGradientButton(
                            onPressed: () {},
                            child: title(getDefaultTextStyle()),
                            text: "",
                            outlineGradientButtonType: OutlineGradientButtonType.outline,
                            outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                            customGradientButtonVariation: (outlineGradientButtonType) {
                              return CustomGradientButtonVariation(
                                outlineGradientButtonType: outlineGradientButtonType,
                                gradient: Constant.buttonGradient2,
                                backgroundColor: Colors.white,
                                textStyle: getDefaultTextStyle()
                              );
                            },
                            customPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        )
      )
    );
  }
}