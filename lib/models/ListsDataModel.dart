import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/data/ListsAdapter.dart';

class ListsDataModel extends ChangeNotifier{

  // Constructor
  ListsDataModel();

  // ListsAdapter
  final ListsAdapter listsAdapter = ListsAdapter.instance;

  // Main List
  ListThing _mainList;
  Future<ListThing> get mainList async {
    _mainList ??= await listsAdapter.getListThingByID(0);
    return _mainList;
  }


  // Get data from adapter

  Future<void> populateListsData() async {
    // if _database is null we instantiate it
    if (_mainList == null) {
      print('KOZZER - _mainList null, populating now');
      _mainList = await listsAdapter.getListThingByID(0);
    }
    notifyListeners();
  }

  ListThing getMainList() {
    print('KOZZER - get mainList');
    return _mainList;
  }   

  // Modify data via listsAdapter

  void addList(ListThing thing){
    print('KOZZER - adding item to mainList: ${thing.toMap()}');
    listsAdapter.insert(thing);       // Database
    _mainList.addChildThing(thing);   // In memory
    _mainList.items.sort((ListThing a, ListThing b) => a.sortOrder.compareTo(b.sortOrder));  // Sorts in place after every add
    notifyListeners();
  }

  void removeList(ListThing thing){
    print('KOZZER - removing item from mainList: ${thing.toMap()}');
    listsAdapter.delete(thing.thingID);   // Database 
    _mainList.removeChildThing(thing);    // In memory 
    notifyListeners();
  }

}