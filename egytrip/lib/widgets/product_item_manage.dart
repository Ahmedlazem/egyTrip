import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:egytrip/pages/edit_hotel_screen.dart';
import 'package:provider/provider.dart';
import 'package:egytrip/providers/hotels.dart';

class ProductItemManage extends StatelessWidget {
  final String id;

  final String hotelName;

  final String cityName;
  final String coName;
  final String start;
  final String end;

  ProductItemManage({
    this.id,
    this.hotelName,
    this.cityName,
    this.coName,
    this.start,
    this.end,
  });
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(22), topLeft: Radius.circular(22)),
      child: Card(
        elevation: 5,
        color: Colors.lightGreenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    // fit: FlexFit.tight,
                    flex: 4,
                    child: Container(
                      height: height / 7,
                      width: width * 0.22,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        //  crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  // constraints: BoxConstraints.tightFor(
                                  //     width: width / 2.6, height: 45),
                                  child: Text(
                                    hotelName,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.visible,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  // constraints: BoxConstraints.tightFor(
                                  //     width: width / 2.6, height: 45),
                                  child: Text(
                                    coName,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.visible,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    //fit: FlexFit.tight,
                    flex: 1,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.green,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  EditHotelScreen.routName,
                                  arguments: id);
                            },
                          ),
                          IconButton(
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).errorColor,
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(
                                      'Are you sure...',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.red),
                                    ),
                                    content: Text(
                                        'Are you sure you want to remove this item ?'),
                                    actions: <Widget>[
                                      FlatButton(
                                          child: Text('yes'),
                                          onPressed: () async {
                                            try {
                                              await Provider.of<Hotels>(context,
                                                      listen: false)
                                                  .removeById(id)
                                                  .then((response) {
                                                Navigator.of(ctx).pop();
                                                Scaffold.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    duration:
                                                        Duration(seconds: 1),
                                                    content: Text(
                                                      'Item was deleted',
                                                    ),
                                                  ),
                                                );
                                              });
                                            } catch (e) {
                                              Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'delete was field please check your connection'),
                                                ),
                                              );
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
                        ]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Start',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'End',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          start.substring(0, 10),
                          style: TextStyle(
                              color: Theme.of(context).errorColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          end.substring(0, 10),
                          style: TextStyle(
                              color: Theme.of(context).errorColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class ImageContainer extends StatelessWidget {
//   final String imageUrl;
//   ImageContainer(this.imageUrl);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: FadeInImage(
//         placeholder: AssetImage('assets/image/feedImage.png'),
//         image: NetworkImage(imageUrl),
//         fit: BoxFit.contain,
//       ),
//       constraints: BoxConstraints.expand(),
//     );
//   }
// }
