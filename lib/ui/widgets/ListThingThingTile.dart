import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:lists/ui/widgets/ListsDragHandle.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:lists/ui/pages/ListThingEntry.dart';

/// Custom ListTile class for things that are lists
class ListThingThingTile extends StatelessWidget {

  final ListThing thisThing;
  final bool      isFirst;
  final bool      isLast;

  const ListThingThingTile(this.thisThing, this.isFirst, this.isLast);

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
      key:          ValueKey(thisThing.key), //
      childBuilder: _buildChild
    );
  }

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
                  child: ScopedModelDescendant<ListsScopedModel>(
                    builder: (context, child, model) => ListTile(
                      key:     ValueKey(thisThing.key),
                      leading: Icon(thisThing.icon, color: Theme.of(context).textTheme.bodyText2.color),
                      title:   Text(thisThing.label,
                          style: thisThing.isMarked
                              ? TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough)
                              : TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
                      onTap:       () => _toggleIsMarked(context, model),
                      onLongPress: () => _editThing(context, thisThing),
                    )
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
