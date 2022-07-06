import 'package:api_project/model/citizen_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/search_widget.dart';
import 'citizen_view.dart';

class OfficerDashboard extends StatefulWidget {
  @override
  _OfficerDashboardState createState() => _OfficerDashboardState();
}

class _OfficerDashboardState extends State<OfficerDashboard> {
  late List<Citizen> citizens;
  List<Citizen> ?activeCitizens;
  String query = '';
  final items = ['All','Sales' ,'Cooking',"Cleaning","Technology","Lawyer",];
  String? value = 'All';


  void getCitizen(currentDevice){

    Citizen citizen = currentDevice;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context)=>CitizenView(citizen : citizen),));

  }
  getCitizenRole(String role)async{

    // SharedPreferences localStorage = await SharedPreferences.getInstance();
    // var token = localStorage.getString('token');
    // var response = await DeviceApi().getAllDevices('devices',token);
    // var devicesObjsJson = jsonDecode(response.body)['data'] as List;
    // List<Devices> deviceObjs = devicesObjsJson.map((dataJson) => Devices.fromJson(dataJson)).toList();
    // print(deviceObjs);
    // devices = deviceObjs;
    setState(() {
      value=role;
      role=='All' ? activeCitizens = myCitizen : activeCitizens = myCitizen.where((i) => i.role==role).toList();

    });
      //Change Switch
    // m,


  }
  @override
  void initState() {
    // TODO: implement initState
    activeCitizens= myCitizen;
  }

  @override
  Widget build(BuildContext context) {
    DropdownMenuItem <String> buildMenuItem(String item) =>
        DropdownMenuItem(
          value: item,
          child: Text(
            item,
          ),);
    void searchDevice(String query){


      final citizen =myCitizen.where((citizen){
        final titleLower= citizen.name!.toLowerCase();
        final searchLower= query.toLowerCase();
        return titleLower.contains(searchLower);

      }
      ).toList();

      setState(() {
        this.query = query;
        this.activeCitizens = citizen;
      });
    }

    Widget buildSearch() => SearchWidget(

        text: query,
        hintText: 'Search Citizen',
        onChanged: searchDevice
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery. of(context). size. height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Container(
              //   color: Colors.black45,
              //   height: 230,
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom: 0),
              //     child: SizedBox(
              //       height: 150,
              //       child: ListView.builder(
              //         itemCount: 5,
              //         scrollDirection: Axis.horizontal,
              //         // Horizontal Grid
              //         itemBuilder: (context, index) => Container(
              //           height: 150,
              //           width: 300,
              //           margin: EdgeInsets.all(10),
              //           child: Card(
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(20)
              //             ),
              //             child: Center(
              //               child: Text(
              //                 "Card $index",
              //                 style: TextStyle(color: Colors.white),
              //               ),
              //             ),
              //           ),
              //           // color: Colors.blueGrey[700],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),


              Padding(
                padding: const EdgeInsets.fromLTRB(8,10,8,2),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                          child: buildSearch()),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0, left: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: DropdownButton(

                    value: value,
                    items: items.map(buildMenuItem).toList(),
                    onChanged: (value) {
                      setState(() {
                        getCitizenRole(value.toString());

                        // getReportChart(date);
                      });
                    },
                  ),
                ),
              ),

              Container(
                width: 370,
                child: const Divider(
                  color: Colors.blueGrey,
                  thickness: 1,
                ),
              ),

              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(

                      children: [

                        activeCitizens == null ? Padding(
                          padding: const EdgeInsets.only(top: 60.0),
                          child: Center(child: Container(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(
                                color: Colors.deepOrangeAccent[100],
                              ))),
                        ) :

                        ListView.builder(
                            itemCount: activeCitizens!.length,
                            itemExtent: 70,



                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              Citizen currentCitizens = activeCitizens![index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 1.0, horizontal: 12.0),
                                child: Card(
                                  color: Colors.blueGrey[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,

                                  child: ListTile(



                                      onTap: () {
                                        getCitizen(currentCitizens);
                                      },
                                      // leading: Container(
                                      //   width: 25,
                                      //   height: 25,
                                      //   child: ClipRRect(
                                      //     borderRadius: new BorderRadius.circular(5.0),
                                      //     child: Image(
                                      //       fit: BoxFit.fill,
                                      //       image: AssetImage(currentDevice.img),
                                      //     ),
                                      //   ),
                                      // ),
                                      leading: Container(
                                        width: 30,
                                        height: 30,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(5.0),
                                          child: const Image(
                                            fit: BoxFit.fill,
                                            image: AssetImage('assets/images/profile.png'),
                                          ),
                                        ),
                                      ),
                                      title:Text('${currentCitizens.name}'),
                                      subtitle:Text('${currentCitizens.role}')
                                      // subtitle: activeDevices![index].deviceStatus == true ? const Icon(Icons.circle, color: Colors.green,) : const Icon(Icons.circle, color: Colors.red,size: 10,),
                                      // trailing:

                                  ),
                                ),
                              );
                            }
                        ),
                      ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
