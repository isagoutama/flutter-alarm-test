
class AlarmInfo {
  int id;
  int randomId;
  String title;
  DateTime alarmDateTime;
  bool isPending;

  AlarmInfo({
    required this.id,
    required this.randomId,
    required this.title,
    required this.alarmDateTime,
    required this.isPending
  });

  factory AlarmInfo.fromMap(Map<String, dynamic> json) => AlarmInfo(
        id: json["id"],
        title: json["title"],
        randomId: json["randomId"],
        alarmDateTime: DateTime.parse(json["alarmDateTime"]),
        isPending: json["isPending"] == 1
      );
  Map<String, dynamic> toMap() => {
        "id": id,
        "randomId": randomId,
        "title": title,
        "alarmDateTime": alarmDateTime.toIso8601String(),
        "isPending": isPending
      };
}