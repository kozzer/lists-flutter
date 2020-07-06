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
    //if (_mainList == null) {
    print('KOZZER - populating _mainList');
    _mainList = await listsAdapter.getListThingByID(0);
    //}
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
      print('KOZZER - in ListsDataModel.addNewListThing.setState()');
      parentThing.addChildThing(newThing);
      parentThing.items.sort((ListThing a, ListThing b) => a.sortOrder.compareTo(b.sortOrder)); // Sorts in place after every add
    });
    return newThing;
  }

  Future<void> removeListThing(ListThing thing) async {
    print('KOZZER - removing item from mainList: ${thing.toMap()}');
    final parentThing = await listsAdapter.getListThingByID(thing.parentThingID);

    await listsAdapter.delete(thing.thingID); // Database
    final refreshed = await listsAdapter.getListThingByID(0);

    setState(() {
      print('KOZZER - in ListsDataModel.removeListThing.setState()');
      _mainList = refreshed;
      parentThing.removeChildThing(thing); // In memory
    });
  }

  Future<void> updateListThing(ListThing updatedThing) async {
    print('KOZZER - updating thing with ID ${updatedThing.thingID}');
    await listsAdapter.update(updatedThing);
    var refreshed = await listsAdapter.getListThingByID(0);

    setState(() {
      print('KOZZER - in ListsDataModel.updateListThing.setState()');
      _mainList = refreshed;
    });
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
  final Key key;
  final ListsDataModel listsDataModel;

  _InheritedStateContainer({
    this.key,
    @required this.listsDataModel,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true; //this.listsDataModel != old.listsDataModel;
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
  ListsDataModel createState() => this.listsDataModel;
}
