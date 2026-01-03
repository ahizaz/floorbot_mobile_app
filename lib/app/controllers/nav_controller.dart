import 'package:floor_bot_mobile/app/views/screens/search/search_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:floor_bot_mobile/app/views/screens/explore/explore_screen.dart';
import 'package:floor_bot_mobile/app/views/screens/mycart/cart_screen.dart';
import 'package:floor_bot_mobile/app/views/screens/orders/orders_screen.dart';
import 'package:floor_bot_mobile/app/views/screens/settings/settings_tab.dart';

class NavController extends GetxController {
  final RxInt _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  final List<Widget> _screens = [
    const ExploreTab(),
    const SearchTab(),
    const CartTab(),
    const OrdersTab(),
    const SettingsTab(),
  ];

  Widget get currentScreen => _screens[_currentIndex.value];

  void changeTab(int index) {
    if (index >= 0 && index < _screens.length) {
      _currentIndex.value = index;
    }
  }
}
