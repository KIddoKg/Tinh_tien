import 'dart:convert';
import 'dart:developer';

import 'package:Xi_Zach/helper/appsetting.dart';
import 'package:Xi_Zach/share/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg_flutter.dart';

import '../../../helper/logging.dart';
import '../../../router/route.dart';
import '../../../share/share_widget.dart';
import '../../viewModel/zizach_Controller.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  TextEditingController nameController = TextEditingController();

  bool loading = true;

  onLogin() async {
    // await Future.delayed(Duration(seconds: 5));
    AppSetting.instance.accessToken = nameController.text;
    AppSetting.instance.save();
    FocusManager.instance.primaryFocus?.unfocus();
    print(AppSetting.instance.accessToken);
  }

  onInit() async {
    // await AppSetting.pref.remove('@profile');
    await AppSetting.init();
    bool isExists = AppSetting.pref.containsKey('@appSetting');
    print(AppSetting.instance.accessToken);
    // bool isExits = AppSetting.instance.accessToken != "";
    print(isExists);
    if (!isExists) {
      loading = false;
      setState(() {

      });
      return;
    }

    if (isExists) {
      print("SSS");
      // var user = AppSetting.pref.getString('@profile')!;
      // log('> appsetting.profile: $user');
      // AppLog.instance.add('appsetting.profile', description: user);
      // print("SSS");
      // var appsetting = json.decode(AppSetting.pref.getString('@appSetting')!);
      // AppSetting.fromJson(appsetting);
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacementNamed(
          context, AppRoute.home);
    }
  }

  @override
  void initState() {

    onInit();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:!loading ?  AppColors.primaryColor : AppColors.whiteBg,
      body: !loading ? Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 50),
              SvgPicture.asset(
                'assets/images/space-ship.svg',
                height: 200,
              ),
              const Wave(),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: 520,
                color: AppColors.secondColor,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            'Nhập tên của bạn để bắt đầu',
                            style: TextStyle(fontSize: 27),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: nameController,
                              style: new TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black45,
                                  fontSize: 21),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 25.0, horizontal: 10.0),
                                labelText: null,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 5.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      16.0), // Set border radius
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                    width: 5.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      16.0), // Set border radius
                                ),
                                hintText: 'Tôi có thể gọi bạn là gì ?',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ButtonColor(
                        "Bắt đầu",
                        backgroundColor: AppColors.primaryColor,
                        onTap: () {
                          onLogin();
                          Navigator.pushReplacementNamed(
                              context, AppRoute.home);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ):LoadingDot()
    );
  }
}
