import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/ListsDataModel.dart';
import 'package:lists/ui/ListThingEntry.dart';
import 'package:lists/ui/ListThingListTile.dart';

class MainListPage extends StatefulWidget {
  const MainListPage({Key key, this.title, this.mainList}) : super(key: key);

  final String title;
  final ListThing mainList;

  @override
  _MainListPageState createState() => _MainListPageState();
}

class _MainListPageState extends State<MainListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //  Also need to expose route to Settings screen
          title: Text(widget.title),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                print('KOZZER - menu open!');
              },
            ),
          ]),
      body: ListView.builder(
          itemCount: widget.mainList?.items?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            print(
                'KOZZER - in list item builer for thing id ${widget.mainList.items[index].thingID}');
            // Always a list on the main page
            return ListThingListTile(widget.mainList.items[index]);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddButtonPressed,
        tooltip: 'Add List',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _onAddButtonPressed() async {
    print('adding new list to Main list');
    var newThing = await Navigator.push<ListThing>(
      context,
      MaterialPageRoute(
        builder: (context) => ListThingEntry(
          parentThingID: 0,
        ),
        fullscreenDialog: true,
      ),
    );
    if (newThing != null) {
      var addedThing =
          await StateContainer.of(context).addNewListThing(newThing);
      setState(() {
        widget.mainList.items.add(addedThing);
      });
    }
  }
}
