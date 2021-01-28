import 'package:flutter/material.dart';
import 'package:meeting_room/model/room.dart';
import 'package:meeting_room/util/essentials.dart';

import '../util/theme/app_colors.dart';

class RoomProvider with ChangeNotifier {
  int activeTileIndex;
  List<Room> rooms = [
    Room(id: '1', name: "Emerald", color: AppColors.appColors[0].name),
    Room(id: '2', name: "Ruby", color: AppColors.appColors[1].name),
    Room(id: '3', name: "Sapphire", color: AppColors.appColors[2].name),
    Room(id: '4', name: "Diamond", color: AppColors.appColors[3].name)
  ];

  void setActiveTileIndex(int index, bool status) {
    activeTileIndex = status ? null : index;
    notifyListeners();
  }

  init() {
    if (meetingRoomBox.isEmpty)
      rooms.forEach((room) => meetingRoomBox.put(room.id, roomToJson(room)));
  }
}
