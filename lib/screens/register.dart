import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //IDIOMAS
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/model/user.dart';
import 'package:now_ui_flutter/screens/verify.dart';
import 'package:now_ui_flutter/services/users_service.dart';
//widgets
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:now_ui_flutter/widgets/input.dart';
import 'package:now_ui_flutter/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import '../constants/Theme.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _email, _password,_username;
  bool _checkboxValue = false;
  bool _isHidden = true;
  final auth = FirebaseAuth.instance;
  final double height = window.physicalSize.height;
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        drawer: NowDrawer(currentPage: "Account"),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/imgs/register-bg2.jpg"),
                      fit: BoxFit.cover)
              ),
            ),
            SafeArea(
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Card(
                      elevation: 5,
                      color: NowUIColors.bgColorScreenTransparent,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Container(
                          height: MediaQuery.of(context).size.height ,
                          // color: NowUIColors.bgColorScreenTransparent,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Center(
                                      child: Text("or be classical",
                                          style: TextStyle(
                                              color: NowUIColors.time,
                                              fontWeight: FontWeight.w200,
                                              fontSize: 16)),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Input(
                                          placeholder: AppLocalizations.of(context).username,
                                          prefixIcon:
                                              Icon(Icons.school, size: 20, color: NowUIColors.primary),
                                          onChanged: (value) {
                                          setState(() {
                                          _username = value.trim();
                                          });}
                                        ),
                                      ),
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
                                            },),
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
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 9),
                                    child: Center(
                                      child: RaisedButton(
                                        textColor: NowUIColors.white,
                                        color: NowUIColors.primary,
                                          onPressed: () => _signup(_email, _password,_username,new MyUser()),
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
                                          child: Text(AppLocalizations.of(context).register,
                                              style:
                                                  TextStyle(fontSize: 14.0))),
                                    ),
                                  ),)
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
  _signup(String _email, String _password,String _username, MyUser user) async {
    try {
      await auth.createUserWithEmailAndPassword(email: _email, password: _password)
          .then((value) =>
      {
        setState(() {
          user.uId = value.user.uid.toString();
          user.username = _username;
          user.email = _email;
        }),
        userService.create(user)
      });
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>VerifyScreen()));
    } on FirebaseAuthException catch (error) {
      Toast.show(error.message, context, duration: Toast.LENGTH_LONG,gravity: Toast.TOP);
    }
  }



  void _toggle() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}

