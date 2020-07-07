import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:lists/ui/ListThingEntry.dart';
import 'package:lists/ui/ListThingListTile.dart';
import 'package:scoped_model/scoped_model.dart';


class MainListPage extends StatelessWidget {
  const MainListPage({Key key, this.title }) : super(key: key);

  final String           title;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ListsScopedModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
            //  Also need to expose route to Settings screen
            title:    Text(title),
            actions:  <Widget>[
              // action button
              IconButton(
                icon:       Icon(Icons.more_vert),
                onPressed:  () async {
                  await model.populateListsData();
                },
              ),
            ]),
        body: ListView.builder(
          itemCount:    model.mainList?.items?.length ?? 0,
          itemBuilder:  (BuildContext context, int index) {
            print('KOZZER - in main page list item builder - index $index');
            // Always a list on the main page
            return ListThingListTile(model.mainList.items[index], model);
          }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _onAddButtonPressed(context),
          tooltip:   'Add List',
          child:     Icon(Icons.add),
        )
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _onAddButtonPressed(BuildContext context) async {
    print('adding new list to Main list');
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => 
          ScopedModelDescendant<ListsScopedModel>(
            builder: (context, child, model) => ListThingEntry(
              parentThingID: 0),
          ),
        fullscreenDialog: true,
      ),
    );
  }
}
