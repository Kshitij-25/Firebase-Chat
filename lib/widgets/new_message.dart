import 'dart:io';

import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewMessage extends StatefulWidget {
  @override
  final void Function(File pickedImage) imagePickFn;
  NewMessage({this.imagePickFn});
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller = new TextEditingController();
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    Firestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
    });
    _controller.clear();
  }

  File _image;
  final picker = ImagePicker();

  void _takePhoto() async {
    final takePhoto = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 300,
    );
    final takePhotoFile = File(takePhoto.path);
    setState(() {
      _image = takePhotoFile;
    });
    widget.imagePickFn(takePhotoFile);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Type a message'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: kPrimaryColor,
            icon: Icon(Icons.camera_alt),
            onPressed: _takePhoto,
          ),
          IconButton(
            color: kPrimaryColor,
            icon: Icon(Icons.send),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
