import 'dart:io';


import 'package:Xi_Zach/helper/formater.dart';
import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xffFC9D45);
const Color kSecondaryColor = Color(0xff573353);
const Color kScaffoldBackground = Color(0xffFFF3E9);

class AppColors {
  AppColors._();

  static const Color background = Color(0XFFF1F4FA);
  static  Color primary = '#7E1717'.toColor();
  static const Color secondary = Color(0XFFFF69B4);
  static const Color accent = Color(0XFF03A89E);
  static const Color text = Color(0XFF06152B);
  static const Color textLight = Color(0XFF99B2C6);
  static const Color neutral = Color(0XFFFFFFFF);
  static const Color lightNeutral = Color(0xFFEEEEEE);
  static const Color lightNeutral5 = Color(0xFFF8F8F8);
  static const Color lightNeutral10 = Color(0xFFDCDCDC);
  static const Color lightNeutral40 = Color(0xFF585858);
  static const textColorLightTheme = Color(0xFF0D0D0E);
  static const Color greenMint = Color(0xFF26AA99);
  static Color whiteBg = Colors.white;
  static Color greyBg = Colors.grey;
  // HexColor.fromHex("f8f9fa")
  static Color backgroundCardColor = '#FCFCFD'.toColor();
  static Color borderCardColor = '#E0E0E0'.toColor();
  static Color backgroundColor = '#f8f9fa'.toColor();
  static Color primaryRedOr = '#fd5f32'.toColor();
  static Color primaryColor = '#43766C'.toColor();
  static Color secondColor = '#F8FAE5'.toColor();
  static Color thirdColor = '#B19470'.toColor();
  static Color fourColor = '#76453B'.toColor();
  static Color fiveColor = '#436850'.toColor();
  static Color sixColor = '#ADBC9F'.toColor();
  static Color sevenColor = '#FBFADA'.toColor();
  static Color primaryDarkColor = '#12372A'.toColor();
  static Color primaryColorWord = '#B5CB99'.toColor();
  static Color primaryColorPink = '#B2533E'.toColor();
  static Color primaryColorYellowW= '#F5EEC8'.toColor();
  static Color primaryColorBlack= '#555843'.toColor();
  static Color primaryColorGreen = '#186F65'.toColor();
  static Color primaryColorYellow = '#FCE09B'.toColor();
  static Color primaryColorGreenPer = '#A7D397'.toColor();
  static Color primaryColorGrey = '#D0D4CA'.toColor();
  // static Color primaryColor = '#025ca6'.toColor();
  static const Color bgButton = Color.fromRGBO(	209, 209, 209, 1.0);


  static double? sizeUI;
  static double? bottomNav;
  static double? bottomArea;


  static void init() {
    if (Platform.isIOS) {
      sizeUI = 255;
      bottomArea = 40;
      bottomNav = 0;
    } else if (Platform.isAndroid) {
      sizeUI = 260;
      bottomNav = 18;
      bottomArea = 0;
    }
  }
// static const Color bgButton = Color.fromRGBO(	204, 204, 204, 1.0);
}

const kHeadingextStyle = TextStyle(
  fontSize: 28,
  color: Color(0xFF0D1333),
  fontWeight: FontWeight.bold,
);

const kSubtitleTextSyule = TextStyle(
  fontSize: 20,
  color: Color(0xFF0D1333),
  // fontWeight: FontWeight.bold,
);

const kTitleTextStyle = TextStyle(
  fontSize: 20,
  color: Color(0xFF0D1333),
  fontWeight: FontWeight.bold,
);

const String dir = "assets/svg/";
class AppSVG{
  AppSVG._();
  static const String payOut = "${dir}payOut.svg";
  static const String payIn = "${dir}payIn.svg";
  static const String historyMoney = "${dir}historyMoney.svg";
  static const String profile = "${dir}profile.svg";
  static const String threeDot = "${dir}threeDot.svg";
  static const String pay = "${dir}pay.svg";
  static const String truck = "${dir}truck.svg";
  static const String voucher = "${dir}voucher.svg";
  static const String cart = "${dir}cart.svg";
  static const String home = "${dir}home.svg";
  static const String logout = "${dir}logout.svg";
  static const String noti = "${dir}noti.svg";
  static const String profi = "${dir}profi.svg";
  static const String wallet = "${dir}wallet.svg";
  static const String setting = "${dir}setting.svg";
  static const String support = "${dir}support.svg";
  static const String gift = "${dir}gift.svg";
  static const String back = "${dir}back.svg";
  static const String ticker = "${dir}ticket.svg";
  static const String close = "${dir}close.svg";
  static const String menu = "${dir}menu.svg";
  static const String location = "${dir}position.svg";
  static const String link = "${dir}link.svg";
  static const String add = "${dir}add.svg";
  static const String next = "${dir}next.svg";
  static const String time = "${dir}time.svg";
  static const String lock = "${dir}lock.svg";
  static const String locationPoint = "${dir}locationPoint.svg";
  static const String filter = "${dir}filter.svg";
  static const String eyeClose = "${dir}eyeClose.svg";
  static const String eyeOpen = "${dir}eyeOpen.svg";
  static const String pointSearch = "${dir}point_search.svg";


  static const String logo = "assets/images/logo_icon.png";


}