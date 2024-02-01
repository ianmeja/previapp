import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //IDIOMAS
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/services/party_service.dart';
import 'package:now_ui_flutter/services/users_service.dart';
import 'package:now_ui_flutter/widgets/drawer.dart';
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import '../ad_manager.dart';
import 'tasks.dart';
import 'package:intl/intl.dart';

class PartyScreen extends StatefulWidget {
  @override
  _PartyState createState() => _PartyState();
}

class _PartyState extends State<PartyScreen> {
  String _linkMessage;
  bool _isCreatingLink = false;
  String _testString =
      'To test: long press link and then copy and click from a non-browser '
      "app. Make sure this isn't being tested on iOS simulator and iOS xcode "
      'is properly setup. Look at firebase_dynamic_links/README.md for more '
      'details.';
  BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  RewardedAd _rewardedAd;
  bool _isRewardedAdReady = false;
  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  PartyService partyService = PartyService();
  Party party;

  @override
  void initState() {
    super.initState();

    // COMPLETE: Initialize _bannerAd
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
    _loadRewardedAd();
    _loadInterstitialAd();
  }





  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      backgroundColor: NowUIColors.bgColorScreen,
      title: Text(AppLocalizations.of(context).limit,
              style: TextStyle(color: NowUIColors.white),),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppLocalizations.of(context).ad,
                style: TextStyle(color: NowUIColors.white),),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: NowUIColors.primary,
          child: Text(AppLocalizations.of(context).close),
        ),
        if(_isRewardedAdReady)
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
              _rewardedAd?.show(
                  onUserEarnedReward: (_, reward) {
                    party.maxGuests+=10;
                    partyService.refreshParty(party);
              });
            },
            textColor: NowUIColors.primary,
            child: Text(AppLocalizations.of(context).advertisement),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    party = ModalRoute.of(context).settings.arguments as Party;
    bool _isHost = party.host == FirebaseAuth.instance.currentUser.uid;
    return FutureBuilder<String>(
        future: getUsername(party.host),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return Scaffold(
            appBar: Navbar(
              title: party.name == null ? AppLocalizations.of(context).not_title : party.name,
              backButton: true,
              rightOptions: _isHost,
              icon: _isHost? Icons.edit : null,
              iconTap:(){
                Navigator.pushNamed(context, "/createParty", arguments: party).then((value) async => { await partyService.getParty(party.idParty).then((value) => setState(() => party = value))} );
              },
            ),
            backgroundColor: NowUIColors.bgColorScreen,
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: 50),
              child:FloatingActionButton(
                  child: Icon(Icons.share),
                  backgroundColor: NowUIColors.primary,
                  onPressed: ()  async{
                    if (party.guest.length == party.maxGuests)
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                        _buildPopupDialog(context),
                      );
                      else {
                        await _shareImage(party.idParty);
                    }
                        /*
                      Share.share(party.idParty,
                          subject: 'Estas invitado a mi fiesta organizada por Previapp');
                      }

                         */
                  }
              )
            ),
            drawer: NowDrawer(currentPage: "Fiestas"),
            body: Container(
                //padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Flexible(
                      flex: 8,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 24, top: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  party.dir == null || party.dir == ""
                                      ? AppLocalizations.of(context).not_address
                                      : party.dir,
                                  style: TextStyle(
                                      color: NowUIColors.text,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24, top: 12),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(DateFormat('dd-MM-yyyy - kk:mm').format(party.date),
                                  style: TextStyle(
                                      color: NowUIColors.text,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24, top: 12, bottom: 12),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: snapshot.hasData
                                  ? Text(snapshot.data,
                                  style: TextStyle(
                                      color: NowUIColors.text,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16))
                                  : Text(AppLocalizations.of(context).loading,
                                  style: TextStyle(
                                      color: NowUIColors.text,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                            ),
                          ),
                        ],
                      )
                    ),
                        Padding(padding: EdgeInsets.only(right: 20, top: 20),
                            child: CircleAvatar(
                              backgroundImage: party.partyPic != null ? NetworkImage(party.partyPic) : AssetImage("./assets/imgs/logo.png"),
                              radius: 65.0,
                              backgroundColor: NowUIColors.bgColorScreen,
                            ))
                    ]
                  ),
                  Container(
                        width: MediaQuery.of(context).size.width*0.8,
                        padding: EdgeInsets.only(bottom: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Padding(padding: EdgeInsets.only(top: 20),child: Text(
                                    party.description == null ||
                                            party.description == ""
                                        ? AppLocalizations.of(context).not_description
                                        : party.description,
                                    style: TextStyle(
                                        color: NowUIColors.text,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                    textAlign: TextAlign.justify,),
                              ),)
                            ]
                        ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: ButtonTheme(
                            minWidth: 150.0,
                            child: RaisedButton.icon(
                                color: NowUIColors.primary,
                                label: Text(
                                  AppLocalizations.of(context).tasks,
                                  style: TextStyle(
                                      fontSize: 14.0, color: NowUIColors.white),
                                ),
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 12, bottom: 12),
                                icon: Icon(
                                  Icons.event_note_sharp,
                                  size: 20.0,
                                  color: NowUIColors.white,
                                ),
                                onPressed: () {
                                  if (_isInterstitialAdReady) _interstitialAd.show();
                                  Navigator.pushNamed(context, '/task',
                                      arguments: party);
                                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Tasks()));
                                }
                            ),
                          )
                      ),
                      Center(
                          child: ButtonTheme(
                            minWidth: 150.0,
                            child: RaisedButton.icon(
                                color: NowUIColors.primary,
                                label: Text(
                                  AppLocalizations.of(context).bills,
                                  style: TextStyle(
                                      fontSize: 14.0, color: NowUIColors.white),
                                ),
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 12, bottom: 12),
                                icon: Icon(
                                  Icons.monetization_on,
                                  size: 20.0,
                                  color: NowUIColors.white,
                                ),
                                onPressed: () {
                                  if (_isInterstitialAdReady) _interstitialAd.show();
                                  Navigator.pushNamed(context, '/bills',
                                      arguments: party);
                                }
                            ),
                          )
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: ButtonTheme(
                            minWidth: 150.0,
                            child: RaisedButton.icon(
                                color: NowUIColors.primary,
                                label: Text(
                                  AppLocalizations.of(context).guests,
                                  style: TextStyle(
                                      fontSize: 14.0, color: NowUIColors.white),
                                ),
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 12, bottom: 12),
                                icon: Icon(
                                  Icons.people,
                                  size: 20.0,
                                  color: NowUIColors.white,
                                ),
                                onPressed: () {
                                  if (_isInterstitialAdReady) _interstitialAd.show();
                                  Navigator.pushNamed(context, '/guests',
                                      arguments: party);
                                }
                            ),
                          )
                      ),
                      Center(
                          child: ButtonTheme(
                            minWidth: 150.0,
                            child: RaisedButton.icon(
                              color: NowUIColors.primary,
                              label: Text(
                                AppLocalizations.of(context).info,
                                style: TextStyle(
                                    fontSize: 14.0, color: NowUIColors.white),
                              ),
                              padding: EdgeInsets.only(
                                  left: 16, right: 16, top: 12, bottom: 12),
                              icon: Icon(
                                Icons.info,
                                size: 20.0,
                                color: NowUIColors.white,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/info',
                                    arguments: party);
                              }
                            ),
                          )
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: ButtonTheme(
                          minWidth: 150.0,
                          child: RaisedButton.icon(
                              color: NowUIColors.primary,
                              label: Text(
                                AppLocalizations.of(context).transport,
                                style: TextStyle(
                                    fontSize: 14.0, color: NowUIColors.white),
                              ),
                              padding: EdgeInsets.only(
                                  left: 16, right: 16, top: 12, bottom: 12),
                              icon: Icon(
                                Icons.emoji_transportation,
                                size: 20.0,
                                color: NowUIColors.white,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/transport',
                                    arguments: party).then((value) async => { await partyService.getParty(party.idParty).then((value) => setState(() => party = value))} );
                              }),
                        ),
                      ),
                      Center(
                          child: ButtonTheme(
                        minWidth: 150.0,
                        child: RaisedButton.icon(
                            color: NowUIColors.primary,
                            label: Text(
                              AppLocalizations.of(context).polls,
                              style: TextStyle(
                                  fontSize: 14.0, color: NowUIColors.white),
                            ),
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 12, bottom: 12),
                            icon: Icon(
                              Icons.question_answer,
                              size: 20.0,
                              color: NowUIColors.white,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/polls',
                                  arguments: party).then((value) async => { await partyService.getParty(party.idParty).then((value) => setState(() => party = value))} );
                            }),
                      )),
                    ],
                  ),
                if (_isBannerAdReady)
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(color: NowUIColors.white),
                        height: _bannerAd.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd),
                      ),
                    ),
                  )
              ],
            )),
          );
        });
  }


  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdManager.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          this._rewardedAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                _isRewardedAdReady = false;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _isRewardedAdReady = true;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
          setState(() {
            _isRewardedAdReady = false;
          });
        },
      ),
    );
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
  @override
  void dispose() {
    // COMPLETE: Dispose a BannerAd object
    _bannerAd.dispose();
    _interstitialAd.dispose();
    // COMPLETE: Dispose an InterstitialAd object
    //_interstitialAd?.dispose();

    // COMPLETE: Dispose a RewardedAd object
    _rewardedAd?.dispose();


    super.dispose();
  }

  Future<String> getUsername(String host) async{
    String toReturn;
    UserService userService = UserService();
    await userService.getById(host).then((value) => toReturn = value.username);
    return toReturn;
  }


  _shareImage(String idParty) async {
    final ByteData bytes = await rootBundle.load('assets/imgs/logo.png');
    await Share.file('esys image', 'esys.png', bytes.buffer.asUint8List(), 'image/png', text: idParty);
  }
  /*
  Future<void> _shareInvitation(String idParty) async
  {
    String url = await createDynamicLink(idParty);
    Share.share(url,
        subject: 'Estas invitado!');

  }

   */


}
