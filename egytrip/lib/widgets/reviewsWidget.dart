import 'package:flutter/material.dart';
import 'appTheme.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewsView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  final String avatar;
  final String title;
  final String date;
  final String rate;
  final String review;
  const ReviewsView({
    Key key,
    this.animationController,
    this.animation,
    this.avatar,
    this.title,
    this.date,
    this.rate,
    this.review,
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
                                child: Image.network(
                                  avatar,
                                  fit: BoxFit.cover,
                                ),
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
                              title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: true,
                              style: new TextStyle(
                                fontWeight: FontWeight.w600,
                                //    fontSize: 14,
                              ),
                            ),
                            Text(
                              date,
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
                                  rating: double.tryParse(rate),
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
                      review,
                      style: new TextStyle(
                        fontWeight: FontWeight.w100,
                        color: AppTheme.getTheme().disabledColor,
                      ),
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
