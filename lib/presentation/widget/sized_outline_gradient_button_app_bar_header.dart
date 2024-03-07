import 'package:flutter/material.dart';

import 'button/custombutton/sized_outline_gradient_button.dart';
import 'tap_area.dart';

class SizedOutlineGradientButtonAppBarHeader extends StatelessWidget {
  final String text;
  final void Function(Widget, String?, TextStyle?)? interceptWidget;

  const SizedOutlineGradientButtonAppBarHeader({
    super.key,
    this.text = "",
    this.interceptWidget
  });

  @override
  Widget build(BuildContext context) {
    Widget result = IgnorePointer(
      child: ExcludeFocus(
        child: Builder(
          builder: (context) => SizedOutlineGradientButton(
            onPressed: () {},
            text: text,
            outlineGradientButtonType: OutlineGradientButtonType.outline,
            outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
            customGradientButtonVariation: (outlineGradientButtonType) {
              return CustomGradientButtonVariation(
                outlineGradientButtonType: outlineGradientButtonType,
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold
                )
              );
            },
            childInterceptor: (textStyle) {
              Widget defaultWidget = Text(
                text,
                style: textStyle,
                textAlign: TextAlign.center,
              );
              if (interceptWidget != null) {
                interceptWidget!(defaultWidget, text, textStyle);
              }
              return Center(
                child: Text(
                  text,
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              );
            },
          )
        ),
      ),
    );
    return Stack(
      children: [
        result,
        Positioned(
          top: 0,
          bottom: 0,
          child: TapArea(
            onTap: () => Navigator.maybePop(context),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  "X",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          )
        )
      ],
    );
  }
}