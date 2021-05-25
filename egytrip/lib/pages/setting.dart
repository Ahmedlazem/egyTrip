import 'package:egytrip/widgets/appTheme.dart';
import 'package:egytrip/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:egytrip/classes/language.dart';
import 'package:egytrip/localization/language_constants.dart';
import 'package:egytrip/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsPage extends StatefulWidget {
  static const String routName = '/setting';
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getTheme().backgroundColor,
      appBar: AppBar(
        title: Text(getTranslated(context, "settings")),
      ),
      drawer: AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8, right: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    MyApp.setCustomeTheme(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(AppTheme.isLightTheme
                        ? FontAwesomeIcons.cloudSun
                        : FontAwesomeIcons.cloudMoon),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            //width: AppBar().preferredSize.height - 8,
            height: AppBar().preferredSize.height - 8,
            color: AppTheme.getTheme().backgroundColor,
            child: Center(
                child: DropdownButton<Language>(
              iconSize: 30,
              hint: Text(getTranslated(context, 'change_language')),
              onChanged: (Language language) {
                _changeLanguage(language);
              },
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                      value: e,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            e.name,
                            style: TextStyle(
                                color: AppTheme.getTheme().primaryColor,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                  )
                  .toList(),
            )),
          ),
        ],
      ),
    );
  }
}
