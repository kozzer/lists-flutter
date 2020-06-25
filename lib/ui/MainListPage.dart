import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/ListsDataModel.dart';
import 'package:lists/ui/ListThingEntry.dart';

class MainListPage extends StatefulWidget {
  const MainListPage({Key key, this.title, this.listsDataModel}) : super(key: key);

  final ListsDataModel listsDataModel;
  final String title;
  @override
  _MainListPageState createState() => _MainListPageState(listsDataModel);
}

class _MainListPageState extends State<MainListPage> {

  _MainListPageState(this.listsDataModel);

  ListsDataModel listsDataModel;

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
              final ListThing item = snapshot.data?.items[index];
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
        onPressed: _onAddButtonPressed,    
        tooltip: 'Add List',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onAddButtonPressed() {
     Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListThingEntry(
          parentThingID:  0, 
          listsDataModel: listsDataModel
        ),
        fullscreenDialog: true,
      ),
    );
  }
}