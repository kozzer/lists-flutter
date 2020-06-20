import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:provider/provider.dart';
import 'package:lists/models/ListsDataModel.dart';

class MainListPage extends StatefulWidget {
  const MainListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainListPageState createState() => _MainListPageState();
}

class _MainListPageState extends State<MainListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(               //  Also need to expose route to Settings screen
        title: Text(widget.title),
        actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                print('KOZZER - pushed!');
              },
            ),
        ]
      ),
      body: Consumer<ListsDataModel> (            // Main list view consumes Lists! data model
        builder: (BuildContext context, ListsDataModel listsDataModel, _) {
          print('KOZZER - in builder - size: ${listsDataModel.mainListSize}');
          return ListView.builder(            
            itemCount:   listsDataModel.mainListSize,
            itemBuilder: (BuildContext context, int index){
              print('KOZZER - in ListView.builder - index: $index');
              final ListThing item = listsDataModel.getMainListThing(index);
              return ListTile(
                leading:  Icon(item.icon),
                title:    Text(item.label),
                subtitle: Text('(${item.listSize} items)'),
                trailing: Icon(Icons.drag_handle)
              );
            } 
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { print('KOZZER - Add New List'); },     // Prints to debug console
        tooltip: 'Add List',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void listItemTap(int itemId){

  }
}