import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/ui/ListThingEntry.dart';

/// Custom ListTile class for things that are lists
class ListThingThingTile extends StatelessWidget
{
  final ListThing thisThing;

  const ListThingThingTile(this.thisThing);

  @override
  Widget build(BuildContext context){

    return ListTile(
      leading:      Icon(thisThing.icon),
      title:        Text(
        thisThing.label,
        style: 
          thisThing.isMarked 
            ? TextStyle(color: Colors.grey) 
            : TextStyle(color: Colors.black)
      ),
      trailing:     Icon(Icons.drag_handle),
      onTap:        () => _toggleIsMarked,
      onLongPress:  () => _editThing(context, thisThing),
    );

  }

  void _toggleIsMarked(){
    print('toggle!');
    thisThing.isMarked = !thisThing.isMarked;
    print('isMarked toggled: ${thisThing.isMarked}');
  }

  void _editThing(BuildContext context, ListThing thisThing){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListThingEntry(
          parentThingID:  0, 
          listsDataModel: null,    // <-- TODO: need to work on state management, using inherited widget?
          existingThing:  thisThing,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}