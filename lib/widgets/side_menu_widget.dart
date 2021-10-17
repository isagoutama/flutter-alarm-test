import 'package:alarm_app/constants/app_colors.dart';
import 'package:alarm_app/models/menu_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenuWidget extends StatelessWidget {

  const SideMenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: menuItemsList().map((menuInfo) => buildMenuButton(menuInfo)).toList(),
        ),
        VerticalDivider(
          color: Colors.white54,
          width: 1,
        ),
      ],
    );
  }

  Widget buildMenuButton(MenuInfo info) {
    return Consumer<MenuInfo>(
      builder: (ctx, value, widget) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 6),
          width: 85,
          color: info.type == value.type ? AppColors.menuBackgroundColor : Colors.transparent,
          child: TextButton(
            onPressed: () {
              var menuInfo = Provider.of<MenuInfo>(ctx, listen: false);
              menuInfo.updateMenuInfo(info);
            },
            child: Column(
              children: [
                Icon(info.icon, color: Colors.white),
                const SizedBox(height: 16),
                Text(info.title, style: TextStyle(color: Colors.white, fontSize: 14))
              ]),
          ),
        );
      },
    );
  }

  List<MenuInfo> menuItemsList() {
    return [
      MenuInfo(MenuType.CLOCK, title: 'Clock', icon: Icons.access_time),
      MenuInfo(MenuType.ALARM, title: 'Alarm', icon: Icons.alarm),
      MenuInfo(MenuType.TIMER, title: 'Timer', icon: Icons.hourglass_bottom),
      MenuInfo(MenuType.STOPWATCH, title: 'Stopwatch', icon: Icons.timer),
    ];
  }
}
