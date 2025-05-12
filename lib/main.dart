

import 'package:demo/views/auth/login.dart';
import 'package:demo/views/clients/create.dart';
import 'package:demo/views/homepage.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

void main() => runApp( MyApp());

class MyApp extends StatelessWidget {
   MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo Getx',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: '/login',
      routes:{
        '/': (context)=>Homepage(),
         '/login':(context)=>Login(),
         'create-client':(context)=>CreateClient(),
      }
    );
  }
}
