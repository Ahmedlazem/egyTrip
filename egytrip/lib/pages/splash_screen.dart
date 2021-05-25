import 'package:egytrip/widgets/homeExplore.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  static const String routName = '/SplashScreen';
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  bool isFirstTime = false;
  Widget indexView = Container();

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    indexView = Container();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startLoadScreen());

    super.initState();
  }

  Future _startLoadScreen() async {
    animationController..forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage(
            'assets/image/load.gif',
          ),
        ),
      ),
      child: HomeExploreScreen(
        animationController: animationController,
      ),
    );
  }
}
