import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:now_ui_flutter/data/models.dart';
import 'package:now_ui_flutter/data/pollModel.dart';
import 'package:now_ui_flutter/model/car.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/services/car_service.dart';
import 'package:now_ui_flutter/services/users_service.dart';

class PartyService {

  CollectionReference partyRef = FirebaseFirestore.instance.collection('party');
  CarService carService = CarService();
  Future<String> addParty(Party party) async{
    String id;
    await partyRef.add((party).toMap())
        .then((value) => {id = value.id});
    return id;
  }

  Future<void> refreshParty(Party party) async {
    await partyRef.doc(party.idParty).set(party.toMap(),SetOptions(merge: true));
  }

  Future<void> deleteCar(String party, String car) async{
    await partyRef.doc(party).set(
        {"cars":{
          car: null}
        },SetOptions(merge: true)
    );

  }
  Future<void> deleteParty(Party party){
    UserService userService = new UserService();
    for(String key in party.guest.keys){
      userService.deletePartyGuest(key, party.idParty);
    }
    userService.deleteMyParty(party.host, party.idParty);
    partyRef.doc(party.idParty).delete();

  }

  Future<void> addGuest(String uid, Party party) async{
    partyRef.doc(party.idParty).set({
      "guest": {
        uid : "true"
      }}
        ,SetOptions(merge: true) );
  }

  /*/
  Future<void> deleteTask(Party party, String key)async{
    partyRef.doc(party.idParty + "." + key).delete();
  }

   */
  Future<void> deleteTask(Party party, String key) async {

    await partyRef.doc(party.idParty ).set(
        {"task":{
          key: null}
        },SetOptions(merge: true)
    );

  }

  Future<void> editTask(NotesModel task, Party party) async{
    deleteTask(party, task.title);
    addTask(task, party);
  }

  Future<void> addTask(NotesModel task, Party party) async{
    partyRef.doc(party.idParty).set({
      "task": {
        task.title : task.content
      }}
        ,SetOptions(merge: true) );
  }

  Future<void> addPoll(pollModel poll, Party party) async{
    partyRef.doc(party.idParty).set({
      "polls": {
        poll.question: {
          "option1" : poll.option1,
          "option2" : poll.option2,
          "option3" : poll.option3,
          "votes" : poll.votes,
          "owner" :poll.owner
        }
      }}
        ,SetOptions(merge: true) );
  }

  Future<void> deletePoll(Party party, pollModel poll) async {
    print(party.idParty +" "+poll.question);
    await partyRef.doc(party.idParty ).set(
        {"polls":{
          poll.question: null}
        },SetOptions(merge: true)
    );

  }

  Future<void> addExpense(String expense,int price,int countPeople, Party party) async{
    partyRef.doc(party.idParty).set({
      "expenses": {
        expense : {
          "price" : price,
          "amount" : price/countPeople,
          "countPeople": countPeople
        }
      }}
        ,SetOptions(merge: true) );
  }

  Future<void> deleteExpense(Party party, String key) async {
    print(party.idParty +" "+key);
    await partyRef.doc(party.idParty ).set(
        {"expenses":{
          key: null}
          },SetOptions(merge: true)
    );

  }



  Future<Party> getParty(String uid) async{
    Party party;
    DocumentSnapshot documentSnapshot = await partyRef.doc(uid).get();
    print("holisss");
    if (documentSnapshot.exists) {
      party = Party.fromSnapshot(documentSnapshot.id, documentSnapshot.data());
    }
    return party;
  }

  Future<List<Party>> get() async {
    QuerySnapshot querySnapshot = await partyRef.get();
    return querySnapshot.docs
        .map((value) => Party.fromSnapshot(value.id, value.data()))
        .toList();
  }

  Future<void> addCar(Party party,Car car) async {
    final partyDocument = partyRef.doc(party.idParty);
    await carService.addCar(car).then((value) => {
      partyDocument.set({
        "cars": {
          value: true,
        }}
          ,SetOptions(merge: true) )
    });
  }
}





