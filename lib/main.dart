import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:lists/ui/MainListPage.dart';

void main() async {
  // Make sure everything is ready to populate data
  WidgetsFlutterBinding.ensureInitialized();

  // Instantiate the lists data model
  var model = ListsScopedModel();

  // Launch app wrapped in ScopedModel widget
  runApp(
    ScopedModel<ListsScopedModel>(
      model: model,                   // <-- data model Constructor
      child: ListsApp()               // <-- app object Constructor
    )
  );
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
      home: MainListPage(title: 'Lists!'),
    );
  }
}
