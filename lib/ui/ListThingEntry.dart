import 'package:flutter/material.dart';
import 'package:lists/models/ListThing.dart';

class ListThingEntry extends StatefulWidget {
  final int parentThingID;
  final ListThing existingThing;

  const ListThingEntry({Key key, this.parentThingID, this.existingThing})
      : super(key: key);

  @override
  _ListThingEntryPageState createState() => _ListThingEntryPageState();
}

class _ListThingEntryPageState extends State<ListThingEntry> {
  bool _formChanged = false;
  FocusNode focusNode;
  String _pageTitle;

  String _label = '';
  IconData _icon;
  bool _isList;

  // Constructor
  _ListThingEntryPageState() {
    if (widget != null &&
        widget.existingThing != null &&
        (widget.existingThing.isList ?? false)) {
      _isList = widget.existingThing.isList;
    } else {
      _isList = false;
    }
    if (widget != null && widget.key != null)
      _pageTitle = 'edit ${widget.existingThing.label}';
    else
      _pageTitle = 'add new thing';
  }

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
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            //  Also need to expose route to Settings screen
            title: Text(_pageTitle),
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  print('KOZZER - menu open!');
                },
              ),
            ]),
        body: Form(
            key: _formKey,
            onChanged: _onFormChange,
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      onSaved: (String val) => _label = val,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        helperText: "Required",
                        labelText: "label",
                      ),
                      autofocus: true,
                      initialValue: widget.existingThing?.label,
                      autovalidate: _formChanged,
                      validator: (String val) {
                        if (val.isEmpty) return "Field cannot be left blank";
                        return null;
                      },
                    ),
                    Text('Is this a list?'),
                    Checkbox(
                        value: _isList,
                        onChanged: (bool val) {
                          _formChanged = true;
                          _isList = val;
                        }),
                    RaisedButton(
                      color: Colors.blue[400],
                      child: Text("save"),
                      onPressed: _formChanged
                          ? () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                Navigator.pop(context, _handleFormSubmit());
                              } else {
                                FocusScope.of(context).requestFocus(focusNode);
                              }
                            }
                          : null,
                    ),
                  ],
                ))));
  }

  void _onFormChange() {
    if (_formChanged) return;
    setState(() {
      _formChanged = true;
    });
  }

  ListThing _handleFormSubmit() {
    if (_formChanged) {
      return ListThing(-1, widget.parentThingID, _label, _isList);
    }

    return null;
  }
}
