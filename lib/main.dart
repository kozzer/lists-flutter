import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:lists/ui/pages/MainListPage.dart';

void main() {
  // Launch app wrapped in ScopedModel widget
  runApp(ListsApp());
}

class ListsApp extends StatelessWidget {
  ListsApp();

  @override
  Widget build(BuildContext context) {
    print('KOZZER - building ListsApp');

    return ScopedModel<ListsScopedModel>(
      model: ListsScopedModel(),
      child: MaterialApp(
        title: 'Lists!',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainListPage(title: 'Lists!'),
      )
    );
  }
}
