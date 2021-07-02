import 'package:flutter/material.dart';

typedef ADialogTextFieldOnClickOk = void Function(String text);

// ignore: use_key_in_widget_constructors
class ADialogTextField extends StatefulWidget {
  final String title;
  final String hintText;
  final TextInputType textInputType;
  final ADialogTextFieldOnClickOk onClickOk;

  // ignore: use_key_in_widget_constructors
  const ADialogTextField({
    required this.title,
    required this.hintText,
    required this.textInputType,
    required this.onClickOk,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ADialogTextField> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          hintText: widget.hintText,
        ),
        keyboardType: widget.textInputType,
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal')),
        TextButton(
            onPressed: () {
              var _text = _textEditingController.text;
              if (_text.isNotEmpty) {
                widget.onClickOk(_text);
                Navigator.pop(context);
              }
            },
            child: const Text('Oke')),
      ],
    );
  }
}
