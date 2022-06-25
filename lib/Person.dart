import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  Person() {
    name = <String, String>{};
    email="";
    imageUrl="";
    documentID="";
  }

  Person.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    email = data['email'];
    imageUrl = data['imageUrl'];
  }

  Person.fromDocumentSnapshot(DocumentSnapshot data) {
    documentID = data.id;
    imageUrl = data['imageUrl'];
    email = data['email'];
    name = <String, String>{
      'first': data['name']['first'],
      'last': data['name']['last']
    };
  }

  late String documentID;
  late Map<String, String> name;
  late String email;
  late String imageUrl;
}
