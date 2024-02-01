import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //IDIOMAS
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/screens/reset.dart';
import 'package:now_ui_flutter/services/users_service.dart';

//widgets
import 'package:now_ui_flutter/widgets/input.dart';

import 'package:now_ui_flutter/widgets/drawer.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

import '../constants/Theme.dart';
import 'home.dart';

class Session extends StatefulWidget {
  @override
  _SessionState createState() => _SessionState();
}

class _SessionState extends State<Session> {
  bool _isHidden = true;
  String _email, _password;
  final auth = FirebaseAuth.instance;
  final double height = window.physicalSize.height;
  UserService userS = new UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/imgs/register-bg2.jpg"),
                      fit: BoxFit.cover)
              ),
            ),
            Container(
              child: ListView(children: [
                Padding(
                  padding: MediaQuery.of(context).padding,
                  child: Card(
                      color: NowUIColors.bgColorScreenTransparent,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Container(
                          height: MediaQuery.of(context).size.height*0.9,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(20),
                                          child:new Image.asset('assets/imgs/logo.png', height: 150,)
                                      )
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RawMaterialButton(
                                        onPressed: () {},
                                        elevation: 4.0,
                                        fillColor: NowUIColors.socialFacebook,
                                        child: Icon(FontAwesomeIcons.facebook,
                                            size: 16.0, color: Colors.white),
                                        padding: EdgeInsets.all(15.0),
                                        shape: CircleBorder(),
                                      ),
                                      RawMaterialButton(
                                        onPressed: () {},
                                        elevation: 4.0,
                                        fillColor: Colors.redAccent,
                                        child: Icon(FontAwesomeIcons.google,
                                            size: 16.0, color: Colors.white),
                                        padding: EdgeInsets.all(15.0),
                                        shape: CircleBorder(),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Input(
                                            placeholder: AppLocalizations.of(context).email,
                                            prefixIcon:
                                                Icon(Icons.email, size: 20, color: NowUIColors.primary),
                                            onChanged: (value) {
                                            setState(() {
                                            _email = value.trim();
                                            });
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Input(
                                            placeholder: AppLocalizations.of(context).password,
                                            obscure: _isHidden,
                                            prefixIcon:
                                                Icon(Icons.lock, size: 20, color: NowUIColors.primary),
                                            suffixIcon:
                                            InkWell(
                                              onTap: this._toggle,
                                              child:Icon(
                                                  _isHidden
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                  color: Colors.pink),
                                            ),
                                          onChanged: (value) {
                                            setState(() {
                                              _password = value.trim();
                                            });
                                          },
                                          onEditingComplete: () {
                                            _signin(_email, _password);
                                          }
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetScreen()));
                                          },
                                          child: Text(AppLocalizations.of(context).forgot_password))
                                    ],),
                                  Center(
                                      child: RaisedButton(
                                        textColor: NowUIColors.white,
                                        color: NowUIColors.primary,
                                        onPressed: ()  => _signin(_email, _password),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 32.0,
                                              right: 32.0,
                                              top: 12,
                                              bottom: 12),
                                          child: Text(AppLocalizations.of(context).login,
                                              style:
                                                  TextStyle(fontSize: 14.0))),
                                    ),
                                  ),
                                  Center(
                                      child: TextButton(
                                        onPressed: () {
                                            Navigator.pushNamed(context, '/register');
                                        },
                                        child: Text(AppLocalizations.of(context).register2,
                                        style:
                                          TextStyle(fontSize: 15, color: NowUIColors.white),),
                                      ),
                                  )
                                ],
                              ),
                            ),
                          ))),
                ),
              ]),
            )
          ],
        ));

  }
  _signin(String _email, String _password) async {
    try {
      await auth.signInWithEmailAndPassword(email: _email, password: _password);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (error) {
      Toast.show(AppLocalizations.of(context).errorSignIn, context, duration: Toast.LENGTH_LONG,gravity: Toast.TOP);
    }
  }

  void _toggle() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
