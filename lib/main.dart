import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lists/ui/pages/LoadingScreen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:lists/ui/pages/MainListPage.dart';
import 'package:lists/models/ListsNavigatorObserver.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Launch app wrapped in ScopedModel widget
  runApp(
    ScopedModel<ListsScopedModel>(
      model: ListsScopedModel(),
      child: ScopedModelDescendant<ListsScopedModel>(
        rebuildOnChange: true,
        builder: (context, child, model) => FutureBuilder<ListsScopedModel>(
          future:  model.populateListsModel(notify: false),
          builder: (context, AsyncSnapshot<ListsScopedModel> snapshot) {
            if (!snapshot.hasData){
              return MaterialApp(
                title: 'Lists!',
                home: LoadingScreen()
              );
            } else {
              return ListsApp(model);
            }
          } ,
        )
      )
    )
  );
}

class ListsApp extends StatelessWidget {

  final ListsScopedModel model;

  ListsApp(this.model);

  @override
  Widget build(BuildContext context) {
    print('KOZZER - building ListsApp');

    return MaterialApp(
      title: 'Lists!',
      navigatorObservers: [ListsNavigatorObserver()],
      theme: model.listsTheme.themeData,
      home:  MainListPage(title: 'Lists!'),
    );
  }
}
