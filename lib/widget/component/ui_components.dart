import 'package:archo/util/essentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

var themeBox = Hive.box("theme_box");

// if dark true else false
Widget get themeSwitcher => CupertinoSwitch(
    value: themeBox.get("theme", defaultValue: "light") == "dark",
    onChanged: (value) {
      var theme = value ? "dark" : "light";
      themeBox.put("theme", theme);
      showToast("Switched to $theme mode", instantInit: false);
    });
