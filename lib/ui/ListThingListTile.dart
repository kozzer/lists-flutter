import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/ui/ChildListPage.dart';
import 'package:lists/ui/ListThingEntry.dart';
import 'package:lists/models/ListsScopedModel.dart';


/// Custom ListTile class for things that are lists
class ListThingListTile extends StatelessWidget {

  final ListThing        thisThing;
  final ListsScopedModel model;

  const ListThingListTile(this.thisThing, this.model);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key:          ValueKey(thisThing.thingID),
      leading:      Icon(thisThing.icon),
      title:        Text(thisThing.label),
      subtitle:     Text('(${thisThing.listSize} items)'),
      trailing:     Icon(Icons.drag_handle),
      onTap:        () => _openChildList(context, thisThing),
      onLongPress:  () => _editList(context, thisThing),
    );
  }

  Future<void> _openChildList(BuildContext context, ListThing thisThing) async {
    print('open child list, thingID: ${thisThing.thingID} - ${thisThing.items.length} children');
    final openedThing = await Navigator.push<ListThing>(
      context,
      MaterialPageRoute(
        builder: (context) => ChildListPage(listName: thisThing.label, thisThing: thisThing),
        fullscreenDialog: true));

    // Refresh in-memory things
    print('KOZZER - refreshing list thing items');
    thisThing.clearChildThings();
    openedThing.items.forEach((thing) => thisThing.addChildThing(thing));
  }

  void _editList(BuildContext context, ListThing thisThing) async {
    final editedThing = await Navigator.push<ListThing>(
      context,
      MaterialPageRoute(
        builder: (context) => ListThingEntry(
          parentThingID: thisThing.parentThingID,
          existingThing: thisThing,
        ),
        fullscreenDialog: true,
      ),
    );
    if (editedThing != null) {
      await model.updateListThing(editedThing);
    }
  }
}
