import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/screen/home.dart';
void main()async{

WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp( options: FirebaseOptions(apiKey: "", appId: "1:645164931368:android:ddbdb7bd024bcc86bd981d", messagingSenderId:"645164931368", projectId: "todoapp-9a9d3"));
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key?key}):super(key : key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  
       return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do Application',
      home:Home()
    );
    /*  if(snapshot.hasError) {
        return  Text(snapshot.error.toString())
      ;
      }
      if(snapshot.connectionState==ConnectionState.waiting){
        return Loading();
      }*/
   
   
     }
     
  }

