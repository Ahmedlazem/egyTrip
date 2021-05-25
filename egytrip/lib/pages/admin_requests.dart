import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egytrip/widgets/app_drawer.dart';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' as intl;

//creat globlabel scofeled key for context request was deleted
final globalScaffoldKey = GlobalKey<ScaffoldState>();

class AdminRequests extends StatelessWidget {
  static const routeName = 'admin requests';

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      key: globalScaffoldKey,
      appBar: AppBar(
        title: Text('Request'),
      ),
      drawer: AppDrawer(),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('User Request')
              .orderBy(
                'createdAt',
                descending: true,
              )
              .snapshots(),
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatSnapshot.data.docs;

            return ListView.builder(
              //reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) => RequestContainer(
                nightNo: chatDocs[index].data()['nightNo'],
                price: chatDocs[index].data()['price'],
                adultsNo: chatDocs[index].data()['adultsNo'],
                kidsNu: chatDocs[index].data()['kidsNo'],
                userName: chatDocs[index].data()['username'],
                arrivalDate: chatDocs[index].data()['ArrivalDate'],
                cityName: chatDocs[index].data()['city'],
                userPhone: chatDocs[index].data()['userPhone'],
                hotelName: chatDocs[index].data()['hotelName'],
                roomNo: chatDocs[index].data()['roomNo'],
                createTime: chatDocs[index].data()['createdAt'],
                hotelMail: chatDocs[index].data()['hotelMail'],
                hotelPhone: chatDocs[index].data()['hotelPhone'],
                hotelSite: chatDocs[index].data()['hotelSite'],
                key: ValueKey(chatDocs[index].id),
                docId: chatDocs[index].id,
              ),
            );
          }),
    );
  }
}

class RequestContainer extends StatelessWidget {
  final String hotelName;
  final String cityName;
  final int adultsNo;
  final String arrivalDate;
  final int kidsNu;
  final int nightNo;
  final List<dynamic> price;
  final String userName;
  final String userPhone;
  final int roomNo;
  final String hotelPhone;
  final String hotelSite;
  final String hotelMail;
  final Timestamp createTime;
  final String docId;
  final Key key;
  RequestContainer(
      {this.hotelName,
      this.docId,
      this.key,
      this.createTime,
      this.roomNo,
      this.cityName,
      this.adultsNo,
      this.arrivalDate,
      this.kidsNu,
      this.nightNo,
      this.price,
      this.userName,
      this.hotelSite,
      this.hotelMail,
      this.hotelPhone,
      this.userPhone});
  void showSnackbar(String message) {
    var currentScaffold = globalScaffoldKey.currentState;
    currentScaffold
        .hideCurrentSnackBar(); // If there is a snackbar visible, hide it before the new one is shown.
    currentScaffold.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // print(key);
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(22),
              ),
              border:
                  Border.all(width: 2, color: Theme.of(context).buttonColor)),
          width: width,
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              child: Column(
                children: [
                  Center(
                      child: Text(intl.DateFormat('dd/MM/yyyy hh:mm')
                          .format(createTime.toDate()))),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'User Info',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '$userName ',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.phone,
                        color: Theme.of(context).accentColor,
                        size: 22,
                      ),
                      Text(
                        userPhone,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.mapMarked,
                        color: Theme.of(context).accentColor,
                        size: 22,
                      ),
                      Spacer(),
                      Text('$cityName '),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.people,
                        color: Theme.of(context).accentColor,
                        size: 25,
                      ),
                      Text('  $adultsNo adults'),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.person_outline,
                        color: Theme.of(context).accentColor,
                        size: 20,
                      ),
                      Text('$kidsNu child'),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.moneyBill,
                        color: Theme.of(context).accentColor,
                        size: 22,
                      ),
                      Text(' $price  person/night'),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.room_service,
                        color: Theme.of(context).accentColor,
                        size: 25,
                      ),
                      Text('$roomNo  room'),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.date_range,
                        color: Theme.of(context).accentColor,
                        size: 25,
                      ),
                      Flexible(
                        child: Text(
                          intl.DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(arrivalDate),
                          ),
                        ),
                      ),
                      Flexible(child: Text('for $nightNo Nights')),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Hotel Info',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    ),
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.hotel,
                        color: Theme.of(context).accentColor,
                        size: 22,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Flexible(
                        child: Text(
                          ' $hotelName',
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.phoneSquare,
                          color: Theme.of(context).accentColor,
                          size: 22,
                        ),
                        Flexible(
                          child: hotelPhone != null
                              ? Text(
                                  hotelPhone,
                                  textDirection: TextDirection.ltr,
                                )
                              : Text("NA"),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.mail,
                        color: Theme.of(context).accentColor,
                        size: 22,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Flexible(
                        child: hotelMail != null
                            ? Text(' $hotelMail')
                            : Text('NA'),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.internetExplorer,
                        color: Theme.of(context).accentColor,
                        size: 22,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      hotelSite != null
                          ? Flexible(
                              child: Container(child: Text(' $hotelSite')))
                          : Text('NA'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              iconSize: 30,
              onPressed:

                  // ignore: unnecessary_statements
                  () async {
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(
                      'Are you sure...',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                    content:
                        Text('Are you sure you want to remove this item ?'),
                    actions: <Widget>[
                      FlatButton(
                          child: Text('yes'),
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('User Request')
                                  .doc('$docId')
                                  .delete()
                                  .then((response) {
                                Navigator.of(ctx).pop();
                                showSnackbar('Request was deleted');
                              });
                            } catch (e) {
                              // print(e);
                              showSnackbar(
                                  'request can not delete rite now check connection');
                            }
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
        ),
      ],
    );
  }
}
