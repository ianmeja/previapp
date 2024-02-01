import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //IDIOMAS
import 'package:now_ui_flutter/constants/Theme.dart';

class Onboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/imgs/register-bg2.jpg"),
                    fit: BoxFit.cover))),
        SafeArea(
          child: Container(
            padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: MediaQuery.of(context).size.height * 0.15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.asset("assets/imgs/logo.png", scale: 2),
                    SizedBox(height: 15),
                    Container(
                        child: Center(
                            child: Column(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text("PreviAPP",
                                    style: TextStyle(
                                        color: NowUIColors.white,
                                        fontWeight: FontWeight.w600)))),
                        Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text("Flutter",
                                  style: TextStyle(
                                      color: NowUIColors.white,
                                      fontWeight: FontWeight.w600)),
                            ))
                      ],
                    ))),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Created By",
                            style: TextStyle(
                                color: NowUIColors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3)),
                        SizedBox(width: 8.0),
                        Image.asset("assets/imgs/team_logo.png", scale: 23),
                        Text("PreviApp Team",
                            style: TextStyle(
                                color: NowUIColors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3)),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      textColor: NowUIColors.white,
                      color: NowUIColors.primary,
                      onPressed: () {
                        Navigator.pushNamed(context, '/session');
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 16, bottom: 16),
                          child: Text(AppLocalizations.of(context).enter,
                              style: TextStyle(fontSize: 12.0))),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}
