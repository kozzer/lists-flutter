import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/ListsDataModel.dart';

class ListThingEntry extends StatefulWidget {

  final int _parentThingID;
  final ListThing _existingThing;

  const ListThingEntry(Key key, this._parentThingID, [ this._existingThing ]) : super(key: key);

  @override
  _ListThingEntryPageState createState() => _ListThingEntryPageState(_parentThingID, _existingThing);
}

class _ListThingEntryPageState extends State<ListThingEntry> {
  final int       _parentThingID;  
  final ListThing _existingThing;
  String          label;
  IconData        icon;
  bool            isList;

  _ListThingEntryPageState(this._parentThingID, [ this._existingThing ]);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() { 
    super.initState();
    // TODO ListThingEntry State initState()
  }

  @override
  void dispose() {
    super.dispose();
    // TODO ListThingEntry State dispose()
  }

  bool validateEntry() {
    // TODO ListThingEntry State validateEntry()
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO ListThingEntry State build()
  }

  void _onFormChange(){
    // TODO ListThingEntry State onFormChange()
  }

  void _handleFormSubmit(){
    // TODO ListThingEntry State handleFormSubmit()
  }

}

