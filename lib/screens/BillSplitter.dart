import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:now_ui_flutter/data/billModel.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/services/party_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //IDIOMAS
import '../constants/Theme.dart';
import '../widgets/navbar.dart';

import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flutter/painting.dart' as prefix0;
import 'package:flutter/widgets.dart';


class BillSplitter extends StatefulWidget {
  Function() triggerRefetch;
  billModel existingBill;
  bool isNew = true;
  BillSplitter({Key key, Function() triggerRefetch, billModel existingBill,bool isNew})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.existingBill = existingBill;
    this.isNew = isNew;
  }
  @override
  _BillSplitterState createState() => _BillSplitterState();
}

class _BillSplitterState extends State<BillSplitter> {
  Party party;
  bool isDirty = false;
  bool isBillNew = true;
  bool save = false;
  FocusNode titleFocus = FocusNode();
  FocusNode totalFocus = FocusNode();

  billModel currentBill;
  TextEditingController titleController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  int _tipPercentage = 0;
  int _personCounter = 1;
  double _billAmount = 0;
  double perPerson = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.existingBill == null) {
      currentBill = billModel(
          title: '',total: '', countPeople: 0, amount: '');
      isBillNew = true;
    } else {
      currentBill = widget.existingBill;
      _personCounter = currentBill.countPeople;
      _billAmount = double.parse(currentBill.total);
      isBillNew = false;
    }
    titleController.text = currentBill.title;
    //amountController.text = currentBill.amount.toString();
    totalController.text = currentBill.total;
    //countPeopleController.text = currentBill.countPeople.toString();
    if(widget.isNew==null) widget.isNew = false;
  }

  @override
  Widget build(BuildContext context) {
    party = ModalRoute.of(context).settings.arguments as Party;
    return Scaffold(
        appBar: Navbar(
          title: AppLocalizations.of(context).bills,
          backButton: true,
          icon: Icons.check,
          iconTap: () {
            handleSave();
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
                      readOnly: widget.isNew,
                      focusNode: titleFocus,
                      autofocus: true,
                      cursorColor: NowUIColors.primary,
                      controller: titleController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onSubmitted: (text) {
                        //titleFocus.unfocus();
                        FocusScope.of(context).requestFocus(totalFocus);
                     },
                    onChanged: (value) {
                      markTitleAsDirty(value);
                    },
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        color: NowUIColors.white,
                        fontFamily: 'ZillaSlab',
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                    decoration: InputDecoration.collapsed(
                      hintText: AppLocalizations.of(context).title,
                      hintStyle: TextStyle(
                        //color: NowUIColors.success,
                          color: NowUIColors.white,
                          fontSize: 32,
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w700),
                      border: InputBorder.none,
                    ),
                  ),),
                ),
            Container(
              margin: EdgeInsets.only(top: 40.0),
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: NowUIColors.bgColorScreen,
                  border: Border.all(color: NowUIColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: <Widget>[
                  TextField(
                    focusNode: totalFocus,
                    autofocus: true,
                    controller: totalController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    maxLines: null,
                    onSubmitted: (text) {
                      totalFocus.unfocus();
                      //FocusScope.of(context).requestFocus(amountFocus);
                    },
                    onChanged: (String value) {
                      try {
                        _billAmount = double.parse(value);
                      } catch (exception) {
                        _billAmount = 0.0;
                      }
                    },
                    cursorColor: NowUIColors.primary,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.white ),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: NowUIColors.bgColorScreenTransparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: NowUIColors.bgColorScreenTransparent),
                      ),
                      hintText: AppLocalizations.of(context).bill_amount,
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: Colors.white,
                      ),
                      focusColor: Colors.white,
                      //contentPadding: EdgeInsets.only(right: 10)),
                    ),

                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: NowUIColors.primary,
                    height: 2,
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).split,
                        style: TextStyle(
                          color: NowUIColors.white,
                          fontSize: 17,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (_personCounter > 1) {
                                  _personCounter--;
                                } else {
                                  //do nothing
                                }
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: NowUIColors.primary,
                              ),
                              child: Center(
                                child: Text(
                                  '-',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: NowUIColors.white,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '$_personCounter',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xffffffff),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _personCounter++;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: NowUIColors.primary,
                              ),
                              child: Center(
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  color: NowUIColors.bgColorScreen,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).per_person,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: NowUIColors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '\$${calculateTotalPerPerson(_billAmount, _personCounter, _tipPercentage)}',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ))
    );
  }

  void handleSave() async {
    PartyService partyService = PartyService();
    setState(() {
      currentBill.title = titleController.text;
      currentBill.amount = perPerson.toString();
      currentBill.total = totalController.text;
      currentBill.countPeople = _personCounter;
      print('Hey there ${currentBill.title}');
    });
    await partyService.addExpense(currentBill.title, (int.parse(currentBill.total)),currentBill.countPeople, party);
    titleFocus.unfocus();
    handleBack();
  }

  void markTitleAsDirty(String title) {
    setState(() {
      isDirty = true;
    });
  }

  void markContentAsDirty(String content) {
    setState(() {
      isDirty = true;
    });
  }

  void handleDelete() async {
    if (isBillNew) {
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text(AppLocalizations.of(context).delete_bill),
              content: Text( AppLocalizations.of(context).permanent_bill),
              actions: <Widget>[
                FlatButton(
                  child: Text(AppLocalizations.of(context).delete,
                      style: prefix0.TextStyle(
                          color: Colors.red.shade300,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                  onPressed: () async {
                    PartyService partyService = PartyService();
                    await partyService.deleteExpense(party, currentBill.title);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text(AppLocalizations.of(context).cancel,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
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

  calculateTotalPerPerson(double billAmount, int splitBy, int tipPercentage) {
      var totalPerPerson =
          (calculateTotalTip(billAmount, splitBy, tipPercentage) + billAmount) /
              splitBy;
      perPerson = totalPerPerson;
      return totalPerPerson.toStringAsFixed(2);
  }

  calculateTotalTip(double billAmount, int splitBy, int tipPercentage) {
    double totalTip = 0.0;
    if (billAmount < 0 || billAmount.toString().isEmpty || billAmount == null) {
    } else {
      totalTip = (billAmount * tipPercentage) / 100;
    }
    return totalTip;
  }

  void handleBack() {
    Navigator.pop(context);
  }

}