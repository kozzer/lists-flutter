import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/UserSettings.dart';

class ListThingModel extends ChangeNotifier{

  final List<ListThing> _mainList = [];
  List<ListThing> get mainList => _mainList;

  UserSettings _userSettings;
  UserSettings get userSettings => _userSettings;

  void setUserSettings(UserSettings settings) {
    _userSettings = settings;
    notifyListeners();
  }

  ListThingModel();   // Data access here? - list data & user settings
}