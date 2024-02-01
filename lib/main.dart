import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:now_ui_flutter/screens/edit_profile.dart';
import 'package:now_ui_flutter/screens/guests.dart';


// screens
import 'package:now_ui_flutter/screens/onboarding.dart';
import 'package:now_ui_flutter/screens/home.dart';
import 'package:now_ui_flutter/screens/pro_register.dart';
import 'package:now_ui_flutter/screens/profile.dart';
import 'package:now_ui_flutter/screens/session.dart';
import 'package:now_ui_flutter/screens/settings.dart';
import 'package:now_ui_flutter/screens/register.dart';
import 'package:now_ui_flutter/screens/party.dart';
import 'package:now_ui_flutter/screens/tasks.dart';
import 'package:now_ui_flutter/screens/createParty.dart';
import 'package:now_ui_flutter/screens/pollView.dart';
import 'package:now_ui_flutter/screens/BillSplitter.dart';
import 'package:now_ui_flutter/screens/bills.dart';
import 'package:now_ui_flutter/screens/polls.dart';
import 'package:now_ui_flutter/screens/createPoll.dart';
import 'package:now_ui_flutter/screens/transport.dart';
import 'package:now_ui_flutter/screens/createTransport.dart';
import 'package:now_ui_flutter/screens/info.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:now_ui_flutter/services/users_service.dart';
import 'package:uni_links/uni_links.dart';

//void main() => runApp(MyApp());


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
  //runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Previapp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Montserrat'),
        initialRoute: (FirebaseAuth.instance.currentUser != null )?'/home':'/onboarding',
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // English, no country code
          const Locale('es', ''), // Spanish, no country code
        ],
        routes: <String, WidgetBuilder>{
          '/settings': (BuildContext context) => new Settings(),
          '/home': (BuildContext context) => new Home(),
          "/onboarding": (BuildContext context) => new Onboarding(),
          "/profile": (BuildContext context) => new Profile(),
          "/edit_profile": (BuildContext context) => new EditProfilePage(),
          "/register": (BuildContext context) => new Register(),
          "/session" : (BuildContext context) => new Session(),
          "/party" : (BuildContext context) => new PartyScreen(),
          "/tasks" : (BuildContext context) => new Tasks(),
          "/createParty" : (BuildContext context) => new CreateParty(),
          "/billSplitter" : (BuildContext context) => new BillSplitter(),
          "/bills" : (BuildContext context) => new Bills(),
          "/guests" : (BuildContext context) => new Guests(),
          "/task" : (BuildContext context) => new Tasks(),
          "/polls" : (BuildContext context) => new polls(),
          "/createPoll" : (BuildContext context) => new createPoll(),
          "/transport" : (BuildContext context) => new Transport(),
          "/createTransport" : (BuildContext context) => new CreateTransport(),
          "/info" : (BuildContext context) => new Info(),
          "/pro_register" : (BuildContext context) => new ProRegister(),

        });

  }




}
/*

class _MyAppState extends State<MyApp> {
  String url = "";

  @override
  void initState() {
    initDynamicLinks();
    super.initState();
  }

  ///Retreive dynamic link firebase.
  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    Uri deepLink = null;
    if(data!=null && data.link!=null){
      deepLink = data.link;
    }

    if (deepLink != null) {
      handleDynamicLink(deepLink);
    }
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink.link;

          if (deepLink != null) {
            handleDynamicLink(deepLink);
          }
        }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });
  }

  }




}

 */
