import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/ListsDataModel.dart';

class ListThingEntry extends StatefulWidget {

  final int            parentThingID;
  final ListsDataModel listsDataModel;
  final ListThing      existingThing;

  const ListThingEntry({Key key, this.parentThingID, this.listsDataModel, this.existingThing }) : super(key: key);

  @override
  _ListThingEntryPageState createState() => _ListThingEntryPageState(parentThingID, listsDataModel, existingThing);
}

class _ListThingEntryPageState extends State<ListThingEntry> {

  bool            _formChanged = false;
  FocusNode       focusNode;

  final int            parentThingID;  
  final ListsDataModel listsDataModel;
  final ListThing      existingThing;
  String               _label = '';
  IconData             _icon;
  bool                 _isList = false;

  _ListThingEntryPageState(this.parentThingID, this.listsDataModel, [ this.existingThing ]);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() { 
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  bool validateEntry() {
    // TODO ListThingEntry State validateEntry()
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(               //  Also need to expose route to Settings screen
        title: Text('add new list thing'),
        actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                print('KOZZER - menu open!');
              },
            ),
        ]
      ),
      body: Form(
        key: _formKey,
        onChanged: _onFormChange,
        child: Column(
          children: <Widget>[
            Text('New List Thing'),
            Text('label'),
            TextFormField(
              onSaved: (String val) => _label = val,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                helperText: "Required",
                labelText: "label",
              ),
              autofocus: true,
              initialValue: existingThing?.label,
              autovalidate: _formChanged,
              validator: (String val) {
                if (val.isEmpty) return "Field cannot be left blank";
                return null;
              },
            ),
            RaisedButton(
              color: Colors.blue[400],
              child: Text("save"),
              onPressed: _formChanged
                  ? () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _handleFormSubmit();
                        Navigator.pop(context);
                      } else {
                        FocusScope.of(context).requestFocus(focusNode);
                      }
                    }
                  : null,
            ),
          ],
        )
      )
    );
  }

  void _onFormChange() {
    if (_formChanged) return;
    setState(() {
      _formChanged = true;
    });
  }

  void _handleFormSubmit(){
    final newThing = ListThing(-1, parentThingID, _label, _isList);
    listsDataModel.addList(newThing);
  }

}

