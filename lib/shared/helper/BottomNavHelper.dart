// bottom_nav_helper.dart
import 'package:flutter/material.dart';
import 'package:techshop_flutter/shared/widgets/navigateBar/bottom.dart';

class BottomNavHelper {
  // Tạo GlobalKey để nắm state
  static final GlobalKey<CustomBottomNavigationBarState> bottomNavKey =
      GlobalKey<CustomBottomNavigationBarState>();

  // Hàm static để reload badge cart
  static Future<void> reloadCartBadge() async {
    bottomNavKey.currentState?.refreshBadge();
  }
}
