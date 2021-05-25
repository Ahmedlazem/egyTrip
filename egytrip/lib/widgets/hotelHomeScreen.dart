import 'dart:ui';
import 'package:egytrip/widgets/popularListView.dart';
import 'package:egytrip/widgets/hotelListData.dart';
import 'package:egytrip/widgets/roomPopupView.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:selection_menu/selection_menu.dart';
import 'appTheme.dart';
import 'hotelListData.dart';
import 'calendarPopupView.dart';
import 'package:egytrip/providers/user_resevation.dart';
import 'package:egytrip/providers/city.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:egytrip/localization/language_constants.dart';
import 'hotelListView.dart';
import 'package:egytrip/pages/city_offers.dart';

double long1;
double lat1;
String cityNameFinal;

class HotelHomeScreen extends StatefulWidget {
  @override
  _HotelHomeScreenState createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  AnimationController _animationController;
  var hotelList = HotelListData.hotelList;
  ScrollController scrollController = new ScrollController();
  int room = 1;
  int ad = 2;
  int child = 0;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 5));
  bool isMap = false;

  final searchBarHieght = 158.0;
  final filterBarHieght = 52.0;

  double lat = 27.9654;
  double long = 34.311312;
  // DateTime _selectedDate = DateTime.now().add(Duration(days: 6));
  Locale locale;
  int roomNu = 1;
  int adultNu = 1;
  int kidsNu = 0;
  int nightNu = 1;
  String userName;
  String userPhone;

  Locale _locale;
  String selectedCity = 'Sharm El-Shikh';
  String selectedLang;
  List<int> number = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<int> numberKids = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  @override
  void initState() {
    getLocale().then((locale) {
      _locale = locale;
      selectedLang = _locale.toString();
    });
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    scrollController.addListener(() {
      if (context != null) {
        if (scrollController.offset <= 0) {
          _animationController.animateTo(0.0);
        } else if (scrollController.offset > 0.0 &&
            scrollController.offset < searchBarHieght) {
          // we need around searchBarHieght scrolling values in 0.0 to 1.0
          _animationController
              .animateTo((scrollController.offset / searchBarHieght));
        } else {
          _animationController.animateTo(1.0);
        }
      }
    });
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.48,
        decoration: BoxDecoration(
          color: AppTheme.getTheme().scaffoldBackgroundColor,
          //AppTheme.getTheme().backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: AppTheme.getTheme().dividerColor,
                offset: Offset(8, 8),
                blurRadius: 8.0),
          ],
        ),
        child: Stack(
          children: <Widget>[
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                children: <Widget>[
                  // getAppBarUI(),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (BuildContext context, Widget child) {
                            return Positioned(
                              top: -searchBarHieght *
                                  (_animationController.value),
                              left: 0,
                              right: 0,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    color: AppTheme.getTheme()
                                        .scaffoldBackgroundColor,
                                    child: Column(
                                      children: <Widget>[
                                        getSearchBarUI(),
                                        getTimeDateUI(),
                                      ],
                                    ),
                                  ),
                                  // getFilterBarUI(),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getMapPinUI() {
    List<Widget> list = List<Widget>();

    for (var i = 0; i < hotelList.length; i++) {
      double top;
      double left;
      double right;
      double bottom;
      if (i == 0) {
        top = 150;
        left = 50;
      } else if (i == 1) {
        top = 50;
        right = 50;
      } else if (i == 2) {
        top = 40;
        left = 10;
      } else if (i == 3) {
        bottom = 260;
        right = 140;
      } else if (i == 4) {
        bottom = 160;
        right = 20;
      }
      list.add(
        Positioned(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          child: Container(
            decoration: BoxDecoration(
              color: hotelList[i].isSelected
                  ? AppTheme.getTheme().primaryColor
                  : AppTheme.getTheme().backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppTheme.getTheme().dividerColor,
                  blurRadius: 16,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
                onTap: () {
                  if (hotelList[i].isSelected == false) {
                    setState(() {
                      hotelList.forEach((f) {
                        f.isSelected = false;
                      });
                      hotelList[i].isSelected = true;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  child: Text(
                    "\$${hotelList[i].perNight}",
                    style: TextStyle(
                        color: hotelList[i].isSelected
                            ? AppTheme.getTheme().backgroundColor
                            : AppTheme.getTheme().primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return list;
  }

  Widget selectCityPhoto() {
    // var popularList = HotelListData.popularList;
    return Container(
      height: 200,
      width: 300,
      child: PopularListView(
        animationController: animationController,
        callBack: selectCity,
      ),
    );
  }

  Widget getListUI() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.getTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: AppTheme.getTheme().dividerColor,
              offset: Offset(0, -2),
              blurRadius: 8.0),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 156 - 50,
            child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox();
                } else {
                  return ListView.builder(
                    itemCount: hotelList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      //var count = hotelList.length > 10 ? 10 : hotelList.length;
                      // var animation = Tween(begin: 0.0, end: 1.0).animate(
                      //     CurvedAnimation(
                      //         parent: animationController,
                      //         curve: Interval((1 / count) * index, 1.0,
                      //             curve: Curves.fastOutSlowIn)));
                      animationController.forward();
                      return HotelListView(
                          // /// callback: () {},
                          //  hotelData: hotelList[index],
                          //animation: animation,
                          // animationController: animationController,
                          );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget getHotelViewList() {
    List<Widget> hotelListViews = List<Widget>();
    for (var i = 0; i < hotelList.length; i++) {
      var count = hotelList.length;
      var animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval((1 / count) * i, 1.0, curve: Curves.fastOutSlowIn),
        ),
      );
    }
    animationController.forward();
    return Column(
      children: hotelListViews,
    );
  }

  Widget getTimeDateUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      // setState(() {
                      //   isDatePopupOpen = true;
                      // });
                      showDemoDialog(context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            getTranslated(context, "Choose date"),
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8)),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}",
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              height: 1,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          //get room no and adult
          Container(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => RoomPopupView(
                          ad: 2,
                          room: 1,
                          ch: 0,
                          barrierDismissible: true,
                          onChnage: (ro, a, c) {
                            setState(() {
                              room = ro;
                              ad = a;
                              child = c;
                            });
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            getTranslated(context, "Number of Rooms"),
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8)),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "$room ${getTranslated(context, "Room")}- $ad ${getTranslated(context, "Adults")}",
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.getTheme().backgroundColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.getTheme().dividerColor,
                        offset: Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: SelectCityDropDown(),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.getTheme().primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: AppTheme.getTheme().dividerColor,
                    offset: Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: selectCity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(FontAwesomeIcons.search,
                      size: 20, color: AppTheme.getTheme().backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void selectCity() {
    print('select city start');
    FocusScope.of(context).requestFocus(FocusNode());
    final userResInfo = UserReservation(
        city: City(
            long: long1 ?? long,
            lat: lat1 ?? lat,
            cityName: cityNameFinal ?? selectedCity),
        date: startDate,
        hotelId: '',
        adultNU: ad,
        kidsNu: child,
        nightNu: (startDate.difference(endDate)).inDays,
        roomNu: room);

    //print(selectedLang.);
    Navigator.of(context).pushNamed(CityOffers.routName,
        arguments: {'userResInfo': userResInfo, "selectedLang": selectedLang});
  }

  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.getTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: AppTheme.getTheme().dividerColor,
                    offset: Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: AppTheme.getTheme().backgroundColor,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "530 hotels found",
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      // FocusScope.of(context).requestFocus(FocusNode());
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => FiltersScreen(),
                      //       fullscreenDialog: true),
                      // );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Filtter",
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.sort,
                                color: AppTheme.getTheme().primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  void showDemoDialog({BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            if (startData != null && endData != null) {
              startDate = startData;
              endDate = endData;
            }
          });
        },
        onCancelClick: () {},
      ),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.getTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: AppTheme.getTheme().dividerColor,
              offset: Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Explore",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.favorite_border),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {
                        setState(() {
                          isMap = !isMap;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                            isMap ? Icons.sort : FontAwesomeIcons.mapMarkedAlt),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MapHotelListView extends StatelessWidget {
  final VoidCallback callback;
  final HotelListData hotelData;

  const MapHotelListView({Key key, this.hotelData, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 8, top: 8, bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.getTheme().backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppTheme.getTheme().dividerColor,
              offset: Offset(4, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: AspectRatio(
            aspectRatio: 2.7,
            child: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 0.90,
                      child: Image.asset(
                        hotelData.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              hotelData.titleTxt,
                              maxLines: 2,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              hotelData.subTxt,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.withOpacity(0.8)),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            FontAwesomeIcons.mapMarkerAlt,
                                            size: 12,
                                            color: AppTheme.getTheme()
                                                .primaryColor,
                                          ),
                                          Text(
                                            " ${hotelData.dist.toStringAsFixed(1)} km to city",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey
                                                    .withOpacity(0.8)),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: SmoothStarRating(
                                          allowHalfRating: true,
                                          starCount: 5,
                                          rating: hotelData.rating,
                                          size: 20,
                                          color:
                                              AppTheme.getTheme().primaryColor,
                                          borderColor:
                                              AppTheme.getTheme().primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "\$${hotelData.perNight}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                        ),
                                      ),
                                      Text(
                                        "/per night",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.grey.withOpacity(0.8)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor:
                        AppTheme.getTheme().primaryColor.withOpacity(0.1),
                    onTap: () {
                      callback();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectCityDropDown extends StatefulWidget {
  @override
  _SelectCityDropDownState createState() => _SelectCityDropDownState();
}

class _SelectCityDropDownState extends State<SelectCityDropDown> {
  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    List<City> CityList2 = [
      // City(
      //     cityName: getTranslated(
      //       context,
      //       "selectCity",
      //     ),
      //     long: 34.311312,
      //     lat: 27.859584),
      City(
          cityName: getTranslated(
            context,
            "Sharm El-Shikh",
          ),
          long: 34.311312,
          lat: 27.859584),
      // City(
      //     cityName: getTranslated(
      //       context,
      //       'Nabq Bay',
      //     ),
      //     long: 34.417317,
      //     lat: 28.016034),
      // City(
      //     cityName: getTranslated(
      //       context,
      //       'Sharm Old Market',
      //     ),
      //     long: 34.295808,
      //     lat: 27.865542),
      //
      // City(
      //     cityName: getTranslated(
      //       context,
      //       'Naama Bay',
      //     ),
      //     long: 34.326752,
      //     lat: 27.914885),
      // City(
      //     cityName: getTranslated(
      //       context,
      //       'Sharks Bay',
      //     ),
      //     long: 34.393251,
      //     lat: 27.963000),

      City(
        cityName: getTranslated(context, 'Hurghada'),
        long: 33.8116,
        lat: 27.2579,
      ),
      City(
        cityName: getTranslated(context, "El-Gona"),
        lat: 27.4025,
        long: 33.6511,
      ),
      City(
          cityName: getTranslated(context, "Mersa Alam"),
          lat: 25.0676,
          long: 34.8790),
      // City(
      //     cityName: getTranslated(context, "Porto Ghalib"),
      //     lat: 25.5354,
      //     long: 34.6375),
      // City(
      //     cityName: getTranslated(context, "Sahl Hasheesh"),
      //     lat: 27.0370,
      //     long: 33.8523),
      City(
          cityName: getTranslated(context, 'Dahab'),
          lat: 28.5091,
          long: 34.5136),
      // City(
      //     cityName: getTranslated(context, "Makadi"),
      //     lat: 26.9886,
      //     long: 33.8996),
      // City(
      //     cityName: getTranslated(context, "Soma Bay"),
      //     lat: 26.8482,
      //     long: 33.9900),
      City(
          cityName: getTranslated(context, 'Taba'),
          lat: 29.4925,
          long: 34.8969),
      // City(
      //     cityName: getTranslated(context, "Safaga"),
      //     lat: 26.7500,
      //     long: 33.9360),
      // City(
      //     cityName: getTranslated(context, "El-Quseer"),
      //     lat: 26.1014,
      //     long: 34.2803),
      City(
          cityName: getTranslated(context, "El-Sokhna"),
          lat: 29.6725,
          long: 32.3370),
      City(
          cityName: getTranslated(context, "Cairo"),
          lat: 30.0444,
          long: 31.2357),
      // City(
      //     cityName: getTranslated(context, "Fifth Settlement"),
      //     lat: 30.0084868,
      //     long: 31.4284756),
      // City(
      //     cityName: getTranslated(context, "Heliopolis"),
      //     lat: 30.115469,
      //     long: 31.346512),
      // City(
      //     cityName: getTranslated(context, "Giza"),
      //     lat: 30.0131,
      //     long: 31.2089),
      // City(
      //     cityName: getTranslated(context, "El Maadi"),
      //     lat: 29.963200,
      //     long: 31.317997),
      // City(
      //     cityName: getTranslated(context, "Nasser City"),
      //     lat: 30.069505,
      //     long: 31.341665),
      // City(
      //     cityName: getTranslated(context, "October city"),
      //     lat: 29.996013,
      //     long: 30.97875),
      City(
          cityName: getTranslated(context, "Luxor"),
          lat: 25.6872,
          long: 32.6396),
      City(
          cityName: getTranslated(context, "Aswan"),
          lat: 24.0928,
          long: 32.8968),
//      City(
//          cityName: getTranslated(context, "Marina"),
//          lat: 27.97909,
//          long: 34.23097),
      City(
          cityName: getTranslated(context, "Alexandria"),
          lat: 31.2001,
          long: 29.9187),
      // City(
      //     cityName: getTranslated(context, "Siwa"),
      //     lat: 29.203171,
      //     long: 25.519545),
//      City(
//          cityName: getTranslated(context, "Ras El bar"),
//          lat: 25.066668,
//          long: 34.900002),
      //marsa 3lm
    ];

    return SelectionMenu<City>(
      itemSearchMatcher: this.itemSearchMatcher,
      // Defaults to null, meaning search is disabled.
      // ItemSearchMatcher takes a searchString and an Item (FontColor in this example)
      // Returns true if searchString can be used to describe Item, else false.
      // Defined below for the sake of brevity.

      searchLatency: Duration(milliseconds: 500),
      // Defaults to const Duration(milliseconds: 500).
      // This is the delay before the SelectionMenu actually starts searching.
      // Since search is called for every character change in the search field,
      // it acts as a buffering time and does not perform search for every
      // character update during this time.

      itemsList: CityList2,
      itemBuilder: this.itemBuilder,
      onItemSelected: this.onItemSelected,
      showSelectedItemAsTrigger: true,
      initiallySelectedItemIndex: 0,
    );
  }

  bool itemSearchMatcher(String searchString, City city) {
    return city.cityName
        .toLowerCase()
        .contains(searchString.trim().toLowerCase());
  }

  Widget itemBuilder(
      BuildContext context, City city, OnItemTapped onItemTapped) {
    // ignore: deprecated_member_use

    return Material(
      color: AppTheme.getTheme().backgroundColor,
      child: InkWell(
        onTap: onItemTapped,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Text(
                  city.cityName,
                  style: TextStyle(
                      color: AppTheme.getTheme().accentColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onItemSelected(City city) {
    setState(() {
      print(city.cityName);
      cityNameFinal = city.cityName ?? "Sharm El-Shikh";
      long1 = city.long;
      lat1 = city.lat;
    });
  }
}
