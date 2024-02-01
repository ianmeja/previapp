import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/services/party_service.dart';
import 'package:now_ui_flutter/widgets/faderoute.dart';
import 'package:now_ui_flutter/data/models.dart';
import 'package:now_ui_flutter/screens/edit.dart';
import 'package:now_ui_flutter/screens/view.dart';
import '../constants/Theme.dart';
import '../widgets/navbar.dart';
import 'settings.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../widgets/cards.dart';

class Tasks extends StatefulWidget {
  Party party;
  Function(Brightness brightness) changeTheme;
  Tasks({Key key, this.title, Function(Brightness brightness) changeTheme})
      : super(key: key) {
    this.changeTheme = changeTheme;
  }

  final String title;

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {

  //bool isFlagOn = false;
  //bool headerShouldHide = false;
  Map<String, dynamic> notesList = new Map();
  TextEditingController searchController = TextEditingController();

  setNotesFromDB(Party party, PartyService partyService) async {
    print("Entered setNotes");
    var fetchedNotes = await partyService.getParty(party.idParty);
    setState(() {
      notesList = fetchedNotes.task;
    });
  }

  @override
  Widget build(BuildContext context) {
    PartyService().getParty((ModalRoute
        .of(context)
        .settings
        .arguments as Party).idParty).then((value) => {setState( () => {widget.party = value})});
    PartyService partyService = new PartyService();
    if(widget.party != null) {
      notesList = widget.party.task;
    }
    return Scaffold(
      appBar: Navbar(
        title: AppLocalizations.of(context).tasks,
        backButton: true,
      ),
      backgroundColor: NowUIColors.bgColorScreen,
      floatingActionButton: FloatingActionButton(
        backgroundColor: NowUIColors.primary,
        onPressed: () {
          gotoEditNote(context,widget.party,partyService);
        },

        child: Icon(Icons.add),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Container(height: 32),
              ...buildNoteComponentsList(),
              Container(height: 100)
            ],
          ),
          margin: EdgeInsets.only(top: 2),
          padding: EdgeInsets.only(left: 15, right: 15),
        ),
      ),
    );
  }


  List<Widget> buildNoteComponentsList() {
      List<Widget> noteComponentsList = [];
      notesList.forEach((key, value) {if(value!= null){
        noteComponentsList.add(NoteCardComponent(
          noteData: new NotesModel(key,value),
          onTapAction: openNoteToRead,
        ));
      }});
      if(noteComponentsList.isEmpty){
        noteComponentsList.add(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children : [
              Center(
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: new Image.asset('assets/imgs/logo.png', height: 100,)
                  )
              ),
              Text(AppLocalizations.of(context).not_tasks,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: NowUIColors.white,
                  fontSize: 20,
                ),
              ),
            ]
        ));
      }
      return noteComponentsList;
    }


  /*void handleSearch(String value) {
    if (value.isNotEmpty) {
      setState(() {
        isSearchEmpty = false;
      });
    } else {
      setState(() {
        isSearchEmpty = true;
      });
    }
  }*/


  void gotoEditNote(BuildContext context, Party party, PartyService partyService) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                EditNotePage(triggerRefetch: refetchNotesFromDB, party:party))).then((value) => setState(() async => {
                  await PartyService().getParty(widget.party.idParty).then((value) => widget.party = value)
    }));
  }



    void refetchNotesFromDB(Party party, PartyService partyService) async {
    await setNotesFromDB(party, partyService);
    print("Refetched notes");
  }



  openNoteToRead(NotesModel noteData, BuildContext context, Party party, PartyService partyService) async {
    await Future.delayed(Duration(milliseconds: 230), () {});
    Navigator.push(
        context,
        FadeRoute(
            page: ViewNotePage(
                triggerRefetch: refetchNotesFromDB, currentNote: noteData, party:widget.party)));
    await Future.delayed(Duration(milliseconds: 300), () {});

  }
/*
  void cancelSearch() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      searchController.clear();
      isSearchEmpty = true;
    });
  }*/
}

