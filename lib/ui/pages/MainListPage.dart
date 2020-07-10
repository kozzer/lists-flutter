import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lists/ui/widgets/SwipeBackground.dart';
import 'package:scoped_model/scoped_model.dart';
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

              body: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Theme.of(context).primaryColor.withAlpha(192),
                  thickness: 0.5,
                  height: 1
                ),
                itemCount:    snapshot.data.mainList?.items?.length ?? 0,
                itemBuilder:  (BuildContext context, int index) {
                  // Always a list on the main page
                  var thisList = model.mainList?.items[index];

                  return Dismissible (
                    key:          ValueKey('dismissable_' + thisList.hashCode.toString()),
                    onDismissed:  (DismissDirection direction) => _onDismissed(context, thisList),
                    background:   SwipeBackground(),
                    child:        ListThingListTile(thisList)
                  );
                }
              ),

              floatingActionButton: FloatingActionButton(
                onPressed: () => _onAddButtonPressed(context, model),
                tooltip:   'Add List',
                child:     Icon(Icons.add),
              )
            );
          } 
        }
      )
    );
  }

  Future<void> _onAddButtonPressed(BuildContext context, ListsScopedModel model) async {
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
  }
}
