import 'package:flutter/material.dart';

class MainListPage extends StatefulWidget {
  MainListPage({Key key, this.title}) : super(key: key);

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
      ),
      body: ListView(               // Build list via the context object?
        children: <Widget>[
          // Hard-coded list items
          ListTile(
            leading:  Icon(IconData(59596, fontFamily: 'MaterialIcons')),
            title:    Text('Shopping List'),
            subtitle: Text('18 items'),
            trailing: Icon(Icons.more_vert),
          ),
          ListTile(
            leading:  Icon(IconData(57445, fontFamily: 'MaterialIcons')),
            title:    Text('To-Do List'),
            subtitle: Text('12 items'),
            trailing: Icon(Icons.more_vert),
          ),
          ListTile(
            leading:  Icon(IconData(59641, fontFamily: 'MaterialIcons')),
            title:    Text('Packing List'),
            subtitle: Text('27 items'),
            trailing: Icon(Icons.more_vert),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { print("Add New List"); },     // Prints to debug console
        tooltip: 'Add List',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}