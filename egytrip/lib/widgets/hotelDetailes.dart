import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egytrip/classes/api_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
//import 'package:egytrip/widgets/reviewsWidget.dart';
import 'package:egytrip/widgets/appTheme.dart';
import 'package:flutter_placeholder_textlines/placeholder_lines.dart';
import 'package:share/share.dart';
import 'package:egytrip/widgets/reviewsListScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:egytrip/localization/language_constants.dart';
import 'package:egytrip/classes/cach.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:like_button/like_button.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'offline_line.dart';

class HotelDetailes extends StatefulWidget {
  // final HotelListData hotelData;
  final String imageUrl;
  final String hotelName;
  final String hotelClass;
  final String hotelRate;
  final String coPhone;
  final String coName;
  final String coMail;
  final List<dynamic> price;
  final String hotelId;
  final String docId;
  const HotelDetailes(
      {Key key,
      this.imageUrl,
      this.hotelId,
      this.hotelName,
      this.hotelClass,
      this.hotelRate,
      this.price,
      this.coPhone,
      this.coName,
      this.coMail,
      this.docId})
      : super(key: key);
  @override
  _HotelDetailesState createState() => _HotelDetailesState();
}

class _HotelDetailesState extends State<HotelDetailes>
    with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  // bool isFav = false;

  ApiCall _apiCall = new ApiCall();
  bool isReadless = false;
  bool reviewLoad = false;
  bool photoLoad = false;
  bool swiber = false;
  bool discraptionLoad = false;
  String hotelPhone;
  String hotelSite;
  String hotelMail;
  List<Review> hotelReview;
  List<String> hotelPhoto;
  AnimationController animationController;
  var imageHieght = 0.0;
  AnimationController _animationController;
  int likeNo = 0;
  bool wasLiked = false;
  final user = FirebaseAuth.instance.currentUser;

  // get review
  Future<void> getReview() async {
    hotelReview = (await _apiCall.getHotelReview(id: widget.hotelId)).reviews;
    //hotelReview = reviewList.reviews;
    if (this.mounted) {
      setState(() {
        reviewLoad = true;
      });
    }
    //print(' the value of review reload is $reviewLoad');
  }

  Future<void> getHotelDiscraption() async {
    var hotelDis =
        (await _apiCall.getHotelDescraption(id: widget.hotelId)).reviews;
    //hotelReview = reviewList.reviews;
    if (this.mounted) {
      setState(() {
        discraptionLoad = true;
      });
    }
    //print(' the value of review reload is $reviewLoad');
  }

  Future<void> getPhoto() async {
    hotelPhoto = (await _apiCall.getHotelPhoto(id: widget.hotelId)).images;
    //hotelReview = reviewList.reviews;
    if (this.mounted) {
      setState(() {
        photoLoad = true;
      });
    }
    //print(' the value of review reload is $reviewLoad');
  }

  Future<void> updateLikeNo() async {
    if (wasLiked == false) {
      await FirebaseFirestore.instance
          .collection('Hotels Offers')
          .doc(widget.docId)
          .update({
        "likeNo": likeNo + 1,
      }).then((_) {
        setState(() {
          likeNo = likeNo + 1;
        });
      });
      //update like status
      await FirebaseFirestore.instance
          .collection('users Favorite')
          .doc('${user.uid}')
          .collection('${widget.docId}')
          .doc('${widget.docId}')
          .set({"like status": !wasLiked}).then((value) {
        if (this.mounted) {
          setState(() {
            wasLiked = !wasLiked;
          });
        }
      });
    } else {
      await FirebaseFirestore.instance
          .collection('Hotels Offers')
          .doc(widget.docId)
          .update({
        "likeNo": likeNo - 1,
      }).then((_) {
        setState(() {
          likeNo = likeNo - 1;
        });
      });
      //update like status
      await FirebaseFirestore.instance
          .collection('users Favorite')
          .doc('${user.uid}')
          .collection('${widget.docId}')
          .doc('${widget.docId}')
          .set({"like status": !wasLiked}).then((value) {
        if (this.mounted) {
          setState(() {
            wasLiked = !wasLiked;
          });
        }
      });
    }
  }

  Future<void> getLikeStatus() async {
    //wasLiked=!wasLiked;

    // read like status
    try {
      await FirebaseFirestore.instance
          .collection('users Favorite')
          .doc('${user.uid}')
          .collection('${widget.docId}')
          .doc('${widget.docId}')
          .get()
          .then((value) {
        if (value.data() == null) {
          if (this.mounted) {
            setState(() {
              wasLiked = false;
            });
          }
        } else {
          if (this.mounted) {
            setState(() {
              wasLiked = value.data()["like status"] == null
                  ? false
                  : value.data()["like status"];
            });
          }
        }
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> getLikeNo() async {
    try {
      await FirebaseFirestore.instance
          .collection('Hotels Offers')
          .doc(widget.docId)
          .get()
          .then((value) {
        if (this.mounted) {
          setState(() {
            likeNo =
                value.data()["likeNo"] == null ? 0 : value.data()["likeNo"];
          });
        }
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    getReview();
    getLikeNo();
    getLikeStatus();
    getPhoto();
    getHotelDiscraption();

    super.didChangeDependencies();
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    animationController.forward();
    scrollController.addListener(() {
      if (context != null) {
        if (scrollController.offset < 0) {
          // we static set the just below half scrolling values
          _animationController.animateTo(0.0);
        } else if (scrollController.offset > 0.0 &&
            scrollController.offset < imageHieght) {
          // we need around half scrolling values
          if (scrollController.offset < ((imageHieght / 1.2))) {
            _animationController
                .animateTo((scrollController.offset / imageHieght));
          } else {
            // we static set the just above half scrolling values "around == 0.22"
            _animationController.animateTo((imageHieght / 1.2) / imageHieght);
          }
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    imageHieght = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.getTheme().backgroundColor,
      body: Stack(
        children: <Widget>[
          Container(
            color: AppTheme.getTheme().backgroundColor,
            child: ListView(
              controller: scrollController,
              //physics:  Slive,
              padding: EdgeInsets.only(top: 24 + imageHieght),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: getHotelDetails(isInList: true),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Divider(
                    height: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          getTranslated(
                            context,
                            "Summary",
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 24, right: 24, top: 4, bottom: 8),
                  child: Container(
                    child: discraptionLoad
                        ? FutureBuilder<ApiHotelRes>(
                            future: _apiCall.getHotelDescraption(
                                id: widget.hotelId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return snapshot.data.hotelDescription.length >
                                        100
                                    ? RichText(
                                        textScaleFactor: 1.8,
                                        textAlign: TextAlign.justify,
                                        text: TextSpan(
                                          children: [
                                            snapshot.data.hotelDescription
                                                        .length >
                                                    100
                                                ? TextSpan(
                                                    text: !isReadless
                                                        ? snapshot.data
                                                            .hotelDescription
                                                            .substring(0, 100)
                                                        : snapshot.data
                                                            .hotelDescription,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppTheme.getTheme()
                                                          .disabledColor,
                                                    ),
                                                    recognizer:
                                                        new TapGestureRecognizer()
                                                          ..onTap = () {},
                                                  )
                                                : Text(
                                                    getTranslated(context,
                                                        "Sorry there isn\\'t available Summery we will try to get latter"),
                                                  ),
                                            TextSpan(
                                              text: !isReadless
                                                  ? getTranslated(
                                                      context, "Read more")
                                                  : getTranslated(
                                                      context,
                                                      " less",
                                                    ),
                                              style: TextStyle(
                                                //fontSize: 14,
                                                color: AppTheme.getTheme()
                                                    .primaryColor,
                                              ),
                                              recognizer:
                                                  new TapGestureRecognizer()
                                                    ..onTap = () {
                                                      setState(() {
                                                        isReadless =
                                                            !isReadless;
                                                      });
                                                    },
                                            ),
                                          ],
                                        ),
                                      )
                                    : Text(
                                        getTranslated(context,
                                            "Sorry there isn\\'t available Summery we will try to get latter"),
                                      );
                              } else if (snapshot.hasError) {
                                return OfflineError();
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: PlaceholderLines(
                                count: 3,
                                align: TextAlign.center,
                                lineHeight: 8,
                                color: Colors.grey.shade300,
                                animate: true,
                              ),
                            ),
                          ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          getTranslated(context, "Photos"),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    // fontSize: 14,
                                    color: AppTheme.getTheme().primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 38,
                                  width: 26,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                /// here we can put photos
                photoLoad
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: FutureBuilder<ApiHotelRes>(
                          future: _apiCall.getHotelPhoto(id: widget.hotelId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return FullScreenWidget(
                                disposeLevel: DisposeLevel.Medium,
                                backgroundColor:
                                    AppTheme.getTheme().backgroundColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Swiper(
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return new ImageContainer(
                                          snapshot.data.images[index]);
                                    },

                                    // indicatorLayout:PageIndicatorLayout ,
                                    // autoplay: true,
                                    itemCount: snapshot.data.images.length,
                                    pagination: new FractionPaginationBuilder(
                                      fontSize: 20,
                                      activeFontSize: 25,
                                    ),
                                    control: new SwiperControl(),
                                  ),
                                ),
                              );
                              //       : ListView.builder(
                              //           padding: EdgeInsets.only(
                              //               right: 4,
                              //               left: 4,
                              //               top: 4,
                              //               bottom: 2),
                              //           scrollDirection: Axis.horizontal,
                              //           itemCount: snapshot.data.images.length,
                              //           itemBuilder: ((ctx, i) =>
                              //               ImageContainer(
                              //                   snapshot.data.images[i])),
                              //         ),
                              // );
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: PlaceholderLines(
                                  count: 4,
                                  align: TextAlign.center,
                                  lineHeight: 8,
                                  color: Colors.grey.shade300,
                                  animate: true,
                                ),
                              ));
                            } else {
                              return Center(child: Text(''));
                            }
                          },
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: ImagePlaceHolder(),
                      ),

                /// put review here ///
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 20, top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    getTranslated(context, "Reviews"),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      //fontSize: 14,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  reviewLoad == false
                                      ? Text("...")
                                      : Text(
                                          hotelReview.length.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            //fontSize: 14,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        '',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          // fontSize: 14,
                                          color:
                                              AppTheme.getTheme().primaryColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 38,
                                        width: 26,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      reviewLoad
                          ? Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReviewsListScreen(
                                              reviewsList: hotelReview,
                                            ),
                                        fullscreenDialog: true),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        getTranslated(context, "Read more"),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          // fontSize: 14,
                                          color:
                                              AppTheme.getTheme().primaryColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 38,
                                        width: 26,
                                        child: Icon(
                                          Icons.arrow_forward,
                                          size: 14,
                                          color:
                                              AppTheme.getTheme().primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Text(''),
                    ],
                  ),
                ),
                reviewLoad == false
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: PlaceholderLines(
                            count: 4,
                            align: TextAlign.center,
                            lineHeight: 8,
                            color: Colors.grey.shade300,
                            animate: true,
                          ),
                        ),
                      )
                    : ReviewsView(
                        reviews: hotelReview[0],
                        animation: animationController,
                        animationController: animationController,
                      ),
                reviewLoad == false
                    ? Text('')
                    : ReviewsView(
                        reviews: hotelReview[1],
                        animation: animationController,
                        animationController: animationController,
                      ),

                SizedBox(
                  height: 16,
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 16, top: 16),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.getTheme().primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppTheme.getTheme().dividerColor,
                          blurRadius: 8,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),

                    /// below book now
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          FlutterPhoneDirectCaller.callNumber(widget.coPhone);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => BookingScreen(
                          //       animationController: animationController,
                          //       imageUrl: widget.imageUrl,
                          //       price: widget.price,
                          //       hotelMail: hotelMail,
                          //       hotelPhone: hotelPhone,
                          //       hotelSite: hotelSite,
                          //       hotelId: widget.hotelId,
                          //       hotelName: widget.hotelName,
                          //       hotelClass: widget.hotelClass,
                          //     ),
                          //   ),
                          // );
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Icon(
                                    FontAwesomeIcons.phoneAlt,
                                    color: AppTheme.getTheme().cardColor,
                                    size: 25,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    getTranslated(context, "Call Us"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
          _backgraoundImageUI(widget.imageUrl),
        ],
      ),
    );
  }

  Widget _backgraoundImageUI(String imageUrl) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget child) {
          var opecity = 1.0 -
              (_animationController.value >= ((imageHieght / 1.2) / imageHieght)
                  ? 1.0
                  : _animationController.value);
          return SizedBox(
            height: imageHieght * (1.0 - _animationController.value),
            child: Stack(
              children: <Widget>[
                IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      //AppTheme.getTheme().primaryColor,
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
                            child: Hero(
                              /// hero for hotel image
                              tag: widget.docId,
                              child: CachedNetworkImage(
                                imageUrl: imageUrl != null
                                    ? imageUrl
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
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    right: 0,
                    top: 30,
                    child: Container(
                      width: 90,
                      child: IconButton(
                        icon: Icon(Icons.share_rounded,
                            color: AppTheme.getTheme().errorColor),
                        onPressed: () async {
                          await Share.share(
                            " ${widget.hotelName}  \n  ${widget.price[0]} EGP for single \n  ${widget.price[1]} EGP for double \n  ${widget.price[2]} EGP for triple \n  *please download فندق كوم*  \n http://onelink.to/qf7d4y  \n for more details ",
                            subject: widget.hotelName,
                          );
                        },
                      ),
                    )),
                Positioned(
                  left: 0,
                  top: 40,
                  child: Material(
                    color: Colors.transparent,

                    ///hero for like button
                    child: Hero(
                      tag: widget.docId + widget.imageUrl,
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 100,
                          child: LikeButton(
                              isLiked: wasLiked,
                              //key: ValueKey(widget.docId),
                              size: 25,
                              circleColor: CircleColor(
                                  start: Colors.deepOrange,
                                  end: Colors.redAccent),
                              bubblesColor: BubblesColor(
                                dotPrimaryColor: Colors.deepOrange,
                                dotSecondaryColor: Colors.redAccent,
                              ),
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  Icons.favorite,
                                  color: isLiked
                                      ? AppTheme.getTheme().errorColor
                                      : Colors.white70,
                                  size: 25,
                                );
                              },
                              likeCount: likeNo,
                              countBuilder:
                                  (int count, bool isLiked, String text) {
                                var color = isLiked
                                    ? AppTheme.getTheme().errorColor
                                    : Colors.white70;

                                Widget result;

                                if (count == 0) {
                                  result = Text(
                                    "0",
                                    style: TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.w700),
                                  );
                                } else
                                  result = Text(
                                    text,
                                    style: TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.w700),
                                  );
                                //  print(isLiked);
                                return result;
                              },
                              onTap: (isLiked) async {
                                /// send your request here
                                // final bool success= await sendRequest();
                                updateLikeNo();

                                /// if failed, you can do nothing
                                // return success? !isLiked:isLiked;

                                return !isLiked;
                              }),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: opecity,
                    child: Column(
                      children: <Widget>[
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
                                          left: 10, right: 10, top: 8),
                                      child: getHotelDetails(),
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
                                            onTap: () {
                                              Navigator.pop(context);
                                              FlutterOpenWhatsapp
                                                  .sendSingleMessage(
                                                      "+2${widget.coPhone}",
                                                      "${widget.hotelName}");
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) =>
                                              //         BookingScreen(
                                              //       animationController:
                                              //           animationController,
                                              //       imageUrl: widget.imageUrl,
                                              //       price: widget.price,
                                              //       hotelMail: hotelMail,
                                              //       hotelPhone: hotelPhone,
                                              //       hotelSite: hotelSite,
                                              //       hotelId: widget.hotelId,
                                              //       hotelName: widget.hotelName,
                                              //       hotelClass:
                                              //           widget.hotelClass,
                                              //     ),
                                              //     // fullscreenDialog: true,
                                              //   ),
                                              // );
                                            },

                                            /// up on image
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Icon(
                                                      FontAwesomeIcons.whatsapp,
                                                      color: AppTheme.getTheme()
                                                          .cardColor,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      getTranslated(context,
                                                          "WhatsApp with Us"),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
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
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            child: new BackdropFilter(
                              filter: new ImageFilter.blur(
                                  sigmaX: 10.0, sigmaY: 10.0),
                              child: Container(
                                color: Colors.black12,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    highlightColor: Colors.transparent,
                                    splashColor: AppTheme.getTheme()
                                        .primaryColor
                                        .withOpacity(0.2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(38)),
                                    onTap: () {
                                      try {
                                        scrollController.animateTo(
                                            MediaQuery.of(context).size.height -
                                                MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    5,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.fastOutSlowIn);
                                      } catch (e) {}
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 4,
                                          bottom: 4),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            getTranslated(
                                                context, "More Details"),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2),
                                            child: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getHotelDetails({bool isInList = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.hotelName,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  //fontSize: 22,
                  color: isInList
                      ? AppTheme.getTheme().textTheme.bodyText1.color
                      : Colors.white,
                ),
              ),
              //show up
              isInList
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  getTranslated(context, "Single"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.getTheme().disabledColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  getTranslated(context, "Double"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.getTheme().disabledColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  getTranslated(context, "Treble"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.getTheme().disabledColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "${(widget.price[0]).toString()} ${getTranslated(context, "EGP")}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.getTheme().disabledColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "${(widget.price[1]).toString()} ${getTranslated(context, "EGP")}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.getTheme().disabledColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "${(widget.price[2]).toString()} ${getTranslated(context, "EGP")}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.getTheme().disabledColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                getTranslated(context, "per night"),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.getTheme().disabledColor,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  getTranslated(context, "Offer By"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.getTheme().disabledColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  widget.coName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.getTheme().disabledColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  getTranslated(context, "phone"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.getTheme().disabledColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  widget.coPhone,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.getTheme().disabledColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  getTranslated(context, "E-Mail"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.getTheme().disabledColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  widget.coMail,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.getTheme().disabledColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
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
                          Text(
                            " ${widget.hotelRate} ${getTranslated(context, "Rate")}",
                            style: TextStyle(
                              //fontSize: 14,
                              color: isInList
                                  ? AppTheme.getTheme().disabledColor
                                  : Colors.white,
                            ),
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
            !isInList
                ? Text(
                    "${(widget.price[1]).toString()} ${getTranslated(context, "EGP")}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      // fontSize: 22,
                      color: isInList
                          ? AppTheme.getTheme().textTheme.bodyText1.color
                          : Colors.white,
                    ),
                  )

                ///show down
                : Text(''),
            SizedBox(
              height: 10,
              // width: 10,
            ),
            !isInList
                ? Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      getTranslated(context, "per night"),
                      style: TextStyle(
                        //fontSize: 14,
                        color: isInList
                            ? AppTheme.getTheme().disabledColor.withOpacity(0.5)
                            : Colors.white,
                      ),
                    ),
                  )
                : Text(''),
          ],
        ),
      ],
    );
  }
}

class ImageContainer extends StatelessWidget {
  final String imageUrl;
  ImageContainer(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        child: Container(
            margin: EdgeInsets.only(left: 4, right: 4),
            // width: width * 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            )),
      ),
    );
  }
}

class ImagePlaceHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            margin: EdgeInsets.only(left: 8, right: 8),
            // width: width - 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.getTheme().primaryColor.withOpacity(0.15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.navigate_before_outlined,
                      color: Colors.grey.shade300,
                      size: 30,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(16),
                        //width: 100,
                        //height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.photo_size_select_actual,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.navigate_next_outlined,
                      color: Colors.grey.shade300,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
