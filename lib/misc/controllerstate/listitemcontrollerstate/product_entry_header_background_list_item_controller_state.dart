import 'package:flutter/material.dart';

import '../../../presentation/widget/product_entry_header.dart';
import '../../productentryheaderbackground/product_entry_header_background.dart';
import 'list_item_controller_state.dart';

class ProductEntryHeaderListItemControllerState extends ListItemControllerState {
  Widget Function(TextStyle) title;
  OnProductEntryTitleTap? onProductEntryTitleTap;
  ProductEntryHeaderBackground productEntryHeaderBackground;

  ProductEntryHeaderListItemControllerState({
    required this.title,
    this.onProductEntryTitleTap,
    required this.productEntryHeaderBackground
  });
}