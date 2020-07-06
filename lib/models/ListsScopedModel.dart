import 'package:scoped_model/scoped_model.dart';
import 'package:lists/data/ListsAdapter.dart';
import 'package:lists/models/ListThing.dart';

class ListsScopedModel extends Model{

  // Constructor - populate list
  ListsScopedModel() {
    listsAdapter.getListThingByID(0).then(
      (mainList) => _mainList = mainList
    );
  }

  // single ListsAdapter
  final ListsAdapter listsAdapter = ListsAdapter.instance;

  // Main List
  ListThing _mainList;
  ListThing get mainList => _mainList;
  

  // Get data from adapter
  Future<ListsScopedModel> rePopulateListsData() async {
    print('KOZZER - populating _mainList');
    _mainList = await listsAdapter.getListThingByID(0);
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

    return newThing;
  }

  Future<void> removeListThing(ListThing thing) async {
    print('KOZZER - removing item from mainList: ${thing.toMap()}');
    final parentThing = await listsAdapter.getListThingByID(thing.parentThingID);

    await listsAdapter.delete(thing.thingID); // Database
    final refreshed = await listsAdapter.getListThingByID(0);

    _mainList = refreshed;
    parentThing.removeChildThing(thing); // In memory
  }

  Future<void> updateListThing(ListThing updatedThing) async {
    print('KOZZER - updating thing with ID ${updatedThing.thingID}');
    await listsAdapter.update(updatedThing);
    var refreshed = await listsAdapter.getListThingByID(0);

    _mainList = refreshed;
  }
}