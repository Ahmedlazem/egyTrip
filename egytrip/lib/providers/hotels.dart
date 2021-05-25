import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'hotel_offers.dart';

class Hotels with ChangeNotifier {

  String selectedCat;
  Hotels();
  List<HotelOffers> _items = [];
  // hotelOffersList;
  List<HotelOffers> get items {
    return [..._items];
  }

  HotelOffers findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(HotelOffers product) async {
    try {
      await FirebaseFirestore.instance.collection('Hotels Offers').add({
        "hotel name": product.hotelName,
        "hotel Id": product.hotelId,
        'city': product.city,
        'price': product.price,
        "company name": product.companyName,
        "company mail": product.companyMail,
        "company phone": product.companyPhone,
        "start Deal": product.startDeal,
        "end Deal": product.endDeal,
      }).then((response) {
        var newProduct = HotelOffers(
            city: product.city,
            hotelName: product.hotelName,
            price: product.price,
            hotelId: product.hotelId,
            id: response.id,
            companyPhone: product.companyName,
            companyName: product.companyName,
            startDeal: product.startDeal,
            endDeal: product.endDeal,
            companyMail: product.companyMail);

        _items.add(newProduct);
        notifyListeners();
      });
    } catch (onError) {
      // by catch error method and print it this will  prevent our from crashing if found error in above future method
      print(onError);
      throw onError;
    }
  }

  Future<void> fetchHotels(String selectedCity) async {
    try {
      final List<HotelOffers> loadedProducts = [];

      await FirebaseFirestore.instance
          .collection('Hotels Offers')
          .where('city', isEqualTo: selectedCity)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          loadedProducts.add(HotelOffers(
            id: result.id,
            city: result.data()['city'],
            hotelId: result.data()["hotel Id"],
            price: result.data()['price'],
            hotelName: result.data()["hotel name"],
            companyMail: result.data()["company mail"],
            companyName: result.data()["company name"],
            companyPhone: result.data()["company phone"],
            startDeal: result.data()["start Deal"],
            endDeal: result.data()["end Deal"],
          ));
        });

        _items = loadedProducts;
        notifyListeners();
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> replaceAndUpdateByID(
      String id, HotelOffers updatedProduct) async {
    //print(' this is is documet id $id');
    try {
      await FirebaseFirestore.instance
          .collection('Hotels Offers')
          .doc(id)
          .update({
        "hotel name": updatedProduct.hotelName,
        "hotel Id": updatedProduct.hotelId,
        'city': updatedProduct.city,
        'price': updatedProduct.price,
        "company mail": updatedProduct.companyMail,
        "company name": updatedProduct.companyName,
        "company phone": updatedProduct.companyPhone,
        "end Deal": updatedProduct.endDeal,
        "start Deal": updatedProduct.startDeal,
      });
    } catch (e) {
      print(e);
      throw (e);
    }
    final index = _items.indexWhere((pro) => pro.id == id);
    _items[index] = updatedProduct;
    notifyListeners();
  }

  Future<void> removeById(String id) async {
    print(id);
    var existProductIndex = _items.indexWhere((pro) => pro.id == id);
    HotelOffers deleteItem = _items[existProductIndex];
    print(id);
    try {
      _items.removeWhere((pro) => pro.id == id);
      await FirebaseFirestore.instance
          .collection('Hotels Offers')
          .doc(id)
          .delete();

      notifyListeners();
    } catch (_) {
      _items.insert(existProductIndex, deleteItem);
      notifyListeners();
    }
  }
}
