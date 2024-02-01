import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //IDIOMAS
import 'package:now_ui_flutter/data/pollModel.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/services/party_service.dart';
import 'package:now_ui_flutter/widgets/faderoute.dart';
//import 'package:now_ui_flutter/data/pollModel.dart';
import 'package:now_ui_flutter/screens/pollView.dart';
// import 'package:now_ui_flutter/services/bdpoll.dart';
import '../constants/Theme.dart';
import '../widgets/navbar.dart';
import '../widgets/poll-card.dart';
import 'createPoll.dart';

class polls extends StatefulWidget {
  Function(Brightness brightness) changeTheme;
  polls({Key key, this.title, Function(Brightness brightness) changeTheme})
      : super(key: key) {
    this.changeTheme = changeTheme;
  }

  final String title;

  @override
  _PollsState createState() => _PollsState();
}

class _PollsState extends State<polls> {
  bool isFlagOn = false;
  bool headerShouldHide = false;
  List<pollModel> pollsList = [];

  Party party;
  Future<List<pollModel>> builder;

  @override
  void initState() {
    super.initState();
  }

  Future<List<pollModel>> setPollsFromDB() async{
    print("Entered setPolls");
    pollsList = [];
    int i = 0;
    print(party);
    await PartyService().getParty(party.idParty).then((value) => {
      party = value,
    });
    if (party!=null)
        if (party.polls!=null){
          party.polls.entries.forEach((element) {
            if (element.value!=null) {
              pollsList.add(
                  pollModel.fromMap(
                      {'_id': i++,
                        'question': element.key.toString(),
                        'option1': element.value['option1'].toString(),
                        'option2': element.value['option2'].toString(),
                        'option3': element.value['option3'].toString(),
                        'votes': element.value['votes']
                      })
              );
            }
      });}
    else
      print("not working");
    return pollsList;
  }

  @override
  Widget build(BuildContext context) {
    party = ModalRoute.of(context).settings.arguments as Party;
    builder = setPollsFromDB();
    return Scaffold(
      appBar: Navbar(
        title: AppLocalizations.of(context).polls,
        backButton: true,
      ),
      backgroundColor: NowUIColors.bgColorScreen,
        floatingActionButton: FloatingActionButton(
          backgroundColor: NowUIColors.primary,
          onPressed: () {
            Navigator.of(context)
                .pushNamed("/createPoll", arguments: party)
                .then((value) => setState(() => {

            }));
          },

          child: Icon(Icons.add),
        ),
      body: FutureBuilder<List<pollModel>> (
          future: builder,
          builder: (BuildContext context, AsyncSnapshot<List<pollModel>> snapshot) {
         if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(height: 32),
                  ...buildpollComponentsList(),
                  Container(height: 100)
                ],
              ),
              margin: EdgeInsets.only(top: 2),
              padding: EdgeInsets.only(left: 15, right: 15),
              ),
            );
          }
         else {
           return Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children : [
                 Center(
                     child: Padding(
                         padding: EdgeInsets.all(20),
                         child: new Image.asset('assets/imgs/logo.png', height: 100,)
                     )
                 ),
                 Text(AppLocalizations.of(context).not_polls,
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     color: NowUIColors.white,
                     fontSize: 20,
                   ),
                 ),
               ]
           );
         }
         })
      );
  }

  List<Widget> buildpollComponentsList() {
    List<Widget> pollComponentsList = [];
    pollsList.sort((a, b) {
      return b.question.compareTo(a.question);
    });
    pollsList.forEach((poll) {
      pollComponentsList.add(PollCardComponent(
        pollData: poll,
        onTapAction: openPollToRead,
      ));
    });

    return pollComponentsList;
  }

  openPollToRead(pollModel pollData) async {
    setState(() {
      headerShouldHide = true;
    });

    Navigator.push(
        context,
        FadeRoute(
            page: ViewPollPage(
                party:party, currentPoll: pollData))).then((value) => setState(() {

    }));


    setState(() {
      headerShouldHide = false;
    });
  }
}
