import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meeting_room/util/essentials.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimezonesPage extends StatefulWidget {
  static const String routeName = "TimezonesPage";

  @override
  _TimezonesPageState createState() => _TimezonesPageState();
}

class _TimezonesPageState extends State<TimezonesPage> {
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  List<tz.Location> locations = tz.timeZoneDatabase.locations.values.toList();
  List<tz.Location> searchResults = [];

  @override
  void initState() {
    searchController.addListener(() => setState(() {
          searchResults = [];
          String value = searchController.text;
          if (nonNullNotEmpty(value))
            locations.forEach((zone) {
              if (zone.name.toLowerCase().contains(value.toLowerCase()) ||
                  zone.currentTimeZone.abbr
                      .toLowerCase()
                      .contains(value.toLowerCase())) searchResults.add(zone);
            });
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ValueListenableBuilder<Box>(
      valueListenable: localeBox.listenable(),
      builder: (context, box, child) => Scaffold(
        appBar: AppBar(
          title: Text(
              'TimeZone (${box.get("timezone_name", defaultValue: defaultTimeZone)})'),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Material(
                color: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: theme.dividerColor)),
                child: ListTile(
                  onTap: focusSearch,
                  title: TextField(
                    style: textTheme.subtitle1,
                    controller: searchController,
                    focusNode: focusNode,
                    textInputAction: TextInputAction.search,
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        InputDecoration.collapsed(hintText: 'Search Location'),
                  ),
                  trailing: nonNullNotEmpty(searchController.text)
                      ? InkWell(
                          onTap: () {
                            searchController.clear();
                            if (focusNode.hasFocus) focusNode.unfocus();
                          },
                          child: Icon(
                            CupertinoIcons.clear,
                            color: theme.accentColor,
                          ),
                        )
                      : InkWell(
                          onTap: focusSearch,
                          child: Icon(
                            CupertinoIcons.search,
                            color: theme.accentColor,
                          ),
                        ),
                ),
              ),
            ),
            Divider(
              height: 0.5,
            ),
            Expanded(
              child: ListView(
                  children: ListTile.divideTiles(
                      context: context,
                      tiles: (nonNullNotEmpty(searchController.text)
                              ? searchResults
                              : locations)
                          .map((zone) {
                        bool isDefault = box.get("timezone_name",
                                defaultValue: defaultTimeZone) ==
                            zone.name;
                        return ListTile(
                          onTap: () {
                            box.put("timezone_name", zone.name);
                            tz.setLocalLocation(zone);
                          },
                          title: Text(zone.name),
                          subtitle: Text(zone.currentTimeZone.abbr),
                          trailing: isDefault
                              ? Icon(
                                  Icons.done,
                                  color: Colors.green,
                                )
                              : SizedBox(),
                        );
                      })).toList()),
            ),
          ]),
        ),
      ),
    );
  }

  focusSearch() {
    if (!focusNode.hasFocus) FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
