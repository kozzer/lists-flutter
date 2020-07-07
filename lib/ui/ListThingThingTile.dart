import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:lists/ui/ListThingEntry.dart';
import 'package:scoped_model/scoped_model.dart';

/// Custom ListTile class for things that are lists
class ListThingThingTile extends StatelessWidget {
  final ListThing thisThing;
  final ListsScopedModel model;

  const ListThingThingTile(this.thisThing, this.model);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key:     ValueKey(thisThing.thingID),
      leading: Icon(thisThing.icon),
      title:   Text(thisThing.label,
          style: thisThing.isMarked
              ? TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough)
              : TextStyle(color: Colors.black)),
      trailing:    Icon(Icons.drag_handle),
      onTap:       () => _toggleIsMarked(context),
      onLongPress: () => _editThing(context, thisThing),
    );
  }

  void _toggleIsMarked(BuildContext context) async {
    print('toggle!');
    thisThing.isMarked = !thisThing.isMarked;
    await model.updateListThing(thisThing);
    await model.populateListsData();
    print('isMarked toggled: ${thisThing.isMarked}');
  }

  void _editThing(BuildContext context, ListThing thisThing) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListThingEntry(
          parentThingID: 0,
          existingThing: thisThing,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}
