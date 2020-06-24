import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lists/data/ListsAdapter.dart';
import 'package:provider/provider.dart';
import 'package:lists/models/ListsDataModel.dart';
import 'package:lists/ui/MainListPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ListsAdapter.instance.database.then((db) => runApp(ListsApp()));
}

class ListsApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListsDataModel>(
      create: (BuildContext context) => ListsDataModel(),
      child: Consumer<ListsDataModel>(
        builder: (context, model, _) => MaterialApp(
          title: 'Lists!',
          theme: ThemeData(
            primarySwatch: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: MainListPage(title: 'Lists!', listsDataModel: model),
        )  // MaterialApp
      )
    );
  }
}