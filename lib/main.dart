import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lists/models/ListThingModel.dart';
import 'package:lists/screens/MainListPage.dart';

void main() {
  runApp(ListsApp());
}

class ListsApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => ListThingModel(),
      child: MaterialApp(
        title: 'Lists!',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainListPage(title: 'Lists!'),
    ));
  }
}