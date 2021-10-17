import 'package:flutter/widgets.dart';

enum MenuType {
  CLOCK, ALARM, TIMER, STOPWATCH
}


class MenuInfo extends ChangeNotifier{
  MenuType type;
  String title;
  IconData icon;

  MenuInfo(this.type, {required this.title, required this.icon});

  void updateMenuInfo(MenuInfo info) {
    this.type = info.type;
    this.title = info.title;
    this.icon = info.icon;

    notifyListeners();
  }
}