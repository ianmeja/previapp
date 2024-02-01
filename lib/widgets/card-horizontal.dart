import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/services/users_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardHorizontal extends StatelessWidget {
  CardHorizontal(
      {this.title = "Placeholder Title",
      this.host = "Placeholder Host",
      this.cta = "Ver fiesta",
      this.img = "./assets/imgs/logo.png",
      this.delete,
      this.tap = defaultFunc});

  final String cta;
  final String img;
  final Function tap;
  final String title;
  final String host;
  final Function delete;

  static void defaultFunc() {
    print("the function works!");
  }

  Future<String> getUsername(String host) async{
    String toReturn;
    UserService userService = UserService();
    await userService.getById(host).then((value) => toReturn = value.username);
    return toReturn;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getUsername(host),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return Container(
              height: 130,
              child: GestureDetector(
                onTap: tap,
                child: Card(
                  elevation: 3,
                  shadowColor: NowUIColors.muted.withOpacity(0.22),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          constraints: BoxConstraints.expand(),
                            decoration: BoxDecoration(
                                color: NowUIColors.bgColorScreenTransparent,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    bottomLeft: Radius.circular(4.0)),
                                image: DecorationImage(
                                  image: img != "./assets/imgs/logo.png" ? NetworkImage(img): AssetImage(img),
                                  fit: img != "./assets/imgs/logo.png" ? BoxFit.fill : BoxFit.contain
                                  )
                                ),
                        ),
                      ),
                      Flexible(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Text(title.length > 20 ? title.substring(0, 20) + "...": title,
                                        style: TextStyle(
                                            color: NowUIColors.secondary,
                                            fontSize: 20)),),
                                    if(host == FirebaseAuth.instance.currentUser.uid)
                                      Flexible(
                                          flex: 1,
                                          child: FlatButton(onPressed: delete, child: Icon(Icons.delete_outline,))
                                      )
                                  ]
                                ),
                                if(snapshot.hasData)
                                  Text(snapshot.data,
                                      style: TextStyle(
                                          color: NowUIColors.secondary,
                                          fontSize: 12))
                                else
                                  Text(AppLocalizations.of(context).loading,
                                  style: TextStyle(
                                      color: NowUIColors.secondary,
                                      fontSize: 12)),
                                Text(AppLocalizations.of(context).viewparty,
                                    style: TextStyle(
                                        color: NowUIColors.primary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              )
          );
        }
    );
  }
}
