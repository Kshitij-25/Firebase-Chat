import 'dart:io' show File, Platform;
import 'package:chat_app/components/already_have_an_account_acheck.dart';

import 'package:chat_app/components/rounded_input_field.dart';
import 'package:chat_app/components/rounded_password_field.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/Login/login_screen.dart';
import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'background.dart';
import 'or_divider.dart';
import 'social_icon.dart';

class Body extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File image,
    BuildContext context,
  ) submitFn;
  Body(
    this.submitFn,
    this.isLoading,
  );
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    // Focus.of(context).unfocus();
    if (_userImageFile == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _userImageFile,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UserImagePicker(_pickedImage),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Your Email",
                onChanged: (value) {},
                onSaved: (value) {
                  _userEmail = value;
                },
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Please enter valid email address';
                  }
                  return null;
                },
              ),
              RoundedInputField(
                hintText: "Username",
                onChanged: (value) {},
                onSaved: (value) {
                  _userName = value;
                },
                validator: (value) {
                  if (value.isEmpty || value.length < 4) {
                    return 'Username must be 4 characteres long';
                  }
                  return null;
                },
              ),
              RoundedPasswordField(
                onChanged: (value) {},
                onSaved: (value) {
                  _userPassword = value;
                },
                validator: (value) {
                  if (value.isEmpty || value.length < 7) {
                    return 'Password must be 7 characters long!';
                  }
                  return null;
                },
              ),
              if (widget.isLoading) CircularProgressIndicator(),
              if (!widget.isLoading)
                SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  height: MediaQuery.of(context).size.height * .06,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: kPrimaryColor,
                    child: Text(
                      'SIGNUP',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _trySubmit,
                  ),
                ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.popAndPushNamed(context, LoginScreen.routeName);
                },
              ),
              OrDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocalIcon(
                    iconSrc: "assets/icons/facebook.svg",
                    press: () {},
                  ),
                  !Platform.isIOS
                      ? SocalIcon(
                          iconSrc: "assets/icons/twitter.svg",
                          press: () {},
                        )
                      : SocalIcon(
                          iconSrc: "assets/icons/apple.svg",
                          press: () {},
                        ),
                  SocalIcon(
                    iconSrc: "assets/icons/google-plus.svg",
                    press: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
