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
  Future<ListThing> addNewListThing(ListThing thing) async {
    print('KOZZER - adding item to mainList: ${thing.toMap()}');

    // Insert into database
    final newThing    = await listsAdapter.insert(thing);
    final parentThing = await listsAdapter.getListThingByID(thing.parentThingID);

    // Add into memory
    parentThing.addChildThing(newThing);
    parentThing.items.sort((ListThing a, ListThing b) => a.sortOrder.compareTo(b.sortOrder)); // Sorts in place after every add

    notifyListeners();
    return newThing;
  }

  Future<void> removeListThing(ListThing thing) async {
    print('KOZZER - removing item from mainList: ${thing.toMap()}');
    final parentThing = await listsAdapter.getListThingByID(thing.parentThingID);

    await listsAdapter.delete(thing.thingID); // Database
    final refreshed = await listsAdapter.getListThingByID(0);

    _mainList = refreshed;
    parentThing.removeChildThing(thing); // In memory
    notifyListeners();
  }

  Future<void> updateListThing(ListThing updatedThing) async {
    print('KOZZER - updating thing with ID ${updatedThing.thingID}');
    await listsAdapter.update(updatedThing);
    var refreshed = await listsAdapter.getListThingByID(0);

    _mainList = refreshed;
    notifyListeners();
  }
}