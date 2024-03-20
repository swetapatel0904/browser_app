import 'dart:html';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/shared_helper.dart';

class HomeProvider with ChangeNotifier{
  List <String> bookmarksData=[];
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

  void setbookMarks()async
  {

    if(await getBookMarkData()==null)
    {
      bookmarksData=[];
    }
    else
    {
      bookmarksData=(await getBookMarkData())!;
    }
    notifyListeners();
  }

  void getbookMarks()
  async{

    if(await getBookMarkData()==null)
    {
      bookmarksData=[];
    }
    else
    {
      bookmarksData=(await getBookMarkData())!;
    }
    notifyListeners();
  }


}