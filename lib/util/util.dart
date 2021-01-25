import 'dart:io';
import 'dart:ui';

import 'package:archo/controller/dio_retry.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:archo/controller/api.dart';

import 'route_builder.dart';

Dio dio = new Dio();
DioCacheManager dioCacheManager =
    DioCacheManager(CacheConfig(baseUrl: Api.baseUrl));

class Util {
  static Future initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    Provider.debugCheckInvalidValueType = null;
    // "Hive" a better & faster storage than shared_preference
    Hive.init((await getApplicationDocumentsDirectory()).path);
    await Hive.openBox('app_box');
    await Hive.openBox('theme_box');
    dioCacheManager.clearExpired();
  }

  static ThemeData get appTheme =>
      Hive.box("theme_box").get("theme", defaultValue: "light") == "light"
          ? lightTheme
          : darkTheme;

  //Customize your theme here
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primarySwatch: Colors.blueGrey,
      primaryColor: Colors.black,
      accentColor: Colors.blue,
      backgroundColor: Colors.blueGrey,
      scaffoldBackgroundColor: Colors.blueGrey.shade900,
      fontFamily: "PublicSans");

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primarySwatch: Colors.blueGrey,
      primaryColor: Colors.blueGrey.shade900,
      accentColor: Colors.blue,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: "PublicSans");

  static String capitalize(String name) {
    assert(name != null && name.isNotEmpty);
    return name.substring(0, 1).toUpperCase() + name.substring(1);
  }

  static platformRoute({@required Widget page, bool isDialog = false}) {
    if (Platform.isIOS || isDialog)
      return MaterialPageRoute(
          builder: (context) => page, fullscreenDialog: isDialog);
    else
      return SlideLeftRoute(
        page: page,
      );
  }

  static initDio(BuildContext context) {
    dio.interceptors.addAll([
      dioCacheManager.interceptor,
      RetryOnConnectionChangeInterceptor(
        context,
        requestRetrier: DioConnectivityRequestRetry(
          dio: dio,
          connectivity: Connectivity(),
        ),
      ),
      RetryInterceptor(
          options: RetryOptions(
            retries: 3,
            retryInterval: const Duration(seconds: 5),
            retryEvaluator: (error) =>
                error.type != DioErrorType.CANCEL &&
                error.type != DioErrorType.RESPONSE,
          ),
          dio: dio)
    ]);
  }
}
