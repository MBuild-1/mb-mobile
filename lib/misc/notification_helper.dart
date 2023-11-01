import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../presentation/widget/colorful_chip_tab_bar.dart';
import 'constant.dart';
import 'multi_language_string.dart';

class _NotificationHelperImpl {
  List<ColorfulChipTabBarData> get colorfulChipTabBarDataList => <ColorfulChipTabBarData>[
    ColorfulChipTabBarData(
      color: Constant.colorMain,
      title: MultiLanguageString({
        Constant.textInIdLanguageKey: "Transaksi",
        Constant.textEnUsLanguageKey: "Transaction"
      }).toEmptyStringNonNull,
      data: "transaction"
    ),
    ColorfulChipTabBarData(
      color: Constant.colorMain,
      title: "Info",
      data: "info"
    ),
    ColorfulChipTabBarData(
      color: Constant.colorMain,
      title: "Promo",
      data: "promo"
    ),
  ];
}

// ignore: non_constant_identifier_names
final NotificationHelper = _NotificationHelperImpl();