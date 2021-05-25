import 'package:egytrip/localization/language_constants.dart';
import 'package:flutter/material.dart';

class Terms extends StatelessWidget {
  static const String routName = 'terms';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 // Colors are easy thanks to Flutter's Colors class.
//                 Colors.blue[900],
//
//                 Colors.blue[800],
//
//                 Colors.blue[700],
//                 Colors.blue[600],
// //                  Colors.blue[500],
// //                  Colors.blue[600],
//               ],
//             ),
//           ),
//         ),
        title: Text(
          getTranslated(context, "Terms & Conditions"),
        ),
      ),
    );
  }
}
