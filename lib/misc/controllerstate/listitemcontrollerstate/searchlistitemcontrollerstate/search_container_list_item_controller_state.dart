import 'dart:ui';

import '../../../../domain/entity/product/productentry/product_entry.dart';
import '../../../../presentation/page/modaldialogpage/search_filter_modal_dialog_page.dart';
import '../../../../presentation/widget/product/product_item.dart';
import '../list_item_controller_state.dart';

class SearchContainerListItemControllerState extends ListItemControllerState {
  int searchResultCount;
  List<ProductEntry> productEntryList;
  Color Function() onGetColorfulChipTabBarColor;
  void Function() onUpdateState;
  void Function() onGotoFilterModalDialog;
  SearchFilterModalDialogPageResponse? Function() searchFilterModalDialogPageResponse;
  OnRemoveWishlistWithProductAppearanceData onRemoveWishlistWithProductAppearanceData;
  OnAddWishlistWithProductAppearanceData onAddWishlistWithProductAppearanceData;
  OnAddCartWithProductAppearanceData onAddProductCart;

  SearchContainerListItemControllerState({
    required this.searchResultCount,
    required this.productEntryList,
    required this.onGetColorfulChipTabBarColor,
    required this.onUpdateState,
    required this.onGotoFilterModalDialog,
    required this.searchFilterModalDialogPageResponse,
    required this.onRemoveWishlistWithProductAppearanceData,
    required this.onAddWishlistWithProductAppearanceData,
    required this.onAddProductCart
  });
}