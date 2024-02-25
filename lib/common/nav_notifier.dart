import 'package:flutter/cupertino.dart';

class NavNotifier extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  changeNavBar(int idx) {
    _currentIndex = idx;
    notifyListeners();
  }
}