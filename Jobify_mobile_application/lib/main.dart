import 'package:api_project/provider/citizen_provider.dart';
import 'package:api_project/signup/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(

      MultiProvider(
        providers: [
          ChangeNotifierProvider(create:(context)=> CitizenProvider()),
        ],
        child: MaterialApp(
          initialRoute: "/login_screen",

          routes: {

            "/login_screen":(context) => LoginPage(),

          },
        ),
      )


  );
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       initialRoute: "/login_screen",
//
//       routes: {
//
//         "/login_screen":(context) => LoginPage(),
//
//       },
//     );
//   }
// }





