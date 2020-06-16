import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lists!',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Lists!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading:  Icon(IconData(59596, fontFamily: 'MaterialIcons')),
            title:    Text('Shopping List'),
            trailing: Icon(Icons.more_vert),
          ),
          ListTile(
            leading:  Icon(IconData(57445, fontFamily: 'MaterialIcons')),
            title:    Text('To-Do List'),
            trailing: Icon(Icons.more_vert),
          ),
          ListTile(
            leading:  Icon(IconData(59641, fontFamily: 'MaterialIcons')),
            title:    Text('Packing List'),
            trailing: Icon(Icons.more_vert),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { print("Add New List"); },
        tooltip: 'Add List',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
