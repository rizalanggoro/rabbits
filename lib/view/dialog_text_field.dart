import 'package:flutter/material.dart';

typedef OnClickCancel = void Function();
typedef OnClickSave = void Function();

class DialogTextField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController textEditingController;
  final OnClickCancel onClickCancel;
  final OnClickSave onClickSave;
  final TextInputType textInputType;

  // ignore: use_key_in_widget_constructors
  const DialogTextField({
    required this.title,
    required this.hintText,
    required this.textEditingController,
    required this.onClickCancel,
    required this.onClickSave,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: TextField(
        keyboardType: textInputType,
        controller: textEditingController,
        decoration: InputDecoration(hintText: hintText),
      ),
      actions: [
        TextButton(onPressed: onClickCancel, child: const Text('Batal')),
        TextButton(onPressed: onClickSave, child: const Text('Simpan')),
      ],
    );
  }
}
