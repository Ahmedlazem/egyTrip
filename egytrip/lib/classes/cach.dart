import 'dart:convert';
import 'dart:io';
import 'package:egytrip/localization/language_constants.dart';
import 'package:egytrip/providers/city.dart';

import 'package:egytrip/providers/hotel_offers.dart';
import 'package:egytrip/providers/user_resevation.dart';
import 'package:http/http.dart' as http;
import 'package:egytrip/classes/api_response.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

UserReservation userReservationInfo;
// ignore: non_constant_identifier_names

var hotelOffer = HotelOffers();

const _header = {
  "x-rapidapi-host": "tripadvisor1.p.rapidapi.com",
  "x-rapidapi-key": "5e2d19ee99msh2635fbec2d41672p1c7bc1jsnbdff98e86e1b",
  // "d169fc396emsh301b69847c83bccp105381jsnf887be62f472",
  // "b7f27c6cd9mshabaf0b920a45e41p16406djsn738e91a41b01",
  "content-type": "application/json",
};

class ApiCall with ChangeNotifier {
  //TODO: Step1 - Declare the URL endpoint to hit
  List<ApiHotelRes> allRes = [];
  List<ApiHotelRes> bestDealRes = [];
  String selectedLang;
  String selectedCur;
  Locale _locale;
  String cityName;
  bool cityStreamFinish;

  // ignore: missing_return
  UserReservation setUserInfo(UserReservation user) {
    return userReservationInfo = user;
  }

  UserReservation get getUserInfo {
    return userReservationInfo;
  }

  void streamFinish() {
    cityStreamFinish = true;
    notifyListeners();
  }

//  get offers hotels
  // ignore: missing_return, non_constant_identifier_names
  Future getOffersCityHotels(
      {UserReservation userReservation, double max, double min}
      // ignore: non_constant_identifier_names

      ) async {
    allRes = [];
    cityStreamFinish = false;
    await getLocale().then((locale) {
      _locale = locale;

      selectedLang = _locale.toString();
    });
    if (selectedLang != '') {
      var city = cityList
          .firstWhere((element) => element.long == userReservation.city.long);
      cityName = city.cityName;
    }
    setUserInfo(userReservation);

    ApiHotelRes response;
    ApiHotelRes res;

    await hotelOffer.fetchHotelsCity(cityName);
    // print(hotelOffer.hotelOffersList[1].hotelName);

    //make method to get hotel inside city have same date if not have same date not include insde list
    List<HotelOffers> getCityOffer(
        {UserReservation userReservation, HotelOffers cityHotelOffers}) {
      final hotelOffers = cityHotelOffers.hotelOffersList;

      List<HotelOffers> newList = [];

      for (var i in hotelOffers) {
        if (i.price.any(
              (element) =>
                  (DateTime.parse(element['startOffer'])) ==
                      userReservation.date ||
                  (DateTime.parse(element['endOffer'])) ==
                      userReservation.date ||
                  (userReservation.date
                          .isAfter(DateTime.parse(element['startOffer'])) &&
                      userReservation.date
                          .isBefore(DateTime.parse(element['endOffer']))),
            ) &&
            //condition to make filter
            i.price.any((element) =>
                double.tryParse(element['priceOffer'][1]) >= min &&
                double.tryParse(element['priceOffer'][1]) <= max)) {
          //  print(i.hotelName);
          newList.add(i);
        }
      }
      return newList;
    }

// get offer city method done
    final newList = getCityOffer(
        userReservation: userReservation, cityHotelOffers: hotelOffer);
    for (var i in newList) {
      try {
        // print(i.hotelName);
        String url =
            "https://tripadvisor1.p.rapidapi.com/hotels/list?offset=0&currency=EGP&limit=30&order=asc&lang=$selectedLang&sort=recommended&location_id=${i.hotelId}&adults=1&checkin=${DateTime.now().add(Duration(days: 7)).toString().substring(0, 10)}&rooms=1&nights=2";

        // try to grt data for hotel by id to add to list of hoteles city

        //TODO: Step2 - Declare a file name that has .json extension and get the Cache Directory

        String fileName =
            "${i.hotelId}$selectedLang${DateTime.now().year}${DateTime.now().month}.json";

        var cacheDir = await getTemporaryDirectory();

        //TODO: Step 3 - Check of the Json file exists so that we can decide whether to make an API call or not

        if (await File(cacheDir.path + "/" + fileName).exists()) {
          //TOD0: Reading from the json File
          var jsonData =
              File(cacheDir.path + "/" + fileName).readAsStringSync();

          // get hotel city
          response = ApiHotelRes.fromJsonOffer(
              json: json.decode(jsonData),
              reservationTime: userReservation.date,
              city: i.city,
              price: i.price,
              docID: i.id,
              coMail: i.companyMail,
              coName: i.companyName,
              coPhone: i.companyPhone);
          allRes.add(response);
          notifyListeners();
        }

        //TODO: If the Json file does not exist, then make the API Call

        else {
          var response1 = await http.get(url, headers: _header);

          if (response1.body.length < 200) {
            //print(" this hotel has not enough data${i.hotelName}");
            //continue to jump to another value  in loop this will add to new app update
            continue;
            //return;
          }

          if (response1.statusCode == 200) {
            String body = utf8.decode(response1.bodyBytes);
            var jsonResponse = body;
            // print(i.hotelName);
            res = ApiHotelRes.fromJsonOffer(
                json: json.decode(jsonResponse),
                reservationTime: userReservation.date,
                city: i.city,
                price: i.price,
                coMail: i.companyMail,
                coName: i.companyName,
                docID: i.id,
                coPhone: i.companyPhone);
            // print(res);
            allRes.add(res);

            notifyListeners();
            //TODO: Step 4  - Save the json response in the CacheData.json file in Cache
            var tempDir = await getTemporaryDirectory();
            File file = new File(tempDir.path + "/" + fileName);
            file.writeAsString(jsonResponse, flush: true, mode: FileMode.write);
          } else {
            print('faild');
          }
        }
      } catch (e) {
        print(e);
        throw e;
      }
    }

    return allRes;
  }

  /// make stream to return requested hotels
// i will make two parameter  max and minumm limits for price to pass it to method get offer price and come form offer city
  Stream<List<ApiHotelRes>> requestsView(
      {UserReservation userReservation, double max, double min}) async* {
    getOffersCityHotels(userReservation: userReservation, min: min, max: max);

    yield allRes;
    notifyListeners();
  }

// best deal method
  Future getBestDealHotels(
      {UserReservation userReservation, double max, double min}
      // ignore: non_constant_identifier_names

      ) async {
    //bestDealRes.clear();
    int n = 0;
    if (bestDealRes.isEmpty) {
      print(" count is ${n++}");
      await getLocale().then((locale) {
        _locale = locale;

        selectedLang = _locale.toString();
      });
      if (selectedLang != '') {
        var city = cityList
            .firstWhere((element) => element.long == userReservation.city.long);
        cityName = city.cityName;
      }
      setUserInfo(userReservation);

      ApiHotelRes response;
      ApiHotelRes res;

      await hotelOffer.fetchBestDeal();
      // print(hotelOffer.hotelOffersList[2].hotelName);
      print('fetch best from fieabase end');

      //make method to get hotel inside city have same date if not have same date not include insde list
      List<HotelOffers> getCityOffer(
          {UserReservation userReservation, HotelOffers cityHotelOffers}) {
        final hotelOffers = cityHotelOffers.bestOffersList;

        List<HotelOffers> newList = [];
        // print('best deal length');
        //print(hotelOffers.length);
        for (var i in hotelOffers) {
          // print(i);
          if (i.price.any(
                (element) =>
                    (DateTime.parse(element['startOffer'])) ==
                        userReservation.date ||
                    (DateTime.parse(element['endOffer'])) ==
                        userReservation.date ||
                    (userReservation.date
                            .isAfter(DateTime.parse(element['startOffer'])) &&
                        userReservation.date
                            .isBefore(DateTime.parse(element['endOffer']))),
              ) &&
              //condition to make filter
              i.price.any((element) =>
                  double.tryParse(element['priceOffer'][1]) >= min &&
                  double.tryParse(element['priceOffer'][1]) <= max)) {
            //  print(i.hotelName);
            newList.add(i);
          }
        }
        return newList;
      }

// get offer city method done
      final newList = getCityOffer(
          userReservation: userReservation, cityHotelOffers: hotelOffer);
      for (var i in newList) {
        try {
          // print("hotel name in best deal  cash is ${i.hotelName}");
          String url =
              "https://tripadvisor1.p.rapidapi.com/hotels/list?offset=0&currency=EGP&limit=30&order=asc&lang=$selectedLang&sort=recommended&location_id=${i.hotelId}&adults=1&checkin=${DateTime.now().add(Duration(days: 7)).toString().substring(0, 10)}&rooms=1&nights=2";

          // try to grt data for hotel by id to add to list of hoteles city

          //TODO: Step2 - Declare a file name that has .json extension and get the Cache Directory

          String fileName =
              "${i.hotelId}$selectedLang${DateTime.now().year}${DateTime.now().month}.json";
          // print(fileName);

          var cacheDir = await getTemporaryDirectory();

          //TODO: Step 3 - Check of the Json file exists so that we can decide whether to make an API call or not

          if (await File(cacheDir.path + "/" + fileName).exists()) {
            print('file was exit in cash');
            //TOD0: Reading from the json File
            var jsonData =
                File(cacheDir.path + "/" + fileName).readAsStringSync();

            // get hotel city
            response = ApiHotelRes.fromJsonOffer(
                json: json.decode(jsonData),
                reservationTime: userReservation.date,
                city: i.city,
                price: i.price,
                docID: i.id,
                coMail: i.companyMail,
                coName: i.companyName,
                coPhone: i.companyPhone);

            bestDealRes.add(response);
            notifyListeners();
          }

          //TODO: If the Json file does not exist, then make the API Call

          else {
            var response1 = await http.get(url, headers: _header);

            if (response1.body.length < 200) {
              //print(" this hotel has not enough data${i.hotelName}");
              //continue to jump to another value  in loop this will add to new app update
              continue;
              //return;
            }

            if (response1.statusCode == 200) {
              String body = utf8.decode(response1.bodyBytes);
              var jsonResponse = body;
              print('file was exit from API');
              // print(i.hotelName);
              res = ApiHotelRes.fromJsonOffer(
                  json: json.decode(jsonResponse),
                  reservationTime: userReservation.date,
                  city: i.city,
                  price: i.price,
                  coMail: i.companyMail,
                  coName: i.companyName,
                  docID: i.id,
                  coPhone: i.companyPhone);
              // print(res);
              bestDealRes.add(res);

              notifyListeners();
              //TODO: Step 4  - Save the json response in the CacheData.json file in Cache
              var tempDir = await getTemporaryDirectory();
              File file = new File(tempDir.path + "/" + fileName);
              file.writeAsString(jsonResponse,
                  flush: true, mode: FileMode.write);
            } else {
              print('faild');
            }
          }
        } catch (e) {
          print(e);
          throw e;
        }
      }
      // convert each item to a string by using JSON encoding
      // final jsonList = bestDealRes.map((item) => jsonEncode(item)).toList();
      //
      // // using toSet - toList strategy
      // final uniqueJsonList = jsonList.toSet().toList();
      //
      // // convert each item back to the original form using JSON decoding
      // final result = uniqueJsonList.map((item) => jsonDecode(item)).toList();
      // bestDealRes = result;
      // notifyListeners();
      return bestDealRes;
    } else {
      return;
    }
  }

  // ignore: missing_return
  Future<ApiHotelRes> getUserCityHotels(
      {UserReservation userReservation}) async {
    setUserInfo(userReservation);

    try {
      await getLocale().then((locale) {
        _locale = locale;

        selectedLang = _locale.toString();
      });

      String url;

      url =
          'https://tripadvisor1.p.rapidapi.com/hotels/list-by-latlng?lang=$selectedLang&limit=30&adults=${userReservation.adultNU}&rooms=${userReservation.roomNu}&child_rm_ages=7%252C10&currency=EGP&checkin=${userReservation.date.toString().substring(0, 10)}&subcategory=hotel%252Cbb%252&nights=${userReservation.nightNu}&latitude=${userReservation.city.lat}&longitude=${userReservation.city.long}';

      //TODO: Step2 - Declare a file name that has .json extension and get the Cache Directory

      String fileName =
          "CacheDataHotel12${userReservation.nightNu}${userReservation.adultNU}${userReservation.city.lat}${userReservation.city.long}${userReservation.date.toString().substring(0, 10)}$selectedLang.json";
      var cacheDir = await getTemporaryDirectory();

      //TODO: Step 3 - Check of the Json file exists so that we can decide whether to make an API call or not

      if (await File(cacheDir.path + "/" + fileName).exists()) {
        //print("Loading Hotel from cache");

        //TOD0: Reading from the json File
        var jsonData = File(cacheDir.path + "/" + fileName).readAsStringSync();

        // get hotel city
        ApiHotelRes response =
            ApiHotelRes.fromJson(json.decode(jsonData), selectedLang);

        return response;
      }
      //TODO: If the Json file does not exist, then make the API Call

      else {
        print("Loading Hotel from API");
        var response = await http.get(url, headers: _header);

        if (response.statusCode == 200) {
          String body = utf8.decode(response.bodyBytes);
          var jsonResponse = body;

          ApiHotelRes res =
              ApiHotelRes.fromJson(json.decode(jsonResponse), selectedLang);

          //TODO: Step 4  - Save the json response in the CacheData.json file in Cache
          var tempDir = await getTemporaryDirectory();
          File file = new File(tempDir.path + "/" + fileName);
          file.writeAsString(jsonResponse, flush: true, mode: FileMode.write);

          return res;
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  // ignore: missing_return
  Future<ApiHotelRes> getHotelPhoto({String id}) async {
    try {
      final String url =
          'https://tripadvisor1.p.rapidapi.com/photos/list?lang=en_US&currency=USD&limit=50&location_id=$id';

      //TODO: Step2 - Declare a file name that has .json extension and get the Cache Directory

      String fileName =
          "CacheDataPhotos$id${DateTime.now().year}${DateTime.now().month}.json";
      var cacheDir = await getTemporaryDirectory();

      //TODO: Step 3 - Check of the Json file exists so that we can decide whether to make an API call or not

      if (await File(cacheDir.path + "/" + fileName).exists()) {
        var jsonData = File(cacheDir.path + "/" + fileName).readAsStringSync();
        ApiHotelRes response =
            ApiHotelRes.fetchHotelPhoto(json.decode(jsonData));
        return response;
      }
      //TODO: If the Json file does not exist, then make the API Call

      else {
        var response = await http.get(url, headers: _header);

        if (response.statusCode == 200) {
          var jsonResponse = response.body;

          final ApiHotelRes res =
              ApiHotelRes.fetchHotelPhoto(json.decode(jsonResponse));

          //TODO: Step 4  - Save the json response in the CacheData.json file in Cache
          var tempDir = await getTemporaryDirectory();
          File file = new File(tempDir.path + "/" + fileName);
          file.writeAsString(jsonResponse, flush: true, mode: FileMode.write);

          return res;
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  // ignore: missing_return
  Future<ApiHotelRes> getCityRest({UserReservation userReservation}) async {
    setUserInfo(userReservation);

    await getLocale().then((locale) {
      _locale = locale;

      selectedLang = _locale.toString();
    });
    try {
      final String url =
          "https://tripadvisor1.p.rapidapi.com/restaurants/list-by-latlng?limit=30&currency=EGP&distance=10&lunit=km&lang=$selectedLang&latitude=${userReservation.city.lat}&longitude=${userReservation.city.long}";

      //TODO: Step2 - Declare a file name that has .json extension and get the Cache Directory

      String fileName =
          "CacheDataCityRest${userReservation.city.cityName}$selectedLang${DateTime.now().year}${DateTime.now().month}.json";

      var cacheDir = await getTemporaryDirectory();

      //TODO: Step 3 - Check of the Json file exists so that we can decide whether to make an API call or not

      if (await File(cacheDir.path + "/" + fileName).exists()) {
        //TOD0: Reading from the json File
        var jsonData = File(cacheDir.path + "/" + fileName).readAsStringSync();
        ApiHotelRes response =
            ApiHotelRes.fetchRestCity(json.decode(jsonData), selectedLang);
        return response;
      }
      //TODO: If the Json file does not exist, then make the API Call

      else {
        var response = await http.get(url, headers: _header);

        if (response.statusCode == 200) {
          String body = utf8.decode(response.bodyBytes);
          var jsonResponse = body;

          ApiHotelRes res = ApiHotelRes.fetchRestCity(
              json.decode(jsonResponse), selectedLang);

          //TODO: Step 4  - Save the json response in the CacheData.json file in Cache
          var tempDir = await getTemporaryDirectory();
          File file = new File(tempDir.path + "/" + fileName);
          file.writeAsString(jsonResponse, flush: true, mode: FileMode.write);

          return res;
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  // ignore: missing_return
  Future<ApiHotelRes> getHotelDescraption({String id}) async {
    await getLocale().then((locale) {
      _locale = locale;

      selectedLang = _locale.toString();
    });

    try {
      final String url =
          'https://tripadvisor1.p.rapidapi.com/hotels/get-details?adults=2&nights=2&currency=EGP&lang=$selectedLang&child_rm_ages=7%252C10&checkin=${DateTime.now().add(Duration(days: 7)).toString().substring(0, 10)}&location_id=$id';

      //TODO: Step2 - Declare a file name that has .json extension and get the Cache Directory

      String fileName =
          "CacheDataDescraption$id$selectedLang${DateTime.now().year}${DateTime.now().month}.json";
      var cacheDir = await getTemporaryDirectory();

      //TODO: Step 3 - Check of the Json file exists so that we can decide whether to make an API call or not

      if (await File(cacheDir.path + "/" + fileName).exists()) {
        //TOD0: Reading from the json File
        var jsonData = File(cacheDir.path + "/" + fileName).readAsStringSync();
        ApiHotelRes response =
            ApiHotelRes.fetchHotelDisc(json.decode(jsonData), selectedLang);
        return response;
      }
      //TODO: If the Json file does not exist, then make the API Call

      else {
        var response = await http.get(url, headers: _header);

        if (response.statusCode == 200) {
          String body = utf8.decode(response.bodyBytes);
          var jsonResponse = body;

          final ApiHotelRes res = ApiHotelRes.fetchHotelDisc(
              json.decode(jsonResponse), selectedLang);

          //TODO: Step 4  - Save the json response in the CacheData.json file in Cache
          var tempDir = await getTemporaryDirectory();
          File file = new File(tempDir.path + "/" + fileName);
          file.writeAsString(jsonResponse, flush: true, mode: FileMode.write);

          return res;
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  // ignore: missing_return
  Future<ApiHotelRes> getHotelReview({String id}) async {
    await getLocale().then((locale) {
      _locale = locale;

      selectedLang = _locale.toString();
    });

    try {
      final String url =
          "https://tripadvisor1.p.rapidapi.com/reviews/list?limit=20&currency=EGP&lang=$selectedLang&location_id=$id";

      //TODO: Step2 - Declare a file name that has .json extension and get the Cache Directory

      String fileName =
          "CacheDataReview$id$selectedLang${DateTime.now().year}${DateTime.now().month}.json";
      var cacheDir = await getTemporaryDirectory();

      //TODO: Step 3 - Check of the Json file exists so that we can decide whether to make an API call or not

      if (await File(cacheDir.path + "/" + fileName).exists()) {
        //  print("Loading review from cache");
        //TOD0: Reading from the json File
        var jsonData = File(cacheDir.path + "/" + fileName).readAsStringSync();
        ApiHotelRes response =
            ApiHotelRes.fetchHotelReviews(json.decode(jsonData));
        return response;
      }
      //TODO: If the Json file does not exist, then make the API Call

      else {
        var response = await http.get(url, headers: _header);
        print("Loading review from API");
        if (response.statusCode == 200) {
          String body = utf8.decode(response.bodyBytes);
          var jsonResponse = body;

          final ApiHotelRes res =
              ApiHotelRes.fetchHotelReviews(json.decode(jsonResponse));

          //TODO: Step 4  - Save the json response in the CacheData.json file in Cache
          var tempDir = await getTemporaryDirectory();
          File file = new File(tempDir.path + "/" + fileName);
          file.writeAsString(jsonResponse, flush: true, mode: FileMode.write);

          return res;
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  List<City> cityList = [
    City(cityName: "Sharm El-Shikh", long: 34.311312, lat: 27.859584),
    City(cityName: 'Nabq Bay', long: 34.417317, lat: 28.016034),
    City(cityName: 'Sharm Old Market', long: 34.295808, lat: 27.865542),
    City(cityName: 'Naama Bay', long: 34.326752, lat: 27.914885),
    City(cityName: 'Sharks Bay', long: 34.393251, lat: 27.963000),
    City(cityName: 'Hurghada', long: 33.8116, lat: 27.2579),
    City(cityName: "El-Gona", lat: 27.4025, long: 33.6511),
    City(cityName: "Marsa Alam", lat: 25.0676, long: 34.8790),
    City(cityName: "Porto Ghalib", lat: 25.5354, long: 34.6375),
    City(cityName: "Sahl Hasheesh", lat: 27.0370, long: 33.8523),
    City(cityName: 'Dahab', lat: 28.5091, long: 34.5136),
    City(cityName: "Makadi", lat: 26.9886, long: 33.8996),
    City(cityName: "Soma Bay", lat: 26.8482, long: 33.9900),
    City(cityName: 'Taba', lat: 29.4925, long: 34.8969),
    City(cityName: "Safaga", lat: 26.7500, long: 33.9360),
    City(cityName: "El-Quseer", lat: 26.1014, long: 34.2803),
    City(cityName: "El-Sokhna", lat: 29.6725, long: 32.3370),
    City(cityName: "Cairo", lat: 30.0444, long: 31.2357),
    City(cityName: "Fifth Settlement", lat: 30.0084868, long: 31.4284756),
    City(cityName: "Heliopolis", lat: 30.115469, long: 31.346512),
    City(cityName: "Giza", lat: 30.0131, long: 31.2089),
    City(cityName: "El Maadi", lat: 29.963200, long: 31.317997),
    City(cityName: "Nasser City", lat: 30.069505, long: 31.341665),
    City(cityName: "October city", lat: 29.996013, long: 30.97875),
    City(cityName: "Luxor", lat: 25.6872, long: 32.6396),
    City(cityName: "Aswan", lat: 24.0928, long: 32.8968),
    City(cityName: "Alexandria", lat: 31.2001, long: 29.9187),
    City(cityName: "Siwa", lat: 29.203171, long: 25.519545),
    City(cityName: "Best Deal", lat: 0.0, long: 0.0),
  ];
}
