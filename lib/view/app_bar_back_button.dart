import 'package:flutter/material.dart';

class AppBarBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded),
      );
}
