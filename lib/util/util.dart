import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meeting_room/util/essentials.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Util {
  static Future initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    Provider.debugCheckInvalidValueType = null;
    tz.initializeTimeZones();

    // "Hive" a better & faster storage than shared_preference
    Hive.init((await getApplicationDocumentsDirectory()).path);
    // Setting up the boxes
    var box = await Hive.openBox('locale_box');
    if (!box.containsKey("timezone_name"))
      tz.setLocalLocation(tz.getLocation(defaultTimeZone));
    await Hive.openBox('app_box');
    await Hive.openBox('meeting_room_box');
    await Hive.openBox('meeting_slot_box');
  }

  static ThemeData get appTheme => lightTheme;

  //Customize your theme here
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primarySwatch: Colors.blueGrey,
      primaryColor: Colors.black,
      accentColor: Colors.blue,
      backgroundColor: Colors.blueGrey,
      scaffoldBackgroundColor: Colors.blueGrey.shade900);

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primarySwatch: Colors.blueGrey,
      primaryColor: Colors.blueGrey.shade900,
      accentColor: Colors.blue,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white);

  static showToast(String message,
          {String title,
          bool instantInit = true,
          Color backgroundColor,
          Color textColor,
          Duration duration,
          Widget icon,
          bool shouldIconPulse,
          SnackPosition position = SnackPosition.BOTTOM}) =>
      Get.snackbar(title, message,
          backgroundColor: backgroundColor ?? Colors.black,
          icon: icon,
          shouldIconPulse: shouldIconPulse,
          snackPosition: position,
          duration: duration,
          instantInit: instantInit,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          colorText: textColor ?? Colors.white);

  static showDialog(
          {String title,
          String message = "",
          String possitiveText = "Yes",
          String negativeText = "Cancel",
          bool instantInit = true,
          Color backgroundColor = Colors.black,
          Color textColor = Colors.white,
          Duration duration,
          bool barrierDismissible = true,
          SnackPosition position = SnackPosition.BOTTOM,
          @required VoidCallback onDonePressed}) =>
      Get.dialog(AlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: WillPopScope(
          onWillPop: () => Future.value(barrierDismissible),
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (nonNullNotEmpty(title))
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 26),
                    child: Text(title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Divider(
                  height: 0.5,
                ),
                Row(
                  children: [
                    if (barrierDismissible) ...{
                      Expanded(
                        child: FlatButton(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                negativeText,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            onPressed: () => Get.back()),
                      ),
                      Container(
                        height: 50,
                        color: Util.appTheme.dividerColor,
                        width: 0.5,
                      )
                    },
                    Expanded(
                      child: FlatButton(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            possitiveText,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Util.appTheme.accentColor),
                          ),
                        ),
                        onPressed: onDonePressed,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ));
}
