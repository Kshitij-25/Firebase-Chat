import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;
  UserImagePicker(this.imagePickFn);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _image;

  final picker = ImagePicker();
  void _pickImage() async {
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 300,
    );

    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _image = pickedImageFile;
    });
    widget.imagePickFn(pickedImageFile);
  }

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
      child: Stack(
        children: [
          CircleAvatar(
            radius: MediaQuery.of(context).size.width * .25,
            backgroundColor: kPrimaryColor,
            backgroundImage: _image != null ? FileImage(_image) : null,
          ),
          Positioned(
            bottom: 0,
            right: MediaQuery.of(context).size.width * .04,
            child: Container(
              decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                iconSize: 35,
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    context: context,
                    builder: (BuildContext ctx) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.image),
                            title: Text('Choose from library'),
                            onTap: _pickImage,
                          ),
                          ListTile(
                            leading: Icon(Icons.image),
                            title: Text('Take photo'),
                            onTap: _takePhoto,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
