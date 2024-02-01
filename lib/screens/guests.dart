import 'dart:collection';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //IDIOMAS
import 'package:flutter/material.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/services/party_service.dart';
import 'package:now_ui_flutter/services/users_service.dart';
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:now_ui_flutter/widgets/guest-card.dart';

class Guests extends StatefulWidget {

  @override
  _GuestsState createState() => _GuestsState();

  Guests();
}

class _GuestsState extends State<Guests> {

  UserService userService = UserService();

  //TODO con el id se complica una banda todo si deciden usar el dynamic hay que cambiarlo

  Future<List<String>> getName(Party party) async {
    Iterable<String> keys;
    await PartyService().getParty(party.idParty).then((value) => keys = value.guest.keys);
    List<String> toReturn = [];
    for (var guestID in keys){
      guestID = guestID.trim();
      await userService.getById(guestID).then((value) => {if(value != null){toReturn.add(value.username)}} );
    }
    return toReturn;
  }

  @override
  Widget build(BuildContext context) {
    Party party = ModalRoute.of(context).settings.arguments as Party;
    // Map<String,dynamic> guests = party.
    return Scaffold(
      appBar: Navbar(
        title: AppLocalizations.of(context).guests,
        backButton: true,
      ),
      backgroundColor: NowUIColors.bgColorScreen,
      body: FutureBuilder<List<String>>(
          future: getName(party),
          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        if(snapshot.data.length == 0)
                          Column(
                              children : [
                                Center(
                                    child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: new Image.asset('assets/imgs/logo.png', height: 100,)
                                    )
                                ),
                                Text(AppLocalizations.of(context).not_guest,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: NowUIColors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ]
                          ),
                        for (var guest in snapshot.data)
                        GuestCard(
                          title: (guest != null) ? guest : AppLocalizations.of(context).not_title,
                        ),
                      ],
                    ),
                  )
              );
            }
            else
              return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 10.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )
              );
          }
      )
    );
  }
}