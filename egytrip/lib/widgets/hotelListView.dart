import 'package:cached_network_image/cached_network_image.dart';
import 'package:egytrip/localization/language_constants.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'hotelDetailes.dart';

class HotelListView extends StatefulWidget {
  const HotelListView({
    Key key,
    this.imageUrl,
    this.hotelName,
    this.hotelClass,
    this.price,
    this.hotelId,
    this.rate,
    this.coName,
    this.coPhone,
    this.coMail,
    this.docId,
  }) : super(key: key);

  final String imageUrl;
  final String hotelName;
  final String hotelClass;
  final List<dynamic> price;
  final String hotelId;
  final String rate;
  final String coName;
  final String coPhone;
  final String coMail;
  final String docId;

  @override
  _HotelListViewState createState() => _HotelListViewState();
}

class _HotelListViewState extends State<HotelListView> {
  int likeNo = 0;
  bool wasLiked = false;
  final user = FirebaseAuth.instance.currentUser;

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
    getLikeNo();
    getLikeStatus();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //print(' hotel name ${widget.hotelName} its photo url ${widget.imageUrl}');
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 6, bottom: 10),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 1000),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return HotelDetailes(
                  key: ValueKey(widget.docId),
                  hotelClass: widget.hotelClass,
                  hotelName: widget.hotelName,
                  hotelRate: widget.rate,
                  imageUrl: widget.imageUrl,
                  price: widget.price,
                  hotelId: widget.hotelId,
                  coPhone: widget.coPhone,
                  coName: widget.coName,
                  coMail: widget.coMail,
                  docId: widget.docId,
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
        child: Container(
          decoration: BoxDecoration(
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
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 2,

                      ///hero for hotel photo
                      child: Hero(
                        tag: widget.docId,
                        child: CachedNetworkImage(
                          //fadeInDuration: Duration(milliseconds: 1),
                          imageUrl: widget.imageUrl != null
                              ? widget.imageUrl
                              : 'assets/image/sea.jpg',
                          imageBuilder: (context, imageProvider) => Container(
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
                    ),
                    Container(
                      color: AppTheme.getTheme().backgroundColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, top: 8, bottom: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      widget.hotelName,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        // fontSize: 22,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: <Widget>[
                                          SmoothStarRating(
                                            allowHalfRating: true,
                                            starCount: 5,
                                            rating: double.tryParse(
                                                widget.hotelClass),
                                            size: 18,
                                            color: AppTheme.getTheme()
                                                .primaryColor,
                                            borderColor: AppTheme.getTheme()
                                                .primaryColor,
                                          ),
                                          Text(
                                            "${widget.rate} ${getTranslated(context, "rating")}",
                                            style: TextStyle(
                                                // fontSize: 14,
                                                color: Colors.grey
                                                    .withOpacity(0.8)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        widget.coName,
                                        softWrap: true,
                                        maxLines: 2,
                                        style: TextStyle(
                                          color:
                                              AppTheme.getTheme().primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16, top: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "${widget.price[1]} ${getTranslated(context, "EGP")}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    // fontSize: 22,
                                  ),
                                ),
                                Text(
                                  getTranslated(context, "/per night"),
                                  style: TextStyle(
                                      // fontSize: 14,
                                      color: Colors.grey.withOpacity(0.8)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Hero(
                    /// hero for like button
                    tag: widget.docId + widget.imageUrl,
                    //widget.docId +
                    child: Material(
                      color: Colors.transparent,
                      child: LikeButton(
                          isLiked: wasLiked,
                          key: ValueKey(widget.docId),
                          size: 25,
                          circleColor: CircleColor(
                              start: Colors.deepOrange, end: Colors.redAccent),
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
                          countBuilder: (int count, bool isLiked, String text) {
                            var color = isLiked
                                ? AppTheme.getTheme().errorColor
                                : Colors.white70;

                            Widget result;
                            if (count == 0) {
                              result = Material(
                                color: Colors.transparent,
                                child: Text(
                                  "0",
                                  style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.w700),
                                ),
                              );
                            } else
                              result = Material(
                                color: Colors.transparent,
                                child: Text(
                                  text,
                                  style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.w700),
                                ),
                              );
                            //  print(isLiked);
                            return result;
                          },
                          onTap: (isLiked) async {
                            /// send your request here
                            // final bool success= await sendRequest();
                            updateLikeNo();
                            // setState(() {
                            //   wasLiked = isLiked;
                            // });

                            /// if failed, you can do nothing
                            // return success? !isLiked:isLiked;

                            return !isLiked;
                          }),
                    ),
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
//me57q4oX3v8CLw3FJqTvhttps://media-cdn.tripadvisor.com/media/photo-s/1c/a3/27/73/taba-hotel-and-nelson.jpg
