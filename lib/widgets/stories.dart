import 'dart:io' show Platform;
import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Stories extends StatefulWidget {
  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  getCurrentUser() async {
    final FirebaseUser user = await _auth.currentUser();
    final String uid = user.uid;
    // Similarly we can get email as well
    //final uemail = user.email;
    print(uid);
    return uid;
    //print(uemail);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor,
      height: Platform.isIOS
          ? MediaQuery.of(context).size.height * .125
          : MediaQuery.of(context).size.height * .16,
      child: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
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
                scrollDirection: Axis.horizontal,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final imgUrl = users[index]['image_url'];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width * .08,
                          backgroundColor: kPrimaryLightColor,
                          backgroundImage: NetworkImage(imgUrl),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          users[index]['username'],
                          style: TextStyle(
                            color: kPrimaryLightColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
