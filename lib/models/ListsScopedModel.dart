import 'package:scoped_model/scoped_model.dart';
import 'package:lists/data/ListsSqLiteAdapter.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/ui/themes/ListsTheme.dart';
import 'package:flutter/material.dart';

class ListsScopedModel extends Model{

  // Constructor 
  ListsScopedModel(){
    print('KOZZER - ListsScopedModel constructor');
  } 

  // single ListsAdapter
  final ListsSqLiteAdapter listsAdapter = ListsSqLiteAdapter.instance;

  // Main List
  ListThing _mainList;
  ListThing get mainList => _mainList;

  // User's theme
  ListsTheme _listsTheme;
  ListsTheme get listsTheme => _listsTheme;
  
  /// Populate main list from database -- 
  ///   notify: needs to be false on app startup 
  ///           because if it fires then, it somehow causes 
  ///           an endless loop of data access
  Future<ListsScopedModel> populateListsModel({bool notify = true}) async {

    // App Theme
    if (_listsTheme == null){

      final String primaryColor = await listsAdapter.getThemeColorString(true);
      final String accentColor  = await listsAdapter.getThemeColorString(false);

      _listsTheme = ListsTheme(
        isDark:       await listsAdapter.getIsDarkTheme(), 
        primaryColor: Color(int.parse(primaryColor.substring(0, 8), radix: 16) + 0x00000000),
        accentColor:  Color(int.parse(accentColor.substring(0, 8), radix: 16) + 0x00000000)
      );
    }

    // Lists data
    print('KOZZER - populating _mainList');
    await Future.delayed(Duration(seconds: 2));
    await listsAdapter.getListThingByID(0).then((dbList) { 
      _mainList = dbList;
      if (notify) 
        notifyListeners(); 
    });

    return this;  // <-- main list ScopedModelDescendant widget needs this
  }


  // Modify data via listsAdapter
  Future<ListThing> addNewListThing(ListThing newThing, { bool keepSortOrder = false }) async {
    print('KOZZER - adding item: ${newThing.toMap()}');

    // Insert into database
    final addedThing = await listsAdapter.insert(newThing, keepSortOrder);

    // Add into memory
    final parentThing = findListThingByID(addedThing.parentThingID, _mainList.items);
    parentThing.addChildThing(addedThing);

    notifyListeners();
    return addedThing;
  }

  Future<void> removeListThing(ListThing thing, { bool notify = true }) async {
    print('KOZZER - removing item from mainList: ${thing.toMap()}');

    // Remove from database
    await listsAdapter.delete(thing.thingID); 

    // Remove from memory
    final parentThing = findListThingByID(thing.parentThingID, _mainList.items);
    parentThing.removeChildThing(thing); 

    if (notify)
      notifyListeners();
  }

  Future<void> updateListThing(ListThing updatedThing, { bool notify = true }) async {
    print('KOZZER - updating thing with ID ${updatedThing.thingID}');

    // Update in database
    await listsAdapter.update(updatedThing);

    // Update in memory
    final theThing = findListThingByID(updatedThing.thingID, _mainList.items);
    theThing.label     = updatedThing.label;
    theThing.icon      = updatedThing.icon;
    theThing.isList    = updatedThing.isList;
    theThing.isMarked  = updatedThing.isMarked;
    theThing.sortOrder = updatedThing.sortOrder;
  
    if (notify)
      notifyListeners();
  }

  void notifyModelListeners() => notifyListeners();

  /// Flattens all list things and returns the in-memory object with the same ID
  ListThing findListThingByID(int targetThingID, List<ListThing> thingList) {
    if (targetThingID == 0)
      return _mainList;
      
    final flatList = _getFlatList(_mainList.items);
    return flatList.where((thing) => thing.thingID == targetThingID).first;
  }

  List<ListThing> _getFlatList(List<ListThing> thingList){
    final flatList = new List<ListThing>();
    thingList.forEach((thing) { 

      flatList.add(thing);

      if (thing.isList && thing.items.length > 0)
        flatList.addAll(_getFlatList(thing.items));
    });
    return flatList;
  }

  void setThemePrimaryColor(Color newColor){
    final String colorString = '${newColor.value.toRadixString(16)}';
    listsAdapter.setThemeColorByString(colorString, true);
    _listsTheme.primaryColor = newColor;
    notifyListeners();
  }
  void setThemeAccentColor(Color newColor){
    final String colorString = '${newColor.value.toRadixString(16)}';
    listsAdapter.setThemeColorByString(colorString, false);
    _listsTheme.accentColor = newColor;
    notifyListeners();
  }
  void setIsDarkTheme(bool isDark){
    listsAdapter.setIsDarkTheme(isDark);
    _listsTheme.isDark = isDark;
    notifyListeners();
  }
}