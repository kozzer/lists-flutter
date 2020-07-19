import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
 
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
          colorPickerWidth: MediaQuery.of(context).size.width * 0.9,
          pickerAreaHeightPercent: 0.7,
          enableAlpha: true,
          displayThumbColor: true,
          showLabel: false,
          paletteType: PaletteType.hsv,
          pickerAreaBorderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(0.0),
            topRight: const Radius.circular(0.0),
          ),
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          child: const Text('Save'),
          color: Theme.of(context).primaryColor,
          textColor: useWhiteForeground(Theme.of(context).primaryColor)
                                ? const Color(0xffffffff)
                                : const Color(0xff000000),
          onPressed: () {
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