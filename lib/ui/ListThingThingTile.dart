import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';

/// Custom ListTile class for things that are lists
class ListThingThingTile extends StatelessWidget
{
  final ListThing thisThing;

  const ListThingThingTile(this.thisThing);

  @override
  Widget build(BuildContext context){

    return ListTile(
      leading:  Icon(thisThing.icon),
      title:    Text(thisThing.label),
      trailing: Icon(Icons.drag_handle)
    );

  }
}