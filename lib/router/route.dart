import 'package:Xi_Zach/new_ver/screen/home/home_screen.dart';
import 'package:Xi_Zach/new_ver/screen/home/name_screen.dart';
import 'package:Xi_Zach/new_ver/screen/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import '../home_page.dart';
import '../new_ver/screen/gameOne/game_home.dart';
import '../new_ver/screen/gameOne/zizach_screen.dart';
import '../new_ver/screen/home/history_screen.dart';
import '../new_ver/viewModel/zizach_Controller.dart';

class AppRoute {
  const AppRoute._();

  static const home = '';
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const zizach = '/zizach';
  static const room = '/room';
  static const homeGameZiZach = '/homeGameZiZach';

  static final routes = {
    home: (context) => const HomeScreen(), // Replace with the appropriate widget
    splash: (context) => const SplashScreen(),
    welcome: (context) =>  WelcomeScreen(),
    room: (context) =>  RomMatch(),
    zizach: (context) =>  ZiZachScreen(),
    homeGameZiZach: (context) =>  HomeZiZach(),
  };
}