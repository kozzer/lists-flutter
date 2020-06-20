import 'package:flutter/material.dart';

class ChildListPage extends StatefulWidget {

  const ChildListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChildListPageState createState() => _ChildListPageState();
}

class _ChildListPageState extends State<ChildListPage> {

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
                print('pushed!');
              },
            ),
        ]
      ),
      body: ListView(               // Build list via the context object?
        children: <Widget>[
          // Hard-coded list items
          ListTile(
            leading:  Icon(Icons.shopping_cart),
            title:    const Text('Shopping List'),
            subtitle: const Text('18 items'),
            trailing: Icon(Icons.drag_handle),
          ),
          ListTile(
            leading:  Icon(Icons.playlist_add_check),
            title:    const Text('To-Do List'),
            subtitle: const Text('12 items'),
            trailing: Icon(Icons.drag_handle),
          ),
          ListTile(
            leading:  Icon(Icons.work),
            title:    const Text('Packing List'),
            subtitle: const Text('27 items'),
            trailing: Icon(Icons.drag_handle),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { print('Add New List'); },     // Prints to debug console
        tooltip: 'Add List',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}