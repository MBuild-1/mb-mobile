import 'package:flutter/material.dart';

import '../../../misc/constant.dart';
import '../modified_shimmer.dart';

class PurchaseSectionNotificationStep extends StatelessWidget {
  final Widget Function(bool) icon;
  final Widget text;
  final double? height;
  final int lineRemovalValue;
  final bool isLineLeftActive;
  final bool isLineRightActive;
  final bool activeValue;
  final bool isLoadingStep;

  const PurchaseSectionNotificationStep({
    super.key,
    required this.icon,
    required this.text,
    this.height,
    this.lineRemovalValue = 0,
    required this.isLineLeftActive,
    required this.isLineRightActive,
    required this.activeValue,
    required this.isLoadingStep
  });

  @override
  Widget build(BuildContext context) {
    Widget column = Column(
      children: [
        isLoadingStep ? ModifiedShimmer.fromColors(child: icon(activeValue)) : icon(activeValue),
        const SizedBox(height: 4),
        text,
        const SizedBox(height: 16),
      ]
    );
    Widget indicator = Builder(
      builder: (context) {
        double size = 16;
        Color borderColor = Constant.colorGrey;
        return SizedBox(
          height: size,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1.5,
                        color: () {
                          if (lineRemovalValue == -1) {
                            return null;
                          }
                          return isLineLeftActive ? Theme.of(context).colorScheme.primary : borderColor;
                        }()
                      )
                    ),
                    Expanded(
                      child: Container(
                        height: 1.5,
                        color: () {
                          if (lineRemovalValue == 1) {
                            return null;
                          }
                          return isLineRightActive ? Theme.of(context).colorScheme.primary : borderColor;
                        }()
                      )
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: activeValue ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
                    border: activeValue ? null : Border.all(color: borderColor),
                    shape: BoxShape.circle
                  ),
                  child: activeValue ? Center(
                    child: Icon(
                      Icons.check,
                      size: size - 4,
                      color: Colors.white
                    ),
                  ) : null
                ),
              )
            ],
          ),
        );
      }
    );
    indicator = isLoadingStep && height != null ? ModifiedShimmer.fromColors(child: indicator) : indicator;
    return height != null ? SizedBox(
      height: height,
      child: Stack(
        children: [
          column,
          Align(
            alignment: Alignment.bottomCenter,
            child: indicator
          )
        ],
      ),
    ) : Column(
      children: [
        column,
        indicator
      ],
    );
  }
}