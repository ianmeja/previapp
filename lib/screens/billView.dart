import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:now_ui_flutter/data/billModel.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/screens/BillSplitter.dart';
import 'package:now_ui_flutter/services/party_service.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //IDIOMAS

import '../constants/Theme.dart';
import '../constants/Theme.dart';

class ViewBillPage extends StatefulWidget {
  Party party;
  billModel currentBill;

  ViewBillPage({Key key, Party party, billModel currentBill})
      : super(key: key) {
    this.party = party;
    this.currentBill = currentBill;
  }
  @override
  _ViewBillPageState createState() => _ViewBillPageState();
}

class _ViewBillPageState extends State<ViewBillPage> {

  Party party;
  @override
  void initState() {
    super.initState();
    showHeader();
  }

  void showHeader() async {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        headerShouldShow = true;
      });
    });
  }

  bool headerShouldShow = false;
  @override
  Widget build(BuildContext context) {

    party = ModalRoute.of(context).settings.arguments as Party;
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
                  child: AnimatedOpacity(
                    opacity: headerShouldShow ? 1 : 0,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                    child: Text(
                      widget.currentBill.title,
                      style: TextStyle(
                        color: NowUIColors.white,
                        fontFamily: 'ZillaSlab',
                        fontWeight: FontWeight.w700,
                        fontSize: 36,
                      ),
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, top: 36, bottom: 24, right: 24),
                  child: Text(
                    'Total: \$ ${widget.currentBill.total }\nPor persona: \$ ${double.parse(widget.currentBill.amount).round().toString()}\nCantidad de personas: ${widget.currentBill.countPeople}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: NowUIColors.white),
                  ),
                )
              ],
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
                          IconButton(
                              icon: Icon(OMIcons.edit),
                              onPressed: handleEdit,
                              color: NowUIColors.white
                          ),
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ));
  }

  void handleSave() async {
    PartyService partyService = PartyService();
    await partyService.addExpense(widget.currentBill.title,
        (int.parse(widget.currentBill.total)),
        widget.currentBill.countPeople,
        party);
  }


  void handleEdit() {
    Navigator.pop(context);
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => BillSplitter(
              existingBill: widget.currentBill,isNew:true)
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
            title: Text(AppLocalizations.of(context).delete_bill),
            content: Text(AppLocalizations.of(context).permanent_bill),
            actions: <Widget>[
              FlatButton(
                child: Text(AppLocalizations.of(context).delete.toUpperCase(),
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () async {
                  PartyService partyService = PartyService();
                  await partyService.deleteExpense(widget.party, widget.currentBill.title);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(AppLocalizations.of(context).cancel.toUpperCase(),
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