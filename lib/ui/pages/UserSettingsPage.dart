import 'package:flutter/material.dart';
import 'package:lists/ui/widgets/ListsColorPicker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lists/ui/widgets/BreadcrumbNavigator.dart';
import 'package:lists/models/RouteThing.dart';

class UserSettingsPage extends StatefulWidget {

  final BuildContext _context;

  UserSettingsPage(this._context);

  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();

  static MaterialPageRoute getRoute(BuildContext context) => 
    MaterialPageRoute(
      fullscreenDialog: true,
      settings: 
        RouteSettings(
          name: 'UserSettingsPage', 
          arguments: RouteThing(ValueKey('UserSettingsPage'), -2, Icons.settings, false)    // -2 indicates that this is settings page
        ),
      builder: (context) => UserSettingsPage(context)
    );
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  Color _primaryColor;
  Color _accentColor;
  bool _isDarkTheme;

  TextEditingController primaryColorTextController;
  TextEditingController accentColorTextController;

  @override
  void initState() {
    final listsTheme = ScopedModel.of<ListsScopedModel>(widget._context).listsTheme;
    _primaryColor = listsTheme.primaryColor;
    _accentColor  = listsTheme.accentColor;
    _isDarkTheme  = listsTheme.isDark;

    primaryColorTextController = TextEditingController(text: '#${_primaryColor.value.toRadixString(16)}');
    accentColorTextController  = TextEditingController(text: '#${_accentColor.value.toRadixString(16)}');
    
    super.initState();
  }

  void _saveChanges(){
    final model = ScopedModel.of<ListsScopedModel>(context);
    model.setThemePrimaryColor(_primaryColor);
    model.setThemeAccentColor(_accentColor);
    model.setIsDarkTheme(_isDarkTheme);
    Navigator.of(context).pop();
  }

  // ValueChanged<Color> callback
  void changePrimaryColor(BuildContext context, Color color) {
    _primaryColor = color;
    primaryColorTextController.text = '#${_primaryColor.value.toRadixString(16)}';
    setState(() {});
  }
  void changeAccentColor(BuildContext context, Color color) {
    _accentColor = color;
    accentColorTextController.text = '#${_accentColor.value.toRadixString(16)}';
    setState(() {});
  }
  void toggleDarkTheme(BuildContext context, bool isDarkTheme){
    _isDarkTheme = isDarkTheme;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ListsScopedModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: null,
          title: BreadCrumbNavigator(),
          backgroundColor: Theme.of(context).primaryColor
        ),
        body: Form(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left:4, right: 6), 
                        child: Text('Primary Color', style: Theme.of(context).textTheme.caption)
                      ),
                      Container(
                        constraints: BoxConstraints.tight(Size(MediaQuery.of(context).size.width / 4, 24)),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            labelText: "",
                            counterStyle: TextStyle(height: double.minPositive,),
                            counterText: ""
                          ),
                          maxLength: 9,                            
                          controller: primaryColorTextController,
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12, left: 12),
                        child: SizedBox(
                          width: 60,
                          child: RaisedButton(
                            elevation: 3.0,
                            onPressed: () async {
                              final prim = await showDialog<Color>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ListsColorPicker(_primaryColor, true);
                                },
                              );
                              if (prim != null){
                                _primaryColor = prim;
                                changePrimaryColor(context, prim);
                              }
                            },
                            child: const Icon(Icons.colorize),
                            color: _primaryColor,
                            textColor: useWhiteForeground(_primaryColor)
                                ? const Color(0xffffffff)
                                : const Color(0xff000000),
                          )
                        )
                      ),
                    ],
                  )
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left:4, right: 6), 
                        child: Text('Accent Color', style: Theme.of(context).textTheme.caption)
                      ),
                      Container(
                        constraints: BoxConstraints.tight(Size(MediaQuery.of(context).size.width / 4, 24)),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            labelText: "",
                            counterStyle: TextStyle(height: double.minPositive,),
                            counterText: ""
                          ),
                          maxLength: 9,
                          controller: accentColorTextController,
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12, left: 12),
                        child: SizedBox (
                          width: 60,
                          child: RaisedButton(
                            elevation: 3.0,
                            onPressed: () async {
                              final acc = await showDialog<Color>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ListsColorPicker(_accentColor, false);
                                },
                              );
                              if (acc != null){
                                _accentColor = acc;
                                changeAccentColor(context, acc);
                              }
                            },
                            child: const Icon(Icons.colorize),
                            color: _accentColor,
                            textColor: useWhiteForeground(_accentColor)
                                ? const Color(0xffffffff)
                                : const Color(0xff000000),
                          )
                        )
                      ),
                    ],
                  )
                ),
                Container(
                  child: Row(children: <Widget>[
                    Expanded(child: Container(),),
                    Text('Enable dark theme?'),
                    Checkbox(
                      value: _isDarkTheme,
                      onChanged: (bool val) => toggleDarkTheme(context, val)
                    ),
                    Expanded(child: Container(),),
                  ],)
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[                   
                    RaisedButton(
                      elevation: 3,
                      onPressed: _saveChanges,
                      child: Text('Save Changes'),
                      color: Theme.of(context).primaryColor,
                      textColor: useWhiteForeground(_primaryColor)
                                    ? const Color(0xffffffff)
                                    : const Color(0xff000000),
                    ),
                  ],
                ),
                Expanded(child: Container(),),
              ],
            )   
          ),
        ),
      )
    );
  }
}