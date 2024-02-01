import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:now_ui_flutter/constants/Theme.dart';

import 'package:now_ui_flutter/widgets/drawer-tile.dart';

class NowDrawer extends StatelessWidget {
  final String currentPage;

  NowDrawer({this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
          color: NowUIColors.bgColorScreen,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(20),
                          child:new Image.asset('assets/imgs/logo.png', height: 50,)
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: IconButton(
                            icon: Icon(Icons.menu,
                                color: NowUIColors.white.withOpacity(0.82),
                                size: 24.0),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ),
          Flexible(
            flex: 5,
            child: ListView(
            padding: EdgeInsets.only(left: 8, right: 16),
            children: [
              DrawerTile(
                  icon: FontAwesomeIcons.music,
                  onTap: () {
                    if (currentPage != "Mis Fiestas")
                      Navigator.pushNamed(context, '/home');
                  },
                  iconColor: NowUIColors.white,
                  title: AppLocalizations.of(context).myparties,
                  isSelected: currentPage == "Mis Fiestas" ? true : false),
              DrawerTile(
                  icon: FontAwesomeIcons.user,
                  onTap: () {
                    if (currentPage != "Perfil")
                      Navigator.pushNamed(context, '/profile');
                  },
                  iconColor: NowUIColors.warning,
                  title: AppLocalizations.of(context).profile,
                  isSelected: currentPage == "Perfil" ? true : false),
              DrawerTile(
                  icon: FontAwesomeIcons.cog,
                  onTap: () {
                    if (currentPage != "Configuración")
                      Navigator.pushNamed(context, '/settings');
                  },
                  iconColor: NowUIColors.success,
                  title: AppLocalizations.of(context).settings,
                  isSelected: currentPage == "Configuración" ? true : false),
            ],
          ),
        ),
        Flexible(
          flex: 2,
          child: Container(
              padding: EdgeInsets.only(left: 8, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                      height: 4,
                      thickness: 0,
                      color: NowUIColors.white.withOpacity(0.8)),
                  DrawerTile(
                    icon: FontAwesomeIcons.bolt,
                    onTap: () {
                      Navigator.pushNamed(context, '/pro_register');
                    },
                    iconColor: NowUIColors.muted,
                    title: "PreviApp PRO",
                  ),
                  DrawerTile(
                    icon: FontAwesomeIcons.signOutAlt,
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(context, '/session',(r) => false);
                    },
                    iconColor: NowUIColors.muted,
                    title: AppLocalizations.of(context).logout,
                  ),
                ],
              )),
        ),
      ]),
    ));
  }
}
