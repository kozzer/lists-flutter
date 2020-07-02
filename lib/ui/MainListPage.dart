import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/ListsStateContainer.dart';
import 'package:lists/ui/ListThingEntry.dart';
import 'package:lists/ui/ListThingListTile.dart';

class MainListPage extends StatefulWidget {
  const MainListPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MainListPageState createState() => _MainListPageState();
}

class _MainListPageState extends State<MainListPage> {

  @override
  Widget build(BuildContext context) {

    print('KOZZER - mainListPage build, get data');

    final listsDataModel = ListsStateContainer.of(context).listsDataModel;

    print('KOZZER - got data from container');

    return Scaffold(
      appBar: AppBar(               //  Also need to expose route to Settings screen
        title: Text(widget.title),
        actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                print('KOZZER - menu open!');
              },
            ),
        ]
      ),
      body:FutureBuilder<ListThing>(
        future: listsDataModel.mainList,
        builder: (BuildContext context, AsyncSnapshot<ListThing> snapshot){
          return ListView.builder(            
            itemCount:   snapshot.hasData ? snapshot.data?.items?.length : 0,
            itemBuilder: (BuildContext context, int index){
              print('KOZZER - in list item builer for thing id ${snapshot.data.items[0].thingID}');
              // Always a list on the main page
              return ListThingListTile(snapshot.data?.items[index]);
            } 
          );            
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddButtonPressed,    
        tooltip: 'Add List',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onAddButtonPressed() {
     print('adding new list to Main list');
     Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListThingEntry(
          parentThingID:  0, 
          listsDataModel: ListsStateContainer.of(context).listsDataModel
        ),
        fullscreenDialog: true,
      ),
    );
  }
}