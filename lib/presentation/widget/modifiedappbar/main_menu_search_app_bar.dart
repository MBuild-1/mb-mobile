import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:provider/provider.dart';

import '../../../misc/constant.dart';
import '../../../misc/page_restoration_helper.dart';
import '../../notifier/notification_notifier.dart';
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
    onSearchTextFieldTapped: onSearchTextFieldTapped
  );

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
        child: Consumer<NotificationNotifier>(
          builder: (_, notificationNotifier, __) => Row(
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
                  lineColor: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
              ],
              Icon(Icons.search, color: Colors.grey.shade600),
              const SizedBox(width: 5),
              Text("Search in Masterbagasi".tr, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              const Spacer(),
              NotificationIconIndicator(
                notificationNumber: notificationNotifier.notificationLoadDataResult.resultIfSuccess ?? 0,
                onTap: () => PageRestorationHelper.toNotificationPage(context),
                icon: SvgPicture.asset(
                  Constant.vectorNotificationIconNotif,
                  color: Constant.colorGrey6,
                  height: 25,
                  width: 25,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(width: 5),
              NotificationIconIndicator(
                notificationNumber: notificationNotifier.inboxLoadDataResult.resultIfSuccess ?? 0,
                onTap: () => PageRestorationHelper.toInboxPage(context),
                icon: SvgPicture.asset(
                  Constant.vectorNotificationIconInbox,
                  color: Constant.colorGrey6,
                  height: 25,
                  width: 25,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(width: 5),
              NotificationIconIndicator(
                notificationNumber: notificationNotifier.cartLoadDataResult.resultIfSuccess ?? 0,
                onTap: () => PageRestorationHelper.toCartPage(context),
                icon: SvgPicture.asset(
                  Constant.vectorNotificationIconCart,
                  color: Constant.colorGrey6,
                  height: 25,
                  width: 25,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ]
          )
        )
      );
    };
  }
}