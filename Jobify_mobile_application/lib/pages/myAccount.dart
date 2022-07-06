import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  final TextEditingController _name = new TextEditingController();
  final TextEditingController _lastName = new TextEditingController();
  final TextEditingController _nic = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _matchPassword = new TextEditingController();
  late GoogleMapController _googleMapController;
  late String lat;
  late String long;
  late LatLng currentPostion;
  String load = 'loading';
  List<Marker> _markers = <Marker>[];

  bool showPassword = false;


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
    _getUserLocation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //   elevation: 1,
      //   leading: IconButton(
      //     icon: Icon(
      //       Icons.arrow_back,
      //       color: Colors.blueGrey,
      //     ),
      //     onPressed: () {},
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: Icon(
      //         Icons.settings,
      //         color: Colors.blueGrey,
      //       ),
      //       onPressed: () {
      //
      //       },
      //     ),
      //   ],
      // ),
      body: Container(

        padding: EdgeInsets.only(left: 16, top: 25, right: 16,bottom: 150),
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
                           decoration: const InputDecoration(
                               contentPadding: EdgeInsets.only(bottom: 3),
                               labelText: 'Name' ,
                               floatingLabelBehavior: FloatingLabelBehavior.always,
                               hintText: 'Name with initials',
                               hintStyle: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.w300,
                                 color: Colors.black,
                               )),
                         ),
                       ),

                       Padding(
                         padding: EdgeInsets.only(bottom: 35.0),
                         child: TextField(
                           controller:_email,
                           obscureText: false,
                           decoration: const InputDecoration(
                               contentPadding: EdgeInsets.only(bottom: 3),
                               labelText: 'Email' ,
                               floatingLabelBehavior: FloatingLabelBehavior.always,
                               hintText: 'email',
                               hintStyle: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.w300,
                                 color: Colors.black,
                               )),
                         ),
                       ),
                       Padding(
                         padding: EdgeInsets.only(bottom: 35.0),
                         child: TextField(
                           controller:_name,
                           obscureText: false,
                           decoration: const InputDecoration(
                               contentPadding: EdgeInsets.only(bottom: 3),
                               labelText: 'Date of Birth' ,
                               floatingLabelBehavior: FloatingLabelBehavior.always,
                               hintText: 'mm/dd/yyyy',
                               hintStyle: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.w300,
                                 color: Colors.black,
                               )),
                         ),
                       ),
                       Padding(
                         padding: EdgeInsets.only(bottom: 35.0),
                         child: TextField(
                           controller:_name,
                           obscureText: false,
                           decoration: const InputDecoration(
                               contentPadding: EdgeInsets.only(bottom: 3),
                               labelText: 'NIC' ,
                               floatingLabelBehavior: FloatingLabelBehavior.always,
                               hintText: 'National ID',
                               hintStyle: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.w300,
                                 color: Colors.black,
                               )),
                         ),
                       ),

                       Container(
                         child: Column(
                           children: [

                             Padding(
                               padding: EdgeInsets.only(bottom: 35.0),
                               child: TextField(
                                 controller:_name,
                                 obscureText: false,
                                 decoration: const InputDecoration(
                                     contentPadding: EdgeInsets.only(bottom: 3),
                                     labelText: 'Address' ,
                                     floatingLabelBehavior: FloatingLabelBehavior.always,
                                     hintText: 'House No, Building Name',
                                     hintStyle: TextStyle(
                                       fontSize: 12,
                                       fontWeight: FontWeight.w300,
                                       color: Colors.black,
                                     )),
                               ),
                             ),

                             // SizedBox(
                             //   height: 10,
                             // ),

                             Padding(
                               padding: EdgeInsets.only(bottom: 35.0),
                               child: TextField(
                                 controller:_name,
                                 obscureText: false,
                                 decoration: const InputDecoration(
                                     contentPadding: EdgeInsets.only(bottom: 3),
                                     // labelText: 'NIC' ,
                                     floatingLabelBehavior: FloatingLabelBehavior.always,
                                     hintText: 'Street Address',
                                     hintStyle: TextStyle(
                                       fontSize: 12,
                                       fontWeight: FontWeight.w300,
                                       color: Colors.black,
                                     )),
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


              Container(
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

                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(


                    children: [

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: Text ('Update Location',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12
                          ),),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlineButton(
                          // padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            _getUserLocation();
                          },
                          child: const Text("UPDATE",
                              style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 1.2,
                                  color: Colors.black)),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),


                      load=='loading' ?
                      Container(
                        height: 400,
                        width: 380,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child:Container(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator(
                                  color: Colors.deepOrangeAccent[100],
                                )),
                          ),
                        ),
                      ) :
                      Container(
                        height: 400,
                        width: 380,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: GoogleMap(
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
                      ),



                      // SizedBox(
                      //   height: 10,
                      // ),


                    ],
                  ),
                ),
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
                  "SAVE CHANGES",
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
