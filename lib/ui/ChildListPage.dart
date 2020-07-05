import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/ListsDataModel.dart';
import 'package:lists/ui/ListThingListTile.dart';
import 'package:lists/ui/ListThingThingTile.dart';
import 'package:lists/ui/ListThingEntry.dart';

class ChildListPage extends StatefulWidget {
  const ChildListPage({Key key, this.listName, this.thisThing}) : super(key: key);

  final String    listName;
  final ListThing thisThing;

  @override
  _ChildListPageState createState() => _ChildListPageState();
}

class _ChildListPageState extends State<ChildListPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child:     Scaffold(
        appBar:  AppBar(
            //  Also need to expose route to Settings screen
            title:   Text(widget.listName),
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
            itemCount:   widget.thisThing.items.length,
            itemBuilder: (BuildContext context, int index) {
              var thing = widget.thisThing.items[index];
              if (thing?.isList ?? false || (thing?.thingID ?? 1) == 0) {
                // Always a list on the main page
                return ListThingListTile(thing);
              } else {
                return ListThingThingTile(thing);
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: _onAddButtonPressed, // Prints to debug console
          tooltip:   'Add List',
          child:     Icon(Icons.add),
        ), 
      )
    );
  }

  Future<void> _onAddButtonPressed() async {
    print('KOZZER - in ChildListPage add button pressed');
    var newThing = await Navigator.push<ListThing>(
      context,
      MaterialPageRoute(
        builder:          (context) => ListThingEntry(parentThingID: widget.thisThing.thingID),
        fullscreenDialog: true,
      ),
    );
    if (newThing != null) {
      var newWithID = await StateContainer.of(context).addNewListThing(newThing);
      
      setState(() {
        print('in ChildListPage.setState()');
        widget.thisThing.addChildThing(newWithID);
      });
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    print('KOZZER - in _onWillPop() ... thisThing: ${widget.thisThing.toMap()}');
    // Pop, passing (possibly) updated thing
    Navigator.pop<ListThing>(context, widget.thisThing);
    return false;
  }
}
