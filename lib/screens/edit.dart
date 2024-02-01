import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/painting.dart' as prefix0;
import 'package:flutter/widgets.dart';
import 'package:now_ui_flutter/data/models.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/services/party_service.dart';
import '../constants/Theme.dart';

class EditNotePage extends StatefulWidget {
  void Function(Party party, PartyService partyService) triggerRefetch;
  NotesModel existingNote;
  Party party;
  EditNotePage({Key key,   void Function(Party party, PartyService partyService) triggerRefetch, NotesModel existingNote, Party party})
      : super(key: key) {
    this.party = party;
    this.triggerRefetch = triggerRefetch;
    this.existingNote = existingNote;
  }
  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  Party party;
  PartyService partyService;
  bool isDirty = false;
  bool isNoteNew = true;
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();

  NotesModel currentNote;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingNote == null) {
      currentNote = NotesModel("", "");
      isNoteNew = true;
    } else {
      currentNote = widget.existingNote;
      isNoteNew = false;
    }
    titleController.text = currentNote.title;
    contentController.text = currentNote.content;
  }

  @override
  Widget build(BuildContext context) {
    party = widget.party;
     partyService = PartyService();
    return Scaffold(
        backgroundColor: NowUIColors.bgColorScreen,
        body: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    focusNode: titleFocus,
                    autofocus: true,
                    controller: titleController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onSubmitted: (text) {
                      titleFocus.unfocus();
                      FocusScope.of(context).requestFocus(contentFocus);
                    },
                    onChanged: (value) {
                      markTitleAsDirty(value);
                    },
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        color: NowUIColors.white,
                        fontFamily: 'ZillaSlab',
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                    decoration: InputDecoration.collapsed(
                      hintText: AppLocalizations.of(context).title,
                      hintStyle: TextStyle(
                          //color: NowUIColors.success,
                          color: NowUIColors.white,
                          fontSize: 32,
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w700),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    focusNode: contentFocus,
                    controller: contentController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (value) {
                      markContentAsDirty(value);
                    },
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: NowUIColors.white),
                    decoration: InputDecoration.collapsed(
                      hintText: '...',
                      hintStyle: TextStyle(
                          color: NowUIColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                    ),
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
                            color: NowUIColors.white, //color icono flecha
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.delete_outline),
                            color: NowUIColors.white, //color icono delete
                            onPressed: () {
                              handleDelete();
                            },
                          ),
                          AnimatedContainer(
                            margin: EdgeInsets.only(left: 10),
                            duration: Duration(milliseconds: 200),
                            width: isDirty ? 100 : 0,
                            height: 42,
                            curve: Curves.decelerate,
                            child: FlatButton(
                              color: NowUIColors.primary, //color boton save
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(100),
                                      bottomLeft: Radius.circular(100))),
                              child: Icon(
                                Icons.done,
                              ),
                              onPressed: handleSave,
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ));
  }

  void handleSave() async {
    setState(() {
      currentNote.title = titleController.text;
      currentNote.content = contentController.text;
      print('Hey there ${currentNote.content}');
    });
    if (isNoteNew) {
      var latestNote = await partyService.addTask(currentNote, party);
    } else {
      await  await partyService.editTask(currentNote, party);
    }
    setState(() {
      isNoteNew = false;
      isDirty = false;
    });
    await widget.triggerRefetch(party,partyService);
    titleFocus.unfocus();
    contentFocus.unfocus();
    handleBack();
  }

  void markTitleAsDirty(String title) {
    setState(() {
      isDirty = true;
    });
  }

  void markContentAsDirty(String content) {
    setState(() {
      isDirty = true;
    });
  }



  void handleDelete() async {
    if (isNoteNew) {
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text(AppLocalizations.of(context).delete_note),
              content: Text(AppLocalizations.of(context).permanent),
              actions: <Widget>[
                FlatButton(
                  child: Text(AppLocalizations.of(context).delete,
                      style: prefix0.TextStyle(
                          color: Colors.red.shade300,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                  onPressed: () async {
                    PartyService partyService2 = new PartyService();
                    await partyService2.deleteTask(widget.party, currentNote.title);
                    widget.triggerRefetch(widget.party, partyService2);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text(AppLocalizations.of(context).cancel,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
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

  void handleBack() async {
    Navigator.pop(context);
  }
}