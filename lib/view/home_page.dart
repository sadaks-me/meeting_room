import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room/provider/home_provider.dart';
import 'package:meeting_room/view/planner_page.dart';
import 'package:meeting_room/view/settings_page.dart';
import 'package:provider/provider.dart';

import '../util/essentials.dart';
import '../util/util.dart';
import 'plan_detail_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "HomePage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Consumer<HomeProvider>(
      builder: (_, home, __) => Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(12),
            child: FlutterLogo(
              style: FlutterLogoStyle.markOnly,
            ),
          ),
          titleSpacing: 0,
          title: Text(
            "Meeting Planner",
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Get.toNamed(SettingsPage.routeName),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Material(
                color: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: theme.dividerColor)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => home.selectDate(context),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat.yMMMd().format(home.selectedDate) +
                              " " +
                              getTimeZoneLoc.currentTimeZone.abbr,
                          style:
                              textTheme.headline6.copyWith(color: Colors.black),
                        ),
                        if (isToday(home.selectedDate))
                          Text(
                            'Today',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey.shade700),
                          )
                      ],
                    ),
                    trailing: Icon(
                      CupertinoIcons.calendar_today,
                      color: theme.accentColor,
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              height: 0.5,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 16),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      'Bookings',
                      style: textTheme.headline4.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ...home.slots
                      .map((slot) => InkWell(
                            onTap: () async {
                              var result =
                                  await Get.to(PlanDetailPage(slot: slot));
                              if (nonNullNotEmpty(result)) {
                                Util.showToast(result);
                                home.getMeetingSlots();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 16),
                              child: Row(
                                children: [
                                  Material(
                                      color: Colors.grey.shade100,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: BorderSide(
                                              color: theme.dividerColor)),
                                      child: Container(
                                        height: 90,
                                        width: 90,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  slot.timeRange.start
                                                      .format(context),
                                                  style: textTheme.subtitle1
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Divider(
                                                    height: 0.5,
                                                  ),
                                                ),
                                                Text(
                                                  slot.timeZone,
                                                  style: textTheme.caption,
                                                ),
                                                Expanded(
                                                  child: Divider(
                                                    height: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  slot.timeRange.end
                                                      .format(context),
                                                  style: textTheme.subtitle1
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  Expanded(
                                    child: Material(
                                      color: Colors.grey.shade100,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(16),
                                            bottomRight: Radius.circular(16),
                                            bottomLeft: Radius.circular(16),
                                          ),
                                          side: BorderSide(
                                              color: theme.dividerColor)),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  color: Colors.blueGrey),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2, horizontal: 5),
                                              child: Text(
                                                slot.priority.name,
                                                style: textTheme.caption
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(slot.title),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          nonNullNotEmpty(slot.desc)
                                              ? slot.desc
                                              : "---",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList()
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result = await Get.to(PlannerPage(), fullscreenDialog: true);
            if (nonNullNotEmpty(result)) {
              Util.showToast(result);
              home.getMeetingSlots();
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
