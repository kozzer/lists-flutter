import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:lists/ui/widgets/ListThingListTile.dart';
import 'package:lists/ui/widgets/ListThingThingTile.dart';
import 'package:lists/ui/pages/ListThingEntry.dart';
import 'package:lists/ui/widgets/SwipeBackground.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lists/ui/pages/UserSettingsPage.dart';
import 'package:lists/ui/themes/ListsTheme.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


class ShowListPage extends StatefulWidget {
  const ShowListPage({this.key, this.listName, this.thisThing, this.listsTheme, this.breadCrumbs}) : super(key: key);

  final Key          key;
  final String       listName;
  final ListThing    thisThing;
  final ListsTheme   listsTheme;
  final List<Widget> breadCrumbs;

  @override
  _ChildListPageState createState() => _ChildListPageState();
}

class _ChildListPageState extends State<ShowListPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
          // Only show Lists! icon on home page
          leading: Padding(
            padding: EdgeInsets.only(left: 0, top: 6, bottom: 6),
            child: (widget?.thisThing?.thingID ?? 0) > 0
              ? IconButton(
                  icon: SvgPicture.asset('lib/assets/lists.svg'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : Padding(
                  padding: EdgeInsets.all(8), 
                  child: SvgPicture.asset('lib/assets/lists.svg')
                )
          ),   
          title:   Text(widget.listName),// _buildBreadCrumbs(),
          actions: <Widget>[
            // action button
            IconButton(
              icon:      Icon(Icons.more_vert),
              onPressed: () {
                Navigator.push<ListThing>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserSettingsPage(context),
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
          ]),

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
                          ? ListThingListTile(thing, index == 0, index == thing.items.length - 1, widget.breadCrumbs) 
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
        foregroundColor: useWhiteForeground(Theme.of(context).primaryColor)
                                ? const Color(0xffffffff)
                                : const Color(0xff000000),
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
      addChildThingToWidget(newThing);
   }

  Future<void> _onDismissed(BuildContext context, ListThing dismissedThing, int index) async {
    
    print('KOZZER - swiped: ${dismissedThing.toMap()}');
    setState(() {
      widget.thisThing.items.removeAt(index);
    });
    await ScopedModel.of<ListsScopedModel>(context).removeListThing(dismissedThing, notify: false);

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
    print('KOZZER - show snack bar');
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<void> _onUndo(BuildContext context, ListThing thing) async {
    final undoThing = await ScopedModel.of<ListsScopedModel>(context).addNewListThing(thing, keepSortOrder: true);
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Delete cancelled')));
    addChildThingToWidget(undoThing);
  }

  void addChildThingToWidget(ListThing addThing){
    setState(() {
      if (widget.thisThing.items.where((thing) => thing.key == addThing.key).length == 0)
        widget.thisThing.addChildThing(addThing);
    });
  }

  Widget _buildBreadCrumbs(){
    return Container(
      padding: const EdgeInsets.all(4),
      child:   Row(children: _buildRowList(), ));
  }

  List<Widget> _buildRowList(){
    List<Widget> crumbs = [];
    for(var crumb in widget.breadCrumbs){
      crumbs.add(crumb);
      crumbs.add(Text(' > '));
    }
    //Add current list title
    crumbs.add(Text(widget.thisThing.thingID > 0 ? widget.thisThing.label : 'Lists!'));
    return crumbs;
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
