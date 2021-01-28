import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meeting_room/model/room.dart';
import 'package:meeting_room/model/slot.dart' hide Priority;
import 'package:meeting_room/util/time_range/time_range.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

var defaultTimeZone = "Asia/Kolkata";
var localeBox = Hive.box('locale_box');
var appBox = Hive.box('app_box');
var meetingRoomBox = Hive.box('meeting_room_box');
var meetingSlotBox = Hive.box('meeting_slot_box');

final defaultOfficeTiming = TimeRangeResult(
  TimeOfDay(hour: 09, minute: 00),
  TimeOfDay(hour: 17, minute: 00),
);

printIfDebug(message) {
  if (!kReleaseMode) print(message);
}

bool nonNullNotEmptyField(Map json, String key) {
  if (json.containsKey(key) && json[key] != null) {
    if (json[key] is List || json[key] is Map) return json[key].length > 0;
    if (json[key] is String) return json[key].trim().isNotEmpty;
  }
  return false;
}

bool nonNullNotEmpty(dynamic value) {
  if (value != null) {
    if (value is List || value is Map) return value.length > 0;
    if (value is String) return value.trim().isNotEmpty;
  }
  return false;
}

bool nonNull(dynamic value) {
  return value != null;
}

String textValidator(String value) {
  if (value.isEmpty) {
    return 'Please enter some text';
  }
  return null;
}

tz.Location get getTimeZoneLoc => tz
    .getLocation(localeBox.get("timezone_name", defaultValue: defaultTimeZone));

TimeOfDay getTimeFromMinutes(int minutes) {
  final int hour = minutes ~/ 60;
  final int remainingMinutes = minutes % 60;
  return TimeOfDay(hour: hour, minute: remainingMinutes);
}

double toToDDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

bool isSameAsToday(DateTime other) {
  var now = tz.TZDateTime.now(getTimeZoneLoc);
  return now.year == other.year &&
      now.month == other.month &&
      now.day == other.day;
}

bool isSameDay(DateTime first, DateTime second) {
  var now = tz.TZDateTime.now(getTimeZoneLoc);
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

bool isToday(DateTime other) {
  var now = tz.TZDateTime.now(getTimeZoneLoc);
  return now.difference(other).inDays == 0 && now.day == other.day;
}

extension TimeRangeExt on TimeRangeResult {
  String get formatRange =>
      "(" +
      this.start.format(Get.overlayContext) +
      " - " +
      this.end.format(Get.overlayContext) +
      ")";

  get printRange {
    printIfDebug(formatRange);
    printIfDebug(
        "lastTime.after(firstTime): " + this.end.after(this.start).toString());
  }
}

Duration getAlertDuration(Alert alert) {
  switch (alert) {
    case Alert.aDay:
      return Duration(days: 1);
      break;
    case Alert.halfMin:
      return Duration(minutes: 30);
      break;
    case Alert.quarterMin:
      return Duration(minutes: 15);
      break;
    default:
      return Duration(minutes: 15);
      break;
  }
}

Priority getAlertPriority(int id) {
  switch (id) {
    case 0:
      return Priority.low;
      break;
    case 1:
      return Priority.defaultPriority;
      break;
    case 2:
      return Priority.max;
      break;
    default:
      return Priority.defaultPriority;
      break;
  }
}

Room getRoomFromId(String id) {
  List<Room> rooms = meetingRoomBox
      .toMap()
      .values
      .map((roomJson) => Room.fromJson(jsonDecode(roomJson)))
      .toList();

  return rooms.firstWhere((room) => room.id == id);
}
