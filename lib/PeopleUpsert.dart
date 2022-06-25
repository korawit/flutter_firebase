import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Person.dart';

class PeopleUpsert extends StatefulWidget {
  @override
  _PeopleUpsertState createState() => _PeopleUpsertState();
}

class _PeopleUpsertState extends State<PeopleUpsert> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  late Person? _person;

  @override
  Widget build(BuildContext context) {
    _person = ModalRoute.of(context)?.settings.arguments as Person?;
    _person = (_person == null) ? Person() : _person;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'People Maintenance',
        ),
      ),
      body: _body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _key.currentState!.save();
          // Save the person here.
          updatePersonToFirestore(_person!);
          Navigator.pop<Person>(context, _person);
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Widget get _body {
    return Form(
      key: _key,
      child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              personFormField(
                  labelText: 'First name', initialValue: _person!.name['first'].toString(), fieldName: ''),
              personFormField(
                  labelText: 'Last name', initialValue: _person!.name['last'].toString(), fieldName: ''),
              personFormField(labelText: 'Email', initialValue: _person!.email, fieldName: ''),
              personFormField(
                  labelText: 'Image URL', initialValue: _person!.imageUrl, fieldName: ''),
            ],
          )),
    );
  }

  Widget personFormField(
      {required String labelText, required String fieldName, required String initialValue}) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: labelText),
      onSaved: (String? val) {
        //_person[fieldName] = val;
        switch (labelText) {
          case 'First name':
            _person?.name['first'] = val!;
            break;
          case 'Last name':
            _person?.name['last'] = val!;
            break;
          case 'Email':
            _person?.email = val!;
            break;
          case 'Image URL':
            _person?.imageUrl = val!;
            break;
          default:
            throw "Bad person field name. I don't know $labelText";
        }
      },
    );
  }

  // Add/update document in collection "people". This one function
  // works for both cases since _person.documentID is null for a
  // new record and Firestore will add/insert a document if the 
  // documentID can't be found.
void updatePersonToFirestore(Person person) {
    if(_person?.documentID!=""){
    FirebaseFirestore.instance
        .collection('people')
        .doc(_person?.documentID)
        .set(<String, dynamic>{
      'name': person.name,
      'email': person.email,
      'imageUrl': person.imageUrl,
    }).then<void>((dynamic doc) {
      print('Document successfully written! $doc');
    }).catchError((dynamic error) {
      print('Error! $error');
    });
    }
    else
    {
      FirebaseFirestore.instance
        .collection('people')
        .add(<String, dynamic>{
      'name': person.name,
      'email': person.email,
      'imageUrl': person.imageUrl,
    }).then<void>((dynamic doc) {
      print('Document successfully added! $doc');
    }).catchError((dynamic error) {
      print('Error! $error');
    });
    }
  }
}
