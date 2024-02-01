import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:now_ui_flutter/ad_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //IDIOMAS
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/model/user.dart';
import 'package:now_ui_flutter/services/party_service.dart';
import 'package:now_ui_flutter/services/users_service.dart';

//widgets
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:now_ui_flutter/widgets/card-horizontal.dart';
import 'package:now_ui_flutter/widgets/drawer.dart';
import 'createParty.dart';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share/share.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey _scaffoldKey = new GlobalKey();
  final PartyService partyService = new PartyService();
  UserService userService = UserService();
  String code;
  Future<List<Party>> loading;

  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    loading = load();
  }

  Future<List<Party>> getPartys(MyUser myUser) async {
    List<Party> homeCards = [];
    if (myUser.myParty != null) {
      for (var partyid in myUser.myParty.keys) {
        await partyService.getParty(partyid).then((value1) =>
        {
          if (value1 != null) homeCards.add(value1),
        });
      }
    }
    if (myUser.guestParty != null) {
      for (var partyid in myUser.guestParty.keys) {
        await partyService.getParty(partyid).then((value1) =>
        {
          if (value1 != null) homeCards.add(value1),
        });
      }
    }
    if (homeCards.isEmpty)
      homeCards.add(new Party(
          "",
          "",
          "",
          "",
          new DateTime.now(),
          new Map(),
          new Map(),
          new Map(),
          new Map(),
          new Map()));
    return homeCards;
  }

  Future<List<Party>> load() async {
    List<Party> homeCards;
    await userService.getById(FirebaseAuth.instance.currentUser.uid).then((value) async => {
      homeCards = await getPartys(value)
    });
    _loadInterstitialAd();
    return homeCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Navbar(
          title:
          AppLocalizations
              .of(context)
              .myparties,
          rightOptions: true,
          icon: Icons.share,
          iconTap: () {
            _shareInvitation();
            },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: NowUIColors.primary,
          onPressed: () {
            newParty();
          },

          child: Icon(Icons.add),
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        key: _scaffoldKey,
        drawer: NowDrawer(currentPage: "Mis Fiestas"),
        body: FutureBuilder<void>(
            future: _initGoogleMobileAds(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshotAds) {
              return FutureBuilder<List<Party>>(
                  future: loading,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Party>> snapshot) {
                    if (snapshot.hasData) {
                      // if (snapshot.data.isEmpty){
                      //   return ari;
                      // } else
                      return Container(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[for (var fiesta in snapshot.data)
                              if(fiesta.host == "")
                                Column(
                                    children: [
                                      Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(20),
                                            child: new Image.asset(
                                              'assets/imgs/logo.png',
                                              height: 50,)
                                        ),
                                      ),
                                      Text(AppLocalizations.of(context).not_parties,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: NowUIColors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ]
                                )
                              else
                                CardHorizontal(
                                    title: (fiesta.name != null)
                                        ? fiesta.name
                                        : AppLocalizations.of(context).not_title,
                                    host: (fiesta.host != null)
                                        ? fiesta.host
                                        : AppLocalizations.of(context).not_host,
                                    delete: () async {await deleteParty(fiesta);},
                                    img: fiesta.partyPic != null ?  fiesta.partyPic : "./assets/imgs/logo.png",
                                    tap: () {
                                      if (_isInterstitialAdReady)
                                        _interstitialAd.show();
                                      Navigator.of(context)
                                          .pushNamed(
                                          '/party', arguments: fiesta)
                                          .then((value) =>
                                          setState(() =>
                                          {
                                            loading = load()
                                          }));
                                    }
                                ),
                            ],
                          ),
                        ),
                      );
                    }
                    else
                      return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 10.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ));
                  }
              );
            }
        )
    );
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdManager.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitialAd();
            },
          );
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context, String title, String mensage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            backgroundColor: NowUIColors.bgColorScreen,
            title: Text(title,
              style: TextStyle(color: NowUIColors.white),),
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  mensage,
                  style: TextStyle(color: NowUIColors.white),),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                textColor: NowUIColors.primary,
                child: Text(AppLocalizations
                    .of(context)
                    .close.toUpperCase()),
              ),
            ],
          );
        }
    );
  }

  void newParty() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 1,
            backgroundColor: NowUIColors.bgColorScreen,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            title: Text(AppLocalizations.of(context).join_party,
              style: TextStyle(color: NowUIColors.white),),
            content:
            SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).code,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: NowUIColors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: NowUIColors.white),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: NowUIColors.white),
                          ),
                          labelStyle: TextStyle(color: NowUIColors.white)),
                      cursorColor: NowUIColors.primary,
                      style: TextStyle(color: NowUIColors.white),
                      onChanged: (value) {
                        code = value.trim();
                      }, ),
                      Padding(
                        padding: EdgeInsets.only(top: 35),
                        child: Center(
                      child: TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await Navigator.of(context)
                              .pushNamed('/createParty')
                              .then((value) =>
                              setState(() =>
                              {
                                loading = load()
                              }));
                        },
                          child: Text(AppLocalizations.of(context).create_party2,
                          style:
                          TextStyle(fontSize: 18, color: NowUIColors.primary, decoration: TextDecoration.underline),),),
                      ),
                    )
                  ],
                ),

            ),
            actions: <Widget>[
              FlatButton(
                child: Text(AppLocalizations.of(context).join.toUpperCase(),
                    style: TextStyle(
                        color: NowUIColors.primary,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () async {
                  bool empty = true;
                  Party party;
                  await partyService.getParty(code).then((value) => {
                    if(value != null){
                      empty = false,
                      party = value,
                    }
                  });
                  if(!empty){
                    if (party.guest.length >= party.maxGuests){
                      Navigator.pop(context);
                      _buildPopupDialog(context, AppLocalizations.of(context).limit, AppLocalizations.of(context).add_guests);
                    }
                    else{
                    await UserService().addGuestParty(party,FirebaseAuth.instance.currentUser.uid);
                    if (_isInterstitialAdReady)
                      _interstitialAd.show();
                    Navigator.pop(context);
                    Navigator.of(context)
                        .pushNamed(
                        '/party', arguments: await partyService.getParty(party.idParty))
                        .then((value1) =>
                        setState(() =>
                        {
                          loading = load()
                        }));

                  }
                } else{
                    Navigator.pop(context);
                    _buildPopupDialog(context,AppLocalizations.of(context).invalid, AppLocalizations.of(context).check);
                  }
                }
              ),
              FlatButton(
                child: Text(AppLocalizations.of(context).cancel.toUpperCase(),
                    style: TextStyle(
                        color: NowUIColors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void deleteParty(Party fiesta) async{
    await partyService.deleteParty(fiesta);
    setState(() {
      loading = load();
    });
  }

  Future<void> _shareInvitation() async
  {
    String url = await createDynamicLink();
    Share.share(url, subject: AppLocalizations.of(context).guest);

  }

  Future<String> createDynamicLink() async{
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://previapp.page.link',
      link: Uri.parse('https://previapp.page.link.com/'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.previapp_app',
        minimumVersion: 0,
      ),
      socialMetaTagParameters:  SocialMetaTagParameters(
        title: AppLocalizations.of(context).install,
      ),
    );

    final Uri url = await parameters.buildUrl();

    return url.toString();

  }



}
