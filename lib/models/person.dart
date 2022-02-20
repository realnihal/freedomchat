class Person {
  String? uid;
  String? name;
  String? email;
  String? username;
  String? status;
  int? state;
  String? profilePhoto;

  Person({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.state,
    this.profilePhoto,
  });

  Map toMap(Person person) {
    var data = Map<String, dynamic>();
    data['uid'] = person.uid;
    data['name'] = person.name;
    data['email'] = person.email;
    data['username'] = person.username;
    data["status"] = person.status;
    data["state"] = person.state;
    data["profilePhoto"] = person.profilePhoto;
    return data;
  }

  Person.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profilePhoto'];
  }
}
