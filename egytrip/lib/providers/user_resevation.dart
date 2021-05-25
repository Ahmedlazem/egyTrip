import 'package:flutter/material.dart';

import 'city.dart';

class UserReservation with ChangeNotifier {
  final int adultNU;
  final int roomNu;
  final DateTime date;
  final int kidsNu;
  final City city;
  final int nightNu;

  String hotelId;

  UserReservation({
    this.city,
    this.roomNu,
    this.date,
    this.adultNU,
    this.nightNu,
    this.kidsNu,
    this.hotelId,
  });
}
