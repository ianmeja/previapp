import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //IDIOMAS
import 'package:intl/intl.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/model/party.dart';
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
import 'home.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  final auth = FirebaseAuth.instance;
  final double height = window.physicalSize.height;
  UserService userService = UserService();
  Party party;

  @override
  Widget build(BuildContext context) {
    party = ModalRoute.of(context).settings.arguments as Party;
    return Scaffold(
        extendBodyBehindAppBar: true,
        drawer: NowDrawer(currentPage: "Info"),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/imgs/register-bg2.jpg"),
                      fit: BoxFit.cover)),
            ),
            Align(
              alignment: Alignment.center,
              child: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, right: 16.0, top: 20),
                    child: Card(
                      elevation: 5,
                      color: NowUIColors.bgColorScreenTransparent,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.7,
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
                                        child: new Image.asset(
                                      'assets/imgs/logo.png',
                                      height: 250,
                                    )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          //padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                          child: Column(
                                            children: [
                                              Row(children: [
                                                Flexible(
                                                  flex: 8,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 24, top: 1),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          party.name == null
                                                              ? AppLocalizations.of(context).not_title
                                                              : party.name,
                                                          style: TextStyle(
                                                              color: NowUIColors
                                                                  .text,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 26)),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 24, top: 12),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      party.dir == null
                                                          ? AppLocalizations.of(context).not_date
                                                          : party.dir,
                                                      style: TextStyle(
                                                          color:
                                                              NowUIColors.text,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12)),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 24, top: 12),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      DateFormat('dd-MM-yyyy - kk:mm').format(party.date),
                                                      style: TextStyle(
                                                          color:
                                                              NowUIColors.text,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12)),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 24, top: 12),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      party.description == null
                                                          ? AppLocalizations.of(context).not_description
                                                          : party.description,
                                                      style: TextStyle(
                                                          color:
                                                              NowUIColors.text,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ))),
                    ),
                  ),
                ]),
              ),
            )
          ],
        ));
  }
}
