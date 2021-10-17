import 'package:alarm_app/constants/app_colors.dart';
import 'package:alarm_app/models/alarm_info.dart';
import 'package:alarm_app/utils/helpers/app_helper.dart';
import 'package:alarm_app/utils/helpers/db_helper.dart';
import 'package:alarm_app/utils/helpers/notification_helper.dart';
import 'package:alarm_app/widgets/clock_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  DateTime _alarmTime = DateTime.now();
  String _alarmTimeString = '';
  DBHelper _alarmHelper = DBHelper();
  List<AlarmInfo> _currentAlarms = [];
  Future<List<AlarmInfo>> _getAlarms() => _alarmHelper.getAlarms();
  int _currentHourSelected = 0;
  int _currentMinuteSelected = 0;

  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      print('------database intialized');
      loadAlarms();
    });
    super.initState();
  }

  void loadAlarms() async {
    await _getAlarms();

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 64, 32, 32),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Alarm', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
              Expanded(
                child: FutureBuilder<List<AlarmInfo>>(
                  initialData: _currentAlarms,
                  future: _getAlarms(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _currentAlarms = snapshot.data!;
                      return ListView.builder(
                        itemCount: _currentAlarms.length + 1,
                        itemBuilder: (ctx, i) {
                          if (i < _currentAlarms.length) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.menuBackgroundColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.label, color: Colors.white,size: 24),
                                          SizedBox(width: 8),
                                          Text(
                                            _currentAlarms[i].title,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ]
                                      ),
                                      Switch(
                                        value: !_currentAlarms[i].isPending, 
                                        onChanged: (value) {
                                          updateAlarm(_currentAlarms[i].id, _currentAlarms[i].randomId, _currentAlarms[i].title, !_currentAlarms[i].isPending, _currentAlarms[i].alarmDateTime);
                                        }
                                      )
                                    ]
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(DateFormat('HH:mm').format(_currentAlarms[i].alarmDateTime), style: TextStyle( color: Colors.white, fontWeight: FontWeight.w700)),
                                      IconButton(
                                        icon: Icon(Icons.delete, size: 24),
                                        color: Colors.white,
                                        onPressed: () => deleteAlarm(_currentAlarms[i].id),  
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ); 
                          }
                          return SizedBox(height: 64);
                        });
                    }

                    return Container();
                  }
                ),
                ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.independence,
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48.0),
                    // side: BorderSide(color: Colors.blue, width: 4)
                  )
                ),
                onPressed: () {
                  _currentHourSelected = DateTime.now().hour;
                  _currentMinuteSelected = DateTime.now().minute;
                  showModalFormAddAlarm(context);
                }, 
                child: Icon(Icons.add_alarm, size: 38, color: Colors.blue),
              ),
            )
          )
        ],
      ),
    );
  }

  void scheduleAlarm(DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo) async {
    print(alarmInfo.title);
    // var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    //   'alarm_notif',
    //   'Alarm Notif',
    //   icon: 'codex_logo',
    //   channelDescription: 'Channel for Alarm notification',
    //   sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
    //   largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
    // );

    // var iOSPlatformChannelSpecifics = IOSNotificationDetails(
    //     sound: 'a_long_cold_sting.wav',
    //     presentAlert: true,
    //     presentBadge: true,
    //     presentSound: true);
    // var platformChannelSpecifics = NotificationDetails(
    //     android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    // await flutterLocalNotificationsPlugin.show('alarm', alarmInfo.desciption, alarmInfo.desciption);
    // await NotificationHelper.showNotification(0, 'Alarm', alarmInfo.desciption, alarmInfo.desciption);
    
  }

  void showModalFormAddAlarm (BuildContext ctx, {var info}) {
    final now = DateTime.now();
    showModalBottomSheet(
      useRootNavigator: true,
      backgroundColor: AppColors.gunMetal,
      context: ctx,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      NumberPicker(
                        zeroPad: true,
                        textStyle: TextStyle(color: Colors.white, fontSize: 16),
                        value: _currentHourSelected,
                        minValue: 0,
                        maxValue: 23,
                        onChanged: (value) => setModalState(() => _currentHourSelected = value),
                      ),
                      Text(':', style: TextStyle(color: Colors.white, fontSize: 25)),
                      NumberPicker(
                        zeroPad: true,
                        textStyle: TextStyle(color: Colors.white, fontSize: 16),
                        value: _currentMinuteSelected,
                        minValue: 0,
                        maxValue: 59,
                        onChanged: (value) => setModalState(() => _currentMinuteSelected = value),
                        // onChanged: (value) {
                        //   print('value: ' + value.toString());
                        //   _currentMinuteSelected = value;
                        //   print(_currentMinuteSelected);
                        //   setState(() {
                            
                        //   });
                        // },
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: ClockWidget(
                      size: MediaQuery.of(context).size.height / 5,
                      dateTime: DateTime(now.year, now.month, now.day, _currentHourSelected, _currentMinuteSelected), 
                      isSecondsVisible: false
                    )
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      onSaveAlarm(context, DateTime(now.year, now.month, now.day, _currentHourSelected, _currentMinuteSelected)); 
                    },
                    icon: Icon(Icons.alarm),
                    label: Text('Save'),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  void onSaveAlarm(BuildContext context, DateTime time) {
    DateTime scheduleAlarmDateTime = time;
    if (time.isAfter(DateTime.now()))
      scheduleAlarmDateTime = time;
    else
      scheduleAlarmDateTime = time.add(Duration(days: 1));

    print(DateFormat('HH:mm').format(scheduleAlarmDateTime));
    var alarmInfo = AlarmInfo(
      id: _currentAlarms.length + 1,
      randomId: AppHelper.getRandomNumber(6),
      alarmDateTime: scheduleAlarmDateTime,
      title: 'Alarm',
      isPending: false
    );
    _alarmHelper.insertAlarm(alarmInfo);
    NotificationHelper.showScheduledNotification(
      id: alarmInfo.randomId, 
      title: alarmInfo.title, 
      body:  DateFormat('HH:mm').format(alarmInfo.alarmDateTime),
      dateTime: alarmInfo.alarmDateTime
    );
    Navigator.pop(context);
    loadAlarms();
  }

  void updateAlarm(int id, int randomId, String title,bool isPending, DateTime dateTime) {
    _alarmHelper.update(id, AlarmInfo(id: id, randomId: randomId, isPending: isPending, title: title, alarmDateTime: dateTime));
    loadAlarms();
  }

  void deleteAlarm(int id) {
    _alarmHelper.delete(id);
    //unsubscribe for notification
    loadAlarms();
  }
}