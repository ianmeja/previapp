class pollModel {
  String question;
  String option1;
  String option2;
  String option3;
  String owner;
  Map<String,dynamic> votes;

  pollModel({ this.question, this.option1, this.option2, this.option3, this.votes,this.owner});

  pollModel.fromMap(Map<String, dynamic> map) {
    this.question = map['question'];
    this.option1 = map['option1'];
    this.option2 = map['option2'];
    this.option3 = map['option3'];
    this.votes = map['votes'];
    this.owner = map['owner'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      question: {
        'option1': this.option1,
        'option2': this.option2,
        'option3': this.option3,
        'votes': this.votes,
        'owner': this.owner
      }
    };
  }
}