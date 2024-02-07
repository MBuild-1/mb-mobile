import 'package:flutter/material.dart';

import '../../../domain/entity/cart/cart.dart';
import '../../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_header_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/separatedcartcontainerlistitemcontrollerstate/cart_separated_container_list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../controllerstate/listitemcontrollerstate/spacing_list_item_controller_state.dart';
import 'separated_cart_item_type_list_sub_interceptor.dart';

class CartSeparatedCartItemTypeListSubInterceptor extends SeparatedCartItemTypeListSubInterceptor {
  CartSeparatedCartItemTypeListSubInterceptor({
    required super.padding,
    required super.itemSpacing,
    required super.listItemControllerStateItemTypeInterceptorChecker
  });

  @override
  bool intercept(
    int i,
    ListItemControllerStateWrapper oldItemTypeWrapper,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newItemTypeList
  ) {
    ListItemControllerState oldItemType = oldItemTypeWrapper.listItemControllerState;
    if (oldItemType is CartSeparatedCartContainerListItemControllerState) {
      List<CartListItemControllerState> cartListItemControllerStateList = [];
      cartListItemControllerStateList = oldItemType.cartListItemControllerStateList;
      CartHeaderListItemControllerState cartHeaderListItemControllerState = CartHeaderListItemControllerState(
        isSelected: false,
        onChangeSelected: () {
          int k = 0;
          int selectedCount = 0;
          while (k < cartListItemControllerStateList.length) {
            CartListItemControllerState cartListItemControllerState = cartListItemControllerStateList[k];
            if (cartListItemControllerState.isSelected) {
              selectedCount += 1;
            }
            k++;
          }
          if (selectedCount == cartListItemControllerStateList.length) {
            for (var cartListItemControllerState in cartListItemControllerStateList) {
              cartListItemControllerState.isSelected = false;
            }
          } else {
            for (var cartListItemControllerState in cartListItemControllerStateList) {
              cartListItemControllerState.isSelected = true;
            }
          }
          oldItemType.onUpdateState();
        }
      );
      newItemTypeList.addAll(<ListItemControllerState>[
        cartHeaderListItemControllerState,
        SpacingListItemControllerState()
      ]);
      int selectedCount = 0;
      List<Cart> selectedCart = [];
      int j = 0;
      while (j < cartListItemControllerStateList.length) {
        CartListItemControllerState cartListItemControllerState = cartListItemControllerStateList[j];
        if (cartListItemControllerState.isSelected) {
          selectedCount += 1;
          selectedCart.add(cartListItemControllerState.cart);
        }
        newItemTypeList.addAll(<ListItemControllerState>[
          if (j > 0) SpacingListItemControllerState(),
          cartListItemControllerState
        ]);
        j++;
        cartListItemControllerState.onChangeSelected = () {
          cartListItemControllerState.isSelected = !cartListItemControllerState.isSelected;
          oldItemType.onUpdateState();
        };
      }
      if (selectedCount == cartListItemControllerStateList.length) {
        cartHeaderListItemControllerState.isSelected = true;
      } else {
        cartHeaderListItemControllerState.isSelected = false;
      }
      CartSeparatedCartContainerStateStorageListItemControllerState cartSeparatedCartContainerStateStorageListItemControllerState = oldItemType.cartSeparatedCartContainerStateStorageListItemControllerState;
      CartSeparatedCartContainerInterceptingActionListItemControllerState cartSeparatedCartContainerInterceptingActionListItemControllerState = oldItemType.cartSeparatedCartContainerInterceptingActionListItemControllerState;
      if (cartSeparatedCartContainerStateStorageListItemControllerState is DefaultCartSeparatedCartContainerStateStorageListItemControllerState) {
        if (selectedCount != cartSeparatedCartContainerStateStorageListItemControllerState._lastSelectedCount) {
          cartSeparatedCartContainerStateStorageListItemControllerState._lastSelectedCount = selectedCount;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            oldItemType.onChangeSelected(selectedCart);
          });
        }
        if (cartListItemControllerStateList.length != cartSeparatedCartContainerStateStorageListItemControllerState._lastCartCount) {
          cartSeparatedCartContainerStateStorageListItemControllerState._lastCartCount = cartListItemControllerStateList.length;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            oldItemType.onCartChange();
          });
        }
      }
      if (cartSeparatedCartContainerInterceptingActionListItemControllerState is DefaultCartSeparatedCartContainerInterceptingActionListItemControllerState) {
        cartSeparatedCartContainerInterceptingActionListItemControllerState._removeCart = (cart) {
          int l = 0;
          while (l < cartListItemControllerStateList.length) {
            CartListItemControllerState cartListItemControllerState = cartListItemControllerStateList[l];
            if (cartListItemControllerState.cart.id == cart.id) {
              cartListItemControllerStateList.removeAt(l);
              break;
            }
            l++;
          }
          oldItemType.onUpdateState();
        };
        cartSeparatedCartContainerInterceptingActionListItemControllerState._getCartCount = () => cartListItemControllerStateList.length;
      }
      return true;
    }
    return false;
  }
}

class DefaultCartSeparatedCartContainerStateStorageListItemControllerState extends CartSeparatedCartContainerStateStorageListItemControllerState {
  int _lastSelectedCount = -1;
  int _lastCartCount = -1;
}

class DefaultCartSeparatedCartContainerInterceptingActionListItemControllerState extends CartSeparatedCartContainerInterceptingActionListItemControllerState {
  void Function(Cart)? _removeCart;
  int Function()? _getCartCount;

  @override
  void Function(Cart)? get removeCart => _removeCart ?? (throw UnimplementedError());

  @override
  int Function()? get getCartCount => _getCartCount ?? (throw UnimplementedError());
}