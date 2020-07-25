import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:lists/models/ListThing.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:lists/ui/widgets/BreadcrumbNavigator.dart';
import 'package:lists/models/RouteThing.dart';


class ListThingEntry extends StatefulWidget {
  final int       parentThingID;
  final ListThing existingThing;

  const ListThingEntry({Key key, this.parentThingID, this.existingThing}) : super(key: key);

  @override
  _ListThingEntryPageState createState() => _ListThingEntryPageState();

  static MaterialPageRoute<ListThing> getRoute(int parentThingID, [ListThing existingThing = null]) => MaterialPageRoute(
    settings: RouteSettings(
      name: 'ListThingEntry', 
      arguments: existingThing != null 
        ? RouteThing(
            ValueKey('ListThingEntry__Edit_Thing_${existingThing.thingID}'),
            existingThing.thingID, 
            Icons.edit_attributes, 
            false)
        : RouteThing(ValueKey('ListThingEntry__Add_Under_Parent_$parentThingID'), -1, Icons.add_circle, false)
    ),
    builder: (context) => parentThingID < 0 
                          ? ListThingEntry(existingThing: existingThing) 
                          : ListThingEntry(parentThingID: parentThingID, existingThing: existingThing),
    fullscreenDialog: true
  );
}

class _ListThingEntryPageState extends State<ListThingEntry> {
  FocusNode focusNode;

  bool      _formChanged = false;
  String    _pageTitle;
  String    _label = '';
  IconData  _icon;
  bool      _isList;

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
    _isList = widget?.parentThingID == 0 || (widget?.existingThing?.isList ?? false);
    setIcon(init: true);
  }

  void toggleIsList(){
    _isList = !_isList;
  }

  void setIcon({bool init = false}){
    //if (init || (_formChanged && _icon.codePoint != 59485 && _icon.codePoint != 58278)){
      _icon = widget?.existingThing?.icon 
        ?? IconData(
            _isList 
              ? 59485     // List icon
              : 58278,    // Circle icon
            fontFamily: "MaterialIcons"
          );
    //}
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
            automaticallyImplyLeading: false,
            leading: null,
            title: BreadCrumbNavigator(),
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
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
                ),
                Text('Is this a list?'),
                Checkbox(
                  value: _isList,
                  onChanged: (bool val) {
                    if (widget?.parentThingID != 0) {
                      setState(() {
                        _formChanged = true;
                        toggleIsList();
                        setIcon();
                      });
                    }
                  }
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,               
                  children: <Widget>[
                    RaisedButton(
                      color: Theme.of(context).primaryColor.withAlpha(192),
                      child: Text('Select icon'),
                      onPressed: _pickIcon
                    ),
                    Icon(
                      _icon,                  
                      color: Theme.of(context).accentColor
                    ),
                  ],
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor.withAlpha(192),
                  child: Text("Save"),
                  onPressed: _formChanged
                      ? () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            final submittedThing = await _handleFormSubmit(model);
                            Navigator.pop(context, submittedThing);
                          } else {
                            FocusScope.of(context).requestFocus(focusNode);
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
      adaptiveDialog:   true,
      iconPickerShape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      iconPackMode:     IconPack.material,
      backgroundColor:  Theme.of(context).scaffoldBackgroundColor,
      iconColor:        Theme.of(context).textTheme.bodyText1.color
    );

    if (icon != null) {
      setState(() {
        _formChanged = true;
        _icon = icon;
        widget?.existingThing?.icon = icon;
      });

      debugPrint('Picked Icon:  $icon');
    }
  }

  Future<ListThing> _handleFormSubmit(ListsScopedModel model) async {
    if (_formChanged) {
      if (widget.existingThing != null) {
        // Already existing, so this is an update
        final updatedThing = widget.existingThing.copyWith(label: _label, isList: _isList, icon: _icon);
        await model.updateListThing(updatedThing);
        return updatedThing;
      } else {
        // Nothing existing, so this is a new item
        final newThing = ListThing(-1, widget.parentThingID, _label, _isList, _icon);
        final addedThing = await model.addNewListThing(newThing);
        return addedThing;
      }
    }
    return null;
  }
}
