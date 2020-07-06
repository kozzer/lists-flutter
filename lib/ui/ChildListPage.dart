import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/ui/ListThingListTile.dart';
import 'package:lists/ui/ListThingThingTile.dart';
import 'package:lists/ui/ListThingEntry.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:lists/models/ListsScopedModel.dart';


class ChildListPage extends StatelessWidget {
  const ChildListPage({Key key, this.listName, this.thisThing}) : super(key: key);

  final String    listName;
  final ListThing thisThing;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child:     ScopedModelDescendant<ListsScopedModel>(
        builder: (context, child, model) => Scaffold(
        appBar:  AppBar(
            //  Also need to expose route to Settings screen
            title:   Text(listName),
            actions: <Widget>[
              // action button
              IconButton(
                icon:      Icon(Icons.more_vert),
                onPressed: () {
                  print('pushed!');
                },
              ),
            ]),
        body: ListView.builder(
            itemCount:   thisThing.items.length,
            itemBuilder: (BuildContext context, int index) {
              var thing = thisThing.items[index];
              if (thing?.isList ?? false || (thing?.thingID ?? 1) == 0) {
                // Always a list on the main page
                return ListThingListTile(thing, model);
              } else {
                return ListThingThingTile(thing, model);
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _onAddButtonPressed(context), // Prints to debug console
          tooltip:   'Add List',
          child:     Icon(Icons.add),
        ), 
      )
    ));
  }

  Future<void> _onAddButtonPressed(BuildContext context) async {
    print('KOZZER - in ChildListPage add button pressed');
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListThingEntry(parentThingID: thisThing.thingID),
        fullscreenDialog: true,
      ),
    );
  }


  Future<bool> _onWillPop(BuildContext context) async {
    print('KOZZER - in _onWillPop() ... thisThing: ${thisThing.toMap()}');
    // Pop, passing (possibly) updated thing
    Navigator.pop(context);
    return false;
  }
}
