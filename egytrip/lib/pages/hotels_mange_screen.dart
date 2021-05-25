import 'package:egytrip/providers/hotel_offers.dart';
import 'package:egytrip/widgets/appTheme.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:egytrip/providers/hotels.dart';
import 'package:egytrip/pages/add_hotel__screen.dart';
import 'package:egytrip/widgets/app_drawer.dart';
import 'package:egytrip/widgets/product_item_manage.dart';

class HotelsManageScreen extends StatefulWidget {
  static const routeName = '/product-screen';

  @override
  _HotelsManageScreenState createState() => _HotelsManageScreenState();
}

class _HotelsManageScreenState extends State<HotelsManageScreen> {
  String selectedCity = 'Hurghada';

  DropdownButton<String> getCategoriesDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    var cityListName = (cityList.map((e) => e.cityName)).toList();
    for (String cat in cityListName) {
      var newItem = DropdownMenuItem(
        child: Text(
          cat,
          style: TextStyle(color: AppTheme.getTheme().primaryColor),
        ),
        value: cat,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      isExpanded: true,
      autofocus: true,
      icon: Icon(
        Icons.format_align_justify,
        size: 20,
      ),
      elevation: 5,
      hint: Text(
        ' Select city',
        softWrap: true,
      ),
      value: selectedCity,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCity = value;
        });
      },
    );
  }

  Future<void> _refreshProducts(BuildContext context) async {
    setState(() {
      selectedCity =
          ModalRoute.of(context).settings.arguments as String ?? selectedCity;
    });

    await Provider.of<Hotels>(context, listen: false).fetchHotels(selectedCity);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    // selectedCategories = ModalRoute.of(context).settings.arguments as String ?? 'Hurghada';

    return Scaffold(
      backgroundColor: AppTheme.getTheme().backgroundColor,
      appBar: AppBar(
        title: Text(
          'Hotels',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AddHotelScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
                margin: EdgeInsets.all(5), child: getCategoriesDropdown()),
          ),
          Expanded(
              child: FutureBuilder(
                  future: _refreshProducts(context),
                  // ignore: missing_return
                  builder: (ctx, snapShot) {
                    switch (snapShot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                      case ConnectionState.none:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                        // if (snapShot.hasError) {
                        //   return OfflineError();
                        // }
                        return RefreshIndicator(
                          onRefresh: () => _refreshProducts(context),
                          child: Consumer<Hotels>(
                            builder: (ctx, productsData, _) => Padding(
                              padding: const EdgeInsets.all(0.1),
                              child: ListView.builder(
                                  itemCount: productsData.items.length,
                                  itemBuilder: (ctx, i) => ProductItemManage(
                                        id: productsData.items[i].id,
                                        hotelName:
                                            productsData.items[i].hotelName,
                                        cityName: productsData.items[i].city,
                                        coName:
                                            productsData.items[i].companyName,
                                        start: productsData.items[i].startDeal,
                                        end: productsData.items[i].endDeal,
                                      )),
                            ),
                          ),
                        );
                    }
                  })),
        ],
      ),
    );
  }
}
