import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //IDIOMAS
import 'package:image_picker/image_picker.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/model/user.dart';
import 'package:now_ui_flutter/services/party_service.dart';
import 'package:now_ui_flutter/services/users_service.dart';
import 'package:flutter/cupertino.dart';
//widgets
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:toast/toast.dart';

class CreateParty extends StatefulWidget {
  @override
  _CreatePartyState createState() => _CreatePartyState();
}

class _CreatePartyState extends State<CreateParty> {
  final GlobalKey _scaffoldKey = new GlobalKey();
  Party party;
  String _name;
  String _dir;
  DateTime _date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 0);
  String _description;
  File partyPic;

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
      final Party party = ModalRoute.of(context).settings.arguments as Party;
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
                    await uploadImage(party, "gallery");
                    setState(() {});
                  }
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).take_photo),
                onTap: () async {
                  Navigator.pop(context);
                  await uploadImage(party, "camera");
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

  uploadImage(Party party, String option) async {
    final storage = FirebaseStorage.instance;
    final picker = ImagePicker();
    PickedFile image;

    if(option == 'gallery'){
      image = await picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if(image != null){
        if(party != null){
          var snapshot = await storage
              .ref()
              .child('partyPics/' + party.idParty)
              .putFile(file);
          party.partyPic = await snapshot.ref.getDownloadURL();
        }
        else
          partyPic = file;
      }
    }
    else if(option == 'camera'){
      image = await picker.getImage(source: ImageSource.camera);
      var file = File(image.path);
      if(image != null) {
        if (party != null) {
          var snapshot = await storage.ref()
              .child('partyPics/' + party.idParty)
              .putFile(file);
          party.partyPic = await snapshot.ref.getDownloadURL();
        }
        else
          partyPic = file;
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    Party party = ModalRoute.of(context).settings.arguments as Party;
    bool _editing = false;
    if(party != null)
      _editing = true;
    return Scaffold(
      appBar: Navbar(
        title: _editing? AppLocalizations.of(context).edit_party : AppLocalizations.of(context).create_party,
        backButton: true,
        icon: Icons.check,
        rightOptions: true,
        iconTap: () async {
          if (_editing)
            await editParty();
          else
            await newParty();
        }
      ),

      backgroundColor: NowUIColors.bgColorScreen,
      body: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: ListView(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex:5,
                      child: Container(
                        padding: const EdgeInsets.only(left: 8.0, top: 22),
                        width: 200,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            controller: _editing? TextEditingController(text: party.name) : null,
                            decoration: InputDecoration(labelText: AppLocalizations.of(context).party_name,//AppLocalizations.of(context).party_name,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: NowUIColors.primary),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: NowUIColors.primary),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: NowUIColors.primary),
                                ),
                                labelStyle: TextStyle(color: NowUIColors.white), ),
                            cursorColor: NowUIColors.primary,
                            style: TextStyle(color: NowUIColors.white),
                            onChanged: (value) {
                              _name = value.trim();
                               }, ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(right: 20, top: 20),
                        child: CircleAvatar(
                            backgroundImage: party != null ? (party.partyPic != null ? NetworkImage(party.partyPic) : AssetImage("./assets/imgs/logo.png")) : (partyPic != null ? FileImage(partyPic) : AssetImage("./assets/imgs/logo.png")),
                            radius: 50.0,
                            backgroundColor: NowUIColors.bgColorScreen,
                            child: Container(
                              padding: EdgeInsets.only(left: 60, top: 60),
                              child: buildEditIcon(NowUIColors.primary, context),
                            )
                        )),
                  ]
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: _editing? TextEditingController(text: party.dir) : null,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context).address,
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
                      _dir = value.trim();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child:  Container(
                    height: 200,
                    child: CupertinoTheme (
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            color: NowUIColors.white,
                            fontSize: 20
                          ),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.dateAndTime,
                        minimumDate: DateTime(2021, 1, 1),
                        initialDateTime: _editing? party.date : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 0),
                        minuteInterval: 30,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDateTime) {
                          _date = newDateTime;
                        },
                      ),
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 12, bottom: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: _editing? TextEditingController(text: party.description) : null,
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
            ],
          )
      ),
    );
  }

  Future<void> newParty() async{
    if(_name==null){
      Toast.show(AppLocalizations.of(context).errorParty, context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
      return;
    }
    else {
      UserService userS = new UserService();
      MyUser user = await userS.getCurrentUser();
      Party newParty = new Party(
          _description,
          _dir,
          _name,
          user.uId,
          _date,
          new Map(),
          new Map(),
          new Map(),
          new Map(),
          new Map());
      await userS.addParty(newParty, user).then((value) => newParty.idParty = value);
      if (partyPic!= null) {
        final storage = FirebaseStorage.instance;
        var snapshot = await storage
            .ref()
            .child('partyPics/' + newParty.idParty)
            .putFile(partyPic);
        newParty.partyPic = await snapshot.ref.getDownloadURL();
        await PartyService().refreshParty(newParty);
      }
      Navigator.pop(context);
    }
  }

  Future<void> editParty() async {
    if(_name==''){
      Toast.show(AppLocalizations.of(context).errorParty, context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
      return;
    }
    Party party = ModalRoute.of(context).settings.arguments as Party;
    if(_name != null)
      party.name = _name;
    if(_description != null)
      party.description = _description;
    if(_dir != null)
      party.dir = _dir;
    if(_date != DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 0))
      party.date = _date;
    PartyService partyService = PartyService();
    await partyService.refreshParty(party);
    Navigator.pop(context);
  }
}