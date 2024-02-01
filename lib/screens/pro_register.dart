import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/widgets/drawer.dart';
import 'package:now_ui_flutter/widgets/grouped_buttons_orientation.dart';
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:now_ui_flutter/widgets/radio_button.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProRegister extends StatefulWidget{
  @override
  ProRegisterState createState() => ProRegisterState();
}

class ProRegisterState extends State<ProRegister> {
  String _picked;

  @override
  Widget build(BuildContext context) {
    _picked = AppLocalizations.of(context).option1_pro;
    return Scaffold(
        backgroundColor: NowUIColors.bgColorScreen,
        appBar: Navbar(
          title: "PreviApp PRO",
          bgColor: NowUIColors.primary,
          backButton: true,
        ),
        drawer: NowDrawer(currentPage: "PRO"),
        body: Container(
            child: Padding(
                padding: const EdgeInsets.only(top: 32.0, left: 16, right: 16),
                child: Column(
                    children: [
                      //BASIC RADIOBUTTONGROUP
                      Container(
                        padding: const EdgeInsets.only(left: 14.0, top: 14.0),
                        child: Text(AppLocalizations.of(context).upgrade,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: NowUIColors.text
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 14.0, top: 14.0),
                        alignment: Alignment.center,
                        child: Text(AppLocalizations.of(context).upg_description,
                          style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: NowUIColors.text
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 30,),
                      RadioButtonGroup(
                        margin: const EdgeInsets.only(left: 12.0),
                        onSelected: (String selected) => setState((){
                          _picked = selected;
                        }),
                        labels: [
                          AppLocalizations.of(context).option1_pro,
                          AppLocalizations.of(context).option2_pro,
                        ],
                        onChange: (String label, int index) => print("label: $label index: $index"),
                        picked: _picked,
                      ),
                      const SizedBox(height: 24),
                      Align(alignment: Alignment.center, child:
                      TextButton(

                        onPressed: (){}
                        , child: Text(AppLocalizations.of(context).continue_pro)
                        , style: TextButton.styleFrom(
                        primary: NowUIColors.text,
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            color: NowUIColors.text
                        ),
                        // background
                        backgroundColor: NowUIColors.primary,),)
                      ),
                    ]),
                ),
            ),
        );
  }
}