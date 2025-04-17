import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  const CustomTab({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: AutoSizeText(title),
    );
  }
}
