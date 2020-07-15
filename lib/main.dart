import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:lists/ui/pages/MainListPage.dart';
import 'package:lists/ui/themes/ListsTheme.dart';

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
        theme: ListsTheme(isDark: true, primaryColor: Color(0xFF00A800), accentColor: Color(0xFFA8A8A8)).themeData,
        home:  MainListPage(title: 'Lists!'),
      )
    );
  }
}
