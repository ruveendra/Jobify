// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:api_project/model/citizen_class.dart';
import 'package:api_project/pages/home_page.dart';
import 'package:api_project/provider/citizen_provider.dart';
import 'package:api_project/services/userServices.dart';
import 'package:api_project/signup/registration.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:passwordfield/passwordfield.dart';
import '../pages/officerDashboard.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  Timer? timer;
  bool isLoading = false;


  Future<bool> _onBackPressed() {
    return  showDialog <bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you really want to exit the app?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  _checkConnectivity()async{
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() => isLoading = false);
      _showDialog();
    }
  }

  _showDialog(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('No Internet'),
            content: Text('Please check your internet connection and try again'),
            actions: [
              FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Ok'))
            ],
          );
        }
    );

  }

  _showMsg(msg) {
    //
    final snackBar = SnackBar(
      backgroundColor: Colors.blueGrey,
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  _login() async {
    var data = {
      'email': _email.text,
      'password': _password.text,
    };
    var body;
    try{
      var response = await CallApi().postData(data, '/login').timeout(Duration(seconds: 10));
      body = json.decode(response.body);
      print(response.statusCode);
      if (response.statusCode == 201){
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', body['token']);
        localStorage.setString('role', body['userRole']);
        setState(() => isLoading = false);
        localStorage.getString('role')=="citizen_role" ?
        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (context) => HomePage())):
        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (context) => OfficerDashboard()));
      } else {
        _showMsg("Invalid Credentials");
        // context.read<CitizenProvider>().UpdateUser (body['token'], body['user']['email'], body['user']['access'], );
        // Citizen user= new Citizen(name: body['user']['username'], email: body['user']['email'], token:body['user']['access'], refToken:body['user']['refresh'] );
        // Get Devices
        // return response;
        // var body=json.decode(response.body);
        // print(body);
      }
    }on TimeoutException catch (e) {
      _showMsg("Something Went Wrong");
      setState(() => isLoading = false);
      // handle timeout
    }
  }

  @override
  void initState() {
    // _try_login();
    super.initState();
    _checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder commonBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(
        color: Colors.blueGrey,
      ),
    );

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Container(
            //     child: Image.asset("assets/images/login5.png")
            // ),
            Center(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top:100.0),
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Image.asset("assets/images/science.png"),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "JOB4U",
                            style: Theme.of(context).textTheme.headline1?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 35.0
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10,),
                          child: TextFormField(
                            controller: _email,
                            autofocus: false,
                            decoration: InputDecoration(
                              border: commonBorder,
                              focusedBorder: commonBorder,
                              enabledBorder: commonBorder,
                              labelText: 'Email Address',
                              labelStyle: Theme.of(context).textTheme.subtitle1,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10,),
                          child: TextField(
                            controller: _password,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: commonBorder,
                              focusedBorder: commonBorder,
                              enabledBorder: commonBorder,
                              labelText: 'Password',
                              labelStyle: Theme.of(context).textTheme.subtitle1,
                            ),

                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Container(
                            width: 250,
                            child: ElevatedButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  backgroundColor: Colors.blueGrey,
                                  shape: StadiumBorder(),
                                ),
                                child: isLoading ?

                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Container(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.deepOrangeAccent[100],
                                          )
                                      ),
                                      const SizedBox(width: 24,),
                                      Text('Please Wait...')

                                    ]
                                ):

                                Text(
                                  'Login',
                                  style: Theme.of(context).textTheme.headline2?.copyWith(color: Colors.white, fontSize: 20),
                                ),
                                onPressed:()async{
                                  setState(() => isLoading = true);
                                  // await _checkConnectivity();
                                  await _login();



                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));

                                }
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "Don't have an account?",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                                fontSize: 14.0,
                              ),
                            ),
                            TextButton(
                                child: Text(
                                  'Register Now',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headline4?.copyWith(color:Colors.blue, fontSize: 16 ),
                                ),
                                onPressed:

                                    () async {
                                  await _checkConnectivity();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                                }
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
