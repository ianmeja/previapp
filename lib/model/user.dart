
import 'package:now_ui_flutter/model/party.dart';

class MyUser {
  String uId;
  String username;
  String email;
  String description;
  String profilePic;
  Map<String,dynamic> myParty;
  Map<String,dynamic> guestParty;

  static const String collectionId = 'users';
  MyUser(
      {this.uId,
        this.username,
        this.description,
        // this.photo,
        this.email});

  MyUser.fromSnapshot(String uid, Map<String, dynamic> user)
      : uId = uid,
        username = user['username'],
        email = user['email'],
        description = user['description'],
        myParty = user['myparty'],
        profilePic = user['profilePic'],
        guestParty = user['party'];

  Map<String, dynamic> toMap() => {
    'username': username,
    'email': email,
    'description' : description,
    'profilePic' : profilePic

  };

  @override
  String toString() {
    return 'user{uId: $uId, username: $username, email: $email}';
  }
}