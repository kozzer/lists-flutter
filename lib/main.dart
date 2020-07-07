import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lists/ui/MainListPage.dart';

void main() {
  // Make sure everything is ready to populate data
  WidgetsFlutterBinding.ensureInitialized();

  // Launch app wrapped in ScopedModel widget
  runApp(ListsApp());
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
