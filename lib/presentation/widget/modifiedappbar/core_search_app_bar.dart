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
  ActionTitleBuilder? get actionTitleBuilder {
    if (!showFilterIconButton) {
      return null;
    }
    return (context) => Row(
      children: [
        SizedBox(width: 2.w),
        IconButton(
          onPressed: onTapSearchFilterIcon ?? () {}, //() => PageRestorationHelper.toSearchFilterPage(context),
          icon: SvgPicture.asset(
            "", //Constant.vectorFilter,
            color: Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, value),
            width: 10.w
          )
        )
      ]
    );
  }

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
            Expanded(
              child: TextField(
                controller: searchTextEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: "Search in Masterbagasi".tr,
                  hintStyle: TextStyle(
                    color: Constant.colorGrey8
                  )
                ),
                onEditingComplete: onSearch != null ? () {
                  if (searchTextEditingController != null) {
                    onSearch!(searchTextEditingController!.text);
                  }
                } : null,
                textInputAction: TextInputAction.done,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14
                ),
              ),
            ),
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
      return IgnorePointer(
        child: ExcludeFocus(
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
        )
      );
    };
  }
}