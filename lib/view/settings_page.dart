import 'package:archo/model/user.dart';
import 'package:archo/provider/home_provider.dart';
import 'package:archo/util/essentials.dart';
import 'package:archo/view/colors_page.dart';
import 'package:archo/view/typography_page.dart';
import 'package:archo/widget/component/ui_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:build_context/build_context.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = "SettingsPage";

  @override
  Widget build(context) {
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);
    print('Settings Executed');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Light Mode"),
                    SizedBox(
                      width: 20,
                    ),
                    themeSwitcher,
                    SizedBox(
                      width: 20,
                    ),
                    Text("Dark Mode"),
                  ],
                )),
            Divider(
              height: 0.5,
            ),
            ValueListenableBuilder<Box>(
              valueListenable: Hive.box('app_box').listenable(),
              builder: (context, box, child) => ExpansionTile(
                tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                title: Text('Show Toast'),
                children: [
                  Container(
                    margin: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Text(
                                      'With Title',
                                      style: context.textTheme.caption,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CupertinoSwitch(
                                        value: box.get("show_title",
                                            defaultValue: false),
                                        onChanged: (value) =>
                                            box.put("show_title", value)),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Row(
                                  children: [
                                    Text(
                                      'With Icon',
                                      style: context.textTheme.caption,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CupertinoSwitch(
                                        value: box.get("show_icon",
                                            defaultValue: false),
                                        onChanged: (value) =>
                                            box.put("show_icon", value)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.theme.accentColor),
                          child: IconButton(
                            onPressed: () {
                              showToast(
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                                title:
                                    box.get("show_title", defaultValue: false)
                                        ? "Title goes here"
                                        : null,
                                icon: box.get("show_icon", defaultValue: false)
                                    ? Icon(
                                        Icons.person,
                                        color: context.theme.accentColor,
                                      )
                                    : null,
                              );
                            },
                            icon: Icon(Icons.arrow_forward),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
                onTap: () {
                  showAppDialog(
                    title: "Title goes here",
                    message:
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                title: Text('Show Dialog')),
            Divider(
              height: 0.5,
            ),
            ListTile(
                onTap: () async {
                  await homeProvider.init();
                  showToast("Users updated");
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                title: Text('Trigger User Api from Home')),
            Divider(
              height: 0.5,
            ),
            ListTile(
                onTap: () => Get.toNamed(TypographyPage.routeName),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                title: Text('Typography')),
            Divider(
              height: 0.5,
            ),
            ListTile(
                onTap: () => Get.toNamed(ColorsPage.routeName),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                title: Text('Theme Colors')),
            Divider(
              height: 0.5,
            ),
          ],
        ),
      ),
    );
  }
}
