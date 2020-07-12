import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:lists/ui/pages/ShowListPage.dart';
import 'package:lists/ui/pages/LoadingScreen.dart';


class MainListPage extends StatelessWidget {
  const MainListPage({ Key key, this.title }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) { 
    return ScopedModelDescendant<ListsScopedModel>( 
      rebuildOnChange: true,
      builder: (context, child, model) => FutureBuilder<ListsScopedModel>(
        future:  model.populateListsData(notify: false),
        builder: (context, AsyncSnapshot<ListsScopedModel> snapshot){

          if (!snapshot.hasData){
            print('KOZZER - no data yet - display LOADING screen');
            // Data not loaded - Show loading screen
            return LoadingScreen();
            
          } else {
            print('KOZZER - got Lists! data, show main list screen');

            // Show lists data
            final mainList = snapshot.data.mainList;
            return ShowListPage(
              key:        mainList.key, 
              listName:   'Lists!', 
              thisThing:  mainList
            );
          } 
        }
      )
    );
  }
}
