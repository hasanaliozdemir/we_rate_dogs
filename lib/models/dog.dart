import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender {
  Male,
  Female,
  Other,
}

class Dog {
  bool ethicsAgreement;
  String birthdate;
  String name;
  Gender gender;
  String imageUrl;
  int id;
  int vote;
  DocumentReference reference;
  int genderNum;

  Dog.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map["name"] != null),
        assert(map["vote"] != null),
        assert(map["image_url"] != null),
        assert(map["birthdate"] != null),
        assert(map["genderNum"] != null),
        assert(map["ethicsAgreement"] != null),
        name = map["name"],
        vote = map["vote"],
        imageUrl = map["image_url"],
        birthdate = map["birthdate"],
        genderNum = map["genderNum"],
        ethicsAgreement = map["ethicsAgreement"];

  Dog.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Dog.withoutInfo()
      : name = "",
        vote = null,
        id = null,
        imageUrl = "",
        ethicsAgreement = false,
        birthdate = null,
        genderNum = null;
}
