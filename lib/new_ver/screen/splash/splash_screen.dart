import 'package:Xi_Zach/home_screen.dart';
import 'package:Xi_Zach/share/app_styles.dart';
import 'package:Xi_Zach/share/share_widget.dart';
import 'package:flutter/material.dart';

import '../../../router/route.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 200,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Kiddo-Cal',
                  style: TextStyle(
                    color: Color(0xff37EBBC),
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Wave(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: AppColors.secondColor,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Ứng dụng lưu trữ thông tin những ván chơi của hội bạn bè',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'tránh bạn bè kêu không có tiền mặt :))',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black45,
                    ),
                  ),
                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ButtonColor(
                      "Bắt đầu với phiên bản cũ",
                      backgroundColor: AppColors.lightNeutral10,
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeScreen(),    ));

                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ButtonColor(
                      "Bắt đầu với phiên bản mới",
                      backgroundColor: AppColors.primaryColor,
                      onTap: (){
                        Navigator.pushReplacementNamed(context, AppRoute.welcome);

                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
