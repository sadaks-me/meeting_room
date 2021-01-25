import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'util.dart';

showToast(String message,
        {String title,
        bool instantInit = true,
        Color backgroundColor,
        Color textColor,
        Duration duration,
        Widget icon,
        bool shouldIconPulse,
        SnackPosition position = SnackPosition.BOTTOM}) =>
    Get.snackbar(title, message,
        backgroundColor: backgroundColor ??
                Hive.box("theme_box").get("theme", defaultValue: "light") ==
                    "dark"
            ? Colors.white
            : Colors.black,
        icon: icon,
        shouldIconPulse: shouldIconPulse,
        snackPosition: position,
        duration: duration,
        instantInit: instantInit,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        colorText: textColor ??
                Hive.box("theme_box").get("theme", defaultValue: "light") ==
                    "dark"
            ? Colors.black
            : Colors.white);

showAppDialog(
        {String title = "",
        String message = "",
        bool instantInit = true,
        Color backgroundColor = Colors.black,
        Color textColor = Colors.white,
        Duration duration,
        bool barrierDismissible = true,
        SnackPosition position = SnackPosition.BOTTOM}) =>
    Get.dialog(AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: WillPopScope(
        onWillPop: () => Future.value(barrierDismissible),
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 26),
                child: Text(title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
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
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () async {
                          Get.back();
                        },
                      ),
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
                          "Done",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Util.appTheme.accentColor),
                        ),
                      ),
                      onPressed: () async {
                        Get.back();
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ));
