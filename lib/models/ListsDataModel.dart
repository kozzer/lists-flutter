import 'package:lists/models/ListThing.dart';
import 'package:lists/data/ListsAdapter.dart';

class ListsDataModel {
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
  Future<ListsDataModel> populateListsData() async {
    // if _database is null we instantiate it
    if (_mainList == null) {
      print('KOZZER - _mainList null, populating now');
      _mainList = await listsAdapter.getListThingByID(0);
    }
    return this;
  }

  ListThing getMainList() {
    print('KOZZER - get mainList');
    return _mainList;
  }

  // Modify data via listsAdapter

  Future<ListThing> addNewListThing(ListThing thing) async {
    print('KOZZER - adding item to mainList: ${thing.toMap()}');

    // Insert into database
    final int newThingId = await listsAdapter.insert(thing);
    ListThing newThing = thing.copyWith(thingID: newThingId);

    // Add to in-memory list
    _mainList.addChildThing(newThing);
    _mainList.items.sort((ListThing a, ListThing b) =>
        a.sortOrder.compareTo(b.sortOrder)); // Sorts in place after every add

    return newThing;
  }

  void removeListThing(ListThing thing) {
    print('KOZZER - removing item from mainList: ${thing.toMap()}');
    listsAdapter.delete(thing.thingID); // Database
    _mainList.removeChildThing(thing); // In memory
  }
}
