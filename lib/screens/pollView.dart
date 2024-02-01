import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/data/pollModel.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/screens/createPoll.dart';
import 'package:now_ui_flutter/services/party_service.dart';
import 'package:now_ui_flutter/services/users_service.dart';
import 'package:polls/polls.dart';

class ViewPollPage extends StatefulWidget {

  Party party;
  pollModel currentPoll;

  ViewPollPage({Key key, Party party, pollModel currentPoll})
      : super(key: key) {
    this.party = party;
    this.currentPoll = currentPoll;
  }

  @override
  _ViewPollPageState createState() => _ViewPollPageState();
}

class _ViewPollPageState extends State<ViewPollPage> {


  @override
  void initState() {
    super.initState();
    showHeader() ;
    // setData();
  }

  void showHeader() async {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        headerShouldShow = true;
      });
    });
  }

  bool headerShouldShow = false;

  double option1 = 0.0;
  double option2 = 0.0;
  double option3 = 0.0;

  String user = FirebaseAuth.instance.currentUser.uid;

  void setData() {
    option1 = 0.0;
    option2 = 0.0;
    option3 = 0.0;
    widget.currentPoll.votes.forEach((key, value) {
      print(value);
      if(value==1){
        option1+=1.0;
      }
      if(value==2){
        option2+=1.0;
      }
      if(value==3){
        option3+=1.0;
      }
    });
    print("optionn 1 : " + option1.toString() +"\noption 2 :" + option2.toString() + "\noption 3 :" + option3.toString());
  }

  @override
  Widget build(BuildContext context) {
    widget.currentPoll.votes = (widget.currentPoll.votes ==null)? {}:widget.currentPoll.votes;

    setData();
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
                  child: Polls(
                    children: [
                      Polls.options(title: widget.currentPoll.option1 , value: option1),
                      Polls.options(title: widget.currentPoll.option2, value: option2),
                      Polls.options(title: widget.currentPoll.option3, value: option3),
                    ],
                    question: Text(widget.currentPoll.question,
                      style: TextStyle(
                      color: NowUIColors.white,
                      fontFamily: 'ZillaSlab',
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                      ),),
                    currentUser: this.user,
                    creatorID: "imposibleId",
                    voteData: widget.currentPoll.votes,
                    userChoice: widget.currentPoll.votes[this.user],
                    outlineColor: NowUIColors.primary,
                    onVoteBackgroundColor: NowUIColors.primary,
                    leadingBackgroundColor: NowUIColors.primary,
                    backgroundColor: NowUIColors.white,
                    onVote: (choice) {
                      print(choice);
                      widget.currentPoll.votes[this.user] = choice;
                      PartyService().addPoll(widget.currentPoll, widget.party);
                      setState(()  { });
                    },
                  ),
                ),],
            ),
            ClipRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    height: 80,
                    color: NowUIColors.primary,
                    child: SafeArea(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: handleBack,
                              color: NowUIColors.white
                          ),
                          Spacer(),
                          IconButton(
                              icon: Icon(Icons.delete_outline),
                              onPressed: handleDelete,
                              color: NowUIColors.white
                          ),
                        ],
                      ),
                    ),
                  )),
            )
      ]
    ));
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
            title: Text(AppLocalizations.of(context).delete_poll),
            content: Text(AppLocalizations.of(context).permanent_poll),
            actions: <Widget>[
              FlatButton(
                child: Text(
                    AppLocalizations.of(context).delete.toUpperCase(),
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () async {
                  PartyService partyService = PartyService();
                  await partyService.deletePoll(widget.party, widget.currentPoll);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                    AppLocalizations.of(context).cancel.toUpperCase(),
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