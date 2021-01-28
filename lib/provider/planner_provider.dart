import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room/model/Room.dart';
import 'package:meeting_room/model/slot.dart';
import 'package:meeting_room/provider/notification_provider.dart';
import 'package:meeting_room/provider/room_provider.dart';
import 'package:meeting_room/util/essentials.dart';
import 'package:meeting_room/util/time_range/time_range.dart';
import 'package:meeting_room/util/util.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class PlannerProvider with ChangeNotifier {
  PlannerProvider(this.context) {
    init();
  }

  final BuildContext context;
  final formKey = GlobalKey<FormState>();
  tz.TZDateTime scheduleTime;
  bool isSlotsAvailable = false;
  TimeRangeResult officeTiming;
  TimeRangeResult selectedRange;

  List<Room> rooms = [];
  List<Priority> priorities = [
    Priority(id: 0, name: "Low"),
    Priority(id: 1, name: "Medium"),
    Priority(id: 2, name: "High"),
  ];
  TextEditingController titleController;
  TextEditingController descController;
  TextEditingController dateController;
  Slot slot;

  init() {
    titleController = TextEditingController();
    descController = TextEditingController();
    dateController = TextEditingController();
    var now = tz.TZDateTime.now(getTimeZoneLoc);
    dateController.text = DateFormat.yMMMd().format(now) +
        " " +
        getTimeZoneLoc.currentTimeZone.abbr;
    Provider.of<RoomProvider>(context, listen: false).init();
    Map<dynamic, dynamic> raw = meetingRoomBox.toMap();
    rooms = raw.values
        .map((roomJson) => Room.fromJson(jsonDecode(roomJson)))
        .toList();
    var start = getTimeFromMinutes(appBox.get("office_timing_start",
        defaultValue: defaultOfficeTiming.start.inMinutes()));
    var end = getTimeFromMinutes(appBox.get("office_timing_end",
        defaultValue: defaultOfficeTiming.end.inMinutes()));
    officeTiming = TimeRangeResult(start, end);
    calculateElapsedRanges(now);
    slot = Slot(
        date: now,
        timeRange: selectedRange,
        room: rooms.first,
        priority: priorities.first,
        alert: Alert.quarterMin);
    setScheduledAlertTime();
  }

  Future selectDate(BuildContext context) async {
    var now = tz.TZDateTime.now(getTimeZoneLoc);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: now,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: now,
        lastDate: now.add(Duration(days: 30)));
    if (picked != null) {
      slot.date = tz.TZDateTime.from(picked, getTimeZoneLoc);

      dateController.text = DateFormat.yMMMd().format(slot.date) +
          " " +
          getTimeZoneLoc.currentTimeZone.abbr;
      calculateElapsedRanges(slot.date);
      setScheduledAlertTime();
      printIfDebug(dateController.text);
    }
  }

  selectTimeRange(TimeRangeResult result) async {
    if (result != null) {
      selectedRange = result;
      slot.timeRange = result;
      setScheduledAlertTime();
      printIfDebug(TimeRangeExt(slot.timeRange).printRange);
    }
  }

  setRoom(Room room) {
    slot.room = room;
    printIfDebug(slot.room.toJson());
    notifyListeners();
  }

  setPriority(Priority priority) {
    slot.priority = priority;
    printIfDebug(slot.priority.toJson());
    notifyListeners();
  }

  setAlert(Alert alert) {
    slot.alert = alert == slot.alert ? null : alert;
    printIfDebug(slot.alert);
    notifyListeners();
  }

  saveSlot() async {
    var now = tz.TZDateTime.now(getTimeZoneLoc);
    slot.id = slot.date.millisecondsSinceEpoch.toString();
    slot.title = titleController.text.trim();
    slot.desc = descController.text.trim();
    slot.timeZone = getTimeZoneLoc.currentTimeZone.abbr;
    if (scheduleTime.isAfter(now)) await alertIfEnabled(slot);
    meetingSlotBox.put(slot.id, slotToJson(slot));
    Get.back(result: "Meeting scheduled");
  }

  alertIfEnabled(Slot slot) async {
    if (nonNull(slot.alert)) {
      var provider = Provider.of<NotificationProvider>(context, listen: false);
      bool isEnabled =
          appBox.get("notification_status", defaultValue: "on") == "on";
      if (!isEnabled) {
        await Util.showDialog(
            title: "Notification Alert is Off",
            message:
                "Would you like to turn on the notification alert and proceed?",
            possitiveText: "Turn On",
            onDonePressed: () {
              appBox.put("notification_status", "on");
              provider.scheduleAlert(context, slot, scheduleTime);
              Get.back();
            });
      } else {
        provider.scheduleAlert(context, slot, scheduleTime);
      }
    }
  }

  setScheduledAlertTime() {
    scheduleTime = tz.TZDateTime(
            getTimeZoneLoc,
            slot.date.year,
            slot.date.month,
            slot.date.day,
            slot.timeRange.start.hour,
            slot.timeRange.start.minute)
        .subtract(getAlertDuration(slot.alert));
    notifyListeners();
  }

  calculateElapsedRanges(DateTime picked) {
    if (isToday(picked)) {
      //If today calculating the elapsed time
      var todNow = TimeOfDay.fromDateTime(tz.TZDateTime.now(getTimeZoneLoc));
      var period;
      if (todNow.period == DayPeriod.am)
        period = todNow.hourOfPeriod + 1;
      else
        period = 12 + todNow.hourOfPeriod + 1;
      printIfDebug("TimeOfDay Now: " + todNow.format(context));
      printIfDebug("TimeOfDay hourOfPeriod: " + period.toString());
      if (officeTiming.end.after(todNow)) {
        isSlotsAvailable = true;
        var start = todNow.before(officeTiming.start)
            ? officeTiming.start
            : TimeOfDay(hour: period, minute: 0);
        printIfDebug("TimeOfDay Start: " + start.format(context));
        printIfDebug(
            "TimeOfDay End: " + start.add(minutes: 30).format(context));
        selectedRange = TimeRangeResult(
          start,
          start.add(minutes: 30),
        );
      } else {
        isSlotsAvailable = false;
        selectedRange = TimeRangeResult(
          TimeOfDay(hour: 09, minute: 00),
          TimeOfDay(hour: 09, minute: 30),
        );
      }
    } else {
      isSlotsAvailable = true;
      selectedRange = TimeRangeResult(
        TimeOfDay(hour: 09, minute: 00),
        TimeOfDay(hour: 09, minute: 30),
      );
    }
  }
}
