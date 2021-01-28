import 'dart:convert';

import 'package:meeting_room/util/time_range/time_range.dart';

import '../util/essentials.dart';
import 'Room.dart';

Slot slotFromJson(String str) => Slot.fromJson(json.decode(str));

String slotToJson(Slot data) => json.encode(data.toJson());

class Slot {
  Slot({
    this.id,
    this.title,
    this.desc,
    this.date,
    this.timeZone,
    this.timeRange,
    this.room,
    this.priority,
    this.alert,
  });

  String id;
  String title;
  String desc;
  DateTime date;
  String timeZone;
  TimeRangeResult timeRange;
  Room room;
  Priority priority;
  Alert alert;

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        id: json["id"],
        title: json["title"],
        desc: json["desc"],
        date: DateTime.parse(json["date"]),
        timeZone: json["timeZone"],
        timeRange: TimeRangeResult(getTimeFromMinutes(json["timeRangeStart"]),
            getTimeFromMinutes(json["timeRangeEnd"])),
        room: Room.fromJson(json["room"]),
        priority: Priority.fromJson(json["priority"]),
        alert: nonNull("alert") ? Alert.values[json["alert"]] : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "desc": desc,
        "date": date.toIso8601String(),
        "timeZone": timeZone,
        "timeRangeStart": timeRange.start.inMinutes(),
        "timeRangeEnd": timeRange.end.inMinutes(),
        "room": room.toJson(),
        "priority": priority.toJson(),
        "alert": nonNull(alert) ? alert.index : null,
      };
}

class Priority {
  Priority({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Priority.fromJson(Map<String, dynamic> json) => Priority(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

enum Alert { quarterMin, halfMin, aDay }

String alertName(Alert alert) {
  switch (alert) {
    case Alert.aDay:
      return "24 hours";
      break;
    case Alert.halfMin:
      return "30 mins";
      break;
    case Alert.quarterMin:
      return "15 mins";
      break;
    default:
      return "";
      break;
  }
}
