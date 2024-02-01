
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/Theme.dart';
import '../constants/Theme.dart';
import '../constants/Theme.dart';
import '../data/billModel.dart';

class BillCardComponent extends StatelessWidget {
  const BillCardComponent({
    this.billData,
    this.onTapAction,
    Key key,
  }) : super(key: key);

  final billModel billData;
  final Function(billModel billData) onTapAction;

  String roundnum(String num) {
    int aux = int.parse(num);
    //aux.round()
    print("amount en int");
    print(aux);
    String aux2 = aux.toString();
    print("amount en string");
    print(aux2);
    return aux2;
  }

    @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 1, 10, 8),
        height: 125,
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
              onTapAction(billData);
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
                            '${billData.title.trim().length <= 20 ? billData.title.trim() : billData.title.trim().substring(0, 20) + '...'}',
                            style: TextStyle(
                                color: NowUIColors.white,
                                fontFamily: 'ZillaSlab',
                                fontSize: 20),
                          ),
                        ],),
                    ],),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      'Total: \$ ${billData.total}\nCantidad de personas: ${billData.countPeople}\nPor persona: \$ ${double.parse(billData.amount).round().toString()}',
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
}