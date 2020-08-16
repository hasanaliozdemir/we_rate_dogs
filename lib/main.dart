import 'package:anketdemoapp/auth.dart';
import 'package:anketdemoapp/pages/dog_add_page.dart';
import 'package:anketdemoapp/pages/dogs_page.dart';
import 'package:anketdemoapp/pages/image_selection_page.dart';
import 'package:anketdemoapp/pages/login_page.dart';
import 'package:anketdemoapp/pages/root_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      routes:  {
        "/home":(BuildContext context)=>DogsPage(),
        "/add":(BuildContext context)=>DogAddPage(),
        "/image":(BuildContext context)=>ImageCapture(),
        "/login":(BuildContext context)=>LoginPage(auth: new Auth(),),
        "/root":(BuildContext context)=>RootPage(auth: new Auth(),)
      },
      initialRoute: "/root",
    );
  }
}




