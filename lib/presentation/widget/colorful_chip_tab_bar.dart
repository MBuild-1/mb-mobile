import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import '../../misc/constant.dart';
import 'modified_chip.dart';
import 'modified_shimmer.dart';

class ColorfulChipTabBar extends StatelessWidget {
  final List<ColorfulChipTabBarData> colorfulChipTabBarDataList;
  final BaseColorfulChipTabBarController colorfulChipTabBarController;
  final EdgeInsetsGeometry? padding;
  final bool isWrap;
  final bool? canSelectAndUnselect;
  final Widget? Function(TextStyle?, ColorfulChipTabBarData)? chipLabelInterceptor;

  const ColorfulChipTabBar({
    Key? key,
    required this.colorfulChipTabBarDataList,
    required this.colorfulChipTabBarController,
    this.padding,
    this.isWrap = true,
    this.canSelectAndUnselect,
    this.chipLabelInterceptor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry effectivePadding = padding ?? EdgeInsets.symmetric(horizontal: Constant.paddingListItem);
    void checkColorfulChipTabBarController({
      required int i,
      required dynamic value,
      required List<Widget> result,
    }) {
      ColorfulChipTabBarData data = colorfulChipTabBarDataList[i];
      Widget? Function(TextStyle?)? effectiveChipLabelInterceptor() {
        return chipLabelInterceptor != null ? (textStyle) => chipLabelInterceptor!(textStyle, data) : null;
      }
      bool effectiveCanSelectAndUnselect = false;
      if (colorfulChipTabBarController is ColorfulChipTabBarController) {
        effectiveCanSelectAndUnselect = canSelectAndUnselect ?? (colorfulChipTabBarController is CanSelectAndUnselectColorfulChipTabBarController);
        result.add(
          ModifiedChipButton(
            label: Text(data.title.toStringNonNull),
            labelInterceptor: effectiveChipLabelInterceptor(),
            backgroundColor: Constant.colorTrainingPreEmploymentChip(context),
            isSelected: i == value,
            canSelectAndUnselect: effectiveCanSelectAndUnselect,
            onTap: () {
              ColorfulChipTabBarController normalColorfulChipTabBarController = colorfulChipTabBarController as ColorfulChipTabBarController;
              if (normalColorfulChipTabBarController is CanSelectAndUnselectColorfulChipTabBarController) {
                int currentSelectedIndex = normalColorfulChipTabBarController.value;
                late int newSelectedIndex;
                if (currentSelectedIndex > -1) {
                  if (currentSelectedIndex == i) {
                    newSelectedIndex = -1;
                  } else {
                    newSelectedIndex = i;
                  }
                } else {
                  newSelectedIndex = i;
                }
                normalColorfulChipTabBarController.value = newSelectedIndex;
              } else {
                normalColorfulChipTabBarController.value = i;
              }
            }
          )
        );
      } else if (colorfulChipTabBarController is MultipleSelectionColorfulChipTabBarController) {
        effectiveCanSelectAndUnselect = canSelectAndUnselect ?? (colorfulChipTabBarController is MultipleSelectionColorfulChipTabBarController);
        List<int> currentSelectionIndexList = value;
        bool isSelected = false;
        for (int j = 0; j < currentSelectionIndexList.length; j++) {
          int currentLastSelectedIndex = currentSelectionIndexList[j];
          if (i == currentLastSelectedIndex) {
            isSelected = true;
          }
        }
        result.add(
          ModifiedChipButton(
            label: Text(data.title.toStringNonNull),
            labelInterceptor: effectiveChipLabelInterceptor(),
            backgroundColor: Constant.colorTrainingPreEmploymentChip(context),
            isSelected: isSelected,
            canSelectAndUnselect: effectiveCanSelectAndUnselect,
            onTap: () {
              MultipleSelectionColorfulChipTabBarController multipleSelectionColorfulChipTabBarController = colorfulChipTabBarController as MultipleSelectionColorfulChipTabBarController;
              List<int> currentLastSelectedIndexList = multipleSelectionColorfulChipTabBarController.value;
              late List<int> newLastSelectedIndexList;
              if (currentLastSelectedIndexList.contains(i)) {
                newLastSelectedIndexList = List.of(currentLastSelectedIndexList.whereNot((element) => element == i));
              } else {
                newLastSelectedIndexList = List.of(currentLastSelectedIndexList + [i]);
              }
              newLastSelectedIndexList.toSet().toList().sort((a, b) => a - b);
              multipleSelectionColorfulChipTabBarController.value = newLastSelectedIndexList;
            }
          )
        );
      }
    }
    if (isWrap) {
      return ValueListenableBuilder(
        valueListenable: colorfulChipTabBarController,
        builder: (context, value, child) => Builder(
          builder: (context) {
            List<Widget> result = [];
            for (int i = 0; i < colorfulChipTabBarDataList.length; i++) {
              checkColorfulChipTabBarController(
                i: i,
                value: value,
                result: result
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
              child: Wrap(
                children: result,
                spacing: 10.0,
                runSpacing: 10.0
              ),
            );
          }
        )
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: effectivePadding,
      child: ValueListenableBuilder(
        valueListenable: colorfulChipTabBarController,
        builder: (context, value, child) => Builder(
          builder: (context) {
            List<Widget> result = [];
            for (int i = 0; i < colorfulChipTabBarDataList.length; i++) {
              if (i > 0) {
                result.add(SizedBox(width: 2.w));
              }
              checkColorfulChipTabBarController(
                i: i,
                value: value,
                result: result
              );
            }
            return Row(children: result);
          }
        ),
      )
    );
  }
}

class ShimmerColorfulChipTabBar extends StatelessWidget {
  final EdgeInsetsGeometry? padding;

  const ShimmerColorfulChipTabBar({
    Key? key,
    this.padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry effectivePadding = padding ?? EdgeInsets.symmetric(horizontal: Constant.paddingListItem);
    return IgnorePointer(
      child: ModifiedShimmer.fromColors(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: effectivePadding,
          child: Builder(
            builder: (context) {
              List<Widget> result = [];
              for (int i = 0; i < 5; i++) {
                if (i > 0) {
                  result.add(SizedBox(width: 2.w));
                }
                result.add(
                  ModifiedChipButton(
                    label: Text("Dummy $i"),
                    backgroundColor: Constant.colorTrainingPreEmploymentChip(context),
                    isSelected: true,
                    onTap: () {}
                  )
                );
              }
              return Row(children: result);
            }
          )
        ),
      ),
    );
  }
}

abstract class BaseColorfulChipTabBarController<T> extends ValueNotifier<T> {
  BaseColorfulChipTabBarController(T value) : super(value);
}

class ColorfulChipTabBarController extends BaseColorfulChipTabBarController<int> {
  ColorfulChipTabBarController(super.value);
}

class CanSelectAndUnselectColorfulChipTabBarController extends ColorfulChipTabBarController {
  CanSelectAndUnselectColorfulChipTabBarController(super.value);
}

class MultipleSelectionColorfulChipTabBarController extends BaseColorfulChipTabBarController<List<int>> {
  MultipleSelectionColorfulChipTabBarController(super.value);
}

class ColorfulChipTabBarData {
  String? title;
  Color color;
  dynamic data;

  ColorfulChipTabBarData({
    this.title,
    required this.color,
    this.data
  });
}