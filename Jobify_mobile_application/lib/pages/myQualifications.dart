import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/userServices.dart';
import '../signup/secondReg.dart';

class MyQualifications extends StatefulWidget {
  @override
  _MyQualificationsState createState() => _MyQualificationsState();
}

class _MyQualificationsState extends State<MyQualifications> {
  final formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldSignUpKey = GlobalKey();
   TextEditingController _qualAward = new TextEditingController();
   TextEditingController _bodyAward = new TextEditingController();

  String loading = "true";
  var quaLevel = [
    "-- Select One --",
    "No Formal Education",
    "Doctorate or higher",
    "Master Degree",
    "Bachelor Degree",
    "Vocational Qualification",
    "O/L Education",
    "A/L Education",
    "Other",];
  var workIn = [
    "-- Select One --",
  "Admin & Clerical",
  "Automotive",
  "Banking",
  "Biotech",
  "Broadcast",
  "Business Development",
  "Construction",
  "Consultant",
  "Customer Service",
  "Design" ,
  "Distribution",
  "Education",
  "Engineering",
  "Entry Level" ,
  "Executive",
  "Facilities",
  "Finance" ,
  "Franchise",
  "General Business",
  "General Labor",
  "Government",
    "Grocery" ,
  "Health Care" ,
  "Hotel - Hospitality",
  "Human Resources" ,
  "Information Technology",
  "Installation - Maint - Repair",
  "Insurance",
  "Inventory" ,
  "Legal",
  "Legal Admin" ,
  "Management" ,
  "Manufacturing",
  "Marketing",
  "Media - Journalism - Newspaper" ,
  "Nonprofit - Social Services" ,
  "Nurse",
  "Pharmaceutical" ,
  "Professional Services",
  "Science",
  "Skilled Labor - Trades",
    "Sales",
    "Other",];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQualifications();
  }

  void getQualifications()async{

    var body;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var response = await CallApi().getQualifications('/dashboard/m/updateQualifications',token);
    body = json.decode(response.body);


    setState((){
      // TextEditingController _qualAward = new TextEditingController();
      // TextEditingController _bodyAward = new TextEditingController();
      _qualAward.text=body['qualifications']['highestQualificationName'];
      _bodyAward.text=body['qualifications']['awardingbodyInput'];
      _quaLevel = body['qualifications']['highestQualificationType'];
      _workIn=body['qualifications']['jobCategory'];
      print(body);

    });
  }




  String? _quaLevel = "-- Select One --";
  String? _quaAward = "-- Select One --";
  String? _awardBody = "Citizen";
  String? _workIn = "-- Select One --";
  @override
  Widget build(BuildContext context) {

    OutlineInputBorder commonBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: BorderSide(

        color: Colors.blueGrey,
      ),
    );

    DropdownMenuItem <String> buildLevelRole(String item) =>
        DropdownMenuItem(
          value: item,
          child: Text(
            item,
          ),);
    DropdownMenuItem <String> buildMAwardRole(String item) =>
        DropdownMenuItem(
          value: item,
          child: Text(
            item,
          ),);
    DropdownMenuItem <String> buildBodyRole(String item) =>
        DropdownMenuItem(
          value: item,
          child: Text(
            item,
          ),);
    DropdownMenuItem <String> buildWorkRole(String item) =>
        DropdownMenuItem(
          value: item,
          child: Text(
            item,
          ),);
    return Scaffold(
        key: _scaffoldSignUpKey,

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
                            Text('Enter Qualifications',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                )),
                            // Text('Please enter your correct information.',
                            //     style: TextStyle(
                            //       fontWeight: FontWeight.normal,
                            //       fontSize: 16.0,
                            //       height: 1.5,
                            //     )),
                            // Text('* Required',
                            //     style: TextStyle(
                            //         fontWeight: FontWeight.normal,
                            //         fontSize: 16.0,
                            //         height: 1.5,
                            //         color: Colors.red)),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            // Name
                            const Align(
                              alignment:Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text('Select Highest Level of Qualification',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),),
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: FormField<String>(
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
                                    isEmpty: _quaLevel == '',
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _quaLevel,
                                        isDense: true,
                                        onChanged:(value) {
                                          setState(() {
                                            _quaLevel=value;
                                            // getReportChart();
                                          });
                                        } ,
                                        items:quaLevel.map(buildLevelRole).toList(),

                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const Align(
                              alignment:Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text('Name of the awarded qualification',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),),
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
                                controller: _qualAward,
                                decoration: InputDecoration(
                                  border: commonBorder,
                                  focusedBorder: commonBorder,
                                  enabledBorder: commonBorder,
                                  // labelText: 'eg- BSc Engineering Honours, ...',
                                  // labelStyle: commonTextStyle,
                                ),
                                maxLines: 1,
                              ),
                            ),

                            const Align(
                              alignment:Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text('Awarding body',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),),
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
                                controller: _bodyAward,
                                decoration: InputDecoration(
                                  border: commonBorder,
                                  focusedBorder: commonBorder,
                                  enabledBorder: commonBorder,
                                  // labelText: 'eg- Plymouth Uk , ...',
                                  // labelStyle: commonTextStyle,
                                ),
                                maxLines: 1,
                              ),
                            ),

                            const Align(
                              alignment:Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text('Please select Job Category',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),),
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: FormField<String>(
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
                                    isEmpty: _workIn == '',
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _workIn,
                                        isDense: true,
                                        onChanged:(value) {
                                          setState(() {
                                            _workIn=value;
                                            // getReportChart();
                                          });
                                        } ,
                                        items:workIn.map(buildWorkRole).toList(),

                                      ),
                                    ),
                                  );
                                },
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
