import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egytrip/widgets/appTheme.dart';
import 'package:flutter/material.dart';

class Users extends StatelessWidget {
  static const routeName = 'users';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getTheme().backgroundColor,
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
            itemBuilder: (ctx, index) => UsersContainer(
              userName: chatDocs[index].data()['username'],
              userPhone: chatDocs[index].data()['phone'],
            ),
          );
        },
      ),
    );
  }
}

class UsersContainer extends StatelessWidget {
  final String userName;
  final String userPhone;
  UsersContainer({this.userName, this.userPhone});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    print(userName);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(22),
          ),
          border: Border.all(width: 2, color: Theme.of(context).buttonColor)),
      width: width,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          child: Column(children: <Widget>[
            Text('Name : $userName'),
            Text(' Phone : $userPhone')
          ]),
        ),
      ),
    );
  }
}
