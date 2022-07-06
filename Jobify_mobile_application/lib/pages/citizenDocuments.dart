// import 'dart:html';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/userServices.dart';


class CitizenDoc extends StatefulWidget {
  @override
  _CitizenDocState createState() => _CitizenDocState();
}

class _CitizenDocState extends State<CitizenDoc> {
  String downloadURL='http://192.168.56.1:5000/uploads/';

  late String filePath='';
  late String cvPath='';
  late String bcPath='';
  late String certPath='';

  void getDocuments()async{

    var body;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var response = await CallApi().getDocuments('/m/dashboard',token);
    body = json.decode(response.body);
    setState((){
      // TextEditingController _qualAward = new TextEditingController();
      // TextEditingController _bodyAward = new TextEditingController();
      // _qualAward.text=body['qualifications']['highestQualificationName'];
      // _bodyAward.text=body['qualifications']['awardingbodyInput'];
      var _quaLevel = body['data']['cv']['cvDocPath'];
      // _workIn=body['qualifications']['jobCategory'];

      filePath=_quaLevel;
      downloadURL='http://192.168.56.1:5000/uploads/$filePath';
      print(downloadURL);
    });
  }

  uploadFile() async {
    // var postUri = Uri.parse("<APIUrl>");
    // var request = new http.MultipartRequest("POST", postUri);
    // request.fields['user'] = 'blah';
    // request.files.add(new http.MultipartFile.fromBytes('file', await File.fromUri("<path/to/file>").readAsBytes(), contentType: new MediaType('image', 'jpeg')))
    //
    // request.send().then((response) {
    //   if (response.statusCode == 200) print("Uploaded!");
    // });

    var postUri = Uri.parse("http://192.168.56.1:5000/citizen/nid/cv");
    http.MultipartRequest request = http.MultipartRequest("POST", postUri);

    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'file', filePath, contentType: MediaType('application', 'x-tar'));
    request.files.add(multipartFile);
    http.StreamedResponse response = await request.send();

  setState(() {

    print(response.statusCode);
  });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocuments();
  }



  @override
  Widget build(BuildContext context) {
    return Column(
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
                                  url:downloadURL,
                                  fileName:filePath
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
                              onPressed: () async {
                                final result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf'],
                                );
                                if (result != null) {
                                  filePath = result.files.single.path.toString();
                                  uploadFile();
                                } else {
                                  // User canceled the picker
                                }


                              },
                              child: const Text("Update",
                                  style: TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 1.2,
                                      color: Colors.black)),
                            ),
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
                              onPressed: () {

                              },
                              child: const Text("Delete",
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
                              onPressed: () async {
                                final result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf'],
                                );
                                if (result != null) {
                                  filePath = result.files.single.path.toString();
                                  uploadFile();
                                } else {
                                  // User canceled the picker
                                }


                              },
                              child: const Text("Update",
                                  style: TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 1.2,
                                      color: Colors.black)),
                            ),
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
                              onPressed: () {

                              },
                              child: const Text("Delete",
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
                              onPressed: () async {
                                final result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf'],
                                );
                                if (result != null) {
                                  filePath = result.files.single.path.toString();
                                  uploadFile();
                                } else {
                                  // User canceled the picker
                                }
                              },
                              child: const Text("Update",
                                  style: TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 1.2,
                                      color: Colors.black)),
                            ),
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
                              onPressed: () {

                              },
                              child: const Text("Delete",
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
    );
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
}
