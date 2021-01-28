import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meeting_room/model/room.dart';
import 'package:meeting_room/provider/room_provider.dart';
import 'package:meeting_room/util/essentials.dart';
import 'package:provider/provider.dart';

import '../util/theme/app_colors.dart';

class MeetingRoomsPage extends StatelessWidget {
  static const String routeName = "ColorsPage";

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
        appBar: AppBar(
          title: Text("Meeting Rooms"),
        ),
        body: Consumer<RoomProvider>(
          builder: (_, provider, __) => ValueListenableBuilder(
              valueListenable: meetingRoomBox.listenable(),
              builder: (context, box, child) {
                Map<dynamic, dynamic> raw = box.toMap();
                List<Room> rooms = raw.values
                    .map((roomJson) => Room.fromJson(jsonDecode(roomJson)))
                    .toList();
                return SingleChildScrollView(
                  child: ExpansionPanelList(
                    expansionCallback: provider.setActiveTileIndex,
                    expandedHeaderPadding: EdgeInsets.symmetric(vertical: 16),
                    children: rooms.map((room) {
                      int index = rooms.indexOf(room);
                      return ExpansionPanel(
                        isExpanded: provider.activeTileIndex == index,
                        canTapOnHeader: true,
                        headerBuilder:
                            (BuildContext context, bool isExpanded) => ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          title: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Room ${index + 1}",
                                        style: textTheme.bodyText2.copyWith(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black54),
                                      ),
                                      Text(
                                        room.name,
                                        style: textTheme.headline6,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.appColors
                                          .firstWhere((appColor) =>
                                              appColor.name == room.color)
                                          .color,
                                      border:
                                          Border.all(color: Colors.black38)),
                                  height: 50,
                                  width: 50,
                                ),
                              ],
                            ),
                          ),
                        ),
                        body: Container(
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text('Change color'),
                              ),
                              Expanded(
                                child: ListView(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(10),
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    for (ColorModel model
                                        in getRemainingColors(rooms))
                                      GestureDetector(
                                        onTap: () {
                                          room.color = model.name;
                                          box.put(room.id, roomToJson(room));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: model.color,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: Colors.black38)),
                                          height: 60,
                                          width: 80,
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
        ));
  }

  List<ColorModel> getRemainingColors(List<Room> rooms) {
    List<ColorModel> colors = AppColors.appColors.toList();
    rooms.forEach((room) {
      int i = colors.indexWhere((color) => color.name == room.color);
      if (i != -1) colors.removeAt(i);
    });
    return colors;
  }
}
