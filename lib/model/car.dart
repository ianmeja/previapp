class Car {
  String idCar;
  String idParty;
  String description;
  String title;
  String from;
  int max;
  String host;
  Map<String, dynamic> guest;

  Car(String idParty, String description,String from,int max, String title, Map<String,dynamic> guest, String host ) {
    this.idParty = idParty;
    this.description = description;
    this.title = title;
    this.from = from;
    this.guest = guest;
    this.max = max;
    this.host = host;
  }

  Car.fromSnapshot(Map<String, dynamic> car){
    idCar= car['idCar'];
    idParty = car['idParty'];
    guest=car['guest'];
    title = car['title'];
    from = car['from'];
    max = car['max'];
    host= car['host'];
    description=car['description'];
  }

  Map<String,dynamic> toMap() => {
    "idParty": this.idParty,
    "guest": this.guest,
    "title": this.title,
    "from": this.from,
    "max": this.max,
    "host": this.host,
    "description" : this.description,
  };

}