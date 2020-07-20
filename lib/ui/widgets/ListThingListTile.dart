import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/ui/pages/ShowListPage.dart';
import 'package:lists/ui/pages/ListThingEntry.dart';
import 'package:lists/ui/widgets/ListsDragHandle.dart';


/// Custom ListTile class for things that are lists
class ListThingListTile extends StatelessWidget {

  final ListThing thisThing;
  final bool      isFirst;
  final bool      isLast;

  const ListThingListTile(this.thisThing, this.isFirst, this.isLast);

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == ReorderableItemState.dragProxy || state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor);
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
              top: isFirst && !placeholder
                  ? Divider.createBorderSide(context) //
                  : BorderSide.none,
              bottom: isLast && placeholder
                  ? BorderSide.none //
                  : Divider.createBorderSide(context)),
          color: placeholder ? null : Theme.of(context).scaffoldBackgroundColor);
    }

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
        top:    false,
        bottom: false,
        child: Opacity(
          // hide content for placeholder
          opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    key:          ValueKey(thisThing.key),
                    leading:      Icon(thisThing.icon, color: Theme.of(context).accentColor),
                    title:        Text(thisThing.label, style: Theme.of(context).textTheme.bodyText1),
                    subtitle:     Text('(${thisThing.listSize} item${thisThing.listSize != 1 ? 's' : ''})', style: Theme.of(context).textTheme.bodyText2),
                    onTap:        () => _openChildList(context, thisThing),
                    onLongPress:  () => _editList(context, thisThing)
                  )
                ),
                // Triggers the reordering
                ListsDragHandle(),
              ],
            ),
          ),
        )
      )
    );

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
      key:          ValueKey(thisThing.key), //
      childBuilder: _buildChild
    );
  }

  Future<void> _openChildList(BuildContext context, ListThing thisThing) async {
    print('open child list, thingID: ${thisThing.thingID} - ${thisThing.items.length} children');

    await Navigator.push(
      context,
      ShowListPage.getRoute(thisThing),
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
