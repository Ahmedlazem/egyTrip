import 'package:egytrip/providers/hotel_offers.dart';
import 'package:egytrip/widgets/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:egytrip/providers/hotels.dart';

String selectedCategories = 'Hurghada';

class AddHotelScreen extends StatefulWidget {
  static const routeName = '/add_product_screen';

  @override
  _AddHotelScreenState createState() => _AddHotelScreenState();
}

class _AddHotelScreenState extends State<AddHotelScreen> {
  DropdownButton<String> getCategoriesDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    var cityListName = (cityList.map((e) => e.cityName)).toList();
    for (String cat in cityListName) {
      var newItem = DropdownMenuItem(
        child: Text(
          cat,
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        value: cat,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      isExpanded: true,
      icon: Icon(
        Icons.format_align_justify,
        size: 20,
        color: Theme.of(context).buttonColor,
      ),
      elevation: 5,
      hint: Text(
        'select city',
        softWrap: true,
        style: TextStyle(color: Theme.of(context).errorColor),
      ),
      value: selectedCategories,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCategories = value;
        });
      },
    );
  }

  DateTime _startDeal;
  DateTime _endDeal;
  bool _isLoading = false;
  // final _priceFocusNode = FocusNode();
  // final _stockFocusNode = FocusNode();
  // final _descriptionFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  var addNewProduct = HotelOffers(
    hotelName: '',
    price: [],
    hotelId: '',
    city: '',
    companyMail: '',
    companyName: '',
    companyPhone: '',
    endDeal: '',
    startDeal: '',
  );

//  @override
  // void dispose() {
  //   // we should dispose focus node when leave the widget to remove data from memory its important.
  //   // _imageFocusNode.removeListener(_updateImage);
  //   _descriptionFocusNode.dispose();
  //   _priceFocusNode.dispose();
  //   _stockFocusNode.dispose();
  //
  //   super.dispose();
  // }

  void saveForm() async {
    final isValid = _form.currentState.validate();
    if (selectedCategories == null) {
      return showDialog<Null>(
        // ignore: deprecated_member_use

        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          backgroundColor: Colors.red,
          content: Text('please select category'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
    if (_endDeal == null) {
      return showDialog<Null>(
        // ignore: deprecated_member_use

        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          backgroundColor: Colors.red,
          content: Text('please select End Deal'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    try {
      await Provider.of<Hotels>(context, listen: false)
          .addProduct(addNewProduct);
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          backgroundColor: Colors.red,
          content: Text(
              'Something went wrong.Check internet Connection and try again'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getTheme().backgroundColor,
      appBar: AppBar(
        title: Text(
          'Add Hotel',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => saveForm(),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    getCategoriesDropdown(),
                    TextFormField(
                      style: TextStyle(color: Theme.of(context).accentColor),
                      validator: (value) {
                        if (value.isEmpty) {
                          return ('this unexpected value');
                        }
                        if (value == null) {
                          return ('please enter Hotel name');
                        }
                        if (value.length < 3) {
                          return 'enter more than 3 character';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Hotel name',
                        // labelStyle: TextStyle(color: Colors.blueAccent),
                      ),
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      //   //to transit the focus pointer automatic to next field by helping focus node
                      // },
                      onSaved: (value) {
                        addNewProduct = HotelOffers(
                            hotelId: addNewProduct.hotelId,
                            city: selectedCategories,
                            companyMail: addNewProduct.companyMail,
                            companyName: addNewProduct.companyName,
                            companyPhone: addNewProduct.companyPhone,
                            hotelName: value,
                            startDeal: _startDeal.toString(),
                            endDeal: _endDeal.toString(),
                            price: addNewProduct.price);
                      },
                    ),
                    TextFormField(
                      //stock data entry
                      style: TextStyle(color: Theme.of(context).accentColor),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please enter your hotel ID ';
                        }
                        if (int.tryParse(value) == null) {
                          return 'please enter your hotel ID ';
                        }
                        if (int.tryParse(value) <= 0) {
                          return 'please enter your hotel ID ';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: 'Hotel ID'),
                      keyboardType: TextInputType.number,
                      // focusNode: _stockFocusNode,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context)
                      //       .requestFocus(_descriptionFocusNode);
                      // },
                      onSaved: (value) {
                        addNewProduct = HotelOffers(
                            hotelId: value,
                            city: selectedCategories,
                            startDeal: _startDeal.toString(),
                            endDeal: _endDeal.toString(),
                            companyMail: addNewProduct.companyMail,
                            companyName: addNewProduct.companyName,
                            companyPhone: addNewProduct.companyPhone,
                            hotelName: addNewProduct.hotelName,
                            price: addNewProduct.price);
                      },
                    ),
                    TextFormField(
                      style: TextStyle(color: Theme.of(context).accentColor),
                      validator: (value) {
                        if (value.isEmpty) {
                          return ('this unexpected value');
                        }
                        if (value == null) {
                          return ('please enter company name');
                        }
                        if (value.length < 3) {
                          return 'enter more than 3 character';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Company name',
                        // labelStyle: TextStyle(color: Colors.blueAccent),
                      ),
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      //   //to transit the focus pointer automatic to next field by helping focus node
                      // },
                      onSaved: (value) {
                        addNewProduct = HotelOffers(
                            hotelId: addNewProduct.hotelId,
                            city: selectedCategories,
                            startDeal: _startDeal.toString(),
                            endDeal: _endDeal.toString(),
                            companyMail: addNewProduct.companyMail,
                            companyName: value,
                            companyPhone: addNewProduct.companyPhone,
                            hotelName: addNewProduct.hotelName,
                            // price: addNewProduct.price,
                            //  description: addNewProduct.description,
                            //  id: null,
                            price: addNewProduct.price);
                      },
                    ),
                    TextFormField(
                      style: TextStyle(color: Theme.of(context).accentColor),
                      validator: (value) {
                        if (value.isEmpty) {
                          return ('this unexpected value');
                        }
                        if (value == null) {
                          return ('please enter company phone');
                        }
                        if (value.length < 10) {
                          return 'enter more than 3 character';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'company phone',
                        // labelStyle: TextStyle(color: Colors.blueAccent),
                      ),
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      //   //to transit the focus pointer automatic to next field by helping focus node
                      // },
                      onSaved: (value) {
                        addNewProduct = HotelOffers(
                            hotelId: addNewProduct.hotelId,
                            city: selectedCategories,
                            startDeal: _startDeal.toString(),
                            endDeal: _endDeal.toString(),
                            hotelName: addNewProduct.hotelName,
                            companyMail: addNewProduct.companyMail,
                            companyName: addNewProduct.companyName,
                            companyPhone: value,
                            // price: addNewProduct.price,
                            //  description: addNewProduct.description,
                            //  id: null,
                            price: addNewProduct.price);
                      },
                    ),
                    TextFormField(
                      style: TextStyle(color: Theme.of(context).accentColor),
                      validator: (value) {
                        if (value.isEmpty) {
                          return ('this unexpected value');
                        }
                        if (value == null) {
                          return ('please enter company Mail');
                        }
                        if (value.length < 3) {
                          return 'enter more than 3 character';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'company Mail',
                        // labelStyle: TextStyle(color: Colors.blueAccent),
                      ),
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      //   //to transit the focus pointer automatic to next field by helping focus node
                      // },
                      onSaved: (value) {
                        addNewProduct = HotelOffers(
                            hotelId: addNewProduct.hotelId,
                            city: selectedCategories,
                            startDeal: _startDeal.toString(),
                            endDeal: _endDeal.toString(),
                            companyMail: value,
                            companyName: addNewProduct.companyName,
                            companyPhone: addNewProduct.companyPhone,
                            hotelName: addNewProduct.hotelName,
                            // price: addNewProduct.price,
                            //  description: addNewProduct.description,
                            //  id: null,
                            price: addNewProduct.price);
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
                                          Text('Start'),
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
                                              color:
                                                  Theme.of(context).buttonColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Text(
                                      _startDeal.toString().substring(0, 10),
                                      style: TextStyle(
                                          color:
                                              AppTheme.getTheme().primaryColor,
                                          fontWeight: FontWeight.w800),
                                    ),
                              _endDeal == null
                                  ? Container(
                                      child: Row(
                                        children: [
                                          Text('End'),
                                          IconButton(
                                            onPressed: () {
                                              showDatePicker(
                                                context: context,
                                                initialDate: _startDeal
                                                    .add(Duration(days: 1)),
                                                firstDate: _startDeal
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
                                              color:
                                                  Theme.of(context).buttonColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Text(
                                      _endDeal.toString().substring(0, 10),
                                      style: TextStyle(
                                          color:
                                              AppTheme.getTheme().primaryColor,
                                          fontWeight: FontWeight.w800),
                                    ),
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
                              height: 5,
                            ),
                            DataRowForm(addNewProduct),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                    )
                  ]),
                ),
              ),
            ),
    );
  }
}

// ignore: must_be_immutable
class DataRowForm extends StatefulWidget {
  HotelOffers addNewProduct;
  DataRowForm(this.addNewProduct);

  @override
  _DataRowFormState createState() => _DataRowFormState();
}

class _DataRowFormState extends State<DataRowForm> {
  Map<String, Object> priceListItem;
  DateTime _startDate;
  DateTime _endDate;
  bool isAdd = false;
  List<String> prices = [];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      //MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _startDate == null
                  ? Container(
                      child: Row(
                        children: [
                          Text('from'),
                          IconButton(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(Duration(days: 600)),
                              ).then((pickedDate) {
                                if (pickedDate == null) {
                                  return;
                                }
                                setState(() {
                                  _startDate = pickedDate;
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
                      _startDate.toString().substring(0, 10),
                      style: TextStyle(
                          color: AppTheme.getTheme().primaryColor,
                          fontWeight: FontWeight.w800),
                    ),
              _endDate == null
                  ? Container(
                      child: Row(
                        children: [
                          Text('To'),
                          IconButton(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: _startDate.add(Duration(days: 1)),
                                firstDate: _startDate.add(Duration(days: 1)),
                                lastDate:
                                    DateTime.now().add(Duration(days: 600)),
                              ).then((pickedDate) {
                                if (pickedDate == null) {
                                  return;
                                }
                                setState(() {
                                  _endDate = pickedDate;
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
                      _endDate.toString().substring(0, 10),
                      style: TextStyle(
                          color: AppTheme.getTheme().primaryColor,
                          fontWeight: FontWeight.w800),
                    ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 60,
            width: width - 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 60,
                  child: TextFormField(
                    style: TextStyle(color: Theme.of(context).errorColor),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please enter your price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'please enter valid price';
                      }
                      if (double.parse(value) <= 0) {
                        return 'please enter Price more than Zer0';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Single'),
                    // onFieldSubmitted: (_) {
                    //   FocusScope.of(context).requestFocus(_priceFocusNode);
                    //   //to transit the focus pointer automatic to next field by helping focus node
                    // },

                    onSaved: (value) {
                      prices.add(value);
                    },
                  ),
                ),
                Container(
                  height: 50,
                  width: 60,
                  child: TextFormField(
                      style: TextStyle(color: Theme.of(context).errorColor),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please enter your price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'please enter valid price';
                        }
                        if (double.parse(value) <= 0) {
                          return 'please enter Price more than Zer0';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'Double'),
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      //   //to transit the focus pointer automatic to next field by helping focus node
                      // },

                      onSaved: (value) {
                        prices.add(value);
                      }),
                ),
                Container(
                  height: 50,
                  width: 60,
                  child: TextFormField(
                    style: TextStyle(color: Theme.of(context).errorColor),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please enter your price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'please enter valid price';
                      }
                      if (double.parse(value) <= 0) {
                        return 'please enter Price more than Zer0';
                      }
                      if (_startDate == null) {
                        return 'please enter start date';
                      }
                      if (_endDate == null) {
                        return 'please enter end date';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Treble'),
                    // onFieldSubmitted: (_) {
                    //   FocusScope.of(context).requestFocus(_priceFocusNode);
                    //   //to transit the focus pointer automatic to next field by helping focus node
                    // },

                    onSaved: (value) {
                      prices.add(value);
                      priceListItem = {
                        'priceOffer': prices,
                        'endOffer': _endDate.toString(),
                        'startOffer': _startDate.toString()
                      };
                      widget.addNewProduct.price.add(priceListItem);
                    },
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 5,
          // ),
          Divider(
            height: 5,
            color: Colors.deepPurple,
            indent: 50,
            endIndent: 50,
            thickness: 1,
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
                  ? DataRowForm(
                      widget.addNewProduct,
                    )
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
