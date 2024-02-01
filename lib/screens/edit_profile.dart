import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/model/user.dart';
import 'package:now_ui_flutter/services/users_service.dart';
import 'package:now_ui_flutter/widgets/drawer.dart';
import 'package:now_ui_flutter/widgets/input.dart';
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:now_ui_flutter/widgets/textfield_widget.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  UserService userService = UserService();

  Widget buildCircle({
    Widget child,
    double all,
    Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  Widget buildEditIcon(Color color, BuildContext context) => buildCircle(
    color: Colors.white,
    all: 2,
    child: InkWell(onTap: () {
      final MyUser user = ModalRoute.of(context).settings.arguments as MyUser;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(AppLocalizations.of(context).pick_photo),
                onTap: () async {
                  Navigator.pop(context);
                  await uploadImage(user, "gallery");
                  setState(() {});
                }
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).take_photo),
                onTap: () async {
                  Navigator.pop(context);
                  await uploadImage(user, "camera");
                  setState(() {});
                },
              )
            ],
          ),
        ),
      );
    }, child: buildCircle(
      color: color,
      all: 6,
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 18,
      ),
    )
    ),
  );

  uploadImage(MyUser user, String option) async {
    final storage = FirebaseStorage.instance;
    final picker = ImagePicker();
    PickedFile image;

    if(option == 'gallery'){
      image = await picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if(image != null){
        var snapshot = await storage.ref().child('userPics/'+user.uId).putFile(file);
        user.profilePic = await snapshot.ref.getDownloadURL();
      }
    }
    else if(option == 'camera'){
      image = await picker.getImage(source: ImageSource.camera);
      var file = File(image.path);
      if(image != null){
        var snapshot = await storage.ref().child('userPics/'+user.uId).putFile(file);
        user.profilePic = await snapshot.ref.getDownloadURL();
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    MyUser user = ModalRoute.of(context).settings.arguments as MyUser;
    return Scaffold(
        appBar: Navbar(
          title: AppLocalizations.of(context).edit_profile,
          backButton: true,
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        drawer: NowDrawer(currentPage: "Editar Perfil"),
        body: Stack(
          children: <Widget>[
            Column(
              children: [
                Container(
                      constraints: BoxConstraints.tightFor(height: 200),
                          child: Align(
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundImage: user.profilePic != null ?
                                  NetworkImage(user.profilePic)
                                      : AssetImage("./assets/imgs/logo.png"),
                                  radius: 65.0,
                                  backgroundColor: NowUIColors.bgColorScreen,),
                                Positioned(
                                    bottom: 0,
                                    right: 4,
                                    child: buildEditIcon(NowUIColors.primary, context),
                                  ),
                              ],
                          ),
                          ),
                  ),
                Flexible(
                  flex: 1,
                  child: //Padding(padding: EdgeInsets.symmetric(horizontal: 32), child:
                  ListView(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    physics: BouncingScrollPhysics(),
                    children: [
                      TextFieldWidget(
                        label: AppLocalizations.of(context).username,
                        text: user.username,
                        onChanged: (name) {setState(() {
                          user.username = name.trim();
                        });},
                      ),
                      const SizedBox(height: 24),
                      TextFieldWidget(
                        label: AppLocalizations.of(context).description,
                        text: user.description,
                        maxLines: 5,
                        onChanged: (about) {
                          setState(() {
                            user.description = about.trim();
                          });
                          },
                      ),
                      const SizedBox(height: 24),
                      Align(alignment: Alignment.center, child:
                        TextButton(
                          onPressed: (){userService.editProfile(user);
                          Navigator.pop(context);}
                          , child: Text(AppLocalizations.of(context).save,)
                          , style: TextButton.styleFrom(
                          primary: NowUIColors.text, // background
                          backgroundColor: NowUIColors.primary,))
                      ),
                    ],
                  ),
                  ),
              ],
            ),
          ],

        ));
  }

}