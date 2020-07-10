import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/ui/pages/ChildListPage.dart';
import 'package:lists/ui/pages/ListThingEntry.dart';


/// Custom ListTile class for things that are lists
class ListThingListTile extends StatelessWidget {

  final ListThing        thisThing;

  const ListThingListTile(this.thisThing);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key:          ValueKey(thisThing.hashCode),
      leading:      Icon(thisThing.icon),
      title:        Text(thisThing.label, style: Theme.of(context).textTheme.bodyText1),
      subtitle:     Text('(${thisThing.listSize} item${thisThing.listSize != 1 ? 's' : ''})', style: Theme.of(context).textTheme.bodyText2),
      trailing:     Icon(Icons.drag_handle, color: Theme.of(context).textTheme.bodyText1.color),
      onTap:        () => _openChildList(context, thisThing),
      onLongPress:  () => _editList(context, thisThing)
    );
  }

  Future<void> _openChildList(BuildContext context, ListThing thisThing) async {
    print('open child list, thingID: ${thisThing.thingID} - ${thisThing.items.length} children');
    await Navigator.push<ListThing>(
      context,
      MaterialPageRoute(
        builder: (context) => ChildListPage(
          key:       ValueKey(thisThing.hashCode.toString()),
          listName:  thisThing.label, 
          thisThing: thisThing
        )
      )
    );
  }

  void _editList(BuildContext context, ListThing thisThing) async {
    await Navigator.push<ListThing>(
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
