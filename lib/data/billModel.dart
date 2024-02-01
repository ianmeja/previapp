import 'dart:ffi';
import 'dart:math';

class billModel {
  int id;
  String title;
  String total;
  int countPeople;
  String amount;

  billModel({this.id, this.title,this.total, this.countPeople, this.amount});

  billModel.fromMap(Map<String, dynamic> map) {
    this.id = map['_id'];
    this.title = map['title'];
    this.total = map['total'];
    this.countPeople = map['countPeople'];
    this.amount = map['amount'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': this.id,
      'title': this.title,
      'total': this.total,
      'countPeople': this.countPeople,
      'amount': this.amount
    };
  }


}