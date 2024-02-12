import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svg_flutter/svg_flutter.dart';
import '../../../router/route.dart';
import '../../../share/app_styles.dart';
import '../../../share/share_widget.dart';
import 'package:provider/provider.dart';

import '../../viewModel/zizach_Controller.dart';

class ZiZachScreen extends StatefulWidget {
  const ZiZachScreen({super.key});

  @override
  State<ZiZachScreen> createState() => _ZiZachScreenState();
}

class _ZiZachScreenState extends State<ZiZachScreen> {
  TextEditingController test = TextEditingController();
  bool switchValue = false;
  int _toggleValue = 0;
  int _toggleValue2 = 0;
  final List<String> dataList = [
    'Item 1ư928490218401824120',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5'
  ];

  @override
  void dispose() {
    // Assuming that ZiZackController is a ChangeNotifier
    Provider.of<ZiZackController>(context, listen: false).dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: "Lịch sử chơi",
        leading: CircleAvatar(
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
      ),
      body: Consumer<ZiZackController>(builder: (context, result, child) {
        return Column(
          children: [
            HorizontalListView(
              data: result.listChar,
              index: 1,
            )
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here
          showPopupInfoOne(context);
          if (kDebugMode) {
            print('Floating Action Button Pressed');
          }
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ), // Set your desired button color
      ),
    );
  }

  Future<BuildContext?> showPopupInfoOne(BuildContext context) {
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
                    return Consumer<ZiZackController>(builder: (context, result, child) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          )
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
                            Expanded(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: SingleChildScrollView(
                                  // physics: NeverScrollableScrollPhysics(),
                                  // shrinkWrap: true,
                                  controller: controller,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Người chơi",
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primaryColor),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: List.generate(
                                            (result.listCharNew.length / 2).ceil(),
                                            (rowIndex) => Row(
                                              children: List.generate(
                                                2,
                                                (columnIndex) {
                                                  final index =
                                                      rowIndex * 2 + columnIndex;
                                                  return index < result.listCharNew.length
                                                      ? Expanded(
                                                          child: SizedBox(
                                                            height: 70,
                                                            // Set the fixed height here
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      8.0),
                                                              margin:
                                                                  EdgeInsets.all(
                                                                      8.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
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
                                                                            TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          color: Colors
                                                                              .blue,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                      ),
                                                                    ),
                                                                    Spacer(),
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                              result.listCharNew.remove(
                                                                                  result.listCharNew[
                                                                                  index]);
                                                                        });
                                                                      },
                                                                      icon: Icon(Icons
                                                                          .remove_circle),
                                                                      color: AppColors
                                                                          .primaryRedOr,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox
                                                          .shrink(); // Use SizedBox.shrink() for empty cells
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    child: TextField(
                                                      controller: test,
                                                      decoration: InputDecoration(
                                                        hintText:
                                                            'Nhập tên người chơi',
                                                        border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  12.0),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  12.0),
                                                          borderSide: BorderSide(
                                                              color: AppColors
                                                                  .primaryColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    width: 100,
                                                    child: ButtonColor(
                                                      onTap: () {
                                                        print("dj");
                                                        Provider.of<ZiZackController>(
                                                                context,
                                                                listen: false)
                                                            .addNewChar(test.text);
                                                        test.clear();
                                                      },
                                                      "Thêm",
                                                      backgroundColor:
                                                          AppColors.primaryColor,
                                                    ))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Hiện tổng điểm khi chơi',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: AppColors.primaryColor,
                                                      fontSize: 18),
                                                ),
                                                Switch(
                                                  value: switchValue,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      switchValue = value;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 18.0),
                                              child: Text(
                                                "Chế độ chơi",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.primaryColor,
                                                    fontSize: 24),
                                              ),
                                            ),
                                            AnimatedToggle(
                                              valueChoose: result.fOrc == 0 ? true: false,
                                              size: 450,
                                              height: 50,
                                              values: ['Tự do', 'Giới hạn'],
                                              onToggleCallback: (value) {
                                                Provider.of<ZiZackController>(
                                                    context,
                                                    listen: false)
                                                    .selectMode(value);

                                              },
                                              lock: false,
                                              buttonColor: AppColors.primaryColor,
                                              backgroundColor:
                                                  const Color(0xFFB5C1CC),
                                              textColor: const Color(0xFFFFFFFF),
                                            ),
                                            result.fOrc  == 0
                                                ? Container(
                                                    child: Text(
                                                      "Chế dộ chơi tự do không giới hạn lượt chơi",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  )
                                                : Container(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 220,
                                                              child: AnimatedToggle(
                                                                height: 50,
                                                                size: 300,
                                                                values: [
                                                                  'Điểm',
                                                                  'Ván'
                                                                ],
                                                                valueChoose: result.dOrv == 0 ? true:false,
                                                                onToggleCallback:
                                                                    (value) {
                                                                      Provider.of<ZiZackController>(
                                                                          context,
                                                                          listen: false)
                                                                          .selectType(value);
                                                                },
                                                                lock: false,
                                                                buttonColor: AppColors
                                                                    .primaryColor,
                                                                backgroundColor:
                                                                    const Color(
                                                                        0xFFB5C1CC),
                                                                textColor:
                                                                    const Color(
                                                                        0xFFFFFFFF),
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 50,
                                                              width: 100,
                                                              child: TextField(
                                                                textAlign: TextAlign
                                                                    .center,
                                                                textAlignVertical:
                                                                    TextAlignVertical
                                                                        .center,
                                                                controller: test,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .primaryColor,
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                // Set numeric keyboard
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .digitsOnly,
                                                                  // Allow only digits
                                                                ],
                                                                decoration:
                                                                    InputDecoration(
                                                                  // hintText: 'Enter Player Name',
                                                                  filled: true,
                                                                  // Set to true to enable filling the background
                                                                  fillColor: AppColors
                                                                      .sixColor
                                                                      .withOpacity(
                                                                          0.5),
                                                                  alignLabelWithHint:
                                                                      true,
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .white, // Set the border color here
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                12.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            result.dOrv == 0
                                                                ? Text(
                                                                    "điểm",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            18,
                                                                        color: AppColors
                                                                            .primaryColor),
                                                                  )
                                                                : Text(
                                                                    "ván",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            18,
                                                                        color: AppColors
                                                                            .primaryColor),
                                                                  )
                                                          ],
                                                        ),
                                                        result.dOrv == 0
                                                            ? Container(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "Ai ăn nhiều nhất thì nghỉ thui, chứ lấy gì bù lỗ.",
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                    Text(
                                                                        "* Có thể thay đổi chế độ chơi sau khi đã tạo ván.",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .w500,
                                                                            fontSize:
                                                                                15))
                                                                  ],
                                                                ),
                                                              )
                                                            : Container(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      "Chơi đủ ván rồi nghỉ thui, lời lỗ không quan trọng zui là được.",
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                    Text(
                                                                        "* Có thể thay đổi chế độ chơi sau khi đã tạo ván.",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .w500,
                                                                            fontSize:
                                                                                15))
                                                                  ],
                                                                ),
                                                              )
                                                      ],
                                                    ),
                                                  ),
                                            SizedBox(
                                              height: 50,
                                            ),
                                            ButtonColor(
                                              onTap:(){
                                                Navigator.pop(context);
                                                print(result.fOrc);
                                                Navigator.of(context).pushNamed(AppRoute.homeGameZiZach);
                                              },
                                              "Bắt đầu thôi",
                                              backgroundColor:
                                                  AppColors.primaryColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );}
                    );
                  });}
            ));
  }
}
