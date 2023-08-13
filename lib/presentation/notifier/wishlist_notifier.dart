import 'package:flutter/material.dart';

import '../../misc/main_route_observer.dart';

class WishlistNotifier extends ChangeNotifier {
  void updateWishlist({bool withRefreshWishlistInMainMenu = true}) {
    notifyListeners();
    if (withRefreshWishlistInMainMenu) {
      if (MainRouteObserver.onRefreshWishlistInMainMenu != null) {
        MainRouteObserver.onRefreshWishlistInMainMenu!();
      }
    }
  }
}