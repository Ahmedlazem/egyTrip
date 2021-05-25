import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egytrip/classes/cach.dart';
import 'package:egytrip/localization/language_constants.dart';
import 'package:egytrip/pages/splash_screen.dart';
import 'package:egytrip/screens/LoginScreen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'appTheme.dart';

ApiCall _apiCall = new ApiCall();

class BookingScreen extends StatefulWidget {
  final AnimationController animationController;
  final String imageUrl;
  final List<dynamic> price;
  final String hotelMail;
  final String hotelPhone;
  final String hotelSite;
  final String hotelId;
  final String hotelName;
  final String hotelClass;

  const BookingScreen(
      {Key key,
      this.animationController,
      this.imageUrl,
      this.price,
      this.hotelMail,
      this.hotelPhone,
      this.hotelSite,
      this.hotelId,
      this.hotelName,
      this.hotelClass})
      : super(key: key);
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
//  List<SettingsListData> userSettingsList = SettingsListData.userSettingsList;
  String userPhone;
  String username;
  int adult = _apiCall.getUserInfo.adultNU;
  int children = _apiCall.getUserInfo.kidsNu;
  DateTime startDate = _apiCall.getUserInfo.date;
  int endDate = _apiCall.getUserInfo.nightNu;
  int room = _apiCall.getUserInfo.roomNu;

  Future<void> _sendRequest() async {
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('User Request').add({
      'adultsNo': _apiCall.getUserInfo.adultNU,
      'roomNo': _apiCall.getUserInfo.roomNu,
      'kidsNo': _apiCall.getUserInfo.kidsNu,
      'city': _apiCall.getUserInfo.city.cityName,
      'nightNo': _apiCall.getUserInfo.nightNu,
      'ArrivalDate': _apiCall.getUserInfo.date.toString(),
      'hotelName': widget.hotelName,
      'price': widget.price,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': username,
      'userPhone': userPhone,
      'hotelPhone': widget.hotelPhone,
      'hotelMail': widget.hotelMail,
      'hotelSite': widget.hotelSite,
    });
  }

  @override
  void initState() {
    widget.animationController.forward();
    super.initState();
  }

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
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animationController,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 40 * (1.0 - widget.animationController.value), 0.0),
            child: Scaffold(
              backgroundColor: AppTheme.getTheme().backgroundColor,
              body: Stack(
                children: <Widget>[
                  IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.getTheme().primaryColor,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppTheme.getTheme().dividerColor,
                            blurRadius: 8,
                            offset: Offset(4, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            top: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: CachedNetworkImage(
                                imageUrl: widget.imageUrl != null
                                    ? widget.imageUrl
                                    : 'assets/image/sea.jpg',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    // bottom: MediaQuery.of(context).padding.bottom + 16,
                    left: 10,
                    right: 10,
                    bottom: 100,
                    // top: 20,
                    child: Opacity(
                      opacity: 0.9,
                      child: Column(children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            child: new BackdropFilter(
                              filter: new ImageFilter.blur(
                                  sigmaX: 10.0, sigmaY: 10.0),
                              child: Container(
                                color: Colors.black12,
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 50),
                                      child: getUserDetails(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          bottom: 16,
                                          top: 16),
                                      child: Container(
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color:
                                              AppTheme.getTheme().primaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24.0)),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: AppTheme.getTheme()
                                                  .dividerColor,
                                              blurRadius: 8,
                                              offset: Offset(4, 4),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(24.0)),
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              _sendRequest();
                                              await showDialog<Null>(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: Center(
                                                    child: Text(
                                                      getTranslated(context,
                                                          "Have a nice Trip"),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      AppTheme.getTheme()
                                                          .backgroundColor,
                                                  elevation: 10,
                                                  content: Text(
                                                    getTranslated(context,
                                                        "we will contact you ASAP to finalize your booking "),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text(
                                                        getTranslated(
                                                            context, "Okay"),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pushReplacementNamed(
                                                                StartScreen
                                                                    .routName);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      (StartScreen.routName));
                                            },
                                            child: Center(
                                              child: Text(
                                                getTranslated(
                                                    context, "Confirm"),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getUserDetails({bool isInList = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    getTranslated(context, "Hello"),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      // fontSize: 20,
                      color: isInList
                          ? AppTheme.getTheme().textTheme.bodyText1.color
                          : Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Text(
                    username == null ? '' : username,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        //fontSize: 20,
                        color: AppTheme.getTheme().primaryColor),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                " ${getTranslated(context, "you are booking")}$room ${getTranslated(context, "room for")} $adult ${getTranslated(context, "Adult and")} $children ${getTranslated(context, "children Starting on")}  ${DateFormat.yMMMd().format(startDate)} ${getTranslated(context, "for")} ${endDate.toString().replaceAll('-', '')} ${getTranslated(context, "night in hotel")}",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  //fontSize: 20,
                  color: isInList
                      ? AppTheme.getTheme().textTheme.bodyText1.color
                      : Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.hotelName,
                //textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  // fontSize: 20,
                  color: isInList
                      ? AppTheme.getTheme().textTheme.bodyText1.color
                      : Colors.white,
                ),
              ),
              isInList
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: <Widget>[
                          SmoothStarRating(
                            allowHalfRating: true,
                            starCount: 5,
                            rating: double.tryParse(widget.hotelClass),
                            size: 20,
                            color: AppTheme.getTheme().primaryColor,
                            borderColor: AppTheme.getTheme().primaryColor,
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "${widget.price}",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                // fontSize: 20,
                color: isInList
                    ? AppTheme.getTheme().textTheme.bodyText1.color
                    : Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              getTranslated(context, "per night"),
              style: TextStyle(
                fontSize: 14,
                color: isInList
                    ? AppTheme.getTheme().disabledColor.withOpacity(0.5)
                    : Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget appBar() {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => EditProfile(),
        //     fullscreenDialog: true,
        //   ),
        // );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Amanda",
                    style: new TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "View and edit profile",
                    style: new TextStyle(
                      fontSize: 18,
                      color: AppTheme.getTheme().disabledColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24, top: 16, bottom: 16),
            child: Container(
              width: 70,
              height: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                child: Image.asset("assets/images/userImage.png"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
