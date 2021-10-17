import 'dart:async';

import 'package:alarm_app/widgets/clock_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({Key? key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<ClockScreen> {

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
        }); 
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var _dateTime = DateTime.now();
    var dateFormat = DateFormat('E, d MMMM').format(_dateTime);
    var timeFormat = DateFormat('HH:mm').format(_dateTime);
    var timeZoneString = _dateTime.timeZoneOffset.toString().split('.').first;
    var offsetSign = '';
    if (!timeZoneString.startsWith('-')) offsetSign = '+';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 64
      ),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text('Clock', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700))
          ),
          SizedBox(height: 32),
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(timeFormat, style: TextStyle(color: Colors.white, fontSize: 64)),
                Text(dateFormat, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300)),
              ],
            ),
          ),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: Align(
              alignment: Alignment.center,
              child: ClockWidget(
                size: MediaQuery.of(context).size.height / 4,
                // size: 50,
                dateTime: _dateTime,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Timezone', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500)),
                  Row(
                      children: [
                        Icon(
                          Icons.language,
                          color: Colors.white,
                        ),
                        SizedBox(width: 16),
                        Text('UTC' + offsetSign + timeZoneString,
                            style: TextStyle(color: Colors.white, fontSize: 14
                            )),
                      ]
                  )
                ],
              )),
        ],
      ),
    );
  }
}

