import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //IDIOMAS
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/model/car.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/services/party_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:now_ui_flutter/services/users_service.dart';
//widgets
import 'package:now_ui_flutter/widgets/navbar.dart';


class CreateTransport extends StatelessWidget {
  final GlobalKey _scaffoldKey = new GlobalKey();
  String _name;
  String _from;
  String _description;
  int _max;
  Party party;

  @override
  Widget build(BuildContext context) {
    party = ModalRoute.of(context).settings.arguments as Party;
    return Scaffold(
      appBar: Navbar(
        title: AppLocalizations.of(context).transport, //AppLocalizations.of(context).create_party, //CAMBIAR
        backButton: true,
        icon: Icons.check,
        rightOptions: true,
        iconTap: () async{
          await newTransport();
          Navigator.pop(context);
        },
      ),
      backgroundColor: NowUIColors.bgColorScreen,
      body: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: ListView(
            children: [
                    Container(
                      padding: const EdgeInsets.only(left: 8.0, top: 22),
                      width: 200,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          decoration: InputDecoration(labelText: AppLocalizations.of(context).type,//AppLocalizations.of(context).party_name,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: NowUIColors.primary),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: NowUIColors.primary),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: NowUIColors.primary),
                              ),
                              labelStyle: TextStyle(color: NowUIColors.white)),
                          cursorColor: NowUIColors.primary,
                          style: TextStyle(color: NowUIColors.white),
                          onChanged: (value) {
                            _name = value.trim();
                          }, ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    decoration: InputDecoration(labelText: AppLocalizations.of(context).from,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: NowUIColors.primary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: NowUIColors.primary),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: NowUIColors.primary),
                        ),
                        labelStyle: TextStyle(color: NowUIColors.white)),
                    cursorColor: NowUIColors.primary,
                    style: TextStyle(color: NowUIColors.white),
                    onChanged: (value) {
                      _from = value.trim();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 12, bottom: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    decoration: InputDecoration(labelText: AppLocalizations.of(context).description,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: NowUIColors.primary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: NowUIColors.primary),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: NowUIColors.primary),
                        ),
                        labelStyle: TextStyle(color: NowUIColors.white)),
                    cursorColor: NowUIColors.primary,
                    style: TextStyle(color: NowUIColors.white),
                    onChanged: (value) {
                      _description = value.trim();
                    },),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 12, bottom: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context).max,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: NowUIColors.primary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: NowUIColors.primary),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: NowUIColors.primary),
                        ),
                        labelStyle: TextStyle(color: NowUIColors.white)),
                    cursorColor: NowUIColors.primary,
                    style: TextStyle(color: NowUIColors.white),
                    onChanged: (value) {
                      _max = int.parse(value.trim());
                    },),
                ),
              ),
            ],
          ),
    ));
  }

  Future<void> newTransport() async{
    PartyService partyS = new PartyService();
    await partyS.addCar(party, new Car(party.idParty,_description, _from, _max, _name, new Map(), FirebaseAuth.instance.currentUser.uid));
  }
}
