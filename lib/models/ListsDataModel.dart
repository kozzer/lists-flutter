import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/UserSettings.dart';
import 'package:lists/data/ListsAdapter.dart';

class ListsDataModel extends ChangeNotifier{

  ListsDataModel();

  List<ListThing> _mainList = <ListThing>[];

  int get mainListSize => _mainList.length;

  UserSettings _userSettings;
  UserSettings get userSettings => _userSettings;

  void setUserSettings(UserSettings settings) {
    _userSettings = settings;
    notifyListeners();
  }

  Future<List<ListThing>> get mainList async {
    if (mainList != null)
      return _mainList;

    // if _database is null we instantiate it
    _mainList = await getAllListsData();
    return _mainList;
  }   

  void addList(ListThing thing){
    _mainList.add(thing);
    _mainList.sort((ListThing a, ListThing b) => a.sortOrder.compareTo(b.sortOrder));  // Sorts in place after every add
    notifyListeners();
  }

  void removeList(ListThing thing){
    _mainList.remove(thing);
    notifyListeners();
  }

  ListThing getMainListThing(int index) => _mainList[index];
}