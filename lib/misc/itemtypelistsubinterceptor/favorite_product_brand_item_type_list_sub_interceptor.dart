import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/domain/entity/product/productbrand/product_brand.dart';
import 'package:masterbagasi/misc/controllerstate/listitemcontrollerstate/decorated_container_list_item_controller_state.dart';

import '../../domain/entity/product/productbrand/favorite_product_brand.dart';
import '../controllerstate/listitemcontrollerstate/card_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/is_running_order_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/order_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/vertical_order_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/waiting_for_payment_order_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/product_detail_brand_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productbrandlistitemcontrollerstate/favorite_product_brand_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../page_restoration_helper.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class FavoriteProductBrandItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  FavoriteProductBrandItemTypeListSubInterceptor({
    required this.padding,
    required this.itemSpacing,
    required this.listItemControllerStateItemTypeInterceptorChecker
  });

  @override
  bool intercept(
    int i,
    ListItemControllerStateWrapper oldItemTypeWrapper,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newItemTypeList
  ) {
    ListItemControllerState oldItemType = oldItemTypeWrapper.listItemControllerState;
    if (oldItemType is FavoriteProductBrandContainerListItemControllerState) {
      FavoriteProductBrandContainerInterceptingActionListItemControllerState favoriteProductBrandContainerInterceptingActionListItemControllerState = oldItemType.favoriteProductBrandContainerInterceptingActionListItemControllerState;
      if (favoriteProductBrandContainerInterceptingActionListItemControllerState is DefaultFavoriteProductBrandContainerInterceptingActionListItemControllerState) {
        favoriteProductBrandContainerInterceptingActionListItemControllerState._onRemoveFavoriteProductBrand = (favoriteProductBrand) {
          oldItemType.favoriteProductBrandList.remove(favoriteProductBrand);
          oldItemType.onUpdateState();
        };
      }
      List<ListItemControllerState> favoriteProductBrandListItemControllerStateList = oldItemType.favoriteProductBrandList.map<ListItemControllerState>(
        (favoriteProductBrand) => CardContainerListItemControllerState(
          borderRadius: BorderRadius.circular(8.0),
          cardContainerChildListItemControllerState: CompoundListItemControllerState(
            listItemControllerState: [
              ProductDetailBrandListItemControllerState(
                productBrand: favoriteProductBrand.productBrand,
                onTapProductBrand: oldItemType.onTapFavoriteProductBrand,
                onRemoveFromFavoriteProductBrand: (productBrand) => oldItemType.onRemoveFromFavoriteProductBrand(favoriteProductBrand),
              ),
              VirtualSpacingListItemControllerState(height: 16)
            ]
          )
        )
      ).toList();
      List<ListItemControllerState> newListItemControllerState = [];
      newListItemControllerState.add(
        VirtualSpacingListItemControllerState(height: padding())
      );
      ListItemControllerState titleListItemControllerState = PaddingContainerListItemControllerState(
        padding: EdgeInsets.symmetric(horizontal: padding()),
        paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
          title: "My Favorite Brand".tr
        ),
      );
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i, ListItemControllerStateWrapper(titleListItemControllerState), oldItemTypeList, newListItemControllerState
      );
      int j = 0;
      while (j < favoriteProductBrandListItemControllerStateList.length) {
        ListItemControllerState listItemControllerState = CompoundListItemControllerState(
          listItemControllerState: [
            VirtualSpacingListItemControllerState(height: padding()),
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: padding()),
              paddingChildListItemControllerState: favoriteProductBrandListItemControllerStateList[j],
            ),
            if (j == favoriteProductBrandListItemControllerStateList.length - 1) VirtualSpacingListItemControllerState(height: padding())
          ]
        );
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i, ListItemControllerStateWrapper(listItemControllerState), oldItemTypeList, newListItemControllerState
        );
        j++;
      }
      newItemTypeList.addAll(newListItemControllerState);
      return true;
    }
    return false;
  }
}

class DefaultFavoriteProductBrandContainerInterceptingActionListItemControllerState extends FavoriteProductBrandContainerInterceptingActionListItemControllerState {
  void Function(FavoriteProductBrand)? _onRemoveFavoriteProductBrand;

  @override
  void Function(FavoriteProductBrand)? get onRemoveFavoriteProductBrand => _onRemoveFavoriteProductBrand ?? (throw UnimplementedError());
}