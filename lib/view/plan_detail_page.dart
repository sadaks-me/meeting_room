import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room/model/slot.dart';
import 'package:meeting_room/util/essentials.dart';
import 'package:meeting_room/util/theme/app_colors.dart';
import 'package:meeting_room/util/util.dart';

class PlanDetailPage extends StatelessWidget {
  static const String routeName = "PlanDetailPage";

  const PlanDetailPage({Key key, this.slot}) : super(key: key);

  final Slot slot;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("Schedule")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Material(
                            color: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: theme.dividerColor)),
                            child: Container(
                              height: 90,
                              width: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        slot.timeRange.start.format(context),
                                        style: textTheme.subtitle1.copyWith(
                                            fontWeight: FontWeight.bold),
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
                                        slot.timeRange.end.format(context),
                                        style: textTheme.subtitle1.copyWith(
                                            fontWeight: FontWeight.bold),
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
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: theme.dividerColor)),
                              child: Container(
                                height: 90,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          DateFormat.yMMMd().format(slot.date),
                                          style: textTheme.subtitle1.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 0.5,
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColors.appColors
                                                      .firstWhere((appColor) =>
                                                          appColor.name ==
                                                          getRoomFromId(
                                                                  slot.room.id)
                                                              .color)
                                                      .color,
                                                  border: Border.all(
                                                      color: Colors.black38)),
                                              height: 20,
                                              width: 20,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              slot.room.name,
                                              style: textTheme.subtitle1
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Material(
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          side: BorderSide(color: theme.dividerColor)),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.blueGrey),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 5),
                              child: Text(
                                slot.priority.name,
                                style: textTheme.caption.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              slot.title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              nonNullNotEmpty(slot.desc) ? slot.desc : "---",
                              style: TextStyle(fontSize: 16, height: 1.3),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            RaisedButton(
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.only(top: 14, bottom: 14),
                onPressed: () async {
                  var result = await Util.showDialog(
                      title: "Remove Schedule",
                      negativeText: "No",
                      message: "Are you sure want to remove the schedule?",
                      onDonePressed: () {
                        meetingSlotBox.delete(slot.id);
                        Get.back(result: "Schedule removed");
                      });
                  if (nonNullNotEmpty(result)) Get.back(result: result);
                },
                child: Text(
                  'Remove',
                  style: context.textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w700, color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
