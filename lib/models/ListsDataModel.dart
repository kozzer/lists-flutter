import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/data/ListsAdapter.dart';

class ListsDataModel extends State<StateContainer> {
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
    final newThing    = await listsAdapter.insert(thing);
    final parentThing = await listsAdapter.getListThingByID(thing.parentThingID);

    setState(() {
      // Add to in-memory list
      parentThing.addChildThing(newThing);
      parentThing.items.sort((ListThing a, ListThing b) => a.sortOrder.compareTo(b.sortOrder)); // Sorts in place after every add
    });
    return newThing;
  }

  Future<void> removeListThing(ListThing thing) async {
    print('KOZZER - removing item from mainList: ${thing.toMap()}');
    var parentThing = await listsAdapter.getListThingByID(thing.parentThingID);
    listsAdapter.delete(thing.thingID); // Database

    setState(() {
      parentThing.removeChildThing(thing); // In memory
    });
  }

  Future<void> updateListThing(ListThing updatedThing) async {
    print('KOZZER - updating thing with ID ${updatedThing.thingID}');
    await listsAdapter.update(updatedThing);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      listsDataModel: this,
      child:          widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final ListsDataModel listsDataModel;

  _InheritedStateContainer({
    Key key,
    @required this.listsDataModel,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}

class StateContainer extends StatefulWidget {
  final Widget         child;
  final ListsDataModel listsDataModel;

  StateContainer({@required this.child, @required this.listsDataModel});

  static ListsDataModel of(BuildContext context) {
    // ignore: deprecated_member_use
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer) as _InheritedStateContainer)
        .listsDataModel;
  }

  @override
  ListsDataModel createState() => new ListsDataModel();
}
