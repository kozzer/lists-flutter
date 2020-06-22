import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/ListsDataModel.dart';

class MainListPage extends StatefulWidget {
  const MainListPage({Key key, this.title, this.listsDataModel}) : super(key: key);

  final String title;
  final ListsDataModel listsDataModel;

  @override
  _MainListPageState createState() => _MainListPageState();
}

class _MainListPageState extends State<MainListPage> {

  ListsDataModel listsDataModel = ListsDataModel;

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
      body:FutureBuilder<ListThing>(
        future: listsDataModel.getMainList(),
        builder: (BuildContext context, AsyncSnapshot<ListThing> snapshot){

          return ListView.builder(            
            itemCount:   snapshot.data.items.length,
            itemBuilder: (BuildContext context, int index){
              print('KOZZER - in ListView.builder - index: $index');
              final ListThing item = snapshot.data.items[index];
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