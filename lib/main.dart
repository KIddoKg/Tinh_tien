import 'package:Xi_Zach/home_page.dart';
import 'package:Xi_Zach/router.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tinh tien',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        backgroundColor: Colors.white,
      ),
      home:const HomeScreen(),
      routes: RouteGenerator.routes,
    );
  }
}
