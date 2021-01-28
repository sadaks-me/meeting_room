import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meeting_room/model/slot.dart';
import 'package:meeting_room/provider/planner_provider.dart';
import 'package:meeting_room/util/time_range/time_range.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

import '../util/essentials.dart';
import '../util/theme/app_colors.dart';
import '../util/util.dart';

class PlannerPage extends StatelessWidget {
  static const String routeName = "PlannerPage";

  @override
  Widget build(BuildContext topContext) {
    final ThemeData theme = Theme.of(topContext);
    final TextTheme textTheme = theme.textTheme;
    final primary = Util.appTheme.primaryColor;

    final labelStyle = TextStyle(
      fontSize: 15,
      color: primary,
      fontWeight: FontWeight.w600,
    );

    return ChangeNotifierProvider(
      create: (_) => PlannerProvider(topContext),
      child: Consumer<PlannerProvider>(
        builder: (context, provider, __) => Scaffold(
          appBar: AppBar(
            title: Text("Create"),
          ),
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Form(
              key: provider.formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 20),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      keyboardType: TextInputType.text,
                      controller: provider.titleController,
                      textCapitalization: TextCapitalization.sentences,
                      validator: textValidator,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: primary)),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          labelText: 'Title*',
                          labelStyle: labelStyle.copyWith(fontSize: 20),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20)),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 4,
                      keyboardType: TextInputType.text,
                      controller: provider.descController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: primary)),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          labelText: 'Description',
                          labelStyle: labelStyle.copyWith(fontSize: 20),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20)),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () => provider.selectDate(context),
                      child: TextFormField(
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        enabled: false,
                        keyboardType: TextInputType.datetime,
                        controller: provider.dateController,
                        decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primary)),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Date*',
                            labelStyle: labelStyle.copyWith(fontSize: 20),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 20)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  if (provider.isSlotsAvailable) ...{
                    TimeRange(
                      fromTitle: Text(
                        'Start Time* (${getTimeZoneLoc.currentTimeZone.abbr})',
                        style: labelStyle,
                      ),
                      toTitle: Text(
                        'End Time* (${getTimeZoneLoc.currentTimeZone.abbr})',
                        style: labelStyle,
                      ),
                      textStyle: TextStyle(
                          fontSize: 16,
                          color: primary,
                          fontWeight: FontWeight.w700),
                      activeTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                      titlePadding: 20,
                      borderColor: primary,
                      activeBorderColor: primary,
                      backgroundColor: Colors.grey.shade100,
                      activeBackgroundColor: primary,
                      firstTime: provider.officeTiming.start,
                      lastTime: provider.officeTiming.end,
                      initialRange: provider.selectedRange,
                      timeStep: 15,
                      timeBlock: 30,
                      onRangeCompleted: provider.selectTimeRange,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Meeting Room*',
                        style: labelStyle,
                      ),
                    ),
                    Container(
                      height: 80,
                      alignment: Alignment.centerLeft,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        children: provider.rooms.map((room) {
                          bool isSelected = provider.slot.room == room;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Material(
                              color:
                                  isSelected ? primary : Colors.grey.shade100,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: primary)),
                              child: InkWell(
                                onTap: () => provider.setRoom(room),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        room.name,
                                        style: textTheme.headline6.copyWith(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.appColors
                                                .firstWhere((appColor) =>
                                                    appColor.name == room.color)
                                                .color,
                                            border: Border.all(
                                                color: isSelected
                                                    ? Colors.white54
                                                    : Colors.black38)),
                                        height: 40,
                                        width: 40,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Priority*',
                        style: labelStyle,
                      ),
                    ),
                    Container(
                      height: 70,
                      alignment: Alignment.centerLeft,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        children: provider.priorities.map((priority) {
                          bool isSelected = provider.slot.priority == priority;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Material(
                              color:
                                  isSelected ? primary : Colors.grey.shade100,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: primary)),
                              child: InkWell(
                                onTap: () => provider.setPriority(priority),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  alignment: Alignment.center,
                                  child: Text(
                                    priority.name,
                                    style: textTheme.headline6.copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Remind before',
                        style: labelStyle,
                      ),
                    ),
                    Container(
                      height: 75,
                      alignment: Alignment.centerLeft,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        children: Alert.values.map((alert) {
                          var now = tz.TZDateTime.now(getTimeZoneLoc);
                          bool isSelected = provider.slot.alert == alert;
                          bool isActive = provider.scheduleTime.isAfter(now);

                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: RaisedButton(
                              onPressed: isActive
                                  ? () => provider.setAlert(alert)
                                  : null,
                              elevation: 0,
                              color:
                                  isSelected ? primary : Colors.grey.shade100,
                              disabledColor: Colors.grey.shade200,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color: isActive
                                          ? primary
                                          : Colors.transparent)),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                alignment: Alignment.center,
                                child: Text(
                                  alertName(alert),
                                  style: textTheme.headline6.copyWith(
                                      color: isSelected || !isActive
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  } else
                    Container(
                        height: 100,
                        alignment: Alignment.center,
                        child: Text(
                          'No slots available today',
                          style: textTheme.headline6,
                        )),
                  if (provider.isSlotsAvailable)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: RaisedButton(
                          color: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.only(top: 14, bottom: 14),
                          onPressed: () {
                            if (provider.formKey.currentState.validate())
                              provider.saveSlot();
                          },
                          child: Text(
                            'Save',
                            style: topContext.textTheme.headline6
                                .copyWith(fontWeight: FontWeight.w700),
                          )),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
