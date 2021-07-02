import 'package:flutter/material.dart';

class ACard extends StatelessWidget {
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget child;

  // ignore: use_key_in_widget_constructors
  const ACard({
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 8),
        ]),
        margin: margin ?? const EdgeInsets.all(0),
        padding: padding ?? const EdgeInsets.all(0),
        child: Material(
          child: child,
          color: Colors.transparent,
        ),
      );
}
