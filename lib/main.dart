import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meeting_room/provider/home_provider.dart';
import 'package:meeting_room/provider/room_provider.dart';
import 'package:meeting_room/view/plan_detail_page.dart';
import 'package:provider/provider.dart';

import 'provider/notification_provider.dart';
import 'util/essentials.dart';
import 'util/util.dart';
import 'view/home_page.dart';
import 'view/meeting_rooms_page.dart';
import 'view/planner_page.dart';
import 'view/settings_page.dart';
import 'view/timezones_page.dart';

void main() async {
  await Util.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => RoomProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: localeBox.listenable(),
      builder: (context, box, _) => GetMaterialApp(
        title: 'Meeting Planner',
        debugShowCheckedModeBanner: false,
        theme: Util.appTheme,
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1,
                alwaysUse24HourFormat:
                    box.get("alwaysUse24HourFormat", defaultValue: false)),
            child: child),
        routes: {
          HomePage.routeName: (context) => HomePage(),
          PlannerPage.routeName: (context) => PlannerPage(),
          PlanDetailPage.routeName: (context) => PlanDetailPage(),
          SettingsPage.routeName: (context) => SettingsPage(),
          MeetingRoomsPage.routeName: (context) => MeetingRoomsPage(),
          TimezonesPage.routeName: (context) => TimezonesPage(),
        },
        initialRoute: HomePage.routeName,
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
