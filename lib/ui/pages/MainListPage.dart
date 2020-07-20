import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:lists/ui/pages/ShowListPage.dart';
import 'package:scoped_model/scoped_model.dart';



class MainListPage extends StatelessWidget {
  const MainListPage({ Key key, this.title }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) { 
    // Show lists data
    final model = ScopedModel.of<ListsScopedModel>(context);
    final mainList = model.mainList;
    return ShowListPage(
      key:         mainList.key, 
      listName:    'Lists!', 
      thisThing:   mainList,
      listsTheme:  model.listsTheme,
    );
  } 
}

