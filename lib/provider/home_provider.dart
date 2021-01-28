import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meeting_room/model/slot.dart';
import 'package:meeting_room/util/essentials.dart';
import 'package:timezone/timezone.dart' as tz;

class HomeProvider with ChangeNotifier {
  HomeProvider() {
    selectedDate = tz.TZDateTime.now(getTimeZoneLoc);
    getMeetingSlots();
  }

  List<Slot> slots = [];
  DateTime selectedDate;

  getMeetingSlots() async {
    Map<dynamic, dynamic> raw = meetingSlotBox.toMap();
    slots = raw.values
        .map((packJson) => Slot.fromJson(jsonDecode(packJson)))
        //Filtering selected day's slots
        .where((slot) => isSameDay(
            tz.TZDateTime.fromMillisecondsSinceEpoch(
                getTimeZoneLoc, int.parse(slot.id)),
            selectedDate))
        .toList()
          //Sorting the slots
          ..sort((a, b) => b.priority.id.compareTo(a.priority.id)
              // + toToDDouble(a.timeRange.start)
              //     .compareTo(toToDDouble(b.timeRange.start),
              );
    notifyListeners();
  }

  Future selectDate(BuildContext context) async {
    var now = tz.TZDateTime.now(getTimeZoneLoc);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: now.subtract(Duration(days: 30)),
        lastDate: now.add(Duration(days: 30)));
    if (picked != null) {
      selectedDate = tz.TZDateTime.from(picked, getTimeZoneLoc);
      getMeetingSlots();
    }
  }
}
