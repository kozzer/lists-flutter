import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/ui/ListThingListTile.dart';
import 'package:lists/ui/ListThingThingTile.dart';
import 'package:lists/ui/ListThingEntry.dart';


class ChildListPage extends StatelessWidget {
  const ChildListPage({Key key, this.listName, this.thisThing}) : super(key: key);

  final String    listName;
  final ListThing thisThing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            print('KOZZER - child list item builder - index: $index');
            var thing = thisThing.items[index];
            if (thing?.isList ?? false || (thing?.thingID ?? 1) == 0) {
              // Always a list on the main page
              return ListThingListTile(thing);
            } else {
              return ListThingThingTile(thing);
            }
          }),
          
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddButtonPressed(context), // Prints to debug console
        tooltip:   'Add List',
        child:     Icon(Icons.add),
      ), 
    );
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
}
