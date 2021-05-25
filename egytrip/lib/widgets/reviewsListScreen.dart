import 'package:flutter/material.dart';
import 'package:egytrip/classes/api_response.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:egytrip/widgets/appTheme.dart';
import 'package:egytrip/localization/language_constants.dart';

class ReviewsListScreen extends StatefulWidget {
  final List<Review> reviewsList;

  const ReviewsListScreen({Key key, this.reviewsList}) : super(key: key);
  @override
  _ReviewsListScreenState createState() => _ReviewsListScreenState();
}

class _ReviewsListScreenState extends State<ReviewsListScreen>
    with TickerProviderStateMixin {
  // List<HotelListData> reviewsList = HotelListData.reviews;
  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getTheme().backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Container(child: appBar()),
          ),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                  top: 8, bottom: MediaQuery.of(context).padding.bottom + 8),
              itemCount: widget.reviewsList.length,
              itemBuilder: (context, index) {
                var count = widget.reviewsList.length > 10
                    ? 10
                    : widget.reviewsList.length;
                var animation = Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: animationController,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn)));
                animationController.forward();
                return ReviewsView(
                  callback: () {},
                  reviews: widget.reviewsList[index],
                  animation: animation,
                  animationController: animationController,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget appBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: AppBar().preferredSize.height,
          child: Padding(
            padding: EdgeInsets.only(top: 8, left: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
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
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 4, left: 24, bottom: 10, right: 24),
          child: Row(
            children: [
              Text(
                getTranslated(context, "Reviews"),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  //fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                widget.reviewsList.length.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  //fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReviewsView extends StatelessWidget {
  final VoidCallback callback;
  final Review reviews;
  final AnimationController animationController;
  final Animation animation;

  const ReviewsView({
    Key key,
    this.reviews,
    this.animationController,
    this.animation,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 40 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            // width: 48,

                            decoration: BoxDecoration(
                              color: AppTheme.getTheme().primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: AppTheme.getTheme().dividerColor,
                                  blurRadius: 8,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: reviews.avatar != null
                                    ? Image.network(
                                        reviews.avatar,
                                        fit: BoxFit.cover,
                                      )
                                    : Center(
                                        child: Icon(Icons.panorama_rounded,
                                            color: Colors.white, size: 30)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              reviews.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: true,
                              style: new TextStyle(
                                fontWeight: FontWeight.w600,
                                //    fontSize: 14,
                              ),
                            ),
                            Text(
                              reviews.travelDate,
                              style: new TextStyle(
                                fontWeight: FontWeight.w100,
                                color: AppTheme.getTheme().disabledColor,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                // Text(
                                //   rate,
                                //   style: new TextStyle(
                                //     fontWeight: FontWeight.w100,
                                //   ),
                                // ),
                                SmoothStarRating(
                                  allowHalfRating: true,
                                  starCount: 5,
                                  rating: double.tryParse(reviews.rate),
                                  size: 16,
                                  color: AppTheme.getTheme().primaryColor,
                                  borderColor: AppTheme.getTheme().primaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      reviews.review,
                      style: new TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.getTheme().disabledColor,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Divider(
                    height: 1,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
