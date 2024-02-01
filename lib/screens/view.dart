import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //IDIOMAS
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:now_ui_flutter/data/models.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/screens/edit.dart';
import 'package:now_ui_flutter/services/party_service.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../constants/Theme.dart';

class ViewNotePage extends StatefulWidget {
  void Function(Party party, PartyService partyService) triggerRefetch;
  NotesModel currentNote;
  Party party;
  ViewNotePage({Key key, void Function(Party party, PartyService partyService) triggerRefetch, NotesModel currentNote, Party party})
      : super(key: key) {
    this.party = party;
    this.triggerRefetch = triggerRefetch;
    this.currentNote = currentNote;
  }
  @override
  _ViewNotePageState createState() => _ViewNotePageState();
}

class _ViewNotePageState extends State<ViewNotePage> {
  Party party;
  PartyService partyService;
  @override
  void initState() {
    super.initState();
    showHeader();
  }

  void showHeader() async {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        headerShouldShow = true;
      });
    });
  }

  bool headerShouldShow = false;
  @override
  Widget build(BuildContext context) {
    /*
     party = ModalRoute
        .of(context)
        .settings
        .arguments as Party;

     */
    party = widget.party;
    partyService = PartyService();
    return Scaffold(
        backgroundColor: NowUIColors.bgColorScreen,
        body: Stack(
          children: <Widget>[
            ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Container(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 24.0, top: 40.0, bottom: 16),
                  child: AnimatedOpacity(
                    opacity: headerShouldShow ? 1 : 0,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                    child: Text(
                      widget.currentNote.title,
                      style: TextStyle(
                        color: NowUIColors.white,
                        fontFamily: 'ZillaSlab',
                        fontWeight: FontWeight.w700,
                        fontSize: 36,
                      ),
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: headerShouldShow ? 1 : 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, top: 36, bottom: 24, right: 24),
                  child: Text(
                    widget.currentNote.content,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: NowUIColors.white),
                  ),
                )
              ],
            ),
            ClipRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    height: 93,
                    color: NowUIColors.primary,
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: SafeArea(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: handleBack,
                              color: NowUIColors.white
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.delete_outline),
                            onPressed: handleDelete,
                              color: NowUIColors.white
                          ),
                          IconButton(
                            icon: Icon(OMIcons.edit),
                            onPressed: handleEdit,
                              color: NowUIColors.white
                          ),
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ));
  }



  void handleEdit() {
    Navigator.pop(context);
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => EditNotePage(
              existingNote: widget.currentNote,
              triggerRefetch: widget.triggerRefetch,party: widget.party,
            )));
  }


  void handleBack() {
    Navigator.pop(context);
  }

  void handleDelete() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(AppLocalizations.of(context).delete_note),
            content: Text(AppLocalizations.of(context).permanent),
            actions: <Widget>[
              FlatButton(
                child: Text(AppLocalizations.of(context).delete.toUpperCase(),
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () async {
                  partyService.deleteTask(widget.party,widget.currentNote.title);
                  widget.triggerRefetch(widget.party, partyService);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(AppLocalizations.of(context).cancel.toUpperCase(),
                    style: TextStyle(
                        color: NowUIColors.black,
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
}