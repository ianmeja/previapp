import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/model/user.dart';
import 'package:now_ui_flutter/services/party_service.dart';

class UserService {

  CollectionReference userRef =
  FirebaseFirestore.instance.collection(MyUser.collectionId);
  PartyService partyService = new PartyService();

  Future<void> create(MyUser user) async {
    final userDocument = userRef.doc(user.uId);
    userDocument.set(user.toMap());
  }

  Future<String> addParty(Party party,MyUser user) async {
    final userDocument = userRef.doc(user.uId);
    String ans;
    await partyService.addParty(party).then((value) => {
      ans = value,
      userDocument.set({
        "myparty": {
          value: true,
        }}
          ,SetOptions(merge: true) )
    });
    return ans;
  }

  Future<MyUser> getCurrentUser() async{
    return await getById(FirebaseAuth.instance.currentUser.uid);
  }

  Future<void> editProfile(MyUser myUser) async{
    final userDocument = userRef.doc(myUser.uId);
    await userDocument.set(
        myUser.toMap(),
        SetOptions(merge: true)
    );
  }
  Future<void> deleteMyParty(String id, String idParty) async{
    final userDocument = userRef.doc(id);
    await userDocument.set(
        {"myparty":{
          idParty : null}
        },SetOptions(merge: true)
    );

  }
  Future<void> deletePartyGuest(String id, String idParty) async {
    final userDocument = userRef.doc(id);
    await userDocument.set(
        {"party":{
          idParty : null}
        },SetOptions(merge: true)
    );

  }

  Future<void> addGuestParty(Party party,String id) async {
    final userDocument = userRef.doc(id);
    await partyService.addGuest(id,party);
     userDocument.set({
        "party": {
         party.idParty: true,
        }}
          ,SetOptions(merge: true) );
   }

  Future<List<Party>> getHostPartys(MyUser user) async{
    List<Party> partyList = List();
    await getById("WOfNYPZxYhgbsCBswE1Cc725qVk2").then((value) => {
      value.myParty.keys.forEach((element) {
        partyService.getParty(element).then((value1) => {
          partyList.add(value1),
        });
      }),
    });
    return partyList;
  }

  Future<MyUser> getById(String uid) async {
    MyUser user;
    DocumentSnapshot documentSnapshot = await userRef.doc(uid).get();
    if (documentSnapshot.exists) {
      user =
          MyUser.fromSnapshot(documentSnapshot.id, documentSnapshot.data());
    }
    return user;
  }

  Future<List<MyUser>> get() async {
    QuerySnapshot querySnapshot = await userRef.get();
    return querySnapshot.docs
        .map((ds) => MyUser.fromSnapshot(ds.id, ds.data()))
        .toList();
  }

}
