import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../misc/constant.dart';
import '../../../misc/inputdecoration/default_input_decoration.dart';
import '../../../misc/page_restoration_helper.dart';
import '../modified_text_field.dart';
import '../tap_area.dart';
import 'search_app_bar.dart';

class MainMenuSearchAppBar extends SearchAppBar {
  MainMenuSearchAppBar({
    Key? key,
    Widget? leading,
    bool automaticallyImplyLeading = true,
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
    return (context) => ModifiedTextField(
      isError: false,
      onEditingComplete: onSearch != null ? () {
        if (searchTextEditingController != null) {
          onSearch!(searchTextEditingController!.text);
        }
      } : null,
      textInputAction: TextInputAction.done,
      controller: searchTextEditingController,
      focusNode: searchFocusNode,
      decoration: searchTextFieldStyle(
        context, DefaultInputDecoration(
          hintText: "Search in MasterBagasi".tr,
          filled: true,
          fillColor: Colors.transparent,
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: SvgPicture.asset(
                  Constant.vectorNotification,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: SvgPicture.asset(
                  Constant.vectorInbox,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  PageRestorationHelper.toCartPage(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: SvgPicture.asset(
                    Constant.vectorCart,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(width: 15),
            ]
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)
        )
      )
    );
  }
}