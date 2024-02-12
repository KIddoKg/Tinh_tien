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

  List<String> status = ["Ăn", "Thua", "X2", "Đền"];

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
    // initSt();
    // loadListCharNew();
    Provider.of<ZiZackController>(context, listen: false).initSt();
    // TODO: implement initState

    super.initState();
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              actions: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.backgroundColor,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        AppSVG.back,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 4.0, left: 8.0, right: 8.0),
                        child: Container(
                          width: 500,
                          height: result.listCharNew.length * 60 >
                                  MediaQuery.of(context).size.height
                              ? result.listCharNew.length * 60
                              : MediaQuery.of(context).size.height,
                          child: Row(
                            children: [
                              generateColumn(Colors.red, result.listCharNew, 0),
                              generateDynamicColumns(Colors.blue, result.point),
                              generateColumnInt(Colors.red,
                                  calculateSumForEachList(result.point), -1),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 20,
                  right: 30,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shadow(
                          radius: 10,
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
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
                                          SvgPicture.asset(
                                            AppSVG.cart,
                                            color: AppColors.primary,
                                          ),
                                          Text(
                                            'Section 1',
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
                                ), // Add some spacing between the sections
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
                                          SvgPicture.asset(
                                            AppSVG.cart,
                                            color: AppColors.primary,
                                          ),
                                          Text(
                                            'Section 1',
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
                                ), // Add some spacing between the sections
                                Expanded(
                                  child: InkWellCir(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            AppSVG.cart,
                                            color: AppColors.primary,
                                          ),
                                          Text(
                                            'Section 1',
                                            style: TextStyle(
                                                color: AppColors.primaryColor),
                                          ),
                                        ],
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
                  ),
                ),
              ],
            )),
      );
    });
  }

  Future<BuildContext?> showPopupSetPoint(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        // isScrollControlled: true,
        backgroundColor: Colors.transparent,
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
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 60, // Độ rộng của hình chữ nhật
                            height: 10, // Chiều cao của hình chữ nhật
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              // Màu nền của hình chữ nhật
                              borderRadius:
                                  BorderRadius.circular(20), // Bán kính bo tròn
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 250,
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: [
                                Column(
                                  children: List.generate(
                                    (result.listCharNew.length / 2).ceil(),
                                    (rowIndex) => Row(
                                      children: List.generate(
                                        2,
                                        (columnIndex) {
                                          final index =
                                              rowIndex * 2 + columnIndex;
                                          return index <
                                                  result.listCharNew.length
                                              ? Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      // Handle the container tap event here

                                                      Provider.of<ZiZackController>(
                                                              context,
                                                              listen: false)
                                                          .chooseCon(index);

                                                      print(
                                                          "Container $index tapped");
                                                    },
                                                    child: SizedBox(
                                                      height: 70,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        margin: const EdgeInsets
                                                            .all(8.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: result
                                                                      .selectedIndex ==
                                                                  index
                                                              ? AppColors
                                                                  .primaryColor
                                                              : AppColors
                                                                  .sixColor
                                                                  .withOpacity(
                                                                      0.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Center(
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  result.listCharNew[
                                                                      index],
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                "${result.listOfMaps[index]['point'] == "" ? 0 : result.listOfMaps[index]['point']}",
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              // physics: NeverScrollableScrollPhysics(),
                              // shrinkWrap: true,
                              controller: controller,
                              child: Container(
                                height: 411.0,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 35.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                numericInputButton('1'),
                                                numericInputButton('2'),
                                                numericInputButton('3'),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                numericInputButton('4'),
                                                numericInputButton('5'),
                                                numericInputButton('6'),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                numericInputButton('7'),
                                                numericInputButton('8'),
                                                numericInputButton('9'),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                numericInputButton('-/+'),
                                                numericInputButton('0'),
                                                backButton()
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 15.0,
                                            left: 8.0,
                                            right: 8.0,
                                            top: 29.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 150,
                                              child: ButtonColor(onTap: () {
                                                Provider.of<ZiZackController>(
                                                        context,
                                                        listen: false)
                                                    .setCai(context);
                                              },
                                                  backgroundColor:
                                                      AppColors.primaryColor,
                                                  "Làm Cái"),
                                            ),
                                            Spacer(),
                                            Container(
                                              width: 150,
                                              child: ButtonColor(onTap: () {
                                                Navigator.pop(context);
                                              },
                                                  backgroundColor:
                                                      AppColors.primaryColor,
                                                  "Set điểm"),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
              });
            }));
  }

  Future<void> showPopupSetAdd(BuildContext context) {
    return showModalBottomSheet<void>(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        // isScrollControlled: true,
        backgroundColor: Colors.transparent,
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
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 60, // Độ rộng của hình chữ nhật
                              height: 10, // Chiều cao của hình chữ nhật
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                // Màu nền của hình chữ nhật
                                borderRadius: BorderRadius.circular(
                                    20), // Bán kính bo tròn
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16, top: 8, bottom: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                  MediaQuery.of(context).size.width < 1000 ?
                              MediaQuery.of(context).size.width /
                                                    2 -
                                                20 : 300,
                                        child: ButtonColor(
                                          "Cái ăn tất",
                                          backgroundColor:
                                              AppColors.primaryColor,
                                          onTap: () {
                                            Provider.of<ZiZackController>(
                                                    context,
                                                    listen: false)
                                                .setCheckAll(
                                                    true,
                                                    result.listOfMaps.length,
                                                    true);
                                          },
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width:
                                        MediaQuery.of(context).size.width < 1000 ?
                                        MediaQuery.of(context).size.width /
                                            2 -
                                            20 : 300,
                                        child: ButtonColor(
                                          "Dân ăn tất",
                                          backgroundColor:
                                              AppColors.primaryColor,
                                          onTap: () {
                                            Provider.of<ZiZackController>(
                                                    context,
                                                    listen: false)
                                                .setCheckAll(
                                                    false,
                                                    result.listOfMaps.length,
                                                    true);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16),
                                  child: ButtonColor(
                                    "Chốt sổ",
                                    backgroundColor: AppColors.primaryColor,
                                    onTap: () {
                                      Navigator.pop(context);
                                      Provider.of<ZiZackController>(context,
                                              listen: false)
                                          .calculateEndForMaps();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 600,
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, left: 8.0, right: 8.0),
                                  child: Container(
                                    height: result.listCharNew.length * 60 >
                                            MediaQuery.of(context).size.height
                                        ? result.listCharNew.length * 60
                                        : MediaQuery.of(context).size.height,
                                    child: Row(
                                      children: [
                                        generateColumn(
                                            Colors.red, result.listCharNew, 0),
                                        generateDynamicColumnsStatus(
                                            context, Colors.blue, status),
                                      ],
                                    ),
                                  ),
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

  Widget numericInputButton(String value) {
    return Consumer<ZiZackController>(builder: (context, result, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              Provider.of<ZiZackController>(context, listen: false)
                  .appendToOutput(result.selectedIndex, value);
            },
            splashColor: Colors.blue,
            child: Container(
              height: 50,
              width: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.fiveColor,
                    blurRadius: 3.0,
                  )
                ],
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
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
                        "${status[col]}",
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
