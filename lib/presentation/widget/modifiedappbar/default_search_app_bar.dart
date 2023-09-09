import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../misc/constant.dart';
import '../modified_vertical_divider.dart';
import '../tap_area.dart';
import 'search_app_bar.dart';

class DefaultSearchAppBar extends SearchAppBar {
  DefaultSearchAppBar({
    Key? key,
    Widget? leading,
    bool automaticallyImplyLeading = false,
    PreferredSizeWidget? bottom,
    double value = 1.0,
    VoidCallback? onSearchTextFieldTapped
  }) : super(
    key: key,
    leading: leading,
    automaticallyImplyLeading: automaticallyImplyLeading,
    bottom: bottom,
    value: value,
    onSearchTextFieldTapped: onSearchTextFieldTapped
  );

  @override
  TextFieldBuilder get textFieldBuilder {
    return (context) {
      final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
      final bool canPop = parentRoute?.canPop ?? false;
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: Constant.inputBorderRadius,
              border: Border.fromBorderSide(
                BorderSide(
                  color: Constant.colorTextFieldBorder,
                  width: Constant.inputBorderWidth
                )
              )
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0
            ),
            child: Row(
              children: [
                if (canPop) ...[
                  TapArea(
                    onTap: () => Navigator.maybePop(context),
                    child: IconTheme(
                      data: IconThemeData(
                        color: Colors.grey.shade600
                      ),
                      child: const BackButtonIcon(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ModifiedVerticalDivider(
                    lineWidth: 1,
                    lineHeight: 25,
                    lineColor: Constant.colorGrey9,
                  ),
                  const SizedBox(width: 8),
                ],
                Icon(Icons.search, color: Constant.colorGrey8),
                const SizedBox(width: 5),
                Text("Search in Masterbagasi".tr, style: TextStyle(color: Constant.colorGrey8)),
              ]
            )
          ),
        ],
      );
    };
  }
}