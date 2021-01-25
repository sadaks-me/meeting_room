import 'package:archo/controller/api.dart';
import 'package:archo/provider/home_provider.dart';
import 'package:archo/view/colors_page.dart';
import 'package:archo/view/typography_page.dart';
import 'package:archo/widget/no_internet.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'provider/app_provider.dart';
import 'provider/connectivity_provider.dart';
import 'util/util.dart';
import 'view/home_page.dart';
import 'view/settings_page.dart';

void main() async {
  await Util.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider(context)),
        ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
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
  void initState() {
    super.initState();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => Util.initDio(context));
  }

  @override
  Widget build(BuildContext context) {
    var appProvider = Provider.of<AppProvider>(context, listen: false);

    return Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ValueListenableBuilder<Box>(
              valueListenable: Hive.box('theme_box').listenable(),
              builder: (context, box, child) {
                printIfDebug("App Releaded");
                return GetMaterialApp(
                  title: 'Flutter Archo',
                  debugShowCheckedModeBanner: false,
                  theme: box.get("theme", defaultValue: "light") == "light"
                      ? Util.lightTheme
                      : Util.darkTheme,
                  routes: {
                    HomePage.routeName: (context) => HomePage(),
                    SettingsPage.routeName: (context) => SettingsPage(),
                    TypographyPage.routeName: (context) => TypographyPage(),
                    ColorsPage.routeName: (context) => ColorsPage(),
                  },
                  routingCallback: (routing) {
                    if (!routing.isSnackbar)
                      printIfDebug("Route: " + routing.current);
                  },
//                onGenerateRoute: (settings) {
//                  switch (settings.name) {
//                    case HomePage.routeName:
//                      return Util.platformRoute(
//                          page: SettingsPage(), isDialog: true);
//                      break;
//                  }
//                  return null;
//                },
                  initialRoute: HomePage.routeName,
                );
              },
            ),
            Consumer<ConnectivityProvider>(
                builder: (context, connectivity, _) =>
                    (connectivity.connectivityResult != null &&
                            connectivity.connectivityResult ==
                                ConnectivityResult.none)
                        ? NoInternetView()
                        : SizedBox())
          ],
        ));
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
