import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/UserSettings.dart';

class ListsDataModel extends ChangeNotifier{

  final List<ListThing> _mainList = [];
  List<ListThing> get mainList => _mainList;  // Return sorted list
  int get mainListSize => _mainList.length;

  UserSettings _userSettings;
  UserSettings get userSettings => _userSettings;

  void setUserSettings(UserSettings settings) {
    _userSettings = settings;
    notifyListeners();
  }

  ListsDataModel();   // CONSTRUCTOR: Data access here? - list data & user settings

  void addList(ListThing thing){
    _mainList.add(thing);
    _mainList.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));  // Sorts in place after every add
    notifyListeners();
  }

  void removeList(ListThing thing){
    _mainList.remove(thing);
    notifyListeners();
  }
}