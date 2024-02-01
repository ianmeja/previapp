import 'dart:math';

class NotesModel {
  String title;
  String content;
  NotesModel(String title, String content){
    this.content = content;
    this.title = title;
  }

  NotesModel.fromMap(Map<String, dynamic> map) {
    this.title = map['title'];
    this.content = map['content'];
  }

}