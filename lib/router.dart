import 'package:Xi_Zach/home_page.dart';
import 'package:Xi_Zach/home_screen.dart';
import 'package:Xi_Zach/home_screen_2.dart';

class RouteGenerator {
  const RouteGenerator._();

  static const home = '';
  static const xizach = '/xizach';
  static const tienlen = '/tienlen';


  static final routes = {
    xizach: (context) => const HomePage(),
    home: (context) => const HomeScreen(),
    tienlen: (context) => const HomeScreen2(),
  };
}
