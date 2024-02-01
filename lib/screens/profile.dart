import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //IDIOMAS
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:now_ui_flutter/model/user.dart';
import 'package:now_ui_flutter/screens/edit_profile.dart';
import 'package:now_ui_flutter/services/users_service.dart';
import 'package:now_ui_flutter/widgets/button_widget.dart';
//widgets
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:now_ui_flutter/widgets/drawer.dart';
import 'package:now_ui_flutter/widgets/photo-album.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: Navbar(
          title: AppLocalizations.of(context).profile
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        drawer: NowDrawer(currentPage: "Perfil"),
        body: FutureBuilder<MyUser>(
                future: UserService().getCurrentUser(),
                builder: (BuildContext context, AsyncSnapshot<MyUser> snapshot){
                  if (snapshot.hasData) {
                    return Stack (
                      children: <Widget>[
                        Column(
                          children: [
                              Container(
                                  constraints: BoxConstraints.tightFor(height: 300),
                                  padding: EdgeInsets.only(top: 50),
                                  decoration: BoxDecoration(
                                      color: NowUIColors.primary,
                                      image: DecorationImage(
                                          image: AssetImage("./assets/imgs/register-bg.png"),
                                          fit: BoxFit.cover)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                      backgroundImage: snapshot.data.profilePic != null ?
                                                          NetworkImage(snapshot.data.profilePic)
                                                          : AssetImage("./assets/imgs/logo.png"),
                                                      radius: 65.0,
                                                      backgroundColor: NowUIColors.bgColorScreen,),
                                              const SizedBox(height: 8,),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(snapshot.data.username,
                                                    style: TextStyle(
                                                        color: NowUIColors
                                                            .white,
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        fontSize: 22)),
                                              ),

                                              Padding(padding: EdgeInsets.only(top: 20,), child:
                                                    TextButton(
                                                        style: TextButton.styleFrom(
                                                          primary: NowUIColors.text, // background
                                                          backgroundColor: NowUIColors.primary,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pushNamed("/edit_profile", arguments: snapshot.data)
                                                              .then((value) => setState(() => {}));
                                                          //Navigator.pushNamed(context, "/edit_profile", arguments: snapshot.data);
                                                        },
                                                        child: Text(
                                                            AppLocalizations.of(context).edit_profile)
                                                    )
                                              )],
                                                ),
                                              ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                  child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 32.0, right: 32.0, top: 40.0),
                                        child: Column(children: [
                                          Align(alignment: Alignment.topLeft,
                                              child:
                                              Text(AppLocalizations.of(context).about_me,
                                                  style: TextStyle(
                                                      color: NowUIColors.text,
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      fontSize: 30.0))
                                          ),
                                          const SizedBox(height: 20,),
                                          Align(alignment: Alignment.topLeft,
                                              child: Text(snapshot.data.description != null && snapshot.data.description.compareTo("") != 0 ?
                                              snapshot.data.description : AppLocalizations.of(context).default_about,
                                              style: TextStyle(
                                                  color: NowUIColors.white
                                                      .withOpacity(0.85),
                                                  fontSize: 15,

                                                  )
                                                    )
                                              ),
                                          ]
                                        ),
                                  )
                              ),
                            ),
                  ),
                        ],),],);
                  } else {
                      return Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 10.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      );
                        }
                })
    );

  }
}

