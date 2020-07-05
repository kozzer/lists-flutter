import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lists/models/ListsDataModel.dart';
import 'package:lists/ui/MainListPage.dart';

void main() async {
  // Make sure everything is ready to populate data
  WidgetsFlutterBinding.ensureInitialized();

  // Populate all data, then create the state container and launch the app
  ListsDataModel().populateListsData().then((listsDataModel) {
    print('KOZZER - got data, about to call runApp() ... listsDataModel: $listsDataModel');
    listsDataModel.listsAdapter.displayListsTable();
    runApp(new StateContainer(
      child:          ListsApp(), 
      listsDataModel: listsDataModel)
    );
  });
}

class ListsApp extends StatelessWidget {
  ListsApp();

  @override
  Widget build(BuildContext context) {
    print('KOZZER - building ListsApp - no parameter');

    return MaterialApp(
      title: 'Lists!',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainListPage(
        title: 'Lists!',
        mainList: StateContainer.of(context).getMainList(),
      ),
    );
  }
}
