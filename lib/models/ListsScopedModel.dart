import 'package:scoped_model/scoped_model.dart';
import 'package:lists/data/ListsAdapter.dart';
import 'package:lists/models/ListThing.dart';

class ListsScopedModel extends Model{

  // Constructor 
  ListsScopedModel(); 

  // single ListsAdapter
  final ListsAdapter listsAdapter = ListsAdapter.instance;

  // Main List
  ListThing _mainList;
  ListThing get mainList => _mainList;
  
  // Get data from adapter
  Future<ListsScopedModel> populateListsData({bool notify = true}) async {
    print('KOZZER - populating _mainList');
    listsAdapter.getListThingByID(0).then((dbList) { 
      _mainList = dbList;
      if (notify) 
        notifyListeners(); 
    });
    return this;
  }


  // Modify data via listsAdapter
  Future<ListThing> addNewListThing(ListThing newThing) async {
    print('KOZZER - adding item: ${newThing.toMap()}');

    // Insert into database
    final addedThing = await listsAdapter.insert(newThing);

    // Add into memory
    final parentThing = findListThingByID(newThing.parentThingID, _mainList.items);
    parentThing.addChildThing(addedThing);
    parentThing.items.sort((ListThing a, ListThing b) => a.sortOrder.compareTo(b.sortOrder)); // Sorts in place after every add

    notifyListeners();
    return addedThing;
  }

  Future<void> removeListThing(ListThing thing) async {
    print('KOZZER - removing item from mainList: ${thing.toMap()}');

    // Remove from database
    await listsAdapter.delete(thing.thingID); 

    // Remove from memory
    final parentThing = findListThingByID(thing.parentThingID, _mainList.items);
    parentThing.removeChildThing(thing); 

    notifyListeners();
  }

  Future<void> updateListThing(ListThing updatedThing) async {
    print('KOZZER - updating thing with ID ${updatedThing.thingID}');

    // Update in database
    await listsAdapter.update(updatedThing);

    // Update in memory
    final theThing    = findListThingByID(updatedThing.thingID, _mainList.items);
    theThing.label    = updatedThing.label;
    theThing.icon     = updatedThing.icon;
    theThing.isList   = updatedThing.isList;
    theThing.isMarked = updatedThing.isMarked;

    notifyListeners();
  }

  /// Flattens all list things and returns the in-memory object with the same ID
  ListThing findListThingByID(int targetThingID, List<ListThing> thingList) {
    final flatList = _getFlatList(_mainList.items);
    return flatList.where((thing) => thing.thingID == targetThingID).first;
  }

  List<ListThing> _getFlatList(List<ListThing> thingList){
    final flatList = new List<ListThing>();
    thingList.forEach((thing) { 
      if (thing.isList && thing.items.length > 0){
        flatList.addAll(_getFlatList(thing.items));
      } else {
        flatList.add(thing);
      }
    });
    return flatList;
  }
}