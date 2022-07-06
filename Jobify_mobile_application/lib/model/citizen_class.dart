
import 'package:flutter/material.dart';

class Citizen extends ChangeNotifier{
  String? name;
  String? email;
  String? role;
  Citizen({required this.name, required this.email,required this.role});
  // String? token;
  // String? refToken;


// User? _user;
//
// User get user => _user!;
//
//
//
//
// void UpdateUser (String name, String email, String token, String refToken ){
//   _user = User(name: name, email: email, token: token, refToken: refToken);
//   notifyListeners();
//
//   // User _user =  User(name: name, email: email, token: token, refToken: refToken);
//
//
//
//
// }
}


Citizen item1 = new Citizen(
  name: "Sam",
  email: "sam@gmail.com",
  role: "Sales",
);

Citizen item2 = new Citizen(
  name: "John",
  email: "sam@gmail.com",
  role: "Cooking",
);
Citizen item3 = new Citizen(
  name: "Henry",
  email: "sam@gmail.com",
  role: "Sales",
);
Citizen item4 = new Citizen(
  name: "Tony",
  email: "sam@gmail.com",
  role: "Cleaning",
);
Citizen item5 = new Citizen(
  name: "Mark",
  email: "sam@gmail.com",
  role: "Technology",
);
Citizen item6 = new Citizen(
  name: "Nick",
  email: "sam@gmail.com",
  role: "Lawyer",
);

List <Citizen> myCitizen = [item1,item2,item3,item4,item5,item6];

