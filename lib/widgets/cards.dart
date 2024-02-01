
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/services/party_service.dart';
import '../constants/Theme.dart';
import '../constants/Theme.dart';
import '../constants/Theme.dart';
import '../data/models.dart';

class NoteCardComponent extends StatelessWidget {
  const NoteCardComponent({
    this.noteData,
    this.onTapAction,
    Key key,
    this.party,
    this.context,
    this.partyService
  }) : super(key: key);

  final NotesModel noteData;
  final BuildContext context;
  final Party party;
  final PartyService partyService;
  final Function(NotesModel noteData, BuildContext buildContext, Party party, PartyService partyService) onTapAction;

  @override
  Widget build(BuildContext context) {
    //String neatDate = DateFormat.yMd().add_jm().format(noteData.date);
    return Container(
        margin: EdgeInsets.fromLTRB(10, 1, 10, 8),
        height: 90,
        decoration: BoxDecoration(
          border: Border.all(color: NowUIColors.primary, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          color: NowUIColors.bgColorScreen,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              onTapAction(noteData,context,party,partyService);
            },
            //splashColor: color.withAlpha(20),
            //highlightColor: color.withAlpha(10),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
              children: [
                  Text(
                    '${noteData.title.trim().length <= 20 ? noteData.title.trim() : noteData.title.trim().substring(0, 20) + '...'}',
                    style: TextStyle(
                      color: NowUIColors.white,
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,
                  ),
                  ),
                  ],),
                Column(
                children: [

                ],),
              ],),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      '${noteData.content.trim().split('\n').first.length <= 30 ? noteData.content.trim().split('\n').first : noteData.content.trim().split('\n').first.substring(0, 30) + '...'}',
                      style:
                      TextStyle(fontSize: 14, color: NowUIColors.white,),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
/*
  BoxShadow buildBoxShadow(Color color, BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return BoxShadow(
          color: noteData.isImportant == true
              ? Colors.black.withAlpha(100)
              : Colors.black.withAlpha(10),
          blurRadius: 8,
          offset: Offset(0, 8));
    }
    return BoxShadow(
        color: noteData.isImportant == true
            ? color.withAlpha(60)
            : color.withAlpha(25),
        blurRadius: 8,
        offset: Offset(0, 8));
  }
}*/
/*
class AddNoteCardComponent extends StatelessWidget {
  const AddNoteCardComponent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
        height: 110,
        decoration: BoxDecoration(
          border: Border.all(color: NowUIColors.primary, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          color: NowUIColors.bgColorScreen,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: NowUIColors.white,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Add new note',
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                color: NowUIColors.white,
                                fontSize: 20),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }*/
}