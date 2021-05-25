import 'package:egytrip/pages/about.dart';
import 'package:egytrip/pages/dashBoard.dart';
import 'package:egytrip/pages/setting.dart';
import 'package:egytrip/pages/splash_screen.dart';
import 'package:egytrip/pages/terms.dart';
import 'package:egytrip/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:egytrip/localization/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String userPhone;
  String username;

  @override
  void didChangeDependencies() {
    LoginScreen.getUserSharedPref().then((value) {
      setState(() {
        username = value['userName'];
        userPhone = value['userPhone'];
      });
    });

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: FittedBox(
              child: Row(
                children: <Widget>[
                  Text(
                    getTranslated(context, 'Hello'),
                    style: TextStyle(
                      // fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    username == null ? '' : username,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      //  fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    // textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            // automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Theme.of(context).buttonColor,
              size: 30,
            ),
            title: Text(
              getTranslated(context, 'Home'),
              style: TextStyle(
                color: Theme.of(context).buttonColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              // To close the Drawer
              Navigator.pop(context);
              // Navigating to About Page
              Navigator.of(context).pushReplacementNamed(StartScreen.routName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.language,
              color: Theme.of(context).buttonColor,
              size: 30,
            ),
            title: Text(
              getTranslated(context, "settings"),
              style: TextStyle(
                color: Theme.of(context).buttonColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              // To close the Drawer
              Navigator.pop(context);
              // Navigating to About Page
              Navigator.of(context).pushNamed(SettingsPage.routName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.whatsappSquare,
              color: Theme.of(context).buttonColor,
              size: 30,
            ),
            title: Text(
              getTranslated(context, "Contact Us"),
              style: TextStyle(
                color: Theme.of(context).buttonColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              FlutterOpenWhatsapp.sendSingleMessage("+201098899505", "");
            },
          ),
          Divider(),
          // ListTile(
          //   leading: Icon(
          //     FontAwesomeIcons.solidEdit,
          //     color: Theme.of(context).buttonColor,
          //     size: 27,
          //   ),
          //   title: Text(
          //     getTranslated(context, "Terms & Conditions"),
          //     style: TextStyle(
          //       color: Theme.of(context).buttonColor,
          //       fontWeight: FontWeight.w700,
          //     ),
          //   ),
          //   onTap: () {
          //     // To close the Drawer
          //     Navigator.pop(context);
          //     // Navigating to About Page
          //     Navigator.of(context).pushNamed(Terms.routName);
          //   },
          // ),
          // Divider(),
          // ListTile(
          //   leading: Icon(
          //     FontAwesomeIcons.readme,
          //     color: Theme.of(context).buttonColor,
          //     size: 27,
          //   ),
          //   title: Text(
          //     getTranslated(context, "About"),
          //     style: TextStyle(
          //       color: Theme.of(context).buttonColor,
          //       fontWeight: FontWeight.w700,
          //     ),
          //   ),
          //   onTap: () {
          //     // To close the Drawer
          //     Navigator.pop(context);
          //     // Navigating to About Page
          //     Navigator.of(context).pushNamed(About.routName);
          //   },
          // ),
          // Divider(),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.signOutAlt,
              color: Theme.of(context).buttonColor,
              size: 30,
            ),
            title: Text(
              getTranslated(context, "LogOut"),
              //  'Log Out',
              style: TextStyle(
                color: Theme.of(context).buttonColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (ctx) => Center(
                        child: AlertDialog(
                          title: Center(
                              child: Text(
                            getTranslated(
                                context, "Are you sure you will logout"),

                            //'Are you sure you want Log Out',
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).buttonColor),
                          )),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                getTranslated(context, " Yes"),
                                style: TextStyle(
                                    color: Theme.of(context).buttonColor),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                FirebaseAuth.instance.signOut();

                                Navigator.pushReplacementNamed(
                                    context, LoginScreen.routName);
                              },
                            ),
                            FlatButton(
                              child: Text(
                                getTranslated(context, "No"),
                              ),
                              onPressed: () {
                                Navigator.of(ctx).pop(true);
                              },
                            ),
                          ],
                        ),
                      ));
            },
          ),
          // if (userId == '6IQlYTQ83vcnllPOHbnOs4rSq7m1')
          Divider(),
          //'6IQlYTQ83vcnllPOHbnOs4rSq7m1'
          userPhone == '+201098899505' ||
                  userPhone == '+201005276809' ||
                  userPhone == '+201111025867'
              ? ListTile(
                  leading: Icon(
                    Icons.dashboard,
                    color: Theme.of(context).buttonColor,
                    size: 30,
                  ),
                  title: Text(
                    'DashBoard',
                    style: TextStyle(
                      color: Theme.of(context).buttonColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () {
                    // To close the Drawer
                    Navigator.pop(context);
                    // Navigating to About Page
                    Navigator.of(context).pushNamed(DashBoard.routeName);
                  },
                )
              : Container(
                  child: Text(''),
                  //visible: false, // set it to false
                )
        ],
      ),
    );
  }
}
