import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';

class MyColorPicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyColorPickerState();
}

class _MyColorPickerState extends State<MyColorPicker> {
  @override
  Widget build(BuildContext context) {
    // This gets the current state of ColorPickerData and also tells Flutter
    // to rebuild this widget when ColorPickerData notifies listeners (in other words,
    // when it changes).

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Consumer<ThemeNotifier>(
          builder: (context, curColor, child) => RaisedButton(
            elevation: 3.0,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Select a color'),
                    content: SingleChildScrollView(
                      child: BlockPicker(
                        pickerColor: curColor.currentColor,
                        onColorChanged: curColor.changeColor,
                      ),
                    ),
                  );
                },
              );
            },
            child: const Text('Pick card colour'),
            color: curColor.currentColor,
            textColor: useWhiteForeground(curColor.currentColor)
                ? const Color(0xffffffff)
                : const Color(0xff000000),
          ),
        ),
      ],
    );
  }
}
