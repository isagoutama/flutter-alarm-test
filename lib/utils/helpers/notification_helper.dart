import 'package:alarm_app/utils/helpers/app_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();
  
  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        sound: RawResourceAndroidNotificationSound('a_long_cold_sting')
      ),
      iOS: IOSNotificationDetails()
    );
  }

  static Future init ({bool initScheduled = false}) async{
    final androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOSSettings = IOSInitializationSettings();
    final settings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings
    );

    final details = await _notification.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.payload);
    }
    
    await _notification.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      }
    );

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showNotification(int id, String? title, String? description, String? payload) async {
    return _notification.show(id, title, payload, await _notificationDetails());
  }

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, time.hour, time.minute, time.second);

    return scheduleDate.isBefore(now) ? scheduleDate.add(Duration(days: 1)) : scheduleDate;
  }

  static void showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime dateTime
  }) async {
    _notification.zonedSchedule(
        id, // choose for each notification an index that is unique
        title,
        body,
        tz.TZDateTime.from(dateTime, tz.local),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    // final scheduledDates =
    //     _scheduleWeekly(
    //       Time(dateTime.hour, dateTime.minute), 
    //       days: [DateTime.sunday, DateTime.monday, DateTime.tuesday, DateTime.wednesday, DateTime.thursday, DateTime.friday, DateTime.saturday]
    //     );

    // for (int i = 0; i < scheduledDates.length; i++) {
    //   final scheduledDate = scheduledDates[i];

    //   _notification.zonedSchedule(
    //     id + i, // choose for each notification an index that is unique
    //     title,
    //     body,
    //     scheduledDate,
    //     await _notificationDetails(),
    //     payload: payload,
    //     androidAllowWhileIdle: true,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime,
    //     matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    //   );
    // }
  }


static List<tz.TZDateTime> _scheduleWeekly(Time time,
      {required List<int> days}) {
    return days.map((day) {
      tz.TZDateTime scheduledDate = _scheduleDaily(time);

      while (day != scheduledDate.weekday) {
        scheduledDate = scheduledDate.add(Duration(days: 1));
      }
      return scheduledDate;
    }).toList();
  }
}