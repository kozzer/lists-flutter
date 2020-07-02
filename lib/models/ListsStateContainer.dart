import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lists/models/ListsDataModel.dart';
import 'package:lists/models/ListThing.dart';


class ListsStateContainer extends StatefulWidget {
  final Widget child;
  final ListsDataModel listsDataModel;

  const ListsStateContainer({
    Key key, 
    @required this.child, 
    @required this.listsDataModel
  }) : super(key: key); 

  @override
  State<StatefulWidget> createState() => AppState();

  static AppState of(BuildContext context){
    print('KOZZER - in of method');
    return context.dependOnInheritedWidgetOfExactType<_ListsDataModelContainer>().listsState;
  }
}

class AppState extends State<ListsStateContainer> {

  ListsDataModel get listsDataModel => widget.listsDataModel;

  @override
  Widget build(BuildContext context){
    print('KOZZER - in AppState.build(), next is _ListsDataModelContainer constructor');
    return _ListsDataModelContainer(
      listsState:     this,
      listsDataModel: widget.listsDataModel,
      child:          widget
    );
  }

  void dispose(){
    super.dispose();
  }

  // Methods to update state
  void addNewListThing(ListThing thing){
    setState(() => listsDataModel.addList(thing));
  }
}

class _ListsDataModelContainer extends InheritedWidget {
  final AppState       listsState;
  final ListsDataModel listsDataModel;

  _ListsDataModelContainer({
    Key       key, 
    @required this.listsState,
    @required child,
    @required this.listsDataModel 
  }) : super(key: key, child: child){
    print('KOZZER - in _ListsDataModelContainer constructor, next is ... nothing');
  }

  @override
  bool updateShouldNotify(_ListsDataModelContainer oldWidget){
    print('KOZZER - in _ListsDataModelContainer.updateShouldNotify()');
    return oldWidget.listsState != this.listsState;
  }
}