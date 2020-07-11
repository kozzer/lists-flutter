import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lists/ui/widgets/SwipeBackground.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:lists/ui/pages/ListThingEntry.dart';
import 'package:lists/ui/widgets/ListThingListTile.dart';
import 'package:lists/ui/pages/LoadingScreen.dart';


class MainListPage extends StatelessWidget {
  const MainListPage({ Key key, this.title }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) { 
    return ScopedModelDescendant<ListsScopedModel>( 
      rebuildOnChange: true,
      builder: (context, child, model) => FutureBuilder<ListsScopedModel>(
        future:  model.populateListsData(notify: false),
        builder: (context, AsyncSnapshot<ListsScopedModel> snapshot){

          if (!snapshot.hasData){
            print('KOZZER - no data yet - display LOADING screen');
            // Data not loaded - Show loading screen
            return LoadingScreen();
            
          } else {
            print('KOZZER - got Lists! data, show main list screen');

            // Show lists data
            return Scaffold(
              appBar: AppBar(
                leading:  Padding(
                  padding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
                  child: Image(
                    image: AssetImage('lib/assets/lists_icon.png')
                  )
                ),
                title:    Text(title, style: Theme.of(context).textTheme.headline1),
                actions:  <Widget>[
                  // action button
                  IconButton(
                    icon:       Icon(Icons.more_vert),
                    color:      Theme.of(context).textTheme.headline1.color,
                    onPressed:  () async {
                      print('KOZZER - refresh data!');
                      await snapshot.data.populateListsData();
                    },
                  ),
                ]
              ),

              body: ReorderableList(
                onReorder:     (item, position) => _reorderCallback(snapshot.data.mainList, item, position),
                onReorderDone: (item) => _reorderDone(snapshot.data, item),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverPadding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                            final thisList = snapshot.data.mainList.items[index];
                            return Dismissible (
                              key:          ValueKey(thisList.key),
                              onDismissed:  (DismissDirection direction) => _onDismissed(context, thisList),
                              background:   SwipeBackground(),
                              child:        Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Theme.of(context).primaryColor.withAlpha(192),
                                      width: 0.8
                                    )
                                  ),
                                ),
                                child: ListThingListTile(thisList, index == 0, index == thisList.items.length - 1)
                              )
                            );
                          },
                          childCount: snapshot.data.mainList.items.length,
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
              )
            );
          } 
        }
      )
    );
  }

  Future<void> _onAddButtonPressed(BuildContext context) async {
    print('KOZZER - adding new list to Main list');
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListThingEntry(parentThingID: 0),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> _onDismissed(BuildContext context, ListThing dismissedThing) async {
    print('KOZZER - swiped ${dismissedThing.toMap()}');
    ScopedModel.of<ListsScopedModel>(context).removeListThing(dismissedThing);
    final snackBar = SnackBar(
      content: Text('Deleted \'${dismissedThing.label}\''),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () async {
          // undo delete main list
          print('KOZZER - Undo delete - thing: $dismissedThing');
          await _onUndo(context, dismissedThing);
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<void> _onUndo(BuildContext context, ListThing thing) async {
    await ScopedModel.of<ListsScopedModel>(context).addNewListThing(thing);
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Delete cancelled')));
  }

    // Returns index of item with given key
  int _indexOfKey(ListThing mainList, ValueKey targetKey) {
    for(int i = 0; i < mainList.items.length; i++){
      final thisKey = ValueKey(mainList.items[i].key);
      print('KOZZER - thisKey: $thisKey -- targetKey: $targetKey');
      if (thisKey.value == targetKey.value)
        return i;
    }
    return -1;
  }

  bool _reorderCallback(ListThing mainList, Key item, Key newPosition) {
    print('KOZZER - _reorderCallback(item: $item, newPosition: $newPosition)');
    int dragIndex = _indexOfKey(mainList, item);
    int curIndex  = _indexOfKey(mainList, newPosition);

    final draggedItem = mainList.items[dragIndex];

    debugPrint("Reordering $item -> $newPosition");
    mainList.items.removeAt(dragIndex);
    mainList.items.insert(curIndex, draggedItem);

    return true;
  }

  Future<void> _reorderDone(ListsScopedModel model, Key item) async {
    print('KOZZER - _reorderDone(item: $item)');
    final dragIndex = _indexOfKey(model.mainList, item);
    final draggedItem = model.mainList.items[dragIndex];
    int i = 0;
    for(final thing in model.mainList.items){
      final reorderedThing = thing.copyWith(sortOrder: i);
      await model.updateListThing(reorderedThing);
      i++;
    }
    //await model.populateListsData();

    debugPrint("Reordering finished for ${draggedItem.label}}");
  }



}
