import 'package:Xi_Zach/home_page.dart';
import 'package:Xi_Zach/new_ver/viewModel/zizach_Controller.dart';
import 'package:Xi_Zach/router.dart';
import 'package:Xi_Zach/router/route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'new_ver/screen/splash/splash_screen.dart';

void main() async {

    runApp(
      // MultiProvider(
      // providers: [
      //   ChangeNotifierProvider(create: (_) => ThemeSettingProvider()),
      // ],

      MultiProvider(
        providers: [
          ChangeNotifierProvider<ZiZackController>(
            create: (context) => ZiZackController(),
          ),
        ],
        child: const MyApp(),
        //const MyApp(),
      ),
    );
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'App Tinh tien',
      // theme: AppTheme.myThemeData,
      // home: const WelcomeScreen(),
      home: const SplashScreen(),
      routes: AppRoute.routes,
    );
  }
}
