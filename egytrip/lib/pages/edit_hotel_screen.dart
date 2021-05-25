import 'package:egytrip/providers/hotel_offers.dart';
import 'package:egytrip/widgets/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egytrip/providers/hotels.dart';

import 'add_hotel__screen.dart';

class EditHotelScreen extends StatefulWidget {
  static const routName = 'edit_screen';
  @override
  _EditHotelScreenState createState() => _EditHotelScreenState();
}

class _EditHotelScreenState extends State<EditHotelScreen> {
  String selectedCategories;
  bool isSelectedCat = false;
  DateTime _startDeal;
  DateTime _endDeal;
  DropdownButton<String> getCategoriesDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    var cityListName = (cityList.map((e) => e.cityName)).toList();
    for (String cat in cityListName) {
      var newItem = DropdownMenuItem(
        child: Text(cat),
        value: cat,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      isExpanded: true,
      icon: Icon(
        Icons.format_align_justify,
        size: 20,
        color: Theme.of(context).accentColor,
      ),
      elevation: 5,
      hint: Text(
        updatedPRO.city,
        softWrap: true,
        style: TextStyle(color: Theme.of(context).errorColor),
      ),
      value: selectedCategories,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCategories = value;
          isSelectedCat = true;
        });
      },
    );
  }

  String id;
  HotelOffers updatedPRO;
  final _form1 = GlobalKey<FormState>();

  void saveForm() async {
    final isValid = _form1.currentState.validate();
    if (!isValid) {
      return;
    }

    _form1.currentState.save();
    await Provider.of<Hotels>(context, listen: false)
        .replaceAndUpdateByID(id, updatedPRO);
    Navigator.of(context).pop();
    //  Navigator.of(context).pushReplacementNamed(ProductManageScreen.routeName,arguments:updatedPRO.city);
  }

  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context).settings.arguments as String;
    print('this coming id $id');
    updatedPRO = Provider.of<Hotels>(context, listen: false).findById(id);
    print(updatedPRO.hotelId);
    return Scaffold(
      backgroundColor: AppTheme.getTheme().backgroundColor,
      appBar: AppBar(
        title: Text(
          'Edit Hotel',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => saveForm(),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form1,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  width: double.infinity,
                  child: getCategoriesDropdown(),
                ),
                TextFormField(
                  initialValue: updatedPRO.hotelName,
                  validator: (value) {
                    if (value.isEmpty) {
                      return ('this unexpected value');
                    }
                    if (value == null) {
                      return ('please enter title');
                    }
                    if (value.length < 3) {
                      return 'enter more than 3 character';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'hotel name'),
                  onSaved: (value) {
                    updatedPRO = HotelOffers(
                        city: isSelectedCat
                            ? selectedCategories
                            : updatedPRO.city,
                        id: id,
                        hotelName: value,
                        hotelId: updatedPRO.hotelId,
                        startDeal: _startDeal == null
                            ? updatedPRO.startDeal
                            : _startDeal.toString(),
                        endDeal: _endDeal == null
                            ? updatedPRO.endDeal
                            : _endDeal.toString(),
                        companyPhone: updatedPRO.companyPhone,
                        companyName: updatedPRO.companyName,
                        companyMail: updatedPRO.companyMail,
                        price: updatedPRO.price);
                  },
                ),
                TextFormField(
                  initialValue: updatedPRO.companyName,
                  validator: (value) {
                    if (value.isEmpty) {
                      return ('this unexpected value');
                    }
                    if (value == null) {
                      return ('please enter company Name');
                    }
                    if (value.length < 3) {
                      return 'enter more than 3 character';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Co name'),
                  onSaved: (value) {
                    updatedPRO = HotelOffers(
                        city: isSelectedCat
                            ? selectedCategories
                            : updatedPRO.city,
                        id: id,
                        startDeal: _startDeal == null
                            ? updatedPRO.startDeal
                            : _startDeal.toString(),
                        endDeal: _endDeal == null
                            ? updatedPRO.endDeal
                            : _endDeal.toString(),
                        hotelName: updatedPRO.hotelName,
                        hotelId: updatedPRO.hotelId,
                        companyPhone: updatedPRO.companyPhone,
                        companyName: value,
                        companyMail: updatedPRO.companyMail,
                        price: updatedPRO.price);
                  },
                ),
                TextFormField(
                  initialValue: updatedPRO.companyPhone,
                  validator: (value) {
                    if (value.isEmpty) {
                      return ('this unexpected value');
                    }
                    if (value == null) {
                      return ('please enter company phone ');
                    }
                    if (value.length < 3) {
                      return 'enter more than 3 character';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Co. phone'),
                  onSaved: (value) {
                    updatedPRO = HotelOffers(
                        city: isSelectedCat
                            ? selectedCategories
                            : updatedPRO.city,
                        id: id,
                        startDeal: _startDeal == null
                            ? updatedPRO.startDeal
                            : _startDeal.toString(),
                        endDeal: _endDeal == null
                            ? updatedPRO.endDeal
                            : _endDeal.toString(),
                        hotelName: updatedPRO.hotelName,
                        hotelId: updatedPRO.hotelId,
                        companyPhone: value,
                        companyName: updatedPRO.companyName,
                        companyMail: updatedPRO.companyMail,
                        price: updatedPRO.price);
                  },
                ),
                TextFormField(
                  initialValue: updatedPRO.companyMail,
                  validator: (value) {
                    if (value.isEmpty) {
                      return ('this unexpected value');
                    }
                    if (value == null) {
                      return ('please enter Email');
                    }
                    if (value.length < 5) {
                      return 'enter more than 5 character';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Co Mail'),
                  onSaved: (value) {
                    updatedPRO = HotelOffers(
                        city: isSelectedCat
                            ? selectedCategories
                            : updatedPRO.city,
                        id: id,
                        startDeal: _startDeal == null
                            ? updatedPRO.startDeal
                            : _startDeal.toString(),
                        endDeal: _endDeal == null
                            ? updatedPRO.endDeal
                            : _endDeal.toString(),
                        hotelName: updatedPRO.hotelName,
                        hotelId: updatedPRO.hotelId,
                        companyPhone: updatedPRO.companyPhone,
                        companyName: updatedPRO.companyName,
                        companyMail: value,
                        price: updatedPRO.price);
                  },
                ),
                Container(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Text('Deal Start'), Text('Deal End')],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _startDeal == null
                              ? Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        updatedPRO.startDeal
                                            .toString()
                                            .substring(0, 10),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now()
                                                .add(Duration(days: 600)),
                                          ).then((pickedDate) {
                                            if (pickedDate == null) {
                                              return;
                                            }
                                            setState(() {
                                              _startDeal = pickedDate;
                                            });
                                          });
                                        },
                                        icon: Icon(
                                          Icons.date_range,
                                          color: Theme.of(context).buttonColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Text(
                                    _startDeal.toString().substring(0, 10),
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.w800),
                                  ) ??
                                  Text('add'),
                          _endDeal == null
                              ? Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        updatedPRO.endDeal
                                            .toString()
                                            .substring(0, 10),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now()
                                                .add(Duration(days: 1)),
                                            firstDate: DateTime.now()
                                                .add(Duration(days: 1)),
                                            lastDate: DateTime.now()
                                                .add(Duration(days: 600)),
                                          ).then((pickedDate) {
                                            if (pickedDate == null) {
                                              return;
                                            }
                                            setState(() {
                                              _endDeal = pickedDate;
                                            });
                                          });
                                        },
                                        icon: Icon(
                                          Icons.date_range,
                                          color: Theme.of(context).buttonColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Text(
                                    _endDeal.toString().substring(0, 10),
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.w800),
                                  ) ??
                                  Text('add'),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple, width: 2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        ShowPriceAndEdit(updatedPRO),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 40,
                  child: RaisedButton.icon(
                    color: Theme.of(context).buttonColor,
                    onPressed: () {
                      saveForm();
                    },
                    icon: Icon(Icons.save),
                    label: Text('Submit'),
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

// ignore: must_be_immutable
class ShowPriceAndEdit extends StatefulWidget {
  HotelOffers addNewProduct;
  ShowPriceAndEdit(this.addNewProduct);

  @override
  _ShowPriceAndEditState createState() => _ShowPriceAndEditState();
}

class _ShowPriceAndEditState extends State<ShowPriceAndEdit> {
  // Map<String, Object> priceListItem;

  bool isAdd = false;
//  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    var newPriceList = widget.addNewProduct.price;
    //print(widget.addNewProduct.price);

    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Column(
            children: [
              ...newPriceList.map((e) {
                int index = widget.addNewProduct.price
                    .indexWhere((element) => element == e);
                return Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        child: Container(
                          color: Colors.grey,
                          height: 70,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                          e['startOffer'].substring(0, 10)),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.arrow_forward,
                                        size: 15,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child:
                                          Text(e['endOffer'].substring(0, 10)),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(" S1:${e['priceOffer'][0]}"),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(" D2:${e['priceOffer'][1]}"),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(" T3:${e['priceOffer'][2]}"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        key: ValueKey(widget.addNewProduct.price[index]),
                        onLongPress: () async {
                          await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(
                                'Are you sure...',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.red),
                              ),
                              content: Text(
                                  'Are you sure you want to remove this item ?'),
                              actions: <Widget>[
                                FlatButton(
                                    child: Text('yes'),
                                    onPressed: () {
                                      setState(() {
                                        widget.addNewProduct.price
                                            .removeAt(index);
                                      });
                                      Navigator.of(ctx).pop();
                                    }),
                                FlatButton(
                                  child: Text('No'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              })
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() {
                  isAdd = true;
                });
              },
              child: isAdd
                  ? DataRowForm(widget.addNewProduct)
                  : Container(
                      padding: EdgeInsets.all(5),
                      height: 35,
                      color: Theme.of(context).accentColor,
                      child: Text(
                        'Add another price',
                        style: (AppTheme.getTheme().textTheme.bodyText1),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// rules_version = '2';
// service cloud.firestore {
// match /databases/{database}/documents {
//
// match/users/{uid}{
// allow write :if request.auth !=null
// // &&
// // request.auth.uid==uid;
// }
// match/users/{uid}{
// allow read :if request.auth !=null ;
// }
//
//
// match /{document=**} {
// allow read, create: if request.auth !=null;
// allow delete, create: if request.auth !=null;
// }
// }
// }
