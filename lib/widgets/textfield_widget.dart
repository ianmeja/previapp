import 'package:flutter/material.dart';
import 'package:now_ui_flutter/constants/Theme.dart';

class TextFieldWidget extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final Function onChanged;

  TextFieldWidget({
    Key key,
    this.maxLines = 1,
    this.label,
    this.text,
    this.onChanged,
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
  }


  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.label,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NowUIColors.text),
      ),
      const SizedBox(height: 8),
      TextField(
        onChanged: widget.onChanged,
        style: TextStyle(color: NowUIColors.text),
        controller: controller,
        cursorColor: NowUIColors.primary,
        decoration: InputDecoration(
          filled: true,
          fillColor: NowUIColors.white.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        maxLines: widget.maxLines,
      ),
    ],
  );
}