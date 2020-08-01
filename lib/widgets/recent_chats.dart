import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class RecentChats extends StatefulWidget {
  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  @override
  Widget build(BuildContext context) {
    final docRef = Firestore.instance.collection('users');
    return StreamBuilder(
      stream: docRef.snapshots(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final users = userSnapshot.data.documents;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final imgUrl = users[index]['image_url'];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * .07,
                      backgroundColor: kPrimaryColor,
                      backgroundImage: NetworkImage(imgUrl),
                    ),
                    title: Text(
                      users[index]['username'],
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Divider()
                ],
              ),
            );
          },
        );
      },
    );
  }
}
