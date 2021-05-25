import 'package:egytrip/localization/language_constants.dart';
import 'package:flutter/material.dart';

import 'RangeSliderView.dart';
import 'appTheme.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  RangeValues _values = RangeValues(500, 5000);
  RangeValues _star = RangeValues(0, 5);
  RangeValues _rate = RangeValues(0, 5);

  var rating = 5.0;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      color: AppTheme.getTheme().backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: appBar(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        children: <Widget>[
                          priceBarFilter(),
                          Divider(
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16 + MediaQuery.of(context).padding.bottom,
                      top: 8),
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
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context, {
                            "values": _values,
                            "star": _star,
                            "rate": _rate,
                          });
                        },
                        child: Center(
                          child: Text(
                            getTranslated(context, "Apply"),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget priceBarFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            getTranslated(context, "Price (for 1 night)"),
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        RangeSliderView(
          label: "💰",
          //"💴",
          //"EGP",
          division: 1000,
          max: 5000,
          min: 500,
          values: _values,
          onChnageRangeValues: (values) {
            _values = values != null ? values : RangeValues(500, 5000);
          },
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            getTranslated(context, "Hotel Star"),
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        // star slider
        RangeSliderView(
          label: "⭐",
          //"⭐" "⭐️" "🌠" '❤️🧡💛💚💙💜",
          division: 1,
          max: 5,
          min: 0,
          values: _star,
          onChnageRangeValues: (values) {
            _star = values != null ? values : RangeValues(0.0, 5.0);
          },
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            getTranslated(context, "Hotel Rate"),
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        RangeSliderView(
          label: "💛",
          //"⭐" "⭐️" "🌠" '❤️🧡💛💚💙💜",
          division: 1,
          max: 5,
          min: 0,
          values: _rate,
          onChnageRangeValues: (values) {
            _rate = values != null ? values : RangeValues(0.0, 5.0);
          },
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget appBar() {
    return Row(
      children: <Widget>[
        Column(
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
              padding: const EdgeInsets.only(
                  top: 4, left: 24, bottom: 16, right: 24),
              child: Text(
                getTranslated(context, "Filters"),
                style: new TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
