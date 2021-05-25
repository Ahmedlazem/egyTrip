import 'dart:convert';

import 'package:flutter/material.dart';

class Review {
  String review;
  String avatar;
  String rate;
  String travelDate;
  String title;

  Review({this.rate, this.review, this.avatar, this.travelDate, this.title});
}

ApiHotelRes apiResponseFromJson(String str, String lang) =>
    ApiHotelRes.fromJson(json.decode(str), lang);

ApiHotelRes fetchHotelDisc(String str, String lang) =>
    ApiHotelRes.fromJson(json.decode(str), lang);

class ApiHotelRes with ChangeNotifier {
  ApiHotelRes({
    this.companyPhone,
    this.companyName,
    this.companyMail,
    this.hotelName,
    this.hotelId,
    this.priceList,
    this.hotelDescription,
    this.imageUrl0,
    this.hotelClass,
    this.location,
    this.ranking,
    this.rate,
    this.hotelPhone,
    this.hotelMail,
    this.hotelWebSite,
    this.cityName,
    this.docId,
  });
  String companyName;
  String companyPhone;
  String companyMail;
  String cityName;
  String location;
  String hotelName;
  String hotelId;
  List<dynamic> priceList;
  String hotelDescription;
  String imageUrl0;
  String ranking;
  String hotelClass;
  String rate;
  String hotelPhone;
  String hotelMail;
  String hotelWebSite;
  String docId;

  // ignore: missing_return

  List<ApiHotelRes> _items = [];
  List<ApiHotelRes> _offersItems = [];
  List<String> _images = [];
  List<String> get images {
    return [..._images];
  }

  List<ApiHotelRes> get items {
    return [..._items];
  }

  List<ApiHotelRes> get offersItems {
    return [..._offersItems];
  }

  List<Review> _reviews = [];
  List<Review> get reviews {
    return [..._reviews];
  }

  // ignore: missing_return

  ApiHotelRes.fromJson(Map<String, dynamic> json, String lang) {
    final List<ApiHotelRes> loadedHotels = [];

    try {
      json['data'].forEach((e) {
        if (e["price"] == null || e["price"].isEmpty || e["photo"] == null) {
          return;
        } else {
          loadedHotels.add(
            ApiHotelRes(
              hotelName: e['name'],
              rate: e["rating"],
              location: e["location_string"],
              hotelId: e["location_id"],
              imageUrl0: e["photo"]["images"]["large"]["url"],
              priceList: lang == 'ar_AR'
                  ? e["price"].toString().length <= 12
                      ? e["price"]
                      : e["price"]
                          .toString()
                          .substring(0, 13)
                          .replaceAll('-', '')
                  : e["price"].toString().length <= 7
                      ? e["price"]
                      : e["price"]
                          .toString()
                          .substring(0, 9)
                          .replaceAll('-', ''),
              hotelClass: e['hotel_class'],
            ),
          );
        }
      });
      try {
        notifyListeners();
      } catch (_) {
        _items = loadedHotels;
        notifyListeners();
      }
    } catch (z) {
      print(z);
      throw z;
    }
  }

  // method to get offer price
  List<dynamic> getOfferPrice(
      DateTime userReservationTime, List<dynamic> price) {
    try {
      var offerPriceElement = price.firstWhere(
          (prod) =>
              (DateTime.parse(prod['startOffer']) == userReservationTime ||
                  DateTime.parse(prod['endOffer']) == userReservationTime) ||
              (userReservationTime
                      .isAfter(DateTime.parse(prod['startOffer'])) &&
                  userReservationTime.isBefore(
                    DateTime.parse(prod['endOffer']),
                  )),
          orElse: () => null);

      // print(offerPriceElement['priceOffer']);
      return offerPriceElement['priceOffer'];
      // == null
      // ? null
      // : offerPriceElement['priceOffer'];
    } catch (e) {
      print(e);
      throw e;
    }
  }

  ApiHotelRes.fromJsonOffer(
      {Map<String, dynamic> json,
      List<dynamic> price,
      String coName,
      String coPhone,
      String coMail,
      String city,
      String docID,
      double selectedHotelClassFilter,
      DateTime reservationTime}) {
    try {
      json['data'].forEach((e) {
        _offersItems.add(
          ApiHotelRes(
            hotelName: e['name'],
            rate: e["rating"],
            location: e["location_string"],
            hotelId: e["location_id"],
            imageUrl0: e["photo"]["images"]["large"]["url"],
            priceList: getOfferPrice(reservationTime, price),
            companyMail: coMail,
            companyName: coName,
            companyPhone: coPhone,
            docId: docID,
            cityName: city,
            hotelClass: e['hotel_class'],
          ),
        );
      });

      notifyListeners();
    } catch (z) {
      print(z);
      throw z;
    }
  }

  ApiHotelRes.fetchRestCity(Map<String, dynamic> json, String lang) {
    final List<ApiHotelRes> loadedRest = [];

    try {
      json['data'].forEach((e) {
        if (e["location_id"] == '5773025' ||
            e['name'] == null ||
            e['name'].isEmpty ||
            e["photo"] == null ||
            e["photo"].isEmpty) {
          return;
        }

        loadedRest.add(
          ApiHotelRes(
            hotelName: e['name'],
            location: e["address"],
            hotelId: e["location_id"],
            imageUrl0: e["photo"]["images"]["large"]["url"] == null
                ? 'hiii'
                : e["photo"]["images"]["large"]["url"],
            rate: e["rating"],
            hotelPhone: e["phone"],
            hotelWebSite: e["website"],
            hotelDescription: e["description"],
            ranking: e["ranking"],
          ),
        );
      });
      _items = loadedRest;
      notifyListeners();
    } catch (x) {
      print(x);
      throw x;
    }
  }

  //get hotels photo
  ApiHotelRes.fetchHotelPhoto(Map<String, dynamic> json) {
    json["data"].forEach((element) {
      _images.add(
        element["images"]["large"]["url"],
      );
      notifyListeners();
    });
  }
//get reviews

  ApiHotelRes.fetchHotelReviews(Map<String, dynamic> json) {
    final List<Review> loadedHotels = [];
    json["data"].forEach((element) {
      loadedHotels.add(Review(
        rate: element["rating"] == null ? 'rate' : element["rating"],
        review: element["text"] == null ? "review" : element["text"],
        avatar: element["user"] == null
            ? 'avatar'
            : element["user"]["contributions"]["avatar_thumbnail_url"],
        travelDate:
            element["travel_date"] == null ? 'date' : element["travel_date"],
        title: element["title"] == null ? "title" : element["title"],
      ));

      _reviews = loadedHotels;

      notifyListeners();
    });
  }
  //fetch hotel discraption
  ApiHotelRes.fetchHotelDisc(Map<String, dynamic> json, String lang) {
    hotelDescription = json["data"][0]["description"];
    // location = json["data"][0]["address"];
    // ranking = json["data"][0]["ranking"];
    // hotelName = json["data"][0]["name"];
    //
    // rate = json["data"][0]["rating"];
    // hotelPhone = json["data"][0]["phone"];
    // hotelMail = json["data"][0]["email"];
    //hotelWebSite = json["data"][0]["website"];

    hotelClass = json["data"][0]["hotel_class"];
    notifyListeners();
  }
}
