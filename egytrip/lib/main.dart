import 'package:egytrip/pages/about.dart';
import 'package:egytrip/pages/add_hotel__screen.dart';
import 'package:egytrip/pages/admin_requests.dart';
import 'package:egytrip/pages/city_offers.dart';
import 'package:egytrip/pages/dashBoard.dart';
import 'package:egytrip/pages/edit_hotel_screen.dart';
import 'package:egytrip/pages/hotels_mange_screen.dart';
import 'package:egytrip/pages/setting.dart';
import 'package:egytrip/pages/splash_screen.dart';
import 'package:egytrip/pages/terms.dart';
import 'package:egytrip/pages/users.dart';
import 'package:egytrip/providers/hotels.dart';
import 'package:egytrip/screens/LoginScreen.dart';
import 'package:egytrip/widgets/appTheme.dart';
import 'package:egytrip/widgets/homeExplore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:egytrip/classes/api_response.dart';
import 'package:egytrip/providers/user_resevation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'classes/cach.dart';
import 'localization/demo_localization.dart';
import 'localization/language_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    RestartWidget(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(
              'assets/image/load.gif',
            ),
          ),
        ),
        //color: Colors.grey,
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);
  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  static setCustomeTheme(BuildContext context) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setCustomeTheme();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void setCustomeTheme() {
    setState(() {
      AppTheme.isLightTheme = !AppTheme.isLightTheme;
    });
  }

  @override
  void didChangeDependencies() async {
    await getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          AppTheme.isLightTheme ? Brightness.dark : Brightness.light,
      statusBarBrightness:
          AppTheme.isLightTheme ? Brightness.light : Brightness.dark,
      systemNavigationBarColor:
          AppTheme.isLightTheme ? Colors.white : Colors.black,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness:
          AppTheme.isLightTheme ? Brightness.dark : Brightness.light,
    ));
    if (this._locale == null) {
      // print('this is country code');
      // print(_locale.languageCode);
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(
              'assets/image/load.gif',
            ),
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800])),
        ),
      );
    } else {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => ApiHotelRes(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => UserReservation(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => ApiCall(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Hotels(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          color: Colors.white,
          theme: AppTheme.getTheme(),
          builder: (BuildContext context, Widget child) {
            if (_locale.languageCode.toString() == 'en') {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: Builder(
                  builder: (BuildContext context) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                          textScaleFactor:
                              MediaQuery.of(context).size.width > 360
                                  ? 1.5
                                  : MediaQuery.of(context).size.width >= 340
                                      ? 1.4
                                      : 1.1),
                      child: child,
                    );
                  },
                ),
              );
            } else {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Builder(
                  builder: (BuildContext context) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaleFactor: MediaQuery.of(context).size.width > 360
                            ? 1.5
                            : MediaQuery.of(context).size.width >= 340
                                ? 1.4
                                : 1.0,
                      ),
                      child: child,
                    );
                  },
                ),
              );
            }
          },
          title: "فندق كوم",
          //'Egy Hotels',
          locale: _locale,
          supportedLocales: [
            Locale("en", "US"),
            //   Locale("fa", "IR"),
            Locale("ar", "AR"),
            //  Locale("hi", "IN")
          ],
          localizationsDelegates: [
            DemoLocalization.delegate,
            // CountryLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          home: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              image: DecorationImage(
                image: AssetImage(
                  'assets/image/load.gif',
                ),
              ),
            ),
            child: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      backgroundColor: AppTheme.getTheme().backgroundColor,
                      body: Center(
                          child: Container(
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )),
                    );
                  }
                  if (userSnapshot.hasData) {
                    return StartScreen();
                    //LoginScreen();

                  }
                  return LoginScreen();
                }),
          ),
          routes: {
            StartScreen.routName: (ctx) => StartScreen(),
            LoginScreen.routName: (ctx) => LoginScreen(),
            HomeExploreScreen.routeName: (ctx) => HomeExploreScreen(),

            SettingsPage.routName: (ctx) => SettingsPage(),
            // ReservationScreen.routeName: (ctx) => ReservationScreen(),
            AdminRequests.routeName: (ctx) => AdminRequests(),
            Terms.routName: (ctx) => Terms(),
            About.routName: (ctx) => About(),
            DashBoard.routeName: (ctx) => DashBoard(),
            Users.routeName: (ctx) => Users(),
            CityOffers.routName: (ctx) => CityOffers(),
            //OfferHomePage.routName: (ctx) => OfferHomePage(),
            HotelsManageScreen.routeName: (ctx) => HotelsManageScreen(),
            AddHotelScreen.routeName: (ctx) => AddHotelScreen(),
            EditHotelScreen.routName: (ctx) => EditHotelScreen(),
          },
        ),
      );
    }
  }
}

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
