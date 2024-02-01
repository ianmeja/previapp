import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/data/pollModel.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/services/party_service.dart';
import 'package:now_ui_flutter/services/users_service.dart';
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //IDIOMAS
import 'package:polls/polls.dart';

class createPoll extends StatefulWidget {

  Function() triggerRefetch;
  pollModel existingPoll;
  createPoll({Key key, Function() triggerRefetch, pollModel existingPoll})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.existingPoll = existingPoll;
  }
  @override
  _createPollState createState() => _createPollState();
}

class _createPollState extends State<createPoll> {

  Party party;
  bool isPollNew = true;

  bool save = false;

  FocusNode questionFocus = FocusNode();
  FocusNode option1Focus = FocusNode();
  FocusNode option2Focus = FocusNode();
  FocusNode option3Focus = FocusNode();

  pollModel currentPoll;

  TextEditingController questionController = TextEditingController();
  TextEditingController option1Controller = TextEditingController();
  TextEditingController option2Controller = TextEditingController();
  TextEditingController option3Controller = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingPoll == null) {
      currentPoll = pollModel(
          question: '', option1: '', option2: '', option3: '');
      isPollNew = true;
    } else {
      currentPoll = widget.existingPoll;
      isPollNew = false;
    }
    questionController.text = currentPoll.question;
    option1Controller.text = currentPoll.option1;
    option2Controller.text = currentPoll.option2;
    option3Controller.text = currentPoll.option3;
  }

  @override
  Widget build(BuildContext context) {
    party = ModalRoute.of(context).settings.arguments as Party;
    return Scaffold(
        appBar: Navbar(
          title: AppLocalizations.of(context).polls,
          backButton: true,
          icon: Icons.check,
          iconTap: () {
            handleSave();
            setSave();
          },
          rightOptions: true,
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        body: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      readOnly: isNew(),
                      cursorColor: NowUIColors.primary,
                      focusNode: questionFocus,
                      autofocus: true,
                      controller: questionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onSubmitted: (text) {
                        questionFocus.unfocus();
                        FocusScope.of(context).requestFocus(option1Focus);
                      },
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                          color: NowUIColors.white,
                          fontFamily: 'ZillaSlab',
                          fontSize: 32,
                          fontWeight: FontWeight.w700),
                      decoration: InputDecoration.collapsed(
                        hintText: AppLocalizations.of(context).question,
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
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 12, bottom: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      focusNode: option1Focus,
                      autofocus: true,
                      controller: option1Controller,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onSubmitted: (text) {
                        option1Focus.unfocus();
                        FocusScope.of(context).requestFocus(option2Focus);
                      },
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).option1,
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
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 12, bottom: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      focusNode: option2Focus,
                      autofocus: true,
                      controller: option2Controller,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onSubmitted: (text) {
                        option2Focus.unfocus();
                        FocusScope.of(context).requestFocus(option2Focus);
                      },
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).option2,
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
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 12, bottom: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      focusNode: option3Focus,
                      autofocus: true,
                      controller: option3Controller,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onSubmitted: (text) {
                        option3Focus.unfocus();
                      },
                      decoration: InputDecoration(labelText: AppLocalizations.of(context).option3,
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
                    ),
                  ),
                ),
              ]
          ),

        )
    );
  }

  void handleSave() async {
    PartyService partyService = PartyService();
    setState(() {
      currentPoll.question = questionController.text;
      currentPoll.option1 = option1Controller.text;
      currentPoll.option2 = option2Controller.text;
      currentPoll.option3 = option3Controller.text;
      currentPoll.owner = FirebaseAuth.instance.currentUser.uid;
      print('question ${currentPoll.question} option1 ${currentPoll.option1} option2 ${currentPoll.option2} option3 ${currentPoll.option3} ');
    });
    print("entre");
    print("id de la fiesta ${party}");
    await partyService.addPoll(currentPoll,party);
    print("el state");
    questionFocus.unfocus();
    option1Focus.unfocus();
    option2Focus.unfocus();
    option3Focus.unfocus();
    handleBack();
  }

  void handleBack(){
    Navigator.pop(context);
  }

  bool isNew(){
    if(questionController.text.isEmpty && save==false)
      return false;
    else
      return true;
  }

  bool setSave(){
    save = true;
  }
}