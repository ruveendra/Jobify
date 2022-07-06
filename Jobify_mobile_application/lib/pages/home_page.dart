import 'package:api_project/pages/myAccount.dart';
import 'package:api_project/pages/myOffers.dart';
import 'package:api_project/pages/myQualifications.dart';
import 'package:api_project/pages/qualificationTabBar.dart';
import 'package:flutter/material.dart';

import 'accountTabBar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Stack(

          children: [
            Container(
              height: size.height* .45,
              decoration: const BoxDecoration(
                  color: Colors.grey
              ),
            ),
            Container(

                child: Image.asset("assets/images/Welcome (2).png",
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,)
            ),
            Padding(
              padding: const EdgeInsets.only(top:145.0, left: 60),
              child: Container(
                color: Colors.transparent,
                child: const Text(
                  'Welcome to',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:174.0, left: 60),
              child: Container(
                color: Colors.transparent,
                child: const Text(
                  'JOB4U',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top:332.0, left: 25),
              child: Container(
                color: Colors.transparent,
                child: Text(
                  'Home',
                  style:  TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),





            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(

                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 350,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Divider(
                            color: Colors.blueGrey,
                            thickness: 1,

                          ),
                        ),
                      ),
                      Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: TextButton(
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(builder:(context)=> AccountTab()));
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(0),
                        ),
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width/100*90,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Container(
                                height: 90,
                                width: 80,
                                margin: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/profile.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "My Profile",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextButton(
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(builder:(context)=> QualTab()));
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0),
                          ),
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width/100*90,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                Container(
                                  height: 90,
                                  width: 80,
                                  margin: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: const DecorationImage(
                                      image: AssetImage('assets/images/certificate (1).png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "My Qualifications",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextButton(
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(builder:(context)=> MyOffers()));
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0),
                          ),
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width/100*90,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                Container(
                                  height: 80,
                                  width: 85,
                                  margin: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/proposal.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "My Offers",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                ]
                  ),
                ),
              ),
            ),

          ],

        ),
      ),

    );
  }
}
