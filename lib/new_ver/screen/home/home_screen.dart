import 'package:Xi_Zach/helper/appsetting.dart';
import 'package:Xi_Zach/share/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../router/route.dart';
import '../../../share/share_widget.dart';
import 'package:animator/animator.dart';

import 'history_screen.dart';
import 'package:svg_flutter/svg_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KSScaffold(
      onReady: () {
        // vm.initData(context);
      },
      onBack: () {
        // vm.reset();
        return true;
      },
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      isDisableFitTop: true,
      child: Container(
        // width: double.infinity,
        // height: 900,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              AppColors.primaryColor,
              AppColors.sevenColor,
            ])),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Container(
                    //       padding: const EdgeInsets.all(5),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color: const Color(0xffB7ADE4),
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           CircleAvatar(
                    //             radius: 21,
                    //             backgroundColor: const Color(0xff37EBBC),
                    //             child: CircleAvatar(
                    //               radius: 18,
                    //               child: SvgPicture.asset(
                    //                 'assets/svg/profi.svg',
                    //                 height: 200,
                    //               ),
                    //             ),
                    //           ),
                    //           const SizedBox(width: 5),
                    //           Text(
                    //             '${AppSetting.instance.accessToken}',
                    //             style: const TextStyle(
                    //               color: Color(0xff001663),
                    //             ),
                    //           ),
                    //           const SizedBox(width: 5),
                    //           Image.asset(
                    //             'assets/images/gem.png',
                    //             width: 25,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    child: Container(
                      height: 32,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Chọn chế độ chơi nào',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontSize: 25, letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: Animator<double>(
                      duration: const Duration(milliseconds: 500),
                      cycles: 0,
                      curve: Curves.easeInOut,
                      tween: Tween<double>(begin: 15.0, end: 20.0),
                      builder: (context, animatorState, child) => Icon(
                        Icons.keyboard_arrow_down,
                        size: animatorState.value * 3.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 64,
                  ),
                  CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        height: 410,
                        enlargeCenterPage: true,
                        padEnds: true,
                        viewportFraction: .6,
                      ),
                      items: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(AppRoute.zizach);
                          },
                          child: const CustomStack(
                            image: 'assets/images/logo_1.png',
                            icon: 'assets/images/cloud 1.png',
                            text1: 'ZiZach',
                            text2: 'Nhiều người',
                            color: Color(0xff2D2D2D),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showCustomAlert(
                              context,
                              type: AlertType.warning,
                              title: 'Thông báo',
                              message: 'Phần này đang làm nha, đang lười qué',
                            );
                          },
                          child: const CustomStack(
                            image: 'assets/images/logo_2.png',
                            icon: 'assets/images/NetBar.png',
                            text1: 'Tien len',
                            text2: '2-4 người',
                            color: Color(0xff444444),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showCustomAlert(
                              context,
                              type: AlertType.warning,
                              title: 'Thông báo',
                              message: 'Phần này đang làm nha, đang lười qué',
                            );
                          },
                          child: const CustomStack(
                            image: 'assets/images/logo_3.png',
                            icon: 'assets/images/group 1.png',
                            text1: 'Chơi nhiều người',
                            text2: 'Game không cần cái',
                            color: Color(0xff444444),
                          ),
                        ),
                      ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
