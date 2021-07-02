import 'package:flutter/material.dart';
import 'package:rabbits/data/unit.dart';

typedef OnSelectedUnit = void Function(Unit selectedUnit);

// ignore: use_key_in_widget_constructors
class DialogSelectUnit extends StatelessWidget {
  final String? title;
  final OnSelectedUnit onSelectedUnit;

  // ignore: use_key_in_widget_constructors
  const DialogSelectUnit({
    required this.onSelectedUnit,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(top: 8),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
      ],
      title: Text(title ?? 'Pilih satuan'),
      content: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            onTap: () {
              onSelectedUnit(Unit.kilogram);
              Navigator.pop(context);
            },
            title: const Text('Kilogram'),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            onTap: () {
              onSelectedUnit(Unit.gram);
              Navigator.pop(context);
            },
            title: const Text('Gram'),
          ),
        ],
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
