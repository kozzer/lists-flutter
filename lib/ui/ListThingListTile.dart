import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/ui/ChildListPage.dart';
import 'package:lists/ui/ListThingEntry.dart';

/// Custom ListTile class for things that are lists
class ListThingListTile extends StatelessWidget {
  final ListThing thisThing;

  const ListThingListTile(this.thisThing);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(thisThing.icon),
      title: Text(thisThing.label),
      subtitle: Text('(${thisThing.listSize} items)'),
      trailing: Icon(Icons.drag_handle),
      onTap: () => _openChildList(context, thisThing),
      onLongPress: () => _editList(context, thisThing),
    );
  }

  void _openChildList(BuildContext context, ListThing thisThing) {
    print('open child list, thingID: ${thisThing.thingID}');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChildListPage(
                  listName: thisThing.label,
                  thisThing: thisThing,
                ),
            fullscreenDialog: true));
  }

  void _editList(BuildContext context, ListThing thisThing) async {
    var editedThing = await Navigator.push<ListThing>(
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
      thisThing = editedThing;
    }
  }
}
