import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../../share/app_styles.dart';
import '../../../share/share_widget.dart';
import '../../viewModel/zizach_Controller.dart';

Future<void> showPopupSetAdd(BuildContext context) {
  return showCupertinoModalBottomSheet(
      topRadius: Radius.circular(36),
      context: context,
      backgroundColor: Colors.transparent,
      // Đảm bảo transparent
      expand: false,
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.85,
          maxChildSize: 0.85,
          expand: false,
          builder: (_, controller) {
            return StatefulBuilder(builder: (BuildContext context,
                StateSetter setState /*You can rename this!*/) {
              return Consumer<ZiZackController>(
                  builder: (context, result, child) {
                return Material(
                  color: Colors.transparent,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.85,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Handle bar
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 60,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),

                        // Phần table với checkbox (scroll được)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 4.0, left: 8.0, right: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Header row cố định
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header cột tên
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4.0, left: 4.0, right: 4.0),
                                      child: Container(
                                        height: 50,
                                        width: 70,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Tên:",
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    // Header các cột checkbox
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4.0, left: 4.0, right: 4.0),
                                        child: Row(
                                          children: List.generate(
                                            result.status.length,
                                            (colIndex) => Expanded(
                                              child: Container(
                                                height: 50,
                                                alignment: Alignment.center,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2.0),
                                                child: Text(
                                                  result.status[colIndex],
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Phần scroll chung cho cả tên và checkbox
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: result.listCharNew
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        final int playerIndex = entry.key;
                                        final String playerName = entry.value;
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4.0, left: 4.0, right: 4.0),
                                          child: Row(
                                            children: [
                                              // Tên người chơi
                                              Container(
                                                height: 50,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  color: result.listOfMaps[
                                                                  playerIndex]
                                                              ['cai'] ==
                                                          false
                                                      ? AppColors.sixColor
                                                      : AppColors.primaryColor,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  playerName,
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    color: AppColors.whiteBg,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              // Các checkbox
                                              Expanded(
                                                child: Row(
                                                  children: List.generate(
                                                    result.status.length,
                                                    (colIndex) {
                                                      String printValue = (colIndex ==
                                                              0)
                                                          ? 'win'
                                                          : (colIndex == 1)
                                                              ? 'def'
                                                              : (colIndex == 2)
                                                                  ? 'x2'
                                                                  : (colIndex ==
                                                                          3)
                                                                      ? 'all'
                                                                      : (colIndex ==
                                                                              4)
                                                                          ? 'hue'
                                                                          : '';
                                                      return Expanded(
                                                        child: Container(
                                                          height: 50,
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      2.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .sixColor,
                                                            border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Checkbox(
                                                            value: result.calPoint[
                                                                        playerIndex]
                                                                    [
                                                                    printValue] ??
                                                                false,
                                                            activeColor: AppColors
                                                                .primaryColor,
                                                            checkColor:
                                                                Colors.white,
                                                            onChanged:
                                                                (bool? value) {
                                                              if (result.listOfMaps[
                                                                          playerIndex]
                                                                      ['cai'] ==
                                                                  false) {
                                                                // Nếu đang tích (value == true), bỏ tích tất cả checkbox khác của người này
                                                                if (value ==
                                                                    true) {
                                                                  // Bỏ tích các checkbox khác
                                                                  [
                                                                    'win',
                                                                    'def',
                                                                    'x2',
                                                                    'all',
                                                                    'hue'
                                                                  ].forEach(
                                                                      (key) {
                                                                    if (key !=
                                                                        printValue) {
                                                                      Provider.of<ZiZackController>(context, listen: false).setCheckBox(
                                                                          playerIndex +
                                                                              1,
                                                                          key,
                                                                          false);
                                                                    }
                                                                  });
                                                                }
                                                                // Sau đó mới set checkbox hiện tại
                                                                Provider.of<ZiZackController>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .setCheckBox(
                                                                        playerIndex +
                                                                            1,
                                                                        printValue,
                                                                        value!);
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Các nút điều khiển (cố định ở cuối)
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: KSButton(
                                      "Cái ăn tất",
                                      backgroundColor: AppColors.sixColor,
                                      onTap: () {
                                        Provider.of<ZiZackController>(context,
                                                listen: false)
                                            .setCheckAll(true,
                                                result.listOfMaps.length, true);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: KSButton(
                                      "Dân ăn tất",
                                      backgroundColor: AppColors.sixColor,
                                      onTap: () {
                                        Provider.of<ZiZackController>(context,
                                                listen: false)
                                            .setCheckAll(false,
                                                result.listOfMaps.length, true);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              KSButton(
                                "Cái x2 toàn sàn",
                                backgroundColor: AppColors.primaryColor,
                                onTap: () {
                                  final controller =
                                      Provider.of<ZiZackController>(context,
                                          listen: false);

                                  // Set checkbox "all" (x2 đền) cho tất cả người chơi không phải cái
                                  controller.setCheckAllCaiX2(
                                      result.listOfMaps.length, true);

                                  // Đóng popup
                                  Navigator.pop(context);

                                  // Tính điểm và kết thúc ván
                                  controller.calculateEndForMaps();

                                  // Kiểm tra xem có đạt điều kiện kết thúc không
                                  if (controller.checkGameEndCondition()) {
                                    // Hiển thị dialog kết thúc game
                                    Future.delayed(Duration(milliseconds: 300),
                                        () {
                                      showEndGameDialog(context);
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 12),
                              KSButton(
                                "Chốt sổ",
                                backgroundColor: AppColors.primaryColor,
                                onTap: () {
                                  final controller =
                                      Provider.of<ZiZackController>(context,
                                          listen: false);

                                  // Kiểm tra tất cả người chơi (không phải cái) phải có ít nhất 1 checkbox được tích
                                  bool allPlayersHaveSelection = true;
                                  List<String> playersWithoutSelection = [];

                                  for (int i = 0;
                                      i < controller.listCharNew.length;
                                      i++) {
                                    // Bỏ qua người chơi là cái
                                    if (controller.listOfMaps[i]['cai'] ==
                                        true) {
                                      continue;
                                    }

                                    // Kiểm tra xem người chơi này có ít nhất 1 checkbox được tích không
                                    bool hasSelection = false;
                                    ['win', 'def', 'x2', 'all', 'hue']
                                        .forEach((key) {
                                      if (controller.calPoint[i][key] == true) {
                                        hasSelection = true;
                                      }
                                    });

                                    if (!hasSelection) {
                                      allPlayersHaveSelection = false;
                                      playersWithoutSelection
                                          .add(controller.listCharNew[i]);
                                    }
                                  }

                                  if (!allPlayersHaveSelection) {
                                    // Hiển thị thông báo lỗi
                                    showCustomAlert(
                                      context,
                                      type: AlertType.warning,
                                      title: 'Thiếu thông tin',
                                      message:
                                          'Các người chơi sau chưa chọn kết quả:\n${playersWithoutSelection.join(", ")}\n\nVui lòng chọn ít nhất 1 ô cho mỗi người chơi!',
                                    );
                                    return;
                                  }

                                  Navigator.pop(context);
                                  controller.calculateEndForMaps();

                                  // Kiểm tra xem có đạt điều kiện kết thúc không
                                  if (controller.checkGameEndCondition()) {
                                    // Hiển thị dialog kết thúc game
                                    Future.delayed(Duration(milliseconds: 300),
                                        () {
                                      showEndGameDialog(context);
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            });
          })).whenComplete(() =>
      Provider.of<ZiZackController>(context, listen: false).checlNewRound());
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
            alignment: Alignment.center,
            child: (col != 0 && col != -1)
                ? Text(
                    "Ván: ${col}",
                    style: TextStyle(
                        fontSize: 17,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  )
                : (col != -1)
                    ? Text(
                        "Tên:",
                        style: TextStyle(
                            fontSize: 17,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        "Điểm:",
                        style: TextStyle(
                            fontSize: 17,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
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
                color: result.listOfMaps[index - 1]['cai'] == false
                    ? AppColors.sixColor
                    : AppColors.primaryColor,
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              alignment: Alignment.center,
              child: Text(
                "$label",
                style: TextStyle(
                    fontSize: 17,
                    color: AppColors.whiteBg,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
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
              borderRadius:
                  BorderRadius.circular(10.0), // Set your desired border radius
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
                      result.status[col],
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
                          : (col == 4)
                              ? 'hue'
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
                      activeColor: AppColors.primaryColor,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        if (result.listOfMaps[index - 1]['cai'] == false) {
                          // Nếu đang tích (value == true), bỏ tích tất cả checkbox khác của người này
                          if (value == true) {
                            // Bỏ tích các checkbox khác
                            ['win', 'def', 'x2', 'all', 'hue'].forEach((key) {
                              if (key != printValue) {
                                Provider.of<ZiZackController>(context,
                                        listen: false)
                                    .setCheckBox(index, key, false);
                              }
                            });
                          }
                          // Sau đó mới set checkbox hiện tại
                          Provider.of<ZiZackController>(context, listen: false)
                              .setCheckBox(index, printValue, value!);
                        }
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hàng header với tên các cột (Ăn, Thua, X2, Đền)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
            child: Row(
              children: List.generate(
                labelLists.length,
                (colIndex) => Expanded(
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Text(
                      result.status[colIndex],
                      style: TextStyle(
                        fontSize: 17,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Các hàng checkbox cho từng người chơi
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: result.listCharNew.asMap().entries.map((entry) {
                  final int playerIndex = entry.key;
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
                    child: Row(
                      children: List.generate(
                        labelLists.length,
                        (colIndex) {
                          String printValue = (colIndex == 0)
                              ? 'win'
                              : (colIndex == 1)
                                  ? 'def'
                                  : (colIndex == 2)
                                      ? 'x2'
                                      : (colIndex == 3)
                                          ? 'all'
                                          : (colIndex == 4)
                                              ? 'hue'
                                              : '';
                          return Expanded(
                            child: Container(
                              height: 50,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              decoration: BoxDecoration(
                                color: AppColors.sixColor,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              alignment: Alignment.center,
                              child: Checkbox(
                                value: result.calPoint[playerIndex]
                                        [printValue] ??
                                    false,
                                activeColor: AppColors.primaryColor,
                                checkColor: Colors.white,
                                onChanged: (bool? value) {
                                  if (result.listOfMaps[playerIndex]['cai'] ==
                                      false) {
                                    // Nếu đang tích (value == true), bỏ tích tất cả checkbox khác của người này
                                    if (value == true) {
                                      // Bỏ tích các checkbox khác
                                      ['win', 'def', 'x2', 'all', 'hue']
                                          .forEach((key) {
                                        if (key != printValue) {
                                          Provider.of<ZiZackController>(context,
                                                  listen: false)
                                              .setCheckBox(
                                                  playerIndex + 1, key, false);
                                        }
                                      });
                                    }
                                    // Sau đó mới set checkbox hiện tại
                                    Provider.of<ZiZackController>(context,
                                            listen: false)
                                        .setCheckBox(playerIndex + 1,
                                            printValue, value!);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  });
}
