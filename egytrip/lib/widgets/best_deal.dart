import 'package:flutter/material.dart';
import 'package:egytrip/localization/language_constants.dart';
import 'package:flutter_placeholder_textlines/flutter_placeholder_textlines.dart';
import 'package:provider/provider.dart';

import 'package:egytrip/classes/cach.dart';

import 'appTheme.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'hotelDetailes.dart';

class BestDeals extends StatefulWidget {
  final int index;
  final AnimationController animationController;
  final Animation animation;
  const BestDeals(
      {Key key, this.index, this.animationController, this.animation})
      : super(key: key);
  @override
  _BestDealsState createState() => _BestDealsState();
}

class _BestDealsState extends State<BestDeals> {
  @override
  Widget build(BuildContext context) {
    final bestList = Provider.of<ApiCall>(
      context,
    ).bestDealRes;
    return bestList[widget.index].offersItems.first.imageUrl0 != null
        ? Padding(
            padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
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
                            aspectRatio: 0.8,
                            child: CachedNetworkImage(
                              //fadeInDuration: Duration(milliseconds: 1),
                              imageUrl: bestList[widget.index]
                                  .offersItems
                                  .first
                                  .imageUrl0,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Expanded(
                            //flex: 1,
                            child: Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width >= 360
                                      ? 10
                                      : 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      bestList[widget.index]
                                          .offersItems
                                          .first
                                          .hotelName,
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        //fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      bestList[widget.index]
                                          .offersItems
                                          .first
                                          .companyName,
                                      style: TextStyle(
                                          //fontSize: 14,
                                          color: Colors.grey.withOpacity(0.8)),
                                    ),
                                  ),
                                  // Expanded(
                                  //   child: SizedBox(),
                                  // ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              // rate star
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4),
                                                child: SmoothStarRating(
                                                  allowHalfRating: true,
                                                  starCount: 5,
                                                  rating: double.tryParse(
                                                    bestList[widget.index]
                                                        .offersItems
                                                        .first
                                                        .rate,
                                                  ),
                                                  size: 16,
                                                  color: AppTheme.getTheme()
                                                      .primaryColor,
                                                  borderColor:
                                                      AppTheme.getTheme()
                                                          .primaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        "${(bestList[widget.index].offersItems.first.priceList[1]).toString()} ${getTranslated(context, "EGP")}",
                                                        textAlign:
                                                            TextAlign.left,
                                                        // maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          //fontSize: 22,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        getTranslated(context,
                                                            "per night"),
                                                        style: TextStyle(
                                                            //fontSize: 14,
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.8)),
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
                                  ),
                                  // Expanded(
                                  //   child: Container(
                                  //     height: 25,
                                  //     child: Text(
                                  //       getTranslated(context, "per night"),
                                  //       style: TextStyle(
                                  //           //fontSize: 14,
                                  //           color:
                                  //               Colors.grey.withOpacity(0.8)),
                                  //     ),
                                  //   ),
                                  // ),
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
                            print('start ontab on side best deal');
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration:
                                    Duration(milliseconds: 1000),
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation) {
                                  return HotelDetailes(
                                    key: ValueKey(bestList[widget.index]
                                        .offersItems
                                        .first
                                        .docId),
                                    hotelClass: bestList[widget.index]
                                        .offersItems
                                        .first
                                        .hotelClass,
                                    hotelName: bestList[widget.index]
                                        .offersItems
                                        .first
                                        .hotelName,
                                    hotelRate: bestList[widget.index]
                                        .offersItems
                                        .first
                                        .rate,
                                    imageUrl: bestList[widget.index]
                                        .offersItems
                                        .first
                                        .imageUrl0,
                                    price: bestList[widget.index]
                                        .offersItems
                                        .first
                                        .priceList,
                                    hotelId: bestList[widget.index]
                                        .offersItems
                                        .first
                                        .hotelId,
                                    coPhone: bestList[widget.index]
                                        .offersItems
                                        .first
                                        .companyPhone,
                                    coName: bestList[widget.index]
                                        .offersItems
                                        .first
                                        .companyName,
                                    coMail: bestList[widget.index]
                                        .offersItems
                                        .first
                                        .companyMail,
                                    docId: bestList[widget.index]
                                        .offersItems
                                        .first
                                        .docId,
                                  );
                                },
                                transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    Widget child) {
                                  return Align(
                                    child: FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : PlaceHolder();
  }
}

class PlaceHolder extends StatelessWidget {
  const PlaceHolder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 9,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        width: width * 0.85,
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: EdgeInsets.only(right: 16),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
                child: Center(
                  child: Icon(
                    Icons.photo_size_select_actual,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PlaceholderLines(
                count: 2,
                animate: true,
                lineHeight: 7,
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
