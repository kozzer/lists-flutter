import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/UserSettings.dart';
import 'package:lists/data/ListsDataAdapter.dart';

class ListsDataModel extends ChangeNotifier{

  ListsDataModel() {
    print('KOZZER - ListsDataModel constructor');
    populateListsData();
  }

  ListsDataAdapter _listsDataAdapter = ListsDataAdapter();
  List<ListThing> _listsData ;

  UserSettings _userSettings;
  UserSettings get userSettings => _userSettings;

  void setUserSettings(UserSettings settings) {
    _userSettings = settings;
    notifyListeners();
  }

  Future<void> populateListsData() async {
    // if _database is null we instantiate it
    if (_listsData == null) {
      print('KOZZER - _mainList null, populating now');
      _listsData = await _listsDataAdapter.getChildItemsForListId(-1);
    }
  }

  Future<List<ListThing>> getMainList() async {
    print('KOZZER - get mainList');

    await populateListsData();
    return _listsData;
  }   

  void addList(ListThing thing){
    _listsData.add(thing);
    _listsData.sort((ListThing a, ListThing b) => a.sortOrder.compareTo(b.sortOrder));  // Sorts in place after every add
    notifyListeners();
  }

  void removeList(ListThing thing){
    _listsData.remove(thing);
    notifyListeners();
  }

}