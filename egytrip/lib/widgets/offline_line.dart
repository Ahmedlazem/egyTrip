import 'package:egytrip/localization/language_constants.dart';

import '../main.dart';
import 'package:flutter/material.dart';

class OfflineError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              getTranslated(context,
                  " you are offline. Please connect to the internet and try again"),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            child: Text(
              getTranslated(context, "Retry"),
            ),
            onPressed: () {
              RestartWidget.restartApp(context);
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
