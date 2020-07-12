import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:lists/ui/widgets/ListThingListTile.dart';
import 'package:lists/ui/widgets/ListThingThingTile.dart';
import 'package:lists/ui/pages/ListThingEntry.dart';
import 'package:lists/ui/widgets/SwipeBackground.dart';


class ShowListPage extends StatefulWidget {
  const ShowListPage({this.key, this.listName, this.thisThing}) : super(key: key);

  final Key       key;
  final String    listName;
  final ListThing thisThing;

  @override
  _ChildListPageState createState() => _ChildListPageState();
}

class _ChildListPageState extends State<ShowListPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
          // Only show Lists! icon on home page
          leading: widget.thisThing.thingID == 0 
            ? Padding(
                padding: EdgeInsets.only(left: 0, top: 12, bottom: 12),
                child:  Image(
                  image: AssetImage('lib/assets/lists_icon.png')
                )) 
            : null,
          title:   Text(widget.listName, style: Theme.of(context).textTheme.headline1),
          actions: <Widget>[
            // action button
            IconButton(
              icon:      Icon(Icons.more_vert),
              onPressed: () {
                print('pushed!');
              },
            ),
          ]),

      // TODO make scopedmodel descendant?
      body: ReorderableList(
        onReorder:     _reorderCallback,
        onReorderDone: _reorderDone,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {

                    final thing = widget.thisThing.items[index];
                    return Dismissible (
                      key:          ValueKey(thing.key),
                      onDismissed:  (DismissDirection direction) => _onDismissed(context, thing, index),
                      background:   SwipeBackground(),
                      child:        Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(
                            color: Theme.of(context).primaryColor.withAlpha(96),
                            width: 1.0
                          )),
                        ),
                        child: ((thing?.isList ?? false || (thing?.thingID ?? 1) == 0)) 
                          ? ListThingListTile(thing, index == 0, index == thing.items.length - 1) 
                          : ListThingThingTile(thing, index == 0, index == thing.items.length - 1)
                      )
                    );

                  },
                  childCount: widget.thisThing.items.length,
                ),
              )
            ),
          ],
        )
      ),
          
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddButtonPressed(context), 
        tooltip:   'Add List',
        child:     Icon(Icons.add),
      ), 
    );
  }

  Future<void> _onAddButtonPressed(BuildContext context) async {
    print('KOZZER - in ChildListPage add button pressed');
    final newThing = await Navigator.push<ListThing>(
      context,
      MaterialPageRoute(
        builder: (context) => ListThingEntry(parentThingID: widget.thisThing.thingID),
        fullscreenDialog: true,
      ),
    );
    if (newThing != null)
      setState(() {
        widget.thisThing.addChildThing(newThing);
      });
   }

  Future<void> _onDismissed(BuildContext context, ListThing dismissedThing, int index) async {
    
    print('KOZZER - swiped: ${dismissedThing.toMap()}');
    ScopedModel.of<ListsScopedModel>(context).removeListThing(dismissedThing);
    setState(() {
      widget.thisThing.items.removeAt(index);
    });

    final snackBar = SnackBar(
      content: Text('Deleted \'${dismissedThing.label}\''),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () async {
          // undo delete list item
          print('KOZZER - Undo delete - thing: $dismissedThing');
          await _onUndo(context, dismissedThing);
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<void> _onUndo(BuildContext context, ListThing thing) async {
    final undoThing = await ScopedModel.of<ListsScopedModel>(context).addNewListThing(thing);
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Delete cancelled')));
    setState(() {
      widget.thisThing.addChildThing(undoThing);
    });
  }

  int _indexOfKey(ValueKey targetKey) {
    for(int i = 0; i < widget.thisThing.items.length; i++){
      final thisKey = ValueKey(widget.thisThing.items[i].key);
      if (thisKey.value == targetKey.value)
        return i;
    }
    return -1;
  }

  bool _reorderCallback(Key item, Key newPosition) {
    print('KOZZER - _reorderCallback(item: $item, newPosition: $newPosition)');
    int dragIndex = _indexOfKey(item);
    int curIndex  = _indexOfKey(newPosition);

    final draggedItem = widget.thisThing.items[dragIndex];

    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      widget.thisThing.items.removeAt(dragIndex);
      widget.thisThing.items.insert(curIndex, draggedItem);
    });
    return true;
  }

  Future<void> _reorderDone(Key item) async {
    print('KOZZER - _reorderDone(item: $item) - update in database');
    final newIndex = _indexOfKey(item);
    final draggedItem = widget.thisThing.items[newIndex];

    // Save all new sortOrder values to database
    for(int i = 0; i < widget.thisThing.items.length; i++){
      var thing = widget.thisThing.items[i];
      if (thing.sortOrder != i){
        thing.sortOrder = i;
        await ScopedModel.of<ListsScopedModel>(context).updateListThing(thing);
      }
    }

    setState((){
      widget.thisThing.items.sort((ListThing a, ListThing b) => a.sortOrder.compareTo(b.sortOrder)); 
    });
    debugPrint("Reordering finished for ${draggedItem.label}: index $newIndex");
  }
}
