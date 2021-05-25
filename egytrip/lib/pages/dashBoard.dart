import 'package:flutter/material.dart';

import 'admin_requests.dart';
import 'package:egytrip/pages/users.dart';
import 'package:egytrip/pages/add_hotel__screen.dart';
import 'package:egytrip/pages/hotels_mange_screen.dart';

class DashBoard extends StatelessWidget {
  static const routeName = 'dash board';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DashBoard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: Container(
                height: 100,
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.border_color,
                        size: 30,
                        color: Theme.of(context).accentColor,
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'Requests',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(AdminRequests.routeName);
                  },
                ),
              ),
            ),
            Center(
              child: Container(
                height: 100,
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.supervised_user_circle_outlined,
                        size: 30,
                        color: Theme.of(context).accentColor,
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'Users',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(Users.routeName);
                  },
                ),
              ),
            ),
            Center(
              child: Container(
                height: 100,
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.handyman,
                        size: 30,
                        color: Theme.of(context).accentColor,
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'Manage Hotels',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(HotelsManageScreen.routeName);
                  },
                ),
              ),
            ),
            Center(
              child: Container(
                height: 100,
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_chart,
                        size: 30,
                        color: Theme.of(context).accentColor,
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'Add Hotel',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(AddHotelScreen.routeName);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
