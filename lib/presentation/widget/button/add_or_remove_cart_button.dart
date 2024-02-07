import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../misc/constant.dart';
import '../modified_svg_picture.dart';
import 'custombutton/sized_outline_gradient_button.dart';

typedef OnAddCart = void Function();
typedef OnRemoveCart = void Function();

class AddOrRemoveCartButton extends StatelessWidget {
  final OnAddCart? onAddCart;
  final OnRemoveCart? onRemoveCart;
  final bool isAddToCart;
  final bool isIcon;
  final bool isLoading;

  const AddOrRemoveCartButton({
    super.key,
    this.onAddCart,
    this.onRemoveCart,
    required this.isAddToCart,
    this.isIcon = false,
    required this.isLoading
  });

  @override
  Widget build(BuildContext context) {
    return SizedOutlineGradientButton(
      onPressed: onAddCart != null ? () => onAddCart!() : null,
      text: "+ ${"Cart".tr}",
      outlineGradientButtonType: isLoading ? OutlineGradientButtonType.solid : (isAddToCart ? OutlineGradientButtonType.solid : OutlineGradientButtonType.outline),
      outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
      childInterceptor: isIcon ? (textStyle) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ModifiedSvgPicture.asset(
              Constant.vectorCart,
              color: onAddCart != null ? (isAddToCart ? Colors.white : Constant.colorMain) : Colors.grey.shade600,
            )
          ],
        );
      } : null,
    );
  }
}