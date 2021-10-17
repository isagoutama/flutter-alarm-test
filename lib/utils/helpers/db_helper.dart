import 'package:alarm_app/models/alarm_info.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  final String tableAlarm = 'alarm';
  final String columnId = 'id';
  final String columnRandomId = 'randomId';
  final String columnTitle = 'title';
  final String columnDateTime = 'alarmDateTime';
  final String columnPending = 'isPending';

  Future<Database> get database async {
    Database _database = await initializeDatabase();;
    return _database;
  }

  Future<Database> initializeDatabase() async {
    final dbDir = await getDatabasesPath();
    final path = dbDir + 'alarm.db';

    final database = await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
          create table $tableAlarm ( 
          $columnId integer primary key, 
          $columnRandomId integer, 
          $columnTitle text not null,
          $columnDateTime text not null,
          $columnPending integer)
        ''');
    });

    return database;
  }

  void insertAlarm(AlarmInfo alarmInfo) async {
    print(DateFormat('HH:mm').format(alarmInfo.alarmDateTime));
    var db = await this.database;
    var result = await db.insert(tableAlarm, alarmInfo.toMap());
    print('result : $result');
  }

  Future<List<AlarmInfo>> getAlarms() async {
    List<AlarmInfo> _alarms = [];

    var db = await this.database;
    var result = await db.query(tableAlarm);
    result.forEach((element) {
      var alarmInfo = AlarmInfo.fromMap(element);
      _alarms.add(alarmInfo);
    });

    return _alarms;
  }

  Future<int> delete(int id) async {
    var db = await this.database;
    return await db.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  }
  
  Future<int> update(int id, AlarmInfo info) async {
    var db = await this.database;
    return await db.update(tableAlarm, info.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }
}