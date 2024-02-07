import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/cart/cart.dart';
import '../../domain/entity/cart/cart_list_parameter.dart';
import '../../domain/entity/cart/support_cart.dart';
import '../../domain/entity/product/productbundle/product_bundle.dart';
import '../../domain/entity/product/productentry/product_entry.dart';
import '../../domain/entity/wishlist/support_wishlist.dart';
import '../../domain/entity/wishlist/wishlist.dart';
import '../../domain/entity/wishlist/wishlist_list_parameter.dart';
import '../../domain/usecase/get_cart_list_use_case.dart';
import '../../domain/usecase/get_wishlist_list_ignoring_login_error.dart';
import '../../misc/cart_helper.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/api_request_manager.dart';
import '../../misc/wishlist_helper.dart';

class ProductNotifier extends ChangeNotifier {
  late ApiRequestManager apiRequestManager;

  final GetWishlistListIgnoringLoginErrorUseCase getWishlistListIgnoringLoginErrorUseCase;
  final GetCartListUseCase getCartListUseCase;

  CancelToken? _wishlistCancelToken;
  CancelToken? _cartCancelToken;

  LoadDataResult<List<Wishlist>> _wishlistListLoadDataResult = NoLoadDataResult<List<Wishlist>>();
  LoadDataResult<List<Wishlist>> get wishlistListLoadDataResult => _wishlistListLoadDataResult;
  set wishlistListLoadDataResult(LoadDataResult<List<Wishlist>> value) {
    _wishlistListLoadDataResult = value;
    notifyListeners();
  }

  LoadDataResult<List<Cart>> _cartListLoadDataResult = NoLoadDataResult<List<Cart>>();
  LoadDataResult<List<Cart>> get cartListLoadDataResult => _cartListLoadDataResult;
  set cartListLoadDataResult(LoadDataResult<List<Cart>> value) {
    _cartListLoadDataResult = value;
    notifyListeners();
  }

  LoadDataResult<bool> isAddToWishlist(SupportWishlist supportWishlist) {
    return _wishlistListLoadDataResult.map<bool>((wishlistList) {
      if (supportWishlist is ProductEntry) {
        Iterable<Wishlist> filteredWishlist = wishlistList.where((wishlist) {
          if (wishlist.supportWishlist is ProductEntry) {
            SupportWishlist filterSupportWishlist = wishlist.supportWishlist;
            return filterSupportWishlist.supportWishlistContentId == supportWishlist.supportWishlistContentId;
          }
          return false;
        });
        return filteredWishlist.isNotEmpty;
      } else if (supportWishlist is ProductBundle) {
        Iterable<Wishlist> filteredWishlist = wishlistList.where((wishlist) {
          if (wishlist.supportWishlist is ProductBundle) {
            SupportWishlist filterSupportWishlist = wishlist.supportWishlist;
            return filterSupportWishlist.supportWishlistContentId == supportWishlist.supportWishlistContentId;
          }
          return false;
        });
        return filteredWishlist.isNotEmpty;
      }
      return false;
    });
  }

  LoadDataResult<bool> isAddToCart(SupportCart supportCart) {
    return _cartListLoadDataResult.map<bool>((cartList) {
      if (supportCart is ProductEntry) {
        Iterable<Cart> filteredCart = cartList.where((cart) {
          if (cart.supportCart is ProductEntry) {
            SupportCart filterSupportCart = cart.supportCart;
            return filterSupportCart.supportCartContentId == supportCart.supportCartContentId;
          }
          return false;
        });
        return filteredCart.isNotEmpty;
      } else if (supportCart is ProductBundle) {
        Iterable<Cart> filteredCart = cartList.where((cart) {
          if (cart.supportCart is ProductBundle) {
            SupportCart filterSupportCart = cart.supportCart;
            return filterSupportCart.supportCartContentId == supportCart.supportCartContentId;
          }
          return false;
        });
        return filteredCart.isNotEmpty;
      }
      return false;
    });
  }

  void loadData() {
    loadWishlistList();
    loadCartList();
  }

  void _cancelWishlistLoading() {
    if (_wishlistCancelToken != null) {
      if (!_wishlistCancelToken!.isCancelled) {
        _wishlistCancelToken!.cancel();
      }
    }
  }

  void loadWishlistList() async {
    _cancelWishlistLoading();
    _wishlistListLoadDataResult = IsLoadingLoadDataResult<List<Wishlist>>();
    notifyListeners();
    _wishlistCancelToken = apiRequestManager.addRequestToCancellationPart("wishlist").value;
    _wishlistListLoadDataResult = await getWishlistListIgnoringLoginErrorUseCase.execute(
      WishlistListParameter()
    ).future(
      parameter: _wishlistCancelToken
    );
    notifyListeners();
  }

  void loadWishlistListFromData(LoadDataResult<List<Wishlist>> wishlistListLoadDataResult) async {
    _cancelWishlistLoading();
    _wishlistListLoadDataResult = await WishlistHelper.getWishlistListIgnoringLoginError(() async {
      return wishlistListLoadDataResult;
    });
    notifyListeners();
  }

  void _cancelCartLoading() {
    if (_cartCancelToken != null) {
      if (!_cartCancelToken!.isCancelled) {
        _cartCancelToken!.cancel();
      }
    }
  }

  void loadCartList() async {
    _cancelCartLoading();
    _cartListLoadDataResult = IsLoadingLoadDataResult<List<Cart>>();
    notifyListeners();
    _cartCancelToken = apiRequestManager.addRequestToCancellationPart("cart").value;
    _cartListLoadDataResult = await CartHelper.getCartListIgnoringLoginError(() async {
      return await getCartListUseCase.execute(
        CartListParameter()
      ).future(
        parameter: _cartCancelToken
      );
    });
    notifyListeners();
  }

  void loadCartListFromData(LoadDataResult<List<Cart>> cartLoadDataResult) async {
    _cancelCartLoading();
    _cartListLoadDataResult = await CartHelper.getCartListIgnoringLoginError(() async {
      return cartLoadDataResult;
    });
    notifyListeners();
  }

  ProductNotifier({
    required this.getWishlistListIgnoringLoginErrorUseCase,
    required this.getCartListUseCase,
  }) {
    apiRequestManager = ApiRequestManager();
    loadData();
  }
}