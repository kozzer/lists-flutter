import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:lists/ui/ListThingEntry.dart';

/// Custom ListTile class for things that are lists
class ListThingThingTile extends StatelessWidget {
  final ListThing thisThing;

  const ListThingThingTile(this.thisThing);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ListsScopedModel>(
      builder: (context, child, model) => ListTile(
        key:     ValueKey(thisThing.thingID),
        leading: Icon(thisThing.icon),
        title:   Text(thisThing.label,
            style: thisThing.isMarked
                ? TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough)
                : TextStyle(color: Colors.black)),
        trailing:    Icon(Icons.drag_handle),
        onTap:       () => _toggleIsMarked(context, model),
        onLongPress: () => _editThing(context, thisThing),
      )
    );
  }

  void _toggleIsMarked(BuildContext context, ListsScopedModel model) async {
    print('toggle!');
    thisThing.isMarked = !thisThing.isMarked;
    await model.updateListThing(thisThing);
    print('isMarked toggled: ${thisThing.isMarked}');
  }

  void _editThing(BuildContext context, ListThing thisThing) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListThingEntry(
          parentThingID: thisThing.parentThingID,
          existingThing: thisThing,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}
