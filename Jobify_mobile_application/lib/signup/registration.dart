// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'package:api_project/pages/home_page.dart';
import 'package:api_project/services/userServices.dart';
import 'package:api_project/signup/secondReg.dart';
import 'package:flutter/material.dart';
// import 'package:iot_smart_park/main.dart';
// import 'package:iot_smart_park/user_data.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/citizen_provider.dart';

// import 'package:iot_smart_park/auth_service.dart';
// import 'package:iot_smart_park/screens/home_page.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final TextEditingController _name = new TextEditingController();
  final TextEditingController _lastName = new TextEditingController();
  final TextEditingController _nic = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _matchPassword = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldSignUpKey = GlobalKey();


  @override
  void initState() {
    super.initState();
  }

  String? _currentSelectedValue = "Citizen";

  @override
  Widget build(BuildContext context) {


    var _role = [
      "Citizen",
      "Company Officer",
    ];

    DropdownMenuItem <String> buildMenuRole(String item) =>
        DropdownMenuItem(
          value: item,
          child: Text(
            item,
          ),);

    OutlineInputBorder commonBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50.0),
      borderSide: BorderSide(
        color: Colors.lightBlueAccent,
      ),
    );

    // TextStyle commonTextStyle = Theme.of(context).textTheme.subtitle1;

    return Scaffold(
        key: _scaffoldSignUpKey,
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        // ),
        body: Stack(

          children: <Widget>[
            // Container(
            //     child: Image.asset("assets/images/login5.png")
            // ),

            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: <Widget>[

                      Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[
                            Text('Get Started',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                )),
                            Text('Please enter your correct information.',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.0,
                                  height: 1.5,
                                )),
                            Text('* Required',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    height: 1.5,
                                    color: Colors.red)),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.fromLTRB(25, 5, 25, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            // Name
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                toolbarOptions: const ToolbarOptions(
                                    copy: true,
                                    paste: true,
                                    cut: true,
                                    selectAll: false),
                                validator: (value) {
                                  String namePattern = r'^[A-Za-z ]{3,40}$';
                                  RegExp regExpName = new RegExp(namePattern);

                                  if (value!.isEmpty) {
                                    return 'Name is Missing';
                                  } else if (!regExpName.hasMatch(value)) {
                                    return 'Please enter a appropriate name';
                                  }
                                  return null;
                                },
                                controller: _name,
                                decoration: InputDecoration(
                                  border: commonBorder,
                                  focusedBorder: commonBorder,
                                  enabledBorder: commonBorder,
                                  labelText: 'Name With Initials *',
                                  // labelStyle: commonTextStyle,
                                ),
                                maxLines: 1,
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                toolbarOptions: const ToolbarOptions(
                                    copy: true,
                                    paste: true,
                                    cut: true,
                                    selectAll: false),
                                validator: (value) {
                                  String namePattern = r'^[A-Za-z ]{3,40}$';
                                  RegExp regExpName = new RegExp(namePattern);

                                  if (value!.isEmpty) {
                                    return 'Name is Missing';
                                  } else if (!regExpName.hasMatch(value)) {
                                    return 'Please enter a appropriate name';
                                  }
                                  return null;
                                },
                                controller: _lastName,
                                decoration: InputDecoration(
                                  border: commonBorder,
                                  focusedBorder: commonBorder,
                                  enabledBorder: commonBorder,
                                  labelText: 'Date Of Birth (mm/dd/yyyy) *',
                                  // labelStyle: commonTextStyle,
                                ),
                                maxLines: 1,
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                controller: _email,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'E-Mail is Missing';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: commonBorder,
                                  focusedBorder: commonBorder,
                                  enabledBorder: commonBorder,
                                  labelText: 'Email',
                                  // labelStyle: commonTextStyle,
                                ),
                                maxLines: 1,
                              ),
                            ),

                            FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    // labelStyle: textStyle,
                                    errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                    hintText: 'Please select expense',
                                    border: commonBorder,
                                    focusedBorder: commonBorder,
                                    enabledBorder: commonBorder,
                                  ),
                                      isEmpty: _currentSelectedValue == '',
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _currentSelectedValue,
                                      isDense: true,
                                      onChanged:(value) {
                                        setState(() {
                                          _currentSelectedValue=value;
                                          // getReportChart();
                                        });
                                      } ,
                                      items:_role.map(buildMenuRole).toList(),

                                    ),
                                  ),
                                );
                              },
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                toolbarOptions: const ToolbarOptions(
                                    copy: true,
                                    paste: true,
                                    cut: true,
                                    selectAll: false),
                                validator: (value) {
                                  String namePattern = r'^[A-Za-z ]{3,40}$';
                                  RegExp regExpName = new RegExp(namePattern);

                                  if (value!.isEmpty) {
                                    return 'Name is Missing';
                                  } else if (!regExpName.hasMatch(value)) {
                                    return 'Please enter a appropriate name';
                                  }
                                  return null;
                                },
                                controller: _nic,
                                decoration: InputDecoration(
                                  border: commonBorder,
                                  focusedBorder: commonBorder,
                                  enabledBorder: commonBorder,
                                  labelText: 'NIC No *',
                                  // labelStyle: commonTextStyle,
                                ),
                                maxLines: 1,
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: PasswordField(
                                controller: _password,
                                color: Colors.blue,
                                hasFloatingPlaceholder: true,
                                passwordConstraint: r'.*[@$#.*].*',
                                border:PasswordBorder(
                                  border: commonBorder,
                                  focusedBorder: commonBorder,
                                  enabledBorder: commonBorder,

                                  // OutlineInputBorder(
                                  //   borderSide: BorderSide(
                                  //     color: Colors.blue.shade100,
                                  //   ),
                                  //   borderRadius: BorderRadius.circular(12),
                                  // ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                    BorderSide(width: 2, color: Colors.red.shade200),
                                  ),
                                ),

                                // hintStyle: commonTextStyle,
                                errorMessage: 'minimum length is 6 charcters',
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                controller: _matchPassword,
                                obscureText: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'empty field..!';
                                  } else if (value != _password.text.toString()) {
                                    return 'password do not match';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: commonBorder,
                                  focusedBorder: commonBorder,
                                  enabledBorder: commonBorder,
                                  labelText: 'Confirm password',
                                  // labelStyle: commonTextStyle,
                                ),
                                maxLines: 1,
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              width: MediaQuery. of(context). size. width,

                              child:Align(
                                alignment: Alignment.topRight,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      child: Icon(Icons.arrow_forward_ios, color: Colors.lightBlueAccent),
                                    ),
                                    onTap: ()
                                    {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegSecond()));
                                    },                                                              //Add the navigation
                                  ),
                                ),
                              ),

                              // child: TextButton(
                              //     style: TextButton.styleFrom(
                              //       padding: EdgeInsets.symmetric(vertical: 10),
                              //       shape: StadiumBorder(),
                              //       backgroundColor: Colors.lightBlueAccent,
                              //     ),
                              //     child: Text(
                              //       'REGISTER',
                              //       style: Theme.of(context).textTheme.headline2?.copyWith(color: Colors.white, fontSize: 15),
                              //     ),
                              //     onPressed: (){
                              //       if (formKey.currentState!.validate()) {
                              //         // ScaffoldMessenger.of(context).showSnackBar(
                              //         //   const SnackBar(content: Text('Processing Data')),
                              //         // );
                              //         _register();
                              //       }
                              //     }
                              // ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}