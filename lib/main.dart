import 'package:alarm_app/constants/app_colors.dart';
import 'package:alarm_app/models/menu_info.dart';
import 'package:alarm_app/screens/alarm/alarm_screen.dart';
import 'package:alarm_app/screens/clock/clock_screen.dart';
import 'package:alarm_app/utils/helpers/notification_helper.dart';
import 'package:alarm_app/widgets/side_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    NotificationHelper.init(initScheduled: true);
    super.initState();
  }

  void listenNotification() => NotificationHelper.onNotifications.stream.listen(onClickNotification);

  void onClickNotification(String? payload) {
    print(payload);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (BuildContext context) => MenuInfo(MenuType.CLOCK, title: 'Clock', icon: Icons.access_time),
        child: Scaffold(
          backgroundColor: AppColors.gunMetal,
          body: Row(
            children: [
              SideMenuWidget(),
              Expanded(
                child: Consumer<MenuInfo>(
                  builder: (ctx, value, widget) {
                    if (value.type == MenuType.CLOCK) {
                      return ClockScreen();
                    } else if (value.type == MenuType.ALARM) {
                      return AlarmScreen();
                    }
                    return Container(
                      margin: EdgeInsets.all(32),
                      child: Text('Soon', style: TextStyle(color: Colors.white))
                    );
                  }
                ),
              )
            ],
          ),// This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }
}
