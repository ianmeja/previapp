import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:now_ui_flutter/services/users_service.dart';

class TransportCard extends StatelessWidget {
  TransportCard(
      {this.title = "Placeholder Title",
        this.description = "Placeholder description",
        this.from = "Placeholder from",
        this.friends,
        this.max,
        this.isOn,
        this.host,
        this.deleteTap,
        this.tap = defaultFunc});

  final Function tap;
  final String title;
  final Function deleteTap;
  final String host;
  final String description;
  final String from;
  final int max;
  final bool isOn;
  Iterable<MapEntry<String, dynamic>> friends;

  static void defaultFunc() {
    print("the function works!");
  }

  Future<String> getUsername(Iterable<MapEntry<String, dynamic>> friends, String host) async{
    String name;
    List<String> toReturn = [];
    UserService userService = UserService();
    await userService.getById(host).then((value) => {
      name = value.username,
      toReturn.add(name)
    });
    for(var friend in friends) {
      if(friend.value != null) {
        await userService.getById(friend.key).then((value) =>
        {
          name = value.username,
          toReturn.add(name)
        });
      }
    }
    return toReturn.toString().substring(1, toReturn.toString().length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 140,
        child: FutureBuilder<String>(
        future: getUsername(friends, host),
          builder: (BuildContext context, AsyncSnapshot<String> snapshotFriends){
          return GestureDetector(
            child: Card(
              elevation: 3,
              shadowColor: NowUIColors.muted.withOpacity(0.22),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      flex: 4,
                      child: Padding(
                        padding: host == FirebaseAuth.instance.currentUser.uid? const EdgeInsets.only(left: 16.0) : const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Text(title,
                                  style: TextStyle(
                                      color: NowUIColors.secondary, fontSize: 20)),
                               if(host == FirebaseAuth.instance.currentUser.uid)
                                 FlatButton(onPressed: deleteTap, child: Icon(Icons.delete_outline,size: 30,))
                              ]
                            ),
                            Text(from,
                                style: TextStyle(
                                    color: NowUIColors.secondary, fontSize: 12)),
                            Text(description,
                                style: TextStyle(
                                    color: NowUIColors.secondary, fontSize: 12)),
                            if(snapshotFriends.hasData)
                              Text(snapshotFriends.data.isEmpty? host : snapshotFriends.data,
                                  style: TextStyle(
                                      color: NowUIColors.secondary, fontSize: 12))
                            else
                              Text(AppLocalizations.of(context).loading,
                                  style: TextStyle(
                                      color: NowUIColors.secondary,
                                      fontSize: 12)),
                          ],
                        ),
                      )),
                  if(host != FirebaseAuth.instance.currentUser.uid)
                    if(!isOn)
                    Flexible(
                        flex: 2,
                        child: FlatButton(
                          onPressed:checkDis()<max? tap:null,
                          child: checkDis()<max? Icon(Icons.add, size: 40,):Icon(Icons.done, size: 40,),
                        )
                    )
                    else
                    Flexible(
                        flex: 2,
                        child: FlatButton(
                          onPressed:tap,
                          child: Icon(Icons.remove, size: 40,),
                        )
                    )
                ],
              ),
            ),
          );} ));
  }

  int checkDis() {
    int toReturn = 0;
    for(var friend in friends){
      if(friend.value != null){
        toReturn++;
      }
    }
    return toReturn;
  }
}
