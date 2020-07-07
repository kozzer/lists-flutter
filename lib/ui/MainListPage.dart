import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:lists/ui/ListThingEntry.dart';
import 'package:lists/ui/ListThingListTile.dart';
import 'package:lists/ui/LoadingScreen.dart';


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
            // Data not loaded - Show loading screen
            return LoadingScreen();
            
          } else {

            // Show lists data
            return Scaffold(
              appBar: AppBar(
                // Also need to expose route to Settings screen
                title:    Text(title),
                actions:  <Widget>[
                  // action button
                  IconButton(
                    icon:       Icon(Icons.more_vert),
                    onPressed:  () async {
                      print('KOZZER - refresh data!');
                      await snapshot.data.populateListsData();
                    },
                  ),
                ]
              ),

              body: ListView.builder(
                itemCount:    snapshot.data.mainList?.items?.length ?? 0,
                itemBuilder:  (BuildContext context, int index) {
                  print('KOZZER - in main page list item builder - index $index');
                  // Always a list on the main page
                  return ListThingListTile(model.mainList.items[index]);
                }
              ),

              floatingActionButton: FloatingActionButton(
                onPressed: () => _onAddButtonPressed(context, model),
                tooltip:   'Add List',
                child:     Icon(Icons.add),
              )
            );
          } 
      })
    );
  }

  Future<void> _onAddButtonPressed(BuildContext context, ListsScopedModel model) async {
    print('adding new list to Main list');
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListThingEntry(parentThingID: 0),
        fullscreenDialog: true,
      ),
    );
  }
}
