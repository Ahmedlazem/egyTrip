// import 'package:egytrip/localization/language_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../main.dart';
// import 'appTheme.dart';
// import 'hotelHomeScreen.dart';
// import 'app_drawer.dart';
// import 'hotelListData.dart';
// import 'titleView.dart';
// import 'popularListView.dart';
// import 'homeExploreSliderView.dart';
//
// class HomeExploreScreen extends StatefulWidget {
//   static const routeName = '/homeExploreScreen';
//   final AnimationController animationController;
//
//   const HomeExploreScreen({Key key, this.animationController})
//       : super(key: key);
//   @override
//   _HomeExploreScreenState createState() => _HomeExploreScreenState();
// }
//
// class _HomeExploreScreenState extends State<HomeExploreScreen>
//     with TickerProviderStateMixin {
//   var hotelList = HotelListData.hotelList;
//   ScrollController controller;
//   AnimationController _animationController;
//   var sliderImageHieght = 0.0;
//   @override
//   void initState() {
//     _animationController =
//         AnimationController(duration: Duration(milliseconds: 0), vsync: this);
//     widget.animationController.forward();
//     controller = ScrollController(initialScrollOffset: 0.0);
//
//     controller.addListener(() {
//       if (context != null) {
//         if (controller.offset < 0) {
//           // we static set the just below half scrolling values
//           _animationController.animateTo(0.0);
//         } else if (controller.offset > 0.0 &&
//             controller.offset < sliderImageHieght) {
//           // we need around half scrolling values
//           if (controller.offset < ((sliderImageHieght / 1.5))) {
//             _animationController
//                 .animateTo((controller.offset / sliderImageHieght));
//           } else {
//             // we static set the just above half scrolling values "around == 0.64"
//             _animationController
//                 .animateTo((sliderImageHieght / 1.5) / sliderImageHieght);
//           }
//         }
//       }
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _animationController.removeListener(() {});
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     sliderImageHieght = MediaQuery.of(context).size.width * 1.3;
//     return AnimatedBuilder(
//       animation: widget.animationController,
//       builder: (BuildContext context, Widget child) {
//         return FadeTransition(
//           opacity: widget.animationController,
//           // FadeTransition and Transform : just for screen loading animation on fistTime
//           child: new Transform(
//             transform: new Matrix4.translationValues(
//                 0.0, 40 * (1.0 - widget.animationController.value), 0.0),
//             child: Scaffold(
//               backgroundColor: AppTheme.getTheme().backgroundColor,
//               body: Stack(
//                 children: <Widget>[
//                   Container(
//                     color: AppTheme.getTheme().backgroundColor,
//                     child: ListView.builder(
//                       controller: controller,
//                       itemCount: 3,
//                       // padding on top is only for we need spec for sider
//                       padding: EdgeInsets.only(
//                           top: sliderImageHieght + 32, bottom: 16),
//                       scrollDirection: Axis.vertical,
//                       itemBuilder: (context, index) {
//                         // some list UI
//                         var count = 3;
//                         var animation = Tween(begin: 0.0, end: 2.0).animate(
//                           CurvedAnimation(
//                             parent: widget.animationController,
//                             curve: Interval((1 / count) * index, 1.0,
//                                 curve: Curves.fastOutSlowIn),
//                           ),
//                         );
//                         if (index == 0) {
//                           return TitleView(
//                             titleTxt: getTranslated(context, "Best Deals"),
//                             subTxt: '',
//                             animation: animation,
//                             animationController: widget.animationController,
//                           );
//                         } else if (index == 1) {
//                           return getDealListView(index);
//                         } else {
//                           return TitleView(
//                             titleTxt: getTranslated(context, 'get your Hotel'),
//                             animation: animation,
//                             animationController: widget.animationController,
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                   // sliderUI with 3 images are moving
//                   _sliderUI(),
//
//                   //just gradient for see the time and battry Icon on "TopBar"
//                   Positioned(
//                     top: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       height: 80,
//                       decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               AppTheme.getTheme().backgroundColor.withOpacity(0.4),
//                               AppTheme.getTheme().backgroundColor.withOpacity(0.0),
//                             ],
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                           )),
//                     ),
//                   ),
//                   // serachUI on Top  Positioned
//                   Positioned(
//                     top: MediaQuery.of(context).padding.top - 5,
//                     left: 0,
//                     right: 0,
//                     child: serachUI(),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _sliderUI() {
//     return Positioned(
//       top: 0,
//       left: 0,
//       right: 0,
//       child: AnimatedBuilder(
//         animation: _animationController,
//         builder: (BuildContext context, Widget child) {
//           // we calculate the opecity between 0.64 to 1.0
//           var opecity = 1.0 -
//               (_animationController.value > 0.64
//                   ? 1.0
//                   : _animationController.value);
//           return SizedBox(
//             height: sliderImageHieght * (1.0 - _animationController.value),
//             child: HomeExploreSliderView(
//               opValue: opecity,
//               click: () {},
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget getDealListView(int index) {
//     var hotelList = HotelListData.hotelList;
//     List<Widget> list = List<Widget>();
//     hotelList.forEach((f) {
//       var animation = Tween(begin: 0.0, end: 1.0).animate(
//         CurvedAnimation(
//           parent: widget.animationController,
//           curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn),
//         ),
//       );
//     });
//     return Padding(
//       padding: const EdgeInsets.only(top: 8),
//       child: Column(
//         children: [
//           HotelHomeScreen(),
//           PopularListView(
//             animationController: widget.animationController,
//             callBack: () {},
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget serachUI() {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppTheme.getTheme().bannerTheme.backgroundColor,
//         // borderRadius: BorderRadius.all(Radius.circular(38)),
//         // border: Border.all(
//         //   color: HexColor("#757575").withOpacity(0.6),
//         // ),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//             color: AppTheme.getTheme().dividerColor,
//             blurRadius: 8,
//             offset: Offset(4, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.only(left: 2, right: 8),
//         child: Container(
//           height: 50,
//           child: Center(
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   flex: 1,
//                   child: IconButton(
//                     icon: Icon(
//                       FontAwesomeIcons.bars,
//                       size: 20,
//                       color: AppTheme.primaryColors,
//                       //AppTheme.getTheme().iconTheme.color,
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AppDrawer(),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   flex: 4,
//                   child: Text(
//                     "فندق كوم",
//                     // "Egy Hotels",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontFamily: 'Lalezar',
//                       //"Anton",
//                       fontSize: 22,
//                       //FF6300
//                       color: Color(0xffFF6300),
//                       //AppTheme.getTheme().accentColor
//                       //Colors.indigo,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Padding(
//                     padding: EdgeInsets.only(top: 8, right: 8),
//                     child: Container(
//                       width: AppBar().preferredSize.height,
//                       height: AppBar().preferredSize.height,
//                       child: Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(32.0),
//                           ),
//                           onTap: () {
//                             MyApp.setCustomeTheme(context);
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Icon(AppTheme.isLightTheme
//                                 ? FontAwesomeIcons.cloudSun
//                                 : FontAwesomeIcons.cloudMoon),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
