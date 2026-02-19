import 'package:Xi_Zach/new_ver/screen/gameOne/set_money_widget.dart';
import 'package:Xi_Zach/new_ver/screen/gameOne/set_point_own_widget.dart';
import 'package:Xi_Zach/new_ver/screen/gameOne/set_point_wave_widget.dart';
import 'package:Xi_Zach/new_ver/screen/gameOne/game_settings_dialog.dart';
import 'package:Xi_Zach/new_ver/screen/gameOne/game_guide_dialog.dart';
import 'package:Xi_Zach/new_ver/screen/gameOne/share_game_qr_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svg_flutter/svg_flutter.dart';
import '../../../data/flex_grid_source.dart';
import '../../../data/utils.dart';
import '../../../router/route.dart';
import '../../../share/app_styles.dart';
import '../../../share/share_widget.dart';
import '../../viewModel/zizach_Controller.dart';
import 'package:provider/provider.dart';
import 'package:flex_grid/flex_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeZiZach extends StatefulWidget {
  const HomeZiZach({super.key});

  @override
  State<HomeZiZach> createState() => _HomeZiZachState();
}

class _HomeZiZachState extends State<HomeZiZach> {
  TextEditingController test = TextEditingController();
  bool switchValue = false;
  FlexGridSource source = FlexGridSource();
  ScrollController _horizontalScrollController = ScrollController();
  ScrollController _verticalScrollController =
      ScrollController(); // Scroll dọc đồng bộ

  List<int> calculateSumForEachList(List<List<int>> listOfLists) {
    if (listOfLists.isEmpty) {
      return [];
    }

    int numberOfElements = listOfLists[0].length;

    List<int> sums = List.filled(numberOfElements, 0);

    for (List<int> list in listOfLists) {
      for (int i = 0; i < numberOfElements; i++) {
        sums[i] += list[i];
      }
    }

    return sums;
  }

  String concatenatedValue = '';

  @override
  void initState() {
    super.initState();

    // KHÔNG gọi initSt() nữa vì:
    // 1. Nếu là game mới → đã gọi initSt() ở popup trước khi vào đây
    // 2. Nếu là continue game → đã load data từ continueInProgressGame()
    // Gọi initSt() ở đây sẽ GHI ĐÈ dữ liệu vừa load!

    print('🎮 HomeZiZach initState - KHÔNG gọi initSt() để giữ dữ liệu');
    final controller = Provider.of<ZiZackController>(context, listen: false);
    print('   listCharNew: ${controller.listCharNew.length} người');
    print('   point: ${controller.point.length} ván');
    print('   listOfMaps: ${controller.listOfMaps.length} players');
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Colors.grey.withOpacity(0.5);
    final MyCellStyle style =
        MyCellStyle(frozenedColumnsCount: 1, frozenedRowsCount: 0);
    return Consumer<ZiZackController>(builder: (context, result, child) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: CustomAppBar(
              context: context,
              title: "Ván ${result.point.length}",
              leading: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.backgroundColor,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        AppSVG.back,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        showExitDialog(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.backgroundColor,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        AppSVG.setting,
                        color: AppColors.primary,
                      ),
                      tooltip: 'Cài đặt trò chơi',
                      onPressed: () {
                        showGameSettingsDialog(context);
                      },
                    ),
                  ),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  // CircleAvatar(
                  //   backgroundColor: AppColors.backgroundColor,
                  //   child: IconButton(
                  //     icon: Icon(
                  //       Icons.bug_report,
                  //       color: AppColors.primary,
                  //     ),
                  //     onPressed: () async {
                  //       // In ra console để debug
                  //       print('\n🔍 DEBUG: Checking game history...\n');
                  //       await Provider.of<ZiZackController>(context,
                  //               listen: false)
                  //           .printGameHistory();
                  //       Provider.of<ZiZackController>(context, listen: false)
                  //           .printCurrentSession();
                  //
                  //       // Hiển thị thông báo
                  //       showCustomAlert(
                  //         context,
                  //         type: AlertType.success,
                  //         title: 'Debug',
                  //         message:
                  //             'Đã in gameHistory ra console. Kiểm tra debug console để xem!',
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
              actions: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.backgroundColor,
                    child: IconButton(
                      icon: Icon(
                        Icons.qr_code_2,
                        color: AppColors.primary,
                      ),
                      tooltip: 'Chia sẻ QR code',
                      onPressed: () {
                        showShareGameQRDialog(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: AppColors.backgroundColor,
                    child: IconButton(
                      icon: Icon(
                        Icons.help_outline,
                        color: AppColors.primary,
                      ),
                      tooltip: 'Hướng dẫn chơi game',
                      onPressed: () {
                        showGameGuideDialog(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: AppColors.backgroundColor,
                    child: IconButton(
                      icon: Icon(
                        result.inputMode == 0
                            ? Icons.calculate_outlined
                            : Icons.back_hand_outlined,
                        color: AppColors.primary,
                      ),
                      tooltip: result.inputMode == 0
                          ? 'Chuyển sang chế độ Tính tay'
                          : 'Chuyển sang chế độ Tính điểm',
                      onPressed: () {
                        Provider.of<ZiZackController>(context, listen: false)
                            .toggleInputMode();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              // actions: Row(
              //   children: [
              //     CircleAvatar(
              //       backgroundColor: AppColors.backgroundColor,
              //       child: IconButton(
              //         icon: SvgPicture.asset(
              //           AppSVG.back,
              //           color: AppColors.primary,
              //         ),
              //         onPressed: () {
              //           Navigator.pop(context);
              //         },
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 10,
              //     ),
              //     CircleAvatar(
              //       backgroundColor: AppColors.backgroundColor,
              //       child: IconButton(
              //         icon: SvgPicture.asset(
              //           AppSVG.setting,
              //           color: AppColors.primary,
              //         ),
              //         onPressed: () {
              //           Navigator.pop(context);
              //         },
              //       ),
              //     ),
              //   ],
              // ),
            ),
            body: Column(
              children: [
                // Banner hiển thị chế độ chơi
                if (result.fOrc == 1 && result.limitValue > 0)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      border: Border(
                        bottom: BorderSide(color: Colors.blue[200]!, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.blue[700], size: 18),
                        SizedBox(width: 8),
                        Text(
                          result.dOrv == 0
                              ? 'Chế độ: Giới hạn ${result.limitValue} điểm'
                              : 'Chế độ: Giới hạn ${result.limitValue} ván',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                // Toàn bộ table với scroll đồng bộ
                Expanded(
                  child: SingleChildScrollView(
                    controller: _verticalScrollController,
                    child: SingleChildScrollView(
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          // Header row - Tên người chơi
                          Row(
                            children:
                                result.listCharNew.asMap().entries.map((entry) {
                              final int playerIndex = entry.key;
                              final String name = entry.value;
                              final int totalScore = result.point.isEmpty
                                  ? 0
                                  : calculateSumForEachList(
                                      result.point)[playerIndex];

                              return Container(
                                height: 60,
                                width: 80,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: result.listOfMaps[playerIndex]
                                              ['cai'] ==
                                          false
                                      ? AppColors.sixColor
                                      : AppColors.primaryColor,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Stack(
                                  children: [
                                    // Tên chính ở giữa
                                    Center(
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.whiteBg,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Tổng điểm nhỏ ở góc dưới phải
                                    if (result.showTotalScore &&
                                        result.point.isNotEmpty)
                                      Positioned(
                                        bottom: 2,
                                        right: 4,
                                        child: Text(
                                          "$totalScore",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors.whiteBg
                                                .withOpacity(0.8),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          // Body - Điểm các ván
                          ...result.point.asMap().entries.map((vanEntry) {
                            final int vanIndex = vanEntry.key;
                            final List<int> vanScores = vanEntry.value;

                            return Row(
                              children: result.listCharNew
                                  .asMap()
                                  .entries
                                  .map((playerEntry) {
                                final int playerIndex = playerEntry.key;
                                final int score = vanScores[playerIndex];

                                return Container(
                                  height: 60,
                                  width: 80,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 2.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.sixColor.withOpacity(0.7),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Stack(
                                    children: [
                                      // Số ván nhỏ ở góc trên bên trái
                                      Positioned(
                                        top: 2,
                                        left: 4,
                                        child: Text(
                                          "${vanIndex + 1}",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors.whiteBg
                                                .withOpacity(0.6),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      // Điểm chính ở giữa
                                      Center(
                                        child: Text(
                                          score == 0 ? "0" : "$score",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.whiteBg,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom controls
                Container(
                  padding:
                      EdgeInsets.only(bottom: 10, left: 20, right: 30, top: 10),
                  child: Shadow(
                    radius: 10,
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: result.inputMode == 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: InkWellCir(
                                    onTap: () {
                                      showPopupSetPoint(context);
                                    },
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.padding_outlined),
                                          Text(
                                            'Cài điểm',
                                            style: TextStyle(
                                                color: AppColors.primaryColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  color: AppColors.thirdColor,
                                ),
                                Expanded(
                                  child: InkWellCir(
                                    onTap: () {
                                      showPopupSetAdd(context);
                                    },
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.calculate_outlined),
                                          Text(
                                            'Tính điểm',
                                            style: TextStyle(
                                                color: AppColors.primaryColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  color: AppColors.thirdColor,
                                ),
                                Expanded(
                                  child: InkWellCir(
                                    onTap: () {
                                      if (result.point.isEmpty) {
                                        showCustomAlert(
                                          context,
                                          type: AlertType.warning,
                                          title: 'Thông báo',
                                          message:
                                              'Chưa có ván nào để kết thúc!',
                                        );
                                      } else {
                                        showEndGameDialog(context);
                                      }
                                    },
                                    child: Center(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.emoji_events_outlined),
                                            Text(
                                              'Kết thúc',
                                              style: TextStyle(
                                                  color:
                                                      AppColors.primaryColor),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: InkWellCir(
                                    onTap: () {
                                      showPopupSetPointOwn(context);
                                    },
                                    child: Center(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.back_hand_outlined),
                                            Text(
                                              'Tính tay',
                                              style: TextStyle(
                                                  color:
                                                      AppColors.primaryColor),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  color: AppColors.thirdColor,
                                ),
                                Expanded(
                                  child: InkWellCir(

                                    onTap: () {
                                      if (result.point.isEmpty) {
                                        showCustomAlert(
                                          context,
                                          type: AlertType.warning,
                                          title: 'Thông báo',
                                          message:
                                              'Chưa có ván nào để kết thúc!',
                                        );
                                      } else {
                                        showEndGameDialog(context);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.emoji_events_outlined),
                                              Text(
                                                'Kết thúc',
                                                style: TextStyle(
                                                    color:
                                                        AppColors.primaryColor),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            )),
      );
    });
  }

  Widget backButton() {
    return Consumer<ZiZackController>(builder: (context, result, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              Provider.of<ZiZackController>(context, listen: false)
                  .appendDel(result.selectedIndex);
            },
            child: Container(
              height: 60,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.red,
                    blurRadius: 3.0,
                  )
                ],
              ),
              child: const Icon(
                Icons.backspace,
                color: Color(0xFF676767),
              ),
            ),
          )
        ],
      );
    });
  }

  Widget generateColumn(Color color, List<String> labels, int col) {
    return Consumer<ZiZackController>(builder: (context, result, child) {
      return Column(
        children: [
          // Index display
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
            child: Container(
              height: 50,
              width: 70,
              // color: color,
              child: (col != 0 && col != -1)
                  ? Center(
                      child: Text(
                      "Ván: ${col}",
                      style: TextStyle(
                          fontSize: 17,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700),
                    ))
                  : (col != -1)
                      ? Center(
                          child: Text(
                          "Tên:",
                          style: TextStyle(
                              fontSize: 17,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700),
                        ))
                      : Center(
                          child: Text(
                          "Điểm:",
                          style: TextStyle(
                              fontSize: 17,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700),
                        )),
            ),
          ),
          // Labels
          ...labels.asMap().entries.map((entry) {
            final int index =
                entry.key + 1; // Adding 1 to start from 1 instead of 0
            final String label = entry.value;

            return Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
              child: Container(
                height: 50,
                width: 70,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  color: result.listOfMaps[index - 1]['cai'] == false
                      ? AppColors.sixColor
                      : AppColors.primaryColor,
                  border: Border.all(
                    color: Colors.white,
                    // Set your desired border color
                    width: 2.0, // Set your desired border width
                  ),
                  borderRadius: BorderRadius.circular(
                      10.0), // Set your desired border radius
                ),
                child: Center(
                    child: Text(
                  "$label",
                  style: TextStyle(
                      fontSize: 17,
                      color: AppColors.whiteBg,
                      fontWeight: FontWeight.w700),
                )),
              ),
            );
          }).toList(),
        ],
      );
    });
  }

  Widget generateColumnInt(Color color, List<int> labels, int col) {
    return Column(
      children: [
        // Index display
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
          child: Container(
            height: 50,
            width: 70,
            // color: color,
            child: (col != 0 && col != -1)
                ? Center(
                    child: Text(
                    "Ván: ${col}",
                    style: TextStyle(
                        fontSize: 17,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w700),
                  ))
                : (col != -1)
                    ? Center(
                        child: Text(
                        "Tên:",
                        style: TextStyle(
                            fontSize: 17,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700),
                      ))
                    : Center(
                        child: Text(
                        "Điểm:",
                        style: TextStyle(
                            fontSize: 17,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700),
                      )),
          ),
        ),
        // Labels
        ...labels.asMap().entries.map((entry) {
          final int index =
              entry.key + 1; // Adding 1 to start from 1 instead of 0
          final int label = entry.value;

          return Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
            child: Container(
              height: 50,
              width: 70,
              decoration: BoxDecoration(
                color: AppColors.sixColor,
                border: Border.all(
                  color: Colors.white,
                  // Set your desired border color
                  width: 2.0, // Set your desired border width
                ),
                borderRadius: BorderRadius.circular(
                    10.0), // Set your desired border radius
              ),
              child: Center(
                  child: Text(
                "$label",
                style: TextStyle(
                    fontSize: 17,
                    color: AppColors.whiteBg,
                    fontWeight: FontWeight.w700),
              )),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget generateDynamicColumns(Color colors, List<List<int>> labelLists) {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          labelLists.length,
          (index) => generateColumnInt(colors, labelLists[index], index + 1),
        ),
      ),
    );
  }

  Widget generateColumnStatus(
      BuildContext context, Color color, List<String> labels, int col) {
    return Consumer<ZiZackController>(builder: (context, result, child) {
      return Column(
        children: [
          // Index display
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
            child: Container(
              height: 50,
              width: 70,
              child: (col != -1)
                  ? Center(
                      child: Text(
                        "${result.status[col]}",
                        style: TextStyle(
                          fontSize: 17,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : (col != -1)
                      ? Center(
                          child: Text(
                            "Tên:",
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            "Điểm:",
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
            ),
          ),
          // Labels and Checkboxes
          ...labels.asMap().entries.map((entry) {
            final int index =
                entry.key + 1; // Adding 1 to start from 1 instead of 0
            final String label = entry.value;
            String printValue = (col == 0)
                ? 'win'
                : (col == 1)
                    ? 'def'
                    : (col == 2)
                        ? 'x2'
                        : (col == 3)
                            ? 'all'
                            : '';
            return Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
              child: Container(
                height: 50,
                width: 70,
                decoration: BoxDecoration(
                  color: AppColors.sixColor,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: result.calPoint[index - 1][printValue] ?? false,
                        onChanged: (bool? value) {
                          if (result.listOfMaps[index - 1]['cai'] == false)
                            Provider.of<ZiZackController>(context,
                                    listen: false)
                                .setCheckBox(index, printValue, value!);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList()
        ],
      );
    });
  }

  Widget generateDynamicColumnsStatus(
      BuildContext context, Color colors, List<String> labelLists) {
    return Consumer<ZiZackController>(builder: (context, result, child) {
      return Expanded(
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
            labelLists.length,
            (index) => generateColumnStatus(
                context, colors, result.listCharNew, index),
          ),
        ),
      );
    });
  }
}
