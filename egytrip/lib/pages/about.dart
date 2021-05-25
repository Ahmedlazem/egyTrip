import 'package:egytrip/localization/language_constants.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  static const String routName = 'About';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslated(context, "About"),
        ),
      ),
    );
  }
}
