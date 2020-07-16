import 'package:chat_app/components/already_have_an_account_acheck.dart';
import 'package:chat_app/components/rounded_button.dart';
import 'package:chat_app/components/rounded_input_field.dart';
import 'package:chat_app/components/rounded_password_field.dart';
import 'package:chat_app/screens/Signup/signup_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import 'background.dart';

class Body extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String password,
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
  String _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    Focus.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
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
              SvgPicture.asset(
                "assets/icons/login.svg",
                height: size.height * 0.35,
              ),
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
                      'LOGIN',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _trySubmit,
                  ),
                ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.popAndPushNamed(context, SignUpScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
