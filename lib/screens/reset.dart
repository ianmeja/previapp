import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/widgets/input.dart';
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //IDIOMAS

import 'register.dart';
import 'session.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  String _email;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NowUIColors.bgColorScreen,
      appBar: Navbar(
        title: AppLocalizations.of(context).new_password,
        rightOptions: false,
        backButton: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 35.0, bottom: 8.0),
            child: Input(
              placeholder: 'Email',
              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                color: NowUIColors.primary,
    //AppLocalizations.of(context).send_email
                child: Text(AppLocalizations.of(context).send_email, style: TextStyle(color: NowUIColors.white),),
                onPressed: () => {
                  auth.sendPasswordResetEmail(email: _email),
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Session()))
                },
              )],
          ),
        ],
      ),
    );
  }

}