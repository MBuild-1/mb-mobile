import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../misc/constant.dart';
import '../../../misc/page_restoration_helper.dart';
import '../modified_vertical_divider.dart';
import '../tap_area.dart';
import 'modified_app_bar.dart';
import 'search_app_bar.dart';

class CoreSearchAppBar extends SearchAppBar {
  final bool readOnly;
  final bool showFilterIconButton;
  final Color? filterIconButtonColor;
  final VoidCallback? onTapSearchFilterIcon;

  CoreSearchAppBar({
    Key? key,
    Widget? leading,
    bool automaticallyImplyLeading = false,
    PreferredSizeWidget? bottom,
    double value = 1.0,
    VoidCallback? onSearchTextFieldTapped,
    OnSearch? onSearch,
    TextEditingController? searchTextEditingController,
    this.readOnly = true,
    required this.showFilterIconButton,
    this.filterIconButtonColor,
    this.onTapSearchFilterIcon,
    FocusNode? searchFocusNode
  }) : super(
    key: key,
    leading: leading,
    automaticallyImplyLeading: automaticallyImplyLeading,
    bottom: bottom,
    value: value,
    onSearchTextFieldTapped: onSearchTextFieldTapped,
    onSearch: onSearch,
    searchTextEditingController: searchTextEditingController,
    searchFocusNode: searchFocusNode,
    isSearchText: true
  );

  @override
  ActionTitleBuilder? get actionTitleBuilder => null;

  @override
  TextFieldBuilder get textFieldBuilder {
    return (context) {
      final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
      final bool canPop = parentRoute?.canPop ?? false;
      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 12.0
        ),
        child: Row(
          children: [
            if (canPop) ...[
              TapArea(
                onTap: () => Navigator.maybePop(context),
                child: const IconTheme(
                  data: IconThemeData(
                    color: Colors.white
                  ),
                  child: BackButtonIcon(),
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
            const Icon(Icons.search, color: Colors.white),
            const SizedBox(width: 5),
            Expanded(
              child: Builder(
                builder: (context) {
                  Widget textField = TextField(
                    controller: searchTextEditingController,
                    decoration: InputDecoration.collapsed(
                      hintText: "Search in Master Bagasi".tr,
                      hintStyle: const TextStyle(
                        color: Colors.white
                      )
                    ),
                    onEditingComplete: onSearch != null ? () {
                      if (searchTextEditingController != null) {
                        onSearch!(searchTextEditingController!.text);
                      }
                    } : null,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14
                    ),
                    focusNode: searchFocusNode
                  );
                  VoidCallback? effectiveOnSearchTextFieldTapped;
                  if (onSearchTextFieldTapped != null) {
                    effectiveOnSearchTextFieldTapped = onSearchTextFieldTapped!;
                  } else {
                    effectiveOnSearchTextFieldTapped = () {
                      PageRestorationHelper.toSearchPage(context);
                    };
                  }
                  return readOnly ? TapArea(
                    onTap: effectiveOnSearchTextFieldTapped,
                    child: IgnorePointer(
                      child: ExcludeFocus(
                        child: textField
                      )
                    ),
                  ) : textField;
                }
              )
            ),
            const SizedBox(width: 5),
            if (showFilterIconButton) ...[
              TapArea(
                onTap: onTapSearchFilterIcon ?? () {},
                child: Icon(Icons.filter_list, color: filterIconButtonColor == null ? Colors.white : filterIconButtonColor!),
              )
            ]
          ]
        )
      );
    };
  }

  @override
  TitleInterceptor? get titleInterceptor {
    if (!readOnly) {
      return super.titleInterceptor;
    }
    return (context, oldTitle) {
      return Material(
        color: Constant.colorGrey12,
        borderRadius: Constant.inputBorderRadius,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: searchTextFieldHeight,
                child: textFieldBuilder(context)
              )
            ),
            if (actionTitleBuilder != null) actionTitleBuilder!(context),
          ]
        )
      );
    };
  }
}