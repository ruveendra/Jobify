import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/home_page.dart';
import '../provider/citizen_provider.dart';
import '../services/userServices.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';

class RegSecond extends StatefulWidget {

  String? name;
  String? dob;
  String? email;
  String? role;
  String? nic;
  String? password;
  RegSecond({this.name,this.dob,this.email,this.role,this.nic,this.password});



  @override
  _RegSecondState createState() => _RegSecondState();
}

class _RegSecondState extends State<RegSecond> with SingleTickerProviderStateMixin {

  String? name;
  String? dob;
  String? email;
  String? role;
  String? nic;
  String? password;
  _RegSecondState({this.name,this.dob,this.email,this.role,this.nic,this.password});

  _register() async {
    var data = {
      'name': name,
      'dob': dob,
      'email': email,
      'role': role,
      'nic': nic,
      'password': password,
      'lat': lat,
      'long': long,
      'speciality': _name.text,
    };

    var emaillogin = _email.text;
    var passwordlogin = _password.text;
    try{
      var res = await CallApi().postData(data, 'user/');
      var body = json.decode(res.body);
      print(body);
      if (body['message']== 'User Created') {
        _login(emaillogin,passwordlogin);
      }
    } catch (e){
      Navigator.of(context).pop();
      // print('Error: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'SignUp Failed',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Invalid E-mail or Password or user already exists, please try with different details',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('close'),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        ),
      );
    }
  }



  final TextEditingController _name = new TextEditingController();
  final TextEditingController _lastName = new TextEditingController();
  final TextEditingController _nic = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _matchPassword = new TextEditingController();

  final formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldSignUpKey = GlobalKey();
  String? _currentSelectedValue = "Citizen";
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  Timer? _debounce;
  late LatLng currentPostion;
  String load = 'loading';
  List<Marker> _markers = <Marker>[];

  late String lat;
  late String long;




  late GoogleMapController _googleMapController;
  // Marker _origin;
  // Marker _destination;
  // Directions _info;

  // void getLocation() async { Position position = await Geolocator .getCurrentPosition(desiredAccuracy: LocationAccuracy.high); print(position); }

  void _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    // LocationPermission permission = await Geolocator.checkPermission();
    var position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
      lat= currentPostion.latitude.toString();
      long= currentPostion.longitude.toString();
      _markers.add(
          Marker(
              markerId: const MarkerId('Your Location'),
              position: currentPostion,
              infoWindow: const InfoWindow(
                  title: 'This is your current location'
              )
          )
      );

      load = 'finished';
      print(currentPostion);
    });
  }


  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    String apiKey = 'AIzaSyDVT8J9CfLFXDk3axP9Ae5fP099XpPOsn4';
    googlePlace = GooglePlace(apiKey);
    _getUserLocation();


  }

  void autoCompleteSearch(String value) async {

    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      print(value);
      print(result.predictions!.first.description);
      setState(() {
        predictions = result.predictions!;
      });
    }
  }


  OutlineInputBorder commonBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(50.0),
    borderSide: BorderSide(
      color: Colors.lightBlueAccent,
    ),
  );


  _login(String email, String password ) async {
    var data = {
      'email': email,
      'password':password,
    };
    print(data['password']);
    print(data['email']);

    var response = await CallApi().postData(data, 'auth/login');
    var body;
    if (response.body.isNotEmpty) {
      body = json.decode(response.body);
      print(body);
      // _showMsg("Test");
    } else {
      print("Empty");
    }

    if (body['error'] != 'Wrong login credentials') {
      SharedPreferences localStorage = await SharedPreferences.getInstance();

      localStorage.setString('token', body['user']['access']);
      localStorage.setString('refToken', body['user']['refresh']);
      localStorage.setString('username', body['user']['username']);
      localStorage.setString('email', body['user']['email']);// assign the second api (refApi)
      localStorage.setString('user', json.encode(body['user']));

      context.read<CitizenProvider>().UpdateUser (body['user']['username'], body['user']['email'], body['user']['access']);
      // User user= new User(name: body['user']['username'], email: body['user']['email'], token:body['user']['access'], refToken:body['user']['refresh'] );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));

    } else {

      _showMsg("Something Went Wrong");

    }
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

                            FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      // labelStyle: textStyle,
                                        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                        hintText: 'Please select expense',
                                        border: commonBorder,
                                        focusedBorder: commonBorder,
                                        enabledBorder: commonBorder,),
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
                                controller: _name,
                                decoration: InputDecoration(
                                  border: commonBorder,
                                  focusedBorder: commonBorder,
                                  enabledBorder: commonBorder,
                                  labelText: 'Name With Initials *',
                                  // labelStyle: commonTextStyle,
                                ),
                                maxLines: 1,
                                onChanged: (value) {
                                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                                  _debounce = Timer(const Duration(milliseconds: 1000), () {
                                    if (value.isNotEmpty) {
                                      //places api
                                      autoCompleteSearch(value);
                                    } else {
                                      //clear out the results
                                    }
                                  });
                                },
                              ),
                            ),
                            Container(
                              height: 400,
                              width: 380,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child:load=='loading' ?
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child:Container(
                                      height: 40,
                                      width: 40,
                                      child: CircularProgressIndicator(
                                        color: Colors.deepOrangeAccent[100],
                                      )),
                                ),
                              )
                              :
                              GoogleMap(
                                myLocationButtonEnabled: false,
                                zoomControlsEnabled: false,

                                initialCameraPosition: CameraPosition(
                                  target:currentPostion,
                                  zoom: 11.5,
                                ),
                                onMapCreated: (controller) => _googleMapController = controller,
                                markers: Set<Marker>.of(_markers),


                              ),

                            ),

                            // Container(
                            //   height: 400,
                            //   width: 380,
                            //   padding: const EdgeInsets.symmetric(vertical: 10),
                            //   child:FlutterMap(
                            //     options: MapOptions(
                            //       center: latLng.LatLng(51.5, -0.09),
                            //       zoom: 13.0,
                            //     ),
                            //     layers: [
                            //       TileLayerOptions(
                            //         urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            //         subdomains: ['a', 'b', 'c'],
                            //         attributionBuilder: (_) {
                            //           return Text("© OpenStreetMap contributors");
                            //         },
                            //       ),
                            //       MarkerLayerOptions(
                            //         markers: [
                            //           Marker(
                            //             width: 80.0,
                            //             height: 80.0,
                            //             point: latLng.LatLng(51.5, -0.09),
                            //             builder: (ctx) =>
                            //                 Container(
                            //                   child: FlutterLogo(),
                            //                 ),
                            //           ),
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            //
                            //   ),

                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              width: 200,
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    shape: StadiumBorder(),
                                    backgroundColor: Colors.lightBlueAccent,
                                  ),
                                  child: Text(
                                    'REGISTER',
                                    style: Theme.of(context).textTheme.headline2?.copyWith(color: Colors.white, fontSize: 15),
                                  ),
                                  onPressed: (){
                                    if (formKey.currentState!.validate()) {
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //   const SnackBar(content: Text('Processing Data')),
                                      // );
                                      _register();
                                    }
                                  }
                              ),
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
