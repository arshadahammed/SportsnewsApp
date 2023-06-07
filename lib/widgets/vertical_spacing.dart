import 'package:flutter/material.dart';

class VerticalSpacing extends StatelessWidget {
  const VerticalSpacing(this.height, {super.key});
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
