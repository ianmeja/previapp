import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //IDIOMAS
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/services/party_service.dart';
import 'package:now_ui_flutter/widgets/faderoute.dart';
import 'package:now_ui_flutter/data/billModel.dart';
import 'package:now_ui_flutter/screens/billView.dart';
import '../constants/Theme.dart';
import '../widgets/navbar.dart';
import '../widgets/bill-card.dart';

class Bills extends StatefulWidget {
  Function(Brightness brightness) changeTheme;
  Bills({Key key, this.title, Function(Brightness brightness) changeTheme})
      : super(key: key) {
    this.changeTheme = changeTheme;
  }

  final String title;

  @override
  _BillsState createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  bool isFlagOn = false;
  bool headerShouldHide = false;
  List<billModel> billsList = [];
  TextEditingController searchController = TextEditingController();

  PartyService partyService = PartyService();

  Party party;
  Future<List<billModel>> builder;

  @override
  void initState() {
    super.initState();
  }

  Future<List<billModel>> setBillsFromDB() async{
    billsList = [];
    await partyService.getParty(party.idParty).then((value) => {
      party = value,
      print("loaded"+value.expenses.keys.first)
    });
    print(party.idParty.toString());
    int i = 0;
    if (party!=null)
        party.expenses.entries.forEach((element) {
          if (element.value!=null)
          billsList.add(
              billModel.fromMap(
                  {'_id' : i++,
                    'title' : element.key.toString(),
                    'total' :element.value['price'].toString(),
                    'countPeople' : (element.value['countPeople']),
                    'amount' : element.value['amount'].toString()
                  })
          );
      });
    else
      print("not working");
    return billsList;
  }

  @override
  Widget build(BuildContext context) {
    party = ModalRoute.of(context).settings.arguments as Party;
    builder = setBillsFromDB();
    return Scaffold(
      appBar: Navbar(
        title: AppLocalizations.of(context).bills,
        backButton: true,
      ),
      backgroundColor: NowUIColors.bgColorScreen,
      floatingActionButton: FloatingActionButton(
      backgroundColor: NowUIColors.primary,
      onPressed: () {
        Navigator.of(context)
            .pushNamed("/billSplitter", arguments: party)
            .then((value) => setState(() => {
        }));
      },

    child: Icon(Icons.add),
    ),
      body: FutureBuilder<List<billModel>> (
        future: builder,
        builder: (BuildContext context, AsyncSnapshot<List<billModel>> snapshot) {
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
                    ...buildBillComponentsList(),
                    Container(height: 100)
                  ],
                ),
                margin: EdgeInsets.only(top: 2),
                padding: EdgeInsets.only(left: 15, right: 15),
              ),
            );
           } else {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children : [
                  Center(
                      child: Padding(
                          padding: EdgeInsets.all(20),
                          child: new Image.asset('assets/imgs/logo.png', height: 100,)
                      )
                  ),
                  Text(AppLocalizations.of(context).not_bills,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: NowUIColors.white,
                      fontSize: 20,
                    ),
                  ),
                ]
            );
          }
        },)

    );
  }

  List<Widget> buildBillComponentsList() {
    List<Widget> billComponentsList = [];
    billsList.sort((a, b) {
      return b.id.compareTo(a.id); //TODO hacerlo por fecha
    });
    billsList.forEach((bill) {
      billComponentsList.add(BillCardComponent(
        billData: bill,
        onTapAction: openBillToRead,
      ));
    });

    return billComponentsList;
  }

  void gotoAddBill() {
    // Navigator.pushNamed(
    //     context,
    //     '/billSplitter',arguments: party);
  }

  // void refetchBillFromDB() async {
  //   await setBillsFromDB();
  //   print("Refetched bills");
  // }

  openBillToRead(billModel billData) async {
    setState(() {
      headerShouldHide = true;
    });
    await Future.delayed(Duration(milliseconds: 230), () {});
    Navigator.push(
        context,
        FadeRoute(
            page: ViewBillPage(
                party: party, currentBill: billData))).then((value) => {
                  setBillsFromDB()
    });
    await Future.delayed(Duration(milliseconds: 300), () {});

    setState(() {
      headerShouldHide = false;
    });
  }
}

