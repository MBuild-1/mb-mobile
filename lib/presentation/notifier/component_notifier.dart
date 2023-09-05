import 'package:flutter/material.dart';

import '../../misc/main_route_observer.dart';

class ComponentNotifier extends ChangeNotifier {
  void updateWishlist({bool withRefreshWishlistInMainMenu = true}) {
    notifyListeners();
    if (withRefreshWishlistInMainMenu) {
      if (MainRouteObserver.onRefreshWishlistInMainMenu != null) {
        MainRouteObserver.onRefreshWishlistInMainMenu!();
      }
    }
  }

  void updateFavorite() {
    notifyListeners();
  }

  void updateCart() {
    notifyListeners();
  }
}