
import 'package:flutter/material.dart';
import '../model/citizen_class.dart';

class CitizenProvider extends ChangeNotifier{

  Citizen? _user;
  Citizen get user => _user!;

  void UpdateUser (String name, String email, String role,  ){

    _user = Citizen(name: name, email: email, role: role);

    notifyListeners();

    // User _user =  User(name: name, email: email, token: token, refToken: refToken);

  }
}