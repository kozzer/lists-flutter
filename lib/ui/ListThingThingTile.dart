import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/ListsDataModel.dart';
import 'package:lists/ui/ListThingEntry.dart';

/// Custom ListTile class for things that are lists
class ListThingThingTile extends StatelessWidget {
  final ListThing thisThing;

  const ListThingThingTile(this.thisThing);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(thisThing.icon),
      title: Text(thisThing.label,
          style: thisThing.isMarked
              ? TextStyle(
                  color: Colors.grey, decoration: TextDecoration.lineThrough)
              : TextStyle(color: Colors.black)),
      trailing:    Icon(Icons.drag_handle),
      onTap:       () => _toggleIsMarked(context),
      onLongPress: () => _editThing(context, thisThing),
    );
  }

  void _toggleIsMarked(BuildContext context) async {
    print('toggle!');
    thisThing.isMarked = !thisThing.isMarked;
    await StateContainer.of(context).updateListThing(thisThing);
    print('isMarked toggled: ${thisThing.isMarked}');
  }

  void _editThing(BuildContext context, ListThing thisThing) async {
    var editedThing = await Navigator.push<ListThing>(
      context,
      MaterialPageRoute(
        builder: (context) => ListThingEntry(
          parentThingID: 0,
          existingThing: thisThing,
        ),
        fullscreenDialog: true,
      ),
    );
    if (editedThing != null) {
      await StateContainer.of(context).updateListThing(editedThing);
    }
  }
}
