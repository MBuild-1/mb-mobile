import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../misc/constant.dart';
import '../../../misc/inputdecoration/default_input_decoration.dart';
import '../../../misc/page_restoration_helper.dart';
import '../../../misc/search_text_field_helper.dart';
import '../../page/getx_page.dart';
//import '../../page/search/search_page.dart';
import 'modified_app_bar.dart';
import '../modified_text_field.dart';

typedef ActionTitleBuilder = Widget Function(BuildContext context);
typedef TextFieldBuilder = Widget Function(BuildContext context);
typedef OnSearch = void Function(String search);

abstract class SearchAppBar extends ModifiedAppBar {
  final VoidCallback? onSearchTextFieldTapped;
  final OnSearch? onSearch;
  final TextEditingController? searchTextEditingController;
  final double value;
  final FocusNode? searchFocusNode;
  final bool isSearchText;

  SearchAppBar({
    Key? key,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    PreferredSizeWidget? bottom,
    this.value = 1.0,
    this.onSearchTextFieldTapped,
    this.onSearch,
    this.searchTextEditingController,
    this.searchFocusNode,
    this.isSearchText = false
  }) : super(
    key: key,
    leading: leading,
    automaticallyImplyLeading: automaticallyImplyLeading,
    bottom: bottom,
    backgroundColor: Constant.colorDarkBlack2
  );

  double get searchTextFieldHeight => 40.0;

  @override
  BackgroundColorInterceptor get backgroundColorInterceptor {
    return (context, oldColor) => oldColor?.withOpacity(value);
  }

  ActionTitleBuilder? get actionTitleBuilder => null;

  TextFieldBuilder get textFieldBuilder {
    return (context) {
      Widget textField = ModifiedTextField(
        isError: false,
        onEditingComplete: onSearch != null ? () {
          if (searchTextEditingController != null) {
            onSearch!(searchTextEditingController!.text);
          }
        } : null,
        textInputAction: TextInputAction.done,
        controller: searchTextEditingController,
        focusNode: searchFocusNode,
        decoration: SearchTextFieldHelper.searchTextFieldStyle(
          context, DefaultInputDecoration(
            hintText: "Search in Master Bagasi".tr,
            filled: true,
            fillColor: Colors.transparent,
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)
          )
        )
      );
      return !isSearchText ? IgnorePointer(
        child: ExcludeFocus(
          child: textField
        )
      ) : textField;
    };
  }

  Widget? Function(BuildContext, Widget?, Widget)? get searchContentInterceptor => null;

  @override
  TitleInterceptor? get titleInterceptor {
    return (context, oldTitle) {
      Widget result = Row(
        children: [
          Expanded(
            child: SizedBox(
              height: searchTextFieldHeight,
              child: Builder(
                builder: (context) {
                  Widget searchTextWidget = Material(
                    color: Constant.colorGrey12,
                    borderRadius: Constant.inputBorderRadius,
                    child: Builder(
                      builder: (context) {
                        if (isSearchText) {
                          return textFieldBuilder(context);
                        }
                        VoidCallback? effectiveOnSearchTextFieldTapped;
                        if (onSearchTextFieldTapped != null) {
                          effectiveOnSearchTextFieldTapped = onSearchTextFieldTapped!;
                        } else {
                          effectiveOnSearchTextFieldTapped = () {
                            PageRestorationHelper.toSearchPage(context);
                          };
                        }
                        return InkWell(
                          borderRadius: Constant.inputBorderRadius,
                          onTap: effectiveOnSearchTextFieldTapped,
                          child: textFieldBuilder(context)
                        );
                      },
                    )
                  );
                  return searchTextWidget;
                }
              )
            )
          ),
          if (actionTitleBuilder != null) actionTitleBuilder!(context),
        ]
      );
      return searchContentInterceptor != null ? searchContentInterceptor!(context, oldTitle, result) : result;
    };
  }

  @override
  SystemOverlayStyleInterceptor get systemOverlayStyleInterceptor {
    return (context, oldSystemUiOverlayStyle) => value > 0.5 ? null : SystemUiOverlayStyle.light;
  }
}