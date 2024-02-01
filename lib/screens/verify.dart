import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/model/user.dart';
import 'package:now_ui_flutter/services/users_service.dart';

import 'home.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NowUIColors.bgColorScreen,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children : [
          Center(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child:new Image.asset('assets/imgs/logo.png', height: 150,)
              )
          ),
          Text(AppLocalizations.of(context).email_user + '${user.email} ' +  AppLocalizations.of(context).please,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: NowUIColors.white,
              fontSize: 20,
            ),
          ),
        ]
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified){
      timer.cancel();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
    }
  }
}