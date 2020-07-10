import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:lists/ui/widgets/ListThingListTile.dart';
import 'package:lists/ui/widgets/ListThingThingTile.dart';
import 'package:lists/ui/pages/ListThingEntry.dart';
import 'package:lists/ui/widgets/SwipeBackground.dart';


class ChildListPage extends StatefulWidget {
  const ChildListPage({this.key, this.listName, this.thisThing}) : super(key: key);

  final Key       key;
  final String    listName;
  final ListThing thisThing;

  @override
  _ChildListPageState createState() => _ChildListPageState();
}

class _ChildListPageState extends State<ChildListPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
          //  Also need to expose route to Settings screen
          title:   Text(widget.listName, style: Theme.of(context).textTheme.headline1),
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
            final thing = widget.thisThing.items[index];

            return Dismissible (
              key:          UniqueKey(),
              onDismissed:  (DismissDirection direction) {
                print('KOZZER - swiped: ${thing.toMap()}');
                ScopedModel.of<ListsScopedModel>(context).removeListThing(thing);
                setState(() {
                  widget.thisThing.items.removeAt(index);
                });
              },
              background:   SwipeBackground(),
              child:        Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(
                    color: Theme.of(context).primaryColor.withAlpha(192),
                    width: 0.5
                  )),
                ),
                child: ((thing?.isList ?? false || (thing?.thingID ?? 1) == 0)) 
                  ? ListThingListTile(thing) 
                  : ListThingThingTile(thing)
              )
            );   
          }
        ),
          
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddButtonPressed(context), 
        tooltip:   'Add List',
        child:     Icon(Icons.add),
      ), 
    );
  }

  Future<void> _onAddButtonPressed(BuildContext context) async {
    print('KOZZER - in ChildListPage add button pressed');
    final newThing = await Navigator.push<ListThing>(
      context,
      MaterialPageRoute(
        builder: (context) => ListThingEntry(parentThingID: widget.thisThing.thingID),
        fullscreenDialog: true,
      ),
    );
    if (newThing != null)
      setState(() {
        widget.thisThing.addChildThing(newThing);
      });
      
  }

  Future<void> _onDismissed(BuildContext context, ListThing dismissedThing) async {
    
    print('KOZZER - swiped: ${dismissedThing.toMap()}');
    ScopedModel.of<ListsScopedModel>(context).removeListThing(dismissedThing);
  }
}
