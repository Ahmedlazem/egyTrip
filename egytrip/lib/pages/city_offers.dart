import 'dart:math';
import 'package:egytrip/classes/api_response.dart';
import 'package:egytrip/classes/cach.dart';
import 'package:egytrip/localization/language_constants.dart';
import 'package:egytrip/providers/hotel_offers.dart';
import 'package:egytrip/providers/user_resevation.dart';
import 'package:egytrip/widgets/appTheme.dart';
import 'package:egytrip/widgets/filter-sceen.dart';
import 'package:egytrip/widgets/hotelListView.dart';
import 'package:egytrip/widgets/offline_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable

class CityOffers extends StatefulWidget {
  static const String routName = '/offers';

  @override
  _CityOffersState createState() => _CityOffersState();
}

class _CityOffersState extends State<CityOffers> {
  String selectedLang;

  double min = 100.0;
  double max = 10000.0;
  double starFilterMax = 5.0;
  double starFilterMin = 0.0;
  double rateFilterMax = 5.0;
  double rateFilterMin = 0.0;
  bool isStreamFinish = false;

  String getCityDisc(UserReservation userReservation) {
    final city = userReservation.city.long;
    final disc = cityList.firstWhere((element) => element.long == city);
    var text = disc.cityDis["$selectedLang"];

    return text;
  }

  String getCityImage(UserReservation userReservation) {
    var city = userReservation.city.long ?? 34.311312;
    print(city.toString());
    final disc = cityList.firstWhere((element) => element.long == city);
    var url = disc.cityDis['imageUrl'];

    return url;
  }

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    UserReservation userReservation = data['userResInfo'];

    final requestsStream = Provider.of<ApiCall>(context, listen: false)
        .requestsView(userReservation: userReservation, max: max, min: min);
    // isStreamFinish =
    //     Provider.of<ApiCall>(context, listen: false).cityStreamFinish ?? false;
    selectedLang = data["selectedLang"];
    getCityImage(userReservation);
    return Scaffold(
      backgroundColor: AppTheme.getTheme().backgroundColor,
      body: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: PageHeader(
              image:
                  //'assets/image/1.gif',
                  getCityImage(userReservation),
              minExtent: 80,
              maxExtent: 300.0,
              updateInformation:
                  (RangeValues x, RangeValues star, RangeValues rate) {
                setState(() {
                  //  print(" rate max is ${rate.end}");
                  min = x.start ?? 5000;
                  max = x.end ?? 200;
                  starFilterMin = star.start ?? 0.0;
                  starFilterMax = star.end ?? 5.0;
                  rateFilterMin = rate.start ?? 0.0;
                  rateFilterMax = rate.end ?? 5.0;
                });
              },
              title: userReservation.city.cityName,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: AppTheme.getTheme().backgroundColor,
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  getCityDisc(userReservation),
                  textAlign: TextAlign.justify,
                  // style: TextStyle(fontSize: 12),
                ),
              ),
            ]),
          ),
          StreamBuilder<dynamic>(
            stream: requestsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<ApiHotelRes> hotelList =
                    Provider.of<ApiCall>(context).allRes;
                print('hotel list has ${hotelList.length}');

                final hotelAfterFilterList = hotelList.where((e) =>
                    e.offersItems.first.imageUrl0 != null &&
                    double.tryParse(e.offersItems.first.hotelClass) >=
                        starFilterMin &&
                    double.tryParse(e.offersItems.first.hotelClass) <=
                        starFilterMax &&
                    double.tryParse(e.offersItems.first.rate) >=
                        rateFilterMin &&
                    double.tryParse(e.offersItems.first.rate) <= rateFilterMax);
                print(
                    'hotel filter list has length ${hotelAfterFilterList.length}');

                if (hotelList.length != 0) {
                  return hotelAfterFilterList.length != 0
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int i) {
                              final bool hotelFilterStatus =
                                  (hotelList[i].offersItems.first.imageUrl0 !=
                                          null &&
                                      double.tryParse(hotelList[i]
                                              .offersItems
                                              .first
                                              .hotelClass) >=
                                          starFilterMin &&
                                      double.tryParse(hotelList[i]
                                              .offersItems
                                              .first
                                              .hotelClass) <=
                                          starFilterMax &&
                                      double.tryParse(hotelList[i]
                                              .offersItems
                                              .first
                                              .rate) >=
                                          rateFilterMin &&
                                      double.tryParse(hotelList[i]
                                              .offersItems
                                              .first
                                              .rate) <=
                                          rateFilterMax);
                              // codition to update is stream finish so ican update ui
                              // if (i == hotelAfterFilterList.length - 1) {
                              //   Provider.of<ApiCall>(context, listen: false)
                              //       .streamFinish();
                              // }
                              if (hotelFilterStatus) {
                                return HotelListView(
                                  key: ValueKey(
                                      hotelList[i].offersItems.first.docId),
                                  imageUrl:
                                      hotelList[i].offersItems.first.imageUrl0,
                                  hotelName:
                                      hotelList[i].offersItems.first.hotelName,
                                  hotelClass:
                                      hotelList[i].offersItems.first.hotelClass,
                                  price:
                                      hotelList[i].offersItems.first.priceList,
                                  hotelId:
                                      hotelList[i].offersItems.first.hotelId,
                                  rate: hotelList[i].offersItems.first.rate,
                                  coName: hotelList[i]
                                      .offersItems
                                      .first
                                      .companyName,
                                  coPhone: hotelList[i]
                                      .offersItems
                                      .first
                                      .companyPhone,
                                  coMail: hotelList[i]
                                      .offersItems
                                      .first
                                      .companyMail,
                                  docId: hotelList[i].offersItems.first.docId,
                                );
                              } else {
                                return Container();
                              }
                            },
                            childCount: hotelList.length,
                          ),
                        )
                      // when no hotels in search
                      : SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      child: Container(
                                        child: Image(
                                          fit: BoxFit.contain,
                                          image: AssetImage(
                                            'assets/image/no_hotel.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Container(
                                        child: Text(
                                          getTranslated(
                                            context,
                                            "Hotels Not Found \n plz try another search",
                                          ),
                                          style: TextStyle(
                                              color: Colors.blueGrey
                                                  .withOpacity(0.4)),
                                          textAlign: TextAlign.center,
                                        ),
                                        margin: EdgeInsets.all(8.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                } else {
                  return SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                      height: 200,
                      child: ListView(
                        children: [
                          Container(
                            height: 40,
                            child: Center(
                              child: LinearProgressIndicator(),
                            ),
                          ),
                          Container(
                              height: 90,
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      getTranslated(context,
                                          "your request is processing"),
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Text(
                                        getTranslated(context,
                                            "* please sure your connected with internet"),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w100,
                                            color: Theme.of(context)
                                                .disabledColor),
                                        textAlign: TextAlign.center),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ]));
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return SliverFillRemaining(child: OfflineError());
              } else {
                return SliverFillRemaining(
                  child: Container(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          child: Center(
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.blue,
                            ),
                          ),
                        ),
                        Container(
                            height: 50,
                            child: Text(
                              getTranslated(context, "check your connection"),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).disabledColor),
                            )),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          // SliverList(
          //   delegate: SliverChildListDelegate([
          //     Container(
          //       color: AppTheme.getTheme().backgroundColor,
          //       padding: const EdgeInsets.all(14.0),
          //       child: Center(
          //         child: Provider.of<ApiCall>(context, listen: true)
          //                     .cityStreamFinish ??
          //                 false
          //             ? Container()
          //             : CircularProgressIndicator(),
          //       ),
          //     ),
          //   ]),
          // ),
        ],
      ),
    );
  }
}

class PageHeader implements SliverPersistentHeaderDelegate {
  PageHeader({
    this.image,
    this.title,
    this.minExtent,
    this.updateInformation,
    @required this.maxExtent,
  });
  final double minExtent;
  final double maxExtent;
  final String image;
  final String title;
  final Function updateInformation;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          image,
          fit: BoxFit.fill,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black54],
              stops: [0.5, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.repeated,
            ),
          ),
        ),
        Positioned(
          left: 10.0,
          right: 10.0,
          bottom: 4.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FilterScreen(),
                          fullscreenDialog: true),
                    ) as Map<String, Object>;
                    updateInformation(
                        result["values"], result['star'], result['rate']);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.filter_list_sharp,
                        color: AppTheme.getTheme().primaryColor,
                        size: 29,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Lalezar',
                  //'fontFamily: ,"Anton",
                  fontSize: 22,
                  //#FF6300
                  color: Color(0xffFF6300),
                  //(0xffff8800)
                  //AppTheme.getTheme().accentColor
                  //Colors.indigo,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double titleOpacity(double shrinkOffset) {
    // simple formula: fade out text as soon as shrinkOffset > 0
    return 1.0 - max(0.0, shrinkOffset) / maxExtent;
    // more complex formula: starts fading out text when shrinkOffset > minExtent
    //return 1.0 - max(0.0, (shrinkOffset - minExtent)) / (maxExtent - minExtent);
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  // TODO: implement showOnScreenConfiguration
  PersistentHeaderShowOnScreenConfiguration get showOnScreenConfiguration =>
      null;

  @override
  // TODO: implement snapConfiguration
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  // TODO: implement stretchConfiguration
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  @override
  // TODO: implement vsync
  TickerProvider get vsync => null;
}
