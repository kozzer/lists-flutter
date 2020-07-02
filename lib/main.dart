import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lists/models/ListsDataModel.dart';
import 'package:lists/models/ListsStateContainer.dart';
import 'package:lists/ui/MainListPage.dart';

void main() async {
  // Make sure everything is ready to populate data
  WidgetsFlutterBinding.ensureInitialized();

  // Populate all data, then create the state container and launch the app
  ListsDataModel().populateListsData().then((listsDataModel) { 
      print('KOZZER - got data, about to call runApp() ... listsDataModel: $listsDataModel');
      runApp(
        ListsStateContainer(
          child:          ListsApp(), 
          listsDataModel: listsDataModel
      ));
  });
}

class ListsApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    print('KOZZER - building ListsApp');

    return MaterialApp(
      title: 'Lists!',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainListPage(title: 'Lists!'),
    );
  }
}