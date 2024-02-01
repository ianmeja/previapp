import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/model/party.dart';
import 'package:now_ui_flutter/services/party_service.dart';
import 'package:now_ui_flutter/services/users_service.dart';
import 'package:now_ui_flutter/widgets/drawer.dart';
import 'package:now_ui_flutter/widgets/faderoute.dart';
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:now_ui_flutter/widgets/transport-card.dart';
import 'package:now_ui_flutter/model/car.dart';
import 'package:now_ui_flutter/services/car_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Transport extends StatefulWidget {
  @override
  _TransportState createState() => _TransportState();
}

class _TransportState extends State<Transport> {
  List<Car> carsList = [];
  TextEditingController searchController = TextEditingController();

  Party party;
  PartyService partyService = PartyService();
  CarService carService = CarService();
  Future<List<Car>> loading;

  Future<List<Car>> getCars(Party party) async {
    await PartyService().getParty(party.idParty).then((value) => {
      party = value,
    });
    List<Car> carCards = [];
    for (var partyid in party.cars.keys) {
      await carService.getCar(partyid).then((value1) => {
        if (value1!=null){
          carCards.add(value1),
          carCards[carCards.length - 1].idCar = partyid,
        }
      });
    }
    return carCards;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    party = ModalRoute.of(context).settings.arguments as Party;
    loading = getCars(party);
    return Scaffold(
        appBar: Navbar(
          title: AppLocalizations.of(context).transport,
          backButton: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: NowUIColors.primary,
          onPressed: () {
            Navigator.pushNamed(context, '/createTransport', arguments: party).then((value) => setState(() => {}));
          },

          child: Icon(Icons.add),
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        body:
          FutureBuilder<List<Car>>(
                  future: loading,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Car>> snapshot) {
                    if (snapshot.hasData && snapshot.data.isNotEmpty) {
                      return Container(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[for (var car in snapshot.data)
                              TransportCard(
                                  title: (car.title != null)
                                      ? car.title
                                      : AppLocalizations.of(context).not_title,
                                  from: (car.from != null)
                                      ? car.from
                                      : AppLocalizations.of(context).not_address,
                                  description: (car.description != null)
                                      ? car.description
                                      : AppLocalizations.of(context).not_description,
                                  friends: (car.guest != null)
                                      ? car.guest.entries
                                      : AppLocalizations.of(context).empty_car,
                                  max: (car.max != null)
                                      ? car.max
                                      : 0,
                                  host: car.host,
                                  deleteTap: () async { await deleteCar(car);},
                                  isOn: (car.guest.containsKey(FirebaseAuth.instance.currentUser.uid) && car.guest[FirebaseAuth.instance.currentUser.uid] != null) || car.host == FirebaseAuth.instance.currentUser.uid,
                                  tap:  () async{
                                    if(car.guest.containsKey(FirebaseAuth.instance.currentUser.uid) && car.guest[FirebaseAuth.instance.currentUser.uid] != null)
                                      await removeFriend(car);
                                    else
                                      await addFriend(car);
                                  }
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    else
                      return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 10.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children : [
                                Center(
                                    child: new Image.asset('assets/imgs/logo.png', height: 100,)
                                ),
                                Text(AppLocalizations.of(context).not_transport,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: NowUIColors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ]
                          ),);
                  }
              )

    );
  }


  addFriend(Car car) async {
    await carService.addCarGuest(FirebaseAuth.instance.currentUser.uid, car);
    setState(() {

    });
  }

  removeFriend(Car car) async {
    await carService.deleteGuest(FirebaseAuth.instance.currentUser.uid, car);
    setState(() {

    });
  }

  deleteCar(Car car) async {
    await carService.deleteCar(car);
    setState(() {

    });
  }
}
