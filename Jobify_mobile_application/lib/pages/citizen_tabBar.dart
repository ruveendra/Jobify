import 'package:api_project/pages/citizen_view.dart';
import 'package:flutter/material.dart';

import 'citizenDocuments.dart';
import 'myAccount.dart';

class CitizenTab extends StatefulWidget {
  @override
  _CitizenTabState createState() => _CitizenTabState();
}

class _CitizenTabState extends State<CitizenTab> with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      tabController = TabController(length: 2, vsync: this);
      super.initState();
    }

    @override
    void dispose() {
      tabController.dispose();
      super.dispose();
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('My Account',
          style: TextStyle(
            color: Colors.black,
          ),
        ) ,
        centerTitle: true,

      ),

      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height ,
          width: double.maxFinite,
          child: Column(
            children: [

              Padding(
                padding: EdgeInsets.only(bottom: 1),
                child: Container(
                  color: Colors.white,
                  child: TabBar(

                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.black,
                    indicatorColor: Colors.black,
                    indicatorWeight: 1,
                    // indicator: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.circular(5),
                    // ),
                    controller: tabController,
                    tabs: const [
                      Tab(
                        text: 'Account Details',
                      ),
                      Tab(
                        text: 'Documents',
                      )
                    ],

                  ),
                ),
              ),


              //
              Container(
                height: MediaQuery.of(context).size.height ,
                width: double.maxFinite,
                child: Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      CitizenView(),
                      CitizenDoc(),
                      // DeviceAnalysis(),
                    ],
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

