import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier{
  double progress = 0;

  void changeProgress(double p) {
    progress = p;
    notifyListeners();
  }
  bool isOnline = true;

  void changeStatus() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        isOnline = false;
      } else {
        isOnline = true;
      }
      notifyListeners();
    });
  }
}