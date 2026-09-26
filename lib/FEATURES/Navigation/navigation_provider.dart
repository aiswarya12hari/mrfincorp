// lib/FEATURES/Navigation/provider/navigation_provider.dart
import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int _tabTapCounter = 0;

  int get currentIndex => _currentIndex;
  int get tabTapCounter => _tabTapCounter;

  void changeTab(int index) {
    if (_currentIndex == index) {
      _tabTapCounter++;
      notifyListeners();
      return;
    }
    _currentIndex = index;
    _tabTapCounter++;
    notifyListeners();
  }
}