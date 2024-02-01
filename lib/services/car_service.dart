import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:now_ui_flutter/model/car.dart';
import 'package:now_ui_flutter/services/party_service.dart';

class CarService {

  CollectionReference carRef = FirebaseFirestore.instance.collection('cars');

  Future<String> addCar(Car car) async{
    String id;
    await carRef.add((car).toMap())
        .then((value) => {id = value.id});
    return id;
  }

  Future<String> addCarGuest(String uid, Car car) async{
    car.guest.putIfAbsent(uid, () => true);
    carRef.doc(car.idCar).set({
      "guest": {
        uid : "true"
      }}
        ,SetOptions(merge: true) );
  }


  Future<Car> getCar(String uid) async{
    Car car;
    DocumentSnapshot documentSnapshot = await carRef.doc(uid).get();
    if (documentSnapshot.exists) {
      car = Car.fromSnapshot(documentSnapshot.data());
    }
    return car;
  }

  Future<void> deleteGuest(String id, Car car) async{
    await carRef.doc(car.idCar ).set(
        {"guest":{
          id: null}
        },SetOptions(merge: true)
    );

  }

  Future<void> deleteCar(Car car){
    PartyService partyService = new PartyService();
    partyService.deleteCar(car.idParty, car.idCar);
    carRef.doc(car.idCar).delete();
  }

  //llama a todos los autos
  Future<List<Car>> get() async {
    QuerySnapshot querySnapshot = await carRef.get();
    return querySnapshot.docs
        .map((value) => Car.fromSnapshot(value.data()))
        .toList();
  }






}
