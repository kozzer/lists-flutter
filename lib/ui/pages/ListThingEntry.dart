import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/ListsScopedModel.dart';

class ListThingEntry extends StatefulWidget {
  final int parentThingID;
  final ListThing existingThing;

  const ListThingEntry({Key key, this.parentThingID, this.existingThing})
      : super(key: key);

  @override
  _ListThingEntryPageState createState() => _ListThingEntryPageState();
}

class _ListThingEntryPageState extends State<ListThingEntry> {
  FocusNode focusNode;

  bool _formChanged = false;
  String _pageTitle;
  String _label = '';
  IconData _icon;
  bool _isList;

  // Constructor
  _ListThingEntryPageState();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    _pageTitle = widget?.existingThing != null
        ? 'edit \'${widget.existingThing.label}\''
        : 'add new thing';
    _isList =
        widget?.parentThingID == 0 || (widget?.existingThing?.isList ?? false);
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
    return ScopedModelDescendant<ListsScopedModel>(
      builder: (context, child, model) => Scaffold(
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
                    if (val.isEmpty)
                      return "Field cannot be left blank";
                    return null;
                  },
                ),
                Text('Is this a list?'),
                Checkbox(
                  value: _isList,
                  onChanged: (bool val) {
                    if (widget?.parentThingID != 0) {
                      setState(() {
                        _formChanged = true;
                        _isList = val;
                      });
                    }
                  }),
                RaisedButton(
                  color: Colors.blue[400],
                  child: Text('Select icon'),
                  onPressed: _pickIcon),
                RaisedButton(
                  color: Colors.blue[400],
                  child: Text("save"),
                  onPressed: _formChanged
                      ? () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            final submittedThing =
                                await _handleFormSubmit(model);
                            Navigator.pop(context, submittedThing);
                          } else {
                            FocusScope.of(context)
                                .requestFocus(focusNode);
                          }
                        }
                      : null,
                ),
              ],
            )
          )
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

  Future<void> _pickIcon() async {
    IconData icon = await FlutterIconPicker.showIconPicker(
      context,
      adaptiveDialog: true,
      iconPickerShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      iconPackMode: IconPack.material,
    );

    if (icon != null) {
      _icon = icon;
      setState(() {
        _formChanged = true;
      });

      debugPrint('Picked Icon:  $icon');
    }
  }

  Future<ListThing> _handleFormSubmit(ListsScopedModel model) async {
    if (_formChanged) {
      if (widget.existingThing != null) {
        // Already existing, so this is an update
        final updatedThing = widget.existingThing
            .copyWith(label: _label, isList: _isList, icon: _icon);
        await model.updateListThing(updatedThing);
        return updatedThing;
      } else {
        // Nothing existing, so this is a new item
        final newThing = ListThing(-1, widget.parentThingID, _label, _isList);
        final addedThing = await model.addNewListThing(newThing);
        return addedThing;
      }
    }
    return null;
  }
}
