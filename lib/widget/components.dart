import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meeting_room/provider/notification_provider.dart';
import 'package:meeting_room/util/essentials.dart';
import 'package:provider/provider.dart';

import '../util/util.dart';

Widget get notificationSwitcher => ValueListenableBuilder(
    valueListenable: appBox.listenable(),
    builder: (context, box, child) => CupertinoSwitch(
        value: box.get("notification_status", defaultValue: "on") == "on",
        onChanged: (value) {
          var status = value ? "on" : "off";
          box.put("notification_status", status);
          if (!value)
            Provider.of<NotificationProvider>(context, listen: false)
                .cancelAllAlert();
          Util.showToast("Notification turned $status", instantInit: false);
        }));

Widget get alwaysUse24hrsFormatSwitcher => ValueListenableBuilder(
    valueListenable: localeBox.listenable(),
    builder: (context, box, child) => CupertinoSwitch(
        value: box.get("alwaysUse24HourFormat", defaultValue: false) == true,
        onChanged: (value) => box.put("alwaysUse24HourFormat", value)));
