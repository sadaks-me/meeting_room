import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  ConnectivityProvider() {
    checkConnectivity();
    streamedConnectivity();
  }

  var connectivityResult;

  checkConnectivity() async {
    await Connectivity().checkConnectivity().then((result) {
      connectivityResult = result;
      notifyListeners();
      print(connectivityResult.toString());
    });
  }

  streamedConnectivity() async {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectivityResult = result;
      notifyListeners();
      print(connectivityResult.toString());
    });
  }
}
