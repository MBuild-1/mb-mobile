import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:provider/provider.dart';

import '../../../misc/constant.dart';
import '../../../misc/page_restoration_helper.dart';
import '../../../misc/search_app_bar_icon_dimension.dart';
import '../../../misc/widget_helper.dart';
import '../../notifier/notification_notifier.dart';
import '../modified_svg_picture.dart';
import '../modified_vertical_divider.dart';
import '../notification_icon_indicator.dart';
import '../notification_number_indicator.dart';
import '../tap_area.dart';
import 'search_app_bar.dart';

class MainMenuSearchAppBar extends SearchAppBar {
  MainMenuSearchAppBar({
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
    onSearchTextFieldTapped: onSearchTextFieldTapped,
    isSearchText: true
  );

  @override
  TextFieldBuilder get textFieldBuilder {
    return (context) {
      final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
      final bool canPop = parentRoute?.canPop ?? false;
      SearchAppBarDimension searchAppBarDimension = SearchAppBarDimension(
        iconButtonSize: searchTextFieldHeight
      );
      return Container(
        padding: const EdgeInsets.all(0.0),
        child: Consumer<NotificationNotifier>(
          builder: (_, notificationNotifier, __) => Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: Constant.inputBorderRadius.copyWith(
                    topRight: Radius.zero,
                    bottomRight: Radius.zero
                  ),
                  onTap: () => PageRestorationHelper.toSearchPage(context),
                  child: Center(
                    child: Row(
                      children: [
                        if (canPop) ...[
                          TapArea(
                            onTap: () => Navigator.maybePop(context),
                            child: Stack(
                              children: [
                                Container(),
                                Center(
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 12.0),
                                      const IconTheme(
                                        data: IconThemeData(
                                          color: Colors.white
                                        ),
                                        child: BackButtonIcon(),
                                      ),
                                      const SizedBox(width: 8),
                                      ModifiedVerticalDivider(
                                        lineWidth: 1,
                                        lineHeight: 25,
                                        lineColor: Constant.colorGrey9,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                        const SizedBox(width: 8),
                        const Icon(Icons.search, color: Colors.white),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            "Search in Master Bagasi".tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13
                            )
                          )
                        ),
                        SizedBox(
                          width: searchAppBarDimension.iconButtonSize + 12.0
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]
          )
        )
      );
    };
  }

  @override
  Widget? Function(BuildContext, Widget?, Widget)? get searchContentInterceptor {
    return (context, oldTitle, oldSearchContent) {
      return WidgetHelper.buildSearchTextFieldWithSearchAppBarIcon(
        context: context,
        searchTextFieldHeight: searchTextFieldHeight,
        searchTextField: oldSearchContent
      );
    };
  }
}