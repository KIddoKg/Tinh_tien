import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../share/app_styles.dart';
import '../../../share/share_widget.dart';
import '../../viewModel/zizach_Controller.dart';

/// Bottom sheet để chỉnh sửa cài đặt game trong khi đang chơi
Future<BuildContext?> showGameSettingsDialog(BuildContext context) {
  final controller = Provider.of<ZiZackController>(context, listen: false);

  // Controllers cho TextField
  TextEditingController nameController = TextEditingController();
  TextEditingController addPlayerController =
      TextEditingController(); // Controller riêng cho thêm người
  TextEditingController limitController = TextEditingController(
      text: controller.limitValue > 0 ? controller.limitValue.toString() : '');

  // State cho rename player
  int? selectedPlayerIndex;

  // Lưu trữ giá trị tạm thời - chỉ áp dụng khi bấm "Xong"
  int tempFOrc = controller.fOrc; // Chế độ: 0 = Tự do, 1 = Giới hạn
  int tempDOrv = controller.dOrv; // Loại giới hạn: 0 = Điểm, 1 = Ván
  int tempLimitValue = controller.limitValue; // Giá trị giới hạn
  bool tempShowTotalScore = controller.showTotalScore; // Hiện tổng điểm

  // Danh sách người chơi tạm - Copy từ controller
  List<String> tempPlayerList = List<String>.from(controller.listCharNew);

  // Map lưu tên mới của người chơi (index -> tên mới)
  Map<int, String> tempRenamedPlayers = {};

  // Danh sách người chơi mới được thêm
  List<String> tempNewPlayers = [];

  return showCupertinoModalBottomSheet(
    topRadius: Radius.circular(36),
    context: context,
    backgroundColor: Colors.transparent,
    expand: false,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.85,
      maxChildSize: 0.85,
      expand: false,
      builder: (_, scrollController) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Consumer<ZiZackController>(
              builder: (context, result, child) {
                return Material(
                  color: Colors.transparent,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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

                          // Content scrollable
                          Expanded(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  children: [
                                    // Tiêu đề
                                    Text(
                                      "Cài đặt trò chơi",
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    // ==================== SECTION 1: QUẢN LÝ NGƯỜI CHƠI ====================
                                    _buildSectionTitle(
                                        Icons.people, 'Quản lý người chơi'),
                                    SizedBox(height: 12),

                                    Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.2),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          // Danh sách người chơi hiện tại - Lưới 3 cột
                                          GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 8,
                                              childAspectRatio: 2.2,
                                            ),
                                            itemCount: tempPlayerList.length,
                                            itemBuilder: (context, index) {
                                              String playerName =
                                                  tempPlayerList[index];
                                              bool isRenaming =
                                                  selectedPlayerIndex == index;

                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: isRenaming
                                                        ? AppColors.primaryColor
                                                        : Colors.grey[300]!,
                                                    width: isRenaming ? 2 : 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    if (isRenaming)
                                                      Expanded(
                                                        child: TextField(
                                                          controller:
                                                              nameController,
                                                          autofocus: true,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: 'Tên...',
                                                            border: InputBorder
                                                                .none,
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 4,
                                                              vertical: 0,
                                                            ),
                                                            isDense: true,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )
                                                    else
                                                      Expanded(
                                                        child: Text(
                                                          playerName,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors
                                                                .grey[800],
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    if (isRenaming)
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              String newName =
                                                                  nameController
                                                                      .text
                                                                      .trim();

                                                              // Kiểm tra tên trống
                                                              if (newName
                                                                  .isEmpty) {
                                                                showCustomAlert(
                                                                  context,
                                                                  type: AlertType
                                                                      .warning,
                                                                  title:
                                                                      'Cảnh báo',
                                                                  message:
                                                                      'Tên người chơi không được để trống!',
                                                                );
                                                                return;
                                                              }

                                                              // Kiểm tra trùng tên (bỏ qua chính nó)
                                                              bool isDuplicate =
                                                                  false;
                                                              for (int i = 0;
                                                                  i <
                                                                      tempPlayerList
                                                                          .length;
                                                                  i++) {
                                                                if (i !=
                                                                        index &&
                                                                    tempPlayerList[i]
                                                                            .toLowerCase() ==
                                                                        newName
                                                                            .toLowerCase()) {
                                                                  isDuplicate =
                                                                      true;
                                                                  break;
                                                                }
                                                              }

                                                              if (isDuplicate) {
                                                                showCustomAlert(
                                                                  context,
                                                                  type: AlertType
                                                                      .warning,
                                                                  title:
                                                                      'Cảnh báo',
                                                                  message:
                                                                      'Tên "$newName" đã tồn tại! Vui lòng chọn tên khác.',
                                                                );
                                                                return;
                                                              }

                                                              if (newName
                                                                  .isNotEmpty) {
                                                                setState(() {
                                                                  // Lưu vào danh sách tạm
                                                                  tempPlayerList[
                                                                          index] =
                                                                      newName;
                                                                  // Đánh dấu đã đổi tên (để apply sau)
                                                                  tempRenamedPlayers[
                                                                          index] =
                                                                      newName;
                                                                  selectedPlayerIndex =
                                                                      null;
                                                                  nameController
                                                                      .clear();
                                                                });
                                                              }
                                                            },
                                                            child: Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .green,
                                                                size: 18),
                                                          ),
                                                          SizedBox(width: 4),
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                selectedPlayerIndex =
                                                                    null;
                                                                nameController
                                                                    .clear();
                                                              });
                                                            },
                                                            child: Icon(
                                                                Icons.close,
                                                                color:
                                                                    Colors.red,
                                                                size: 18),
                                                          ),
                                                        ],
                                                      )
                                                    else
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedPlayerIndex =
                                                                index;
                                                            nameController
                                                                    .text =
                                                                playerName;
                                                          });
                                                        },
                                                        child: Icon(Icons.edit,
                                                            color: AppColors
                                                                .primaryColor,
                                                            size: 16),
                                                      ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),

                                          SizedBox(height: 12),

                                          // Thêm người chơi trực tiếp - Không cần popup
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller:
                                                      addPlayerController,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Nhập tên người chơi mới...',
                                                    prefixIcon: Icon(
                                                      Icons.person_add,
                                                      color: AppColors
                                                          .primaryColor,
                                                      size: 20,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide: BorderSide(
                                                        color: AppColors
                                                            .primaryColor,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 12,
                                                    ),
                                                  ),
                                                  onSubmitted: (value) {
                                                    String newName =
                                                        value.trim();

                                                    // Kiểm tra tên trống
                                                    if (newName.isEmpty) {
                                                      showCustomAlert(
                                                        context,
                                                        type: AlertType.warning,
                                                        title: 'Cảnh báo',
                                                        message:
                                                            'Tên người chơi không được để trống!',
                                                      );
                                                      return;
                                                    }

                                                    // Kiểm tra trùng tên
                                                    bool isDuplicate =
                                                        tempPlayerList.any((name) =>
                                                            name.toLowerCase() ==
                                                            newName
                                                                .toLowerCase());

                                                    if (isDuplicate) {
                                                      showCustomAlert(
                                                        context,
                                                        type: AlertType.warning,
                                                        title: 'Cảnh báo',
                                                        message:
                                                            'Tên "$newName" đã tồn tại! Vui lòng chọn tên khác.',
                                                      );
                                                      return;
                                                    }

                                                    if (newName.isNotEmpty) {
                                                      setState(() {
                                                        // Thêm vào danh sách tạm
                                                        tempPlayerList
                                                            .add(newName);
                                                        // Đánh dấu là người mới (để apply sau)
                                                        tempNewPlayers
                                                            .add(newName);
                                                      });
                                                      addPlayerController
                                                          .clear();
                                                    }
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              ElevatedButton(
                                                onPressed: () {
                                                  String newName =
                                                      addPlayerController.text
                                                          .trim();

                                                  // Kiểm tra tên trống
                                                  if (newName.isEmpty) {
                                                    showCustomAlert(
                                                      context,
                                                      type: AlertType.warning,
                                                      title: 'Cảnh báo',
                                                      message:
                                                          'Tên người chơi không được để trống!',
                                                    );
                                                    return;
                                                  }

                                                  // Kiểm tra trùng tên
                                                  bool isDuplicate =
                                                      tempPlayerList.any((name) =>
                                                          name.toLowerCase() ==
                                                          newName
                                                              .toLowerCase());

                                                  if (isDuplicate) {
                                                    showCustomAlert(
                                                      context,
                                                      type: AlertType.warning,
                                                      title: 'Cảnh báo',
                                                      message:
                                                          'Tên "$newName" đã tồn tại! Vui lòng chọn tên khác.',
                                                    );
                                                    return;
                                                  }

                                                  if (newName.isNotEmpty) {
                                                    setState(() {
                                                      // Thêm vào danh sách tạm
                                                      tempPlayerList
                                                          .add(newName);
                                                      // Đánh dấu là người mới (để apply sau)
                                                      tempNewPlayers
                                                          .add(newName);
                                                    });
                                                    addPlayerController.clear();
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.primaryColor,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 16,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Thêm',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 24),

                                    // ==================== SECTION 2: HIỂN THỊ ====================
                                    _buildSectionTitle(
                                        Icons.visibility, 'Hiển thị'),
                                    SizedBox(height: 12),

                                    Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.2),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.calculate,
                                              color: AppColors.primaryColor),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Hiện tổng điểm',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  'Hiển thị hàng tổng điểm ở cuối bảng',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Switch(
                                            value: tempShowTotalScore,
                                            onChanged: (value) {
                                              setState(() {
                                                tempShowTotalScore = value;
                                              });
                                            },
                                            activeColor: AppColors.primaryColor,
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 24),

                                    // ==================== SECTION 3: CHẾ ĐỘ CHƠI ====================
                                    _buildSectionTitle(
                                        Icons.gamepad, 'Chế độ chơi'),
                                    SizedBox(height: 12),

                                    Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.2),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Toggle Tự do / Giới hạn
                                          Row(
                                            children: [
                                              Icon(Icons.sports_esports,
                                                  color:
                                                      AppColors.primaryColor),
                                              SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  'Loại chế độ',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 12),

                                          Center(
                                            child: AnimatedToggle(
                                              values: ['Tự do', 'Giới hạn'],
                                              onToggleCallback: (value) {
                                                setState(() {
                                                  tempFOrc = value;
                                                });
                                              },
                                              KSButton: AppColors.primaryColor,
                                              backgroundColor:
                                                  Colors.grey[200]!,
                                              textColor:
                                                  const Color(0xFFFFFFFF),
                                              valueChoose: tempFOrc == 0,
                                              height: 50,
                                              size: 450,
                                            ),
                                          ),

                                          // Hiển thị thêm options nếu chọn Giới hạn
                                          if (tempFOrc == 1) ...[
                                            SizedBox(height: 20),
                                            Divider(),
                                            SizedBox(height: 12),

                                            // Toggle Điểm / Ván
                                            Row(
                                              children: [
                                                Icon(Icons.flag,
                                                    color:
                                                        AppColors.primaryColor,
                                                    size: 20),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Giới hạn theo',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 220,
                                                  child: AnimatedToggle(
                                                    height: 50,
                                                    size: 300,
                                                    values: ['Điểm', 'Ván'],
                                                    valueChoose: tempDOrv == 0
                                                        ? true
                                                        : false,
                                                    onToggleCallback: (value) {
                                                      setState(() {
                                                        tempDOrv = value;
                                                      });
                                                    },
                                                    lock: false,
                                                    KSButton:
                                                        AppColors.primaryColor,
                                                    backgroundColor:
                                                        const Color(0xFFB5C1CC),
                                                    textColor:
                                                        const Color(0xFFFFFFFF),
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  width: 100,
                                                  child: TextField(
                                                    controller: limitController,
                                                    maxLines: 1, // ⭐ BẮT BUỘC
                                                    textAlign: TextAlign.center,
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,

                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        tempLimitValue =
                                                            int.tryParse(
                                                                    value) ??
                                                                0;
                                                      });
                                                    },

                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),

                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: AppColors
                                                          .sixColor
                                                          .withOpacity(0.5),

                                                      isDense:
                                                          true, // ⭐ rất quan trọng
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        vertical:
                                                            14, // chỉnh cho vừa chiều cao
                                                        horizontal: 0,
                                                      ),

                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                // tempDOrv == 0
                                                //     ? Text(
                                                //         "điểm",
                                                //         style: TextStyle(
                                                //             fontWeight:
                                                //                 FontWeight.w600,
                                                //             fontSize: 18,
                                                //             color: AppColors
                                                //                 .primaryColor),
                                                //       )
                                                //     : Text(
                                                //         "ván",
                                                //         style: TextStyle(
                                                //             fontWeight:
                                                //                 FontWeight.w600,
                                                //             fontSize: 18,
                                                //             color: AppColors
                                                //                 .primaryColor),
                                                //       )
                                              ],
                                            ),
                                            // Center(
                                            //   child: AnimatedToggle(
                                            //     values: ['Điểm', 'Ván'],
                                            //     onToggleCallback: (value) {
                                            //       result.selectType(value);
                                            //       setState(() {});
                                            //     },
                                            //     KSButton: AppColors.sixColor,
                                            //     backgroundColor:
                                            //         Colors.grey[200]!,
                                            //     textColor:
                                            //         const Color(0xFFFFFFFF),
                                            //     valueChoose: result.dOrv == 0,
                                            //     height: 50,
                                            //     size: 450,
                                            //   ),
                                            // ),

                                            // SizedBox(height: 16),
                                            //
                                            // // TextField nhập giới hạn
                                            // TextField(
                                            //   controller: limitController,
                                            //   keyboardType:
                                            //       TextInputType.number,
                                            //   inputFormatters: [
                                            //     FilteringTextInputFormatter
                                            //         .digitsOnly,
                                            //   ],
                                            //   decoration: InputDecoration(
                                            //     labelText: result.dOrv == 0
                                            //         ? 'Nhập số điểm giới hạn'
                                            //         : 'Nhập số ván giới hạn',
                                            //     hintText: result.dOrv == 0
                                            //         ? 'VD: 100'
                                            //         : 'VD: 10',
                                            //     prefixIcon: Icon(
                                            //       result.dOrv == 0
                                            //           ? Icons.score
                                            //           : Icons.timer,
                                            //       color: AppColors.primaryColor,
                                            //     ),
                                            //     border: OutlineInputBorder(
                                            //       borderRadius:
                                            //           BorderRadius.circular(10),
                                            //     ),
                                            //     focusedBorder:
                                            //         OutlineInputBorder(
                                            //       borderRadius:
                                            //           BorderRadius.circular(10),
                                            //       borderSide: BorderSide(
                                            //         color:
                                            //             AppColors.primaryColor,
                                            //         width: 2,
                                            //       ),
                                            //     ),
                                            //   ),
                                            //   onChanged: (value) {
                                            //     int? limitValue =
                                            //         int.tryParse(value);
                                            //     result.setLimitValue(
                                            //         limitValue ?? 0);
                                            //   },
                                            // ),

                                            SizedBox(height: 12),

                                            // Hướng dẫn
                                            Container(
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[50],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.blue[200]!,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.info_outline,
                                                    color: Colors.blue[700],
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      tempDOrv == 0
                                                          ? 'Game sẽ tự động kết thúc khi người cao nhất đạt số điểm này'
                                                          : 'Game sẽ tự động kết thúc khi đạt số ván này',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.blue[900],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Nút "Xong" ở cuối - luôn cố định
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, -2),
                                ),
                              ],
                            ),
                            child: KSButton(
                              onTap: () async {
                                // Đóng dialog trước
                                Navigator.pop(context);

                                // Đợi một chút để animation hoàn thành
                                await Future.delayed(
                                    Duration(milliseconds: 100));

                                // ===== 1. Áp dụng thay đổi người chơi =====
                                // Đổi tên người chơi
                                tempRenamedPlayers.forEach((index, newName) {
                                  if (index < result.listCharNew.length) {
                                    result.renamePlayer(index, newName);
                                  }
                                });

                                // Thêm người chơi mới
                                for (String newPlayer in tempNewPlayers) {
                                  result.addPlayerToExistingGame(newPlayer);
                                }

                                // ===== 2. Áp dụng thay đổi settings =====
                                result.setShowTotalScore(tempShowTotalScore);
                                result.selectMode(tempFOrc);
                                result.selectType(tempDOrv);
                                result.setLimitValue(tempLimitValue);
                              },
                              "Xong",
                              backgroundColor: AppColors.primaryColor,
                            ),
                          ),
                        ], // Đóng children của Column
                      ), // Đóng Column
                    ), // Đóng Padding
                  ), // Đóng Container
                ); // Đóng Material
              }, // Đóng builder của Consumer
            ); // Đóng Consumer
          }, // Đóng builder của StatefulBuilder
        ); // Đóng StatefulBuilder
      }, // Đóng builder của DraggableScrollableSheet
    ), // Đóng DraggableScrollableSheet
  ); // Đóng showCupertinoModalBottomSheet
}

Widget _buildSectionTitle(IconData icon, String title) {
  return Row(
    children: [
      Icon(icon, color: AppColors.primaryColor, size: 22),
      SizedBox(width: 8),
      Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
    ],
  );
}
