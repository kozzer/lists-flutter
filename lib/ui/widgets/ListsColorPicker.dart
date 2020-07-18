import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:lists/models/ListsScopedModel.dart';
 
class ListsColorPicker extends StatefulWidget {

  final Color themeColor;
  final bool  isPrimaryColor;

  ListsColorPicker(this.themeColor, this.isPrimaryColor);

  @override
  _ListsColorPickerState createState() => _ListsColorPickerState();
}

class _ListsColorPickerState extends State<ListsColorPicker> {

  Color _pickerColor;

  @override
  void initState() {
    super.initState();
    _pickerColor = widget.themeColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0.0),
      contentPadding: const EdgeInsets.all(0.0),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: _pickerColor,
          onColorChanged: (newColor) => setState(() => _pickerColor = newColor),
          colorPickerWidth: 300.0,
          pickerAreaHeightPercent: 0.7,
          enableAlpha: true,
          displayThumbColor: true,
          showLabel: true,
          paletteType: PaletteType.hsv,
          pickerAreaBorderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(2.0),
            topRight: const Radius.circular(2.0),
          ),
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          child: const Text('Save'),
          onPressed: () {
            widget.isPrimaryColor 
              ? ScopedModel.of<ListsScopedModel>(context).setThemePrimaryColor(_pickerColor)
              : ScopedModel.of<ListsScopedModel>(context).setThemeAccentColor(_pickerColor);
            Navigator.pop<Color>(context, _pickerColor);
          }
        ),
        RaisedButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context)
        ),
      ],
    );
      }
} 