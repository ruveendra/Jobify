import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../model/citizen_class.dart';

class CitizenView extends StatefulWidget {
  Citizen ?citizen;
  CitizenView({this.citizen});
  @override
  _CitizenViewState createState() => _CitizenViewState(citizen);
}

class _CitizenViewState extends State<CitizenView> {
  Citizen ?citizen;
  _CitizenViewState(this.citizen);
  late String filePath='';
  late String cvPath='';
  late String bcPath='';
  late String certPath='';

  final TextEditingController _name = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _dob = new TextEditingController();
  final TextEditingController _nic = new TextEditingController();
  final TextEditingController _address = new TextEditingController();
  final TextEditingController _addressLine = new TextEditingController();
  late GoogleMapController _googleMapController;
  late String lat;
  late String long;
  late LatLng currentPostion;
  String load = 'loading';
  List<Marker> _markers = <Marker>[];


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
  Widget build(BuildContext context) {

    OutlineInputBorder commonBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
          color: Colors.blueGrey),);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('Citizen'),
      ),

      body: Container(
          padding: EdgeInsets.only(left: 16, top: 25, right: 16,bottom: 30),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                // const Text(
                //   "Edit Profile",
                //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                // ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 4,
                                color: Colors.blueGrey),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10))
                            ],
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                                ))),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: Colors.blueGrey,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: Container(
                      decoration: BoxDecoration(


                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0 , 17),
                              blurRadius: 17,
                              spreadRadius: -23,
                              color: Colors.black38,
                            )
                          ],
                          color:
                          Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 0.1,
                            color: (Colors.blueGrey[100])!,

                          )
                      ),
                      child:Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 35.0),
                              child: TextField(
                                controller:_name,
                                obscureText: false,
                                decoration:  InputDecoration(
                                    border: commonBorder,
                                    focusedBorder: commonBorder,
                                    enabledBorder: commonBorder,
                                    contentPadding: EdgeInsets.only(bottom: 3),
                                    labelText: 'Name' ,
                                    labelStyle: Theme.of(context).textTheme.subtitle1,
                                    floatingLabelBehavior: FloatingLabelBehavior.always,

                                    // hintText: 'Name with initials',
                                    // hintStyle: const TextStyle(
                                    //   fontSize: 12,
                                    //   fontWeight: FontWeight.w300,
                                    //   color: Colors.black,
                                    // )
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(bottom: 35.0),
                              child: TextField(
                                controller:_email,
                                obscureText: false,
                                decoration:  InputDecoration(
                                    border: commonBorder,
                                    focusedBorder: commonBorder,
                                    enabledBorder: commonBorder,
                                    labelStyle: Theme.of(context).textTheme.subtitle1,
                                    contentPadding: EdgeInsets.only(bottom: 3),
                                    labelText: 'Email' ,
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    // hintText: 'email',
                                    // hintStyle: TextStyle(
                                    //   fontSize: 12,
                                    //   fontWeight: FontWeight.w300,
                                    //   color: Colors.black,
                                    // )
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 35.0),
                              child: TextField(
                                controller:_dob,
                                obscureText: false,
                                decoration:  InputDecoration(
                                    border: commonBorder,
                                    focusedBorder: commonBorder,
                                    enabledBorder: commonBorder,
                                    labelStyle: Theme.of(context).textTheme.subtitle1,
                                    contentPadding: EdgeInsets.only(bottom: 3),
                                    labelText: 'Date of Birth' ,
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    // hintText: 'mm/dd/yyyy',
                                    // hintStyle: const TextStyle(
                                    //   fontSize: 12,
                                    //   fontWeight: FontWeight.w300,
                                    //   color: Colors.black,
                                    // )
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 35.0),
                              child: TextField(
                                controller:_nic,
                                obscureText: false,
                                decoration:  InputDecoration(
                                    border: commonBorder,
                                    focusedBorder: commonBorder,
                                    enabledBorder: commonBorder,
                                    labelStyle: Theme.of(context).textTheme.subtitle1,
                                    contentPadding: EdgeInsets.only(bottom: 3),
                                    labelText: 'NIC' ,
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    // hintText: 'National ID',
                                    // hintStyle: const TextStyle(
                                    //   fontSize: 12,
                                    //   fontWeight: FontWeight.w300,
                                    //   color: Colors.black,
                                    // )
                                ),
                              ),
                            ),

                            Container(
                              child: Column(
                                children: [

                                  Padding(
                                    padding: EdgeInsets.only(bottom: 35.0),
                                    child: TextField(
                                      controller:_address,
                                      obscureText: false,
                                      decoration:  InputDecoration(
                                          border: commonBorder,
                                          focusedBorder: commonBorder,
                                          enabledBorder: commonBorder,
                                          labelStyle: Theme.of(context).textTheme.subtitle1,
                                          contentPadding: EdgeInsets.only(bottom: 3),
                                          labelText: 'Address' ,
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          // hintText: 'House No, Building Name',
                                          // hintStyle: TextStyle(
                                          //   fontSize: 12,
                                          //   fontWeight: FontWeight.w300,
                                          //   color: Colors.black,
                                          // )
                                      ),
                                    ),
                                  ),

                                  // SizedBox(
                                  //   height: 10,
                                  // ),

                                  Padding(
                                    padding: EdgeInsets.only(bottom: 35.0),
                                    child: TextField(
                                      controller:_addressLine,
                                      obscureText: false,
                                      decoration:  InputDecoration(
                                          border: commonBorder,
                                          focusedBorder: commonBorder,
                                          enabledBorder: commonBorder,
                                          labelStyle: Theme.of(context).textTheme.subtitle1,
                                          contentPadding: EdgeInsets.only(bottom: 3),
                                          // labelText: 'NIC' ,
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          // hintText: 'Street Address',
                                          // hintStyle: TextStyle(
                                          //   fontSize: 12,
                                          //   fontWeight: FontWeight.w300,
                                          //   color: Colors.black,
                                          // )
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),

                          ],
                        ),
                      )
                  ),
                ),


            Column(
              children:  [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      decoration: BoxDecoration(


                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0 , 17),
                              blurRadius: 17,
                              spreadRadius: -23,
                              color: Colors.black38,
                            )
                          ],
                          color:
                          Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 0.1,
                            color: (Colors.blueGrey[100])!,

                          )
                      ),
                      child:Column(
                        children: [

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('My CV',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),),
                            ),
                          ),

                          // const Divider(
                          //   height: 10,
                          //   thickness: 1,
                          //   color: Colors.blueGrey,
                          //
                          // ),

                          Container(
                            height: 110,
                            child:Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                        color: Colors.white,
                                        height: 50,
                                        width: 50,
                                        child: cvPath=='' ?
                                        Container(

                                          child: Image.asset("assets/images/upload1.png",
                                            height: 50,
                                            width: 50,
                                          ),
                                        )
                                            :
                                        Image.asset("assets/images/pdf.png",
                                          height: 350,
                                          width: double.infinity,
                                          fit: BoxFit.cover,)
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: ButtonTheme(
                                      minWidth: 40.0,
                                      height: 24.0,
                                      child: OutlineButton(
                                        // padding: EdgeInsets.symmetric(horizontal: 50),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)),
                                        onPressed: () => openFile(
                                            url:'hello',
                                            fileName:'hello.mp4'
                                        ),
                                        child: const Text("View",
                                            style: TextStyle(
                                                fontSize: 12,
                                                letterSpacing: 1.2,
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ) ,
                          ),

                        ],
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(


                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0 , 17),
                            blurRadius: 17,
                            spreadRadius: -23,
                            color: Colors.black38,
                          )
                        ],
                        color:
                        Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 0.1,
                          color: (Colors.blueGrey[100])!,

                        )
                    ),
                    child: Column(
                      children: [

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Birth Certificates',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),),
                          ),
                        ),

                        // const Divider(
                        //   thickness: 1,
                        //   color: Colors.blueGrey,
                        //
                        // ),

                        Container(

                          height: 120,
                          child:Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                      color: Colors.white,
                                      height: 50,
                                      width: 50,
                                      child: cvPath=='' ?
                                      Container(

                                        child: Image.asset("assets/images/upload1.png",
                                          height: 50,
                                          width: 50,
                                        ),
                                      )
                                          :
                                      Image.asset("assets/images/pdf.png",
                                        height: 350,
                                        width: double.infinity,
                                        fit: BoxFit.cover,)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ButtonTheme(
                                    minWidth: 40.0,
                                    height: 24.0,
                                    child: OutlineButton(
                                      // padding: EdgeInsets.symmetric(horizontal: 50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)),
                                      onPressed: () => openFile(
                                          url:'hello',
                                          fileName:'hello.mp4'
                                      ),
                                      child: const Text("View",
                                          style: TextStyle(
                                              fontSize: 12,
                                              letterSpacing: 1.2,
                                              color: Colors.black)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ) ,
                        ),

                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      decoration: BoxDecoration(


                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0 , 17),
                              blurRadius: 17,
                              spreadRadius: -23,
                              color: Colors.black38,
                            )
                          ],
                          color:
                          Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 0.1,
                            color: (Colors.blueGrey[100])!,

                          )
                      ),
                      child:Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Certificates',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),),
                            ),
                          ),

                          // const Divider(
                          //   thickness: 1,
                          //   color: Colors.blueGrey,
                          //
                          // ),

                          Container(
                            height: 120,
                            child:Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                        color: Colors.white,
                                        height: 50,
                                        width: 50,
                                        child: cvPath=='' ?
                                        Container(

                                          child: Image.asset("assets/images/upload1.png",
                                            height: 50,
                                            width: 50,
                                          ),
                                        )
                                            :
                                        Image.asset("assets/images/pdf.png",
                                          height: 350,
                                          width: double.infinity,
                                          fit: BoxFit.cover,)
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: ButtonTheme(
                                      minWidth: 40.0,
                                      height: 24.0,
                                      child: OutlineButton(
                                        // padding: EdgeInsets.symmetric(horizontal: 50),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)),
                                        onPressed: () => openFile(
                                            url:'hello',
                                            fileName:'hello.mp4'
                                        ),
                                        child: const Text("View",
                                            style: TextStyle(
                                                fontSize: 12,
                                                letterSpacing: 1.2,
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ) ,
                          ),
                        ],
                      )
                  ),
                )






              ],
            ),

                SizedBox(
                  height: 40,
                ),

                RaisedButton(
                  onPressed: () {},
                  color: Colors.blueGrey,
                  // padding: EdgeInsets.symmetric(horizontal: 20),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text(
                    "Contact Citizen",
                    style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2.2,
                        color: Colors.white),
                  ),
                ),


                // buildTextField("Full Name", "Dor Alex", false),
                // buildTextField("E-mail", "alexd@gmail.com", false),
                // buildTextField("Password", "********", true),
                // buildTextField("Location", "TLV, Israel", false),
                // const SizedBox(
                //   height: 150,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //
                //     RaisedButton(
                //       onPressed: () {},
                //       color: Colors.blueGrey,
                //       padding: EdgeInsets.symmetric(horizontal: 50),
                //       elevation: 2,
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(20)),
                //       child: const Text(
                //         "SAVE",
                //         style: TextStyle(
                //             fontSize: 14,
                //             letterSpacing: 2.2,
                //             color: Colors.white),
                //       ),
                //     )
                //   ],
                // )
              ],
            ),
          ),
        ),


    );




  }
}

openFile({required String url, String? fileName}) async{
  final file = await downloadFile(url,fileName!);
  if (file==null) return;
  print('Path ${file.path}');
  OpenFile.open(file.path);
}

Future<File?> downloadFile(String url, String name)async {

  final appStorage = await getApplicationDocumentsDirectory();
  final file =File('${appStorage.path}/$name');

  try {
    final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        )
    );

    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return file;
  }catch(e){
    return null;
  }

}
