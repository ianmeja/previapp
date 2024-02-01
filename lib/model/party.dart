class Party {
  String name;
  String idParty;
  String host;
  DateTime date;
  String dir;
  String description;
  int maxGuests;
  String partyPic;
  Map<String, dynamic> guest;
  Map<String, dynamic> expenses;
  Map<String, dynamic> polls;
  Map<String, dynamic> cars;
  Map<String,dynamic> task;

  Party(String description, String dir, String name, String host, DateTime date, Map<String, dynamic> guest,Map<String,dynamic> expenses,Map<String,dynamic> polls,Map<String,dynamic> cars,Map<String,dynamic> task) {
    this.description = description;
    this.task = task;
    this.expenses = expenses;
    this.polls = polls;
    this.cars = cars;
    this.dir = dir;
    this.maxGuests = 10;
    this.name = name;
    this.host = host;
    this.date = date;
    this.guest = guest;
  }

  Party.fromSnapshot(String idParty, Map<String, dynamic> party){
    this.idParty = idParty;
    host = party['host'];
    description = party['des'];
    name = party['name'];
    dir = party['dir'];
    maxGuests = party['maxGuests'];
    expenses = party['expenses'];
    partyPic = party['partyPic'];
    polls = party['polls'];
    cars = party['cars'];
    task = party['task'];
    date = DateTime.fromMicrosecondsSinceEpoch( party['date'].microsecondsSinceEpoch);
    guest = party['guest'];

  }

  Map<String, dynamic> toMap() => {
    "name": this.name,
    "host": this.host,
    "dir": this.dir,
    "polls": this.polls,
    "cars": this.cars,
    "expenses":this.expenses,
    "maxGuests": this.maxGuests,
    "partyPic": this.partyPic,
    "task":this.task,
    "des": this.description,
    "date": this.date,
    "guest": this.guest
  };



}