import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';

class FormColorPicker extends StatefulWidget {
  const FormColorPicker({this.labelText, this.initialValue, this.onSelected});

  final String labelText;
  final String initialValue;
  final Function(String) onSelected;

  @override
  _FormColorPickerState createState() => _FormColorPickerState();
}

class _FormColorPickerState extends State<FormColorPicker> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  String _color;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showPicker();
      }
    });
  }

  @override
  void didChangeDependencies() {
    _textController.text = widget.initialValue;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showPicker() {
    Color color = Colors.black;
    if (widget.initialValue.isNotEmpty) {
      color = Color(int.parse(widget.initialValue.substring(1, 7), radix: 16) +
          0xFF000000);
    }

    showDialog<AlertDialog>(
      context: context,
      child: AlertDialog(
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color,
            onColorChanged: (color) {
              final hex = color.value.toRadixString(16);
              _color = '#' + hex.substring(2, hex.length);
            },
            enableLabel: true,
            enableAlpha: false,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(AppLocalization.of(context).done),
            onPressed: () {
              widget.onSelected(_color);
              _textController.text = _color;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        InkWell(
          key: ValueKey(widget.labelText),
          onTap: () => _showPicker(),
          child: IgnorePointer(
            child: TextFormField(
              //focusNode: _focusNode,
              readOnly: true,
              controller: _textController,
              decoration: InputDecoration(
                labelText: widget.labelText,
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _textController.text = '';
            widget.onSelected(null);
          },
        ),
      ],
    );
  }
}