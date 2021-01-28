import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meeting_room/util/essentials.dart';
import 'package:meeting_room/util/time_range/time_range.dart';
import 'package:meeting_room/view/meeting_rooms_page.dart';
import 'package:meeting_room/widget/components.dart';

import '../util/essentials.dart';
import '../util/util.dart';
import 'timezones_page.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = "SettingsPage";

  @override
  Widget build(context) {
    Color primary = Util.appTheme.primaryColor;
    final defaultDay = TimeRangeResult(
      TimeOfDay(hour: 0, minute: 0),
      TimeOfDay(hour: 24, minute: 00),
    );
    final labelStyle = TextStyle(
      fontSize: 15,
      color: primary,
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ValueListenableBuilder<Box>(
                valueListenable: appBox.listenable(),
                builder: (context, box, child) {
                  var start = getTimeFromMinutes(box.get("office_timing_start",
                      defaultValue: defaultOfficeTiming.start.inMinutes()));
                  var end = getTimeFromMinutes(box.get("office_timing_end",
                      defaultValue: defaultOfficeTiming.end.inMinutes()));

                  TimeRangeResult officeTiming = TimeRangeResult(start, end);

                  return ExpansionTile(
                      tilePadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Office Timing'),
                          Text(
                            TimeRangeExt(officeTiming).formatRange,
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 20),
                          child: TimeRange(
                            key: ValueKey(routeName),
                            fromTitle: Text(
                              'Day Start',
                              style: labelStyle,
                            ),
                            toTitle: Text(
                              'Day End',
                              style: labelStyle,
                            ),
                            textStyle: TextStyle(
                                fontSize: 16,
                                color: primary,
                                fontWeight: FontWeight.w700),
                            activeTextStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                            titlePadding: 20,
                            borderColor: primary,
                            activeBorderColor: primary,
                            backgroundColor: Colors.grey.shade100,
                            activeBackgroundColor: primary,
                            firstTime: defaultDay.start,
                            lastTime: defaultDay.end,
                            initialRange: officeTiming,
                            timeStep: 30,
                            timeBlock: 30,
                            onRangeCompleted: (range) {
                              if (range != null) {
                                TimeRangeExt(range).printRange;
                                box.put("office_timing_start",
                                    range.start.inMinutes());
                                box.put(
                                    "office_timing_end", range.end.inMinutes());
                              }
                            },
                          ),
                        ),
                      ]);
                }),
            Divider(
              height: 0.5,
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              title: Text("Notification Alert"),
              trailing: notificationSwitcher,
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              title: Text("Use 24 Hour Format"),
              trailing: alwaysUse24hrsFormatSwitcher,
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
              onTap: () => Get.toNamed(TimezonesPage.routeName),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Time Zone'),
                  Text(
                    localeBox.get("timezone_name",
                            defaultValue: defaultTimeZone) +
                        " (${getTimeZoneLoc.currentTimeZone.abbr})",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
                onTap: () => Get.toNamed(MeetingRoomsPage.routeName),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                title: Text('Meeting Rooms')),
            Divider(
              height: 0.5,
            ),
          ],
        ),
      ),
    );
  }
}
