import 'package:flutter/material.dart';
import 'package:lists/ui/widgets/ListsColorPicker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:lists/models/ListsScopedModel.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class UserSettingsPage extends StatefulWidget {

  final BuildContext _context;

  UserSettingsPage(this._context);

  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  Color _primaryColor;
  Color _accentColor;
  bool _isDarkTheme;

  @override
  void initState() {
    _primaryColor = Theme.of(widget._context).primaryColor;
    _accentColor  = Theme.of(widget._context).accentColor;
    _isDarkTheme  = ScopedModel.of<ListsScopedModel>(widget._context).listsTheme.isDark;
    super.initState();
  }

  // ValueChanged<Color> callback
  void changePrimaryColor(BuildContext context, Color color) {
    ScopedModel.of<ListsScopedModel>(context).setThemePrimaryColor(color);
    setState(() => _primaryColor = color);
  }
  void changeAccentColor(BuildContext context, Color color) {
    ScopedModel.of<ListsScopedModel>(context).setThemeAccentColor(color);
    setState(() => _accentColor = color);
  }
  void toggleDarkTheme(BuildContext context, bool isDarkTheme){
    ScopedModel.of<ListsScopedModel>(context).setIsDarkTheme(isDarkTheme);
    setState(() => _isDarkTheme = isDarkTheme);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ListsScopedModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints.tight(Size(MediaQuery.of(context).size.width / 3, 24)),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          decoration: null,
                          maxLength: 9,
                          initialValue: '#${_primaryColor.value.toRadixString(16)}',
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12, left: 12),
                        child: RaisedButton(
                          elevation: 3.0,
                          onPressed: () async {
                            final prim = await showDialog<Color>(
                              context: context,
                              builder: (BuildContext context) {
                                return ListsColorPicker(_primaryColor, true);
                              },
                            );
                            if (prim != null)
                              changePrimaryColor(context, prim);
                          },
                          child: const Text('Pick Primary Color'),
                          color: _primaryColor,
                          textColor: useWhiteForeground(_primaryColor)
                              ? const Color(0xffffffff)
                              : const Color(0xff000000),
                        )
                      ),
                    ],
                  )
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints.tight(Size(MediaQuery.of(context).size.width / 3, 24)),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          decoration: null,
                          maxLength: 9,
                          initialValue: '#${_accentColor.value.toRadixString(16)}',
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12, left: 12),
                        child: RaisedButton(
                          elevation: 3.0,
                          onPressed: () async {
                            final acc = await showDialog<Color>(
                              context: context,
                              builder: (BuildContext context) {
                                return ListsColorPicker(_accentColor, false);
                              },
                            );
                            if (acc != null)
                              changeAccentColor(context, acc);
                          },
                          child: const Text('Pick Accent Color'),
                          color: _primaryColor,
                          textColor: useWhiteForeground(_primaryColor)
                              ? const Color(0xffffffff)
                              : const Color(0xff000000),
                        )
                      ),
                    ],
                  )
                ),
                Container(
                  child: Row(children: <Widget>[
                    Text('Enable dark theme?'),
                    Checkbox(
                      value: _isDarkTheme,
                      onChanged: (bool val) => toggleDarkTheme(context, val)
                    )
                  ],)
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