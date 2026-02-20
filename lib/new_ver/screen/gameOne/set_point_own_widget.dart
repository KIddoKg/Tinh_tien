import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../../share/app_styles.dart';
import '../../../share/share_widget.dart';
import '../../viewModel/zizach_Controller.dart';
import 'set_money_widget.dart';

Future<void> showPopupSetPointOwn(BuildContext context) {
  // Tạo state riêng cho popup này, không dùng chung với set điểm
  Map<int, String> tempPoints = {};

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
          builder: (_, controller) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
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
                          padding: const EdgeInsets.all(8.0).copyWith(top: 16),
                          child: Container(
                            width: 60,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),

                        // Title
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Nhập điểm trực tiếp",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),

                        // Danh sách người chơi với ô nhập điểm
                        Expanded(
                          child: SingleChildScrollView(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Builder(
                              builder: (context) {
                                // 🚪 Filter: Chỉ lấy player chưa out
                                List<int> activePlayers = [];
                                for (int i = 0;
                                    i < result.listCharNew.length;
                                    i++) {
                                  if (result.listOfMaps[i]['isOut'] != true) {
                                    activePlayers.add(i);
                                  }
                                }

                                return Column(
                                  children: List.generate(
                                    (activePlayers.length / 3).ceil(),
                                    (rowIndex) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12.0),
                                        child: Row(
                                          children: [
                                            // Player 1 (cột 1)
                                            Expanded(
                                              child: _buildPlayerCard(
                                                context,
                                                setState,
                                                result,
                                                activePlayers[rowIndex * 3],
                                                tempPoints,
                                              ),
                                            ),
                                            // Spacing
                                            if (rowIndex * 3 + 1 <
                                                activePlayers.length)
                                              const SizedBox(width: 8),
                                            // Player 2 (cột 2)
                                            if (rowIndex * 3 + 1 <
                                                activePlayers.length)
                                              Expanded(
                                                child: _buildPlayerCard(
                                                  context,
                                                  setState,
                                                  result,
                                                  activePlayers[
                                                      rowIndex * 3 + 1],
                                                  tempPoints,
                                                ),
                                              )
                                            else
                                              Expanded(child: Container()),
                                            // Spacing
                                            if (rowIndex * 3 + 2 <
                                                activePlayers.length)
                                              const SizedBox(width: 8),
                                            // Player 3 (cột 3)
                                            if (rowIndex * 3 + 2 <
                                                activePlayers.length)
                                              Expanded(
                                                child: _buildPlayerCard(
                                                  context,
                                                  setState,
                                                  result,
                                                  activePlayers[
                                                      rowIndex * 3 + 2],
                                                  tempPoints,
                                                ),
                                              )
                                            else
                                              Expanded(child: Container()),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // Nút điều khiển ở cuối
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
                              // 2 nút nằm chung 1 hàng
                              Row(
                                children: [
                                  // Nút Cài Cái
                                  Expanded(
                                    child: KSButton(
                                      "Làm Cái",
                                      backgroundColor: AppColors.sixColor,
                                      onTap: () async {
                                        // Đóng popup hiện tại
                                        // Navigator.pop(context);
                                        // Mở popup Cài điểm
                                        // await showPopupSetPoint(context);
                                        Provider.of<ZiZackController>(context,
                                                listen: false)
                                            .setCai(context);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Nút xác nhận (chỉ enabled khi tổng = 0)
                                  Expanded(
                                    child: Opacity(
                                      opacity: _calculateTotalPointsWithCai(
                                                  result, tempPoints) ==
                                              0
                                          ? 1.0
                                          : 0.5,
                                      child: KSButton(
                                        "Xác nhận",
                                        backgroundColor: AppColors.primaryColor,
                                        onTap: _calculateTotalPointsWithCai(
                                                    result, tempPoints) ==
                                                0
                                            ? () {
                                                // Lưu tempPoints vào controller trước khi đóng
                                                _saveDirectPoints(context,
                                                    result, tempPoints);
                                                Navigator.pop(context);
                                              }
                                            : () {
                                                // Hiển thị thông báo lỗi
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Tổng điểm phải bằng 0! Hiện tại: ${_calculateTotalPointsWithCai(result, tempPoints)}",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor: Colors.red,
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ),
                                                );
                                              },
                                      ),
                                    ),
                                  ),
                                ],
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

// Tính tổng điểm bao gồm cả điểm của Cái
int _calculateTotalPointsWithCai(
    ZiZackController controller, Map<int, String> tempPoints) {
  int caiPoints = _calculateCaiPoints(controller, tempPoints);
  int conPoints = 0;

  for (int i = 0; i < controller.listOfMaps.length; i++) {
    if (controller.listOfMaps[i]['cai'] != true) {
      String pointStr = tempPoints[i] ?? '0';
      if (pointStr.isEmpty) pointStr = '0';
      conPoints += int.tryParse(pointStr) ?? 0;
    }
  }

  return caiPoints + conPoints;
}

// Tính điểm cho Cái dựa trên tổng điểm của các con
int _calculateCaiPoints(
    ZiZackController controller, Map<int, String> tempPoints) {
  int totalConPoints = 0;

  // Tính tổng điểm của các con (không bao gồm Cái)
  for (int i = 0; i < controller.listOfMaps.length; i++) {
    if (controller.listOfMaps[i]['cai'] != true) {
      String pointStr = tempPoints[i] ?? '0';
      if (pointStr.isEmpty) pointStr = '0';
      totalConPoints += int.tryParse(pointStr) ?? 0;
    }
  }

  // Cái sẽ nhận số âm của tổng điểm con (để tổng = 0)
  return -totalConPoints;
}

void _saveDirectPoints(BuildContext context, ZiZackController controller,
    Map<int, String> tempPoints) {
  // Tính điểm cho Cái trước
  for (int i = 0; i < controller.listOfMaps.length; i++) {
    if (controller.listOfMaps[i]['cai'] == true) {
      int caiPoints = _calculateCaiPoints(controller, tempPoints);
      tempPoints[i] = caiPoints.toString();
      break;
    }
  }

  // Copy tempPoints vào listOfMaps
  tempPoints.forEach((index, pointStr) {
    if (index < controller.listOfMaps.length) {
      controller.listOfMaps[index]['point'] = pointStr;
    }
  });
  // Gọi hàm tính điểm
  controller.calculateDirectPoints();

  // Kiểm tra xem có đạt điều kiện kết thúc không
  if (controller.checkGameEndCondition()) {
    // Hiển thị dialog kết thúc game
    Future.delayed(Duration(milliseconds: 300), () {
      showEndGameDialog(context);
    });
  }
}

Widget _buildPlayerCard(BuildContext context, StateSetter parentSetState,
    ZiZackController result, int index, Map<int, String> tempPoints) {
  if (index >= result.listCharNew.length) {
    return Container();
  }

  final String name = result.listCharNew[index];
  final bool isCai = result.listOfMaps[index]['cai'] == true;

  // Nếu là Cái, hiển thị điểm tự động tính
  int pointValue = isCai
      ? _calculateCaiPoints(result, tempPoints)
      : int.tryParse(tempPoints[index] ?? '0') ?? 0;

  // Xử lý -0 thành 0
  final String currentPoint = pointValue == 0 ? '0' : pointValue.toString();

  return InkWell(
    onTap: isCai
        ? null // Cái không cho nhấn vào nhập điểm
        : () {
            result.chooseCon(index);
            _showNumberKeyboard(
                context, parentSetState, index, name, tempPoints);
          },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: isCai
            ? AppColors.primaryColor.withOpacity(0.1)
            : AppColors.sixColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: isCai
              ? AppColors.primaryColor.withOpacity(0.5)
              : (result.selectedIndex == index
                  ? AppColors.primaryColor
                  : Colors.grey.withOpacity(0.3)),
          width: isCai ? 2.0 : (result.selectedIndex == index ? 2.5 : 1.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tên người chơi
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              if (isCai)
                Text(
                  " (Cái)",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor.withOpacity(0.7),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),

          // Điểm hiện tại
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: isCai
                  ? AppColors.primaryColor.withOpacity(0.2)
                  : Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Text(
              currentPoint.isEmpty ? "0" : currentPoint,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isCai ? AppColors.primaryColor : AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _showNumberKeyboard(
    BuildContext context,
    StateSetter parentSetState,
    int playerIndex,
    String playerName,
    Map<int, String> tempPoints) {
  return showModalBottomSheet(
    isScrollControlled: true,
    isDismissible: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Consumer<ZiZackController>(
      builder: (context, controller, child) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
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

                  // Display current value
                  Container(
                    height: 80,
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      color: AppColors.sixColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        width: 2.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '$playerName: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        Text(
                          () {
                            String value = tempPoints[playerIndex] ?? '';
                            if (value.isEmpty) return '0';
                            if (value == '-')
                              return '-'; // ✨ Hiển thị dấu '-' khi chỉ có dấu
                            return value;
                          }(),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),

                  // Keyboard
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Row 1: 1, 2, 3
                          Expanded(
                            child: Row(
                              children: [
                                _buildNumberKey('1', setState, playerIndex,
                                    tempPoints, parentSetState),
                                const SizedBox(width: 12),
                                _buildNumberKey('2', setState, playerIndex,
                                    tempPoints, parentSetState),
                                const SizedBox(width: 12),
                                _buildNumberKey('3', setState, playerIndex,
                                    tempPoints, parentSetState),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Row 2: 4, 5, 6
                          Expanded(
                            child: Row(
                              children: [
                                _buildNumberKey('4', setState, playerIndex,
                                    tempPoints, parentSetState),
                                const SizedBox(width: 12),
                                _buildNumberKey('5', setState, playerIndex,
                                    tempPoints, parentSetState),
                                const SizedBox(width: 12),
                                _buildNumberKey('6', setState, playerIndex,
                                    tempPoints, parentSetState),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Row 3: 7, 8, 9
                          Expanded(
                            child: Row(
                              children: [
                                _buildNumberKey('7', setState, playerIndex,
                                    tempPoints, parentSetState),
                                const SizedBox(width: 12),
                                _buildNumberKey('8', setState, playerIndex,
                                    tempPoints, parentSetState),
                                const SizedBox(width: 12),
                                _buildNumberKey('9', setState, playerIndex,
                                    tempPoints, parentSetState),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Row 4: +/-, 0, Backspace
                          Expanded(
                            child: Row(
                              children: [
                                _buildSpecialKey(
                                  '+/-',
                                  AppColors.primaryColor,
                                  setState,
                                  () {
                                    _toggleSignTemp(playerIndex, tempPoints);
                                    parentSetState(() {});
                                  },
                                ),
                                const SizedBox(width: 12),
                                _buildNumberKey('0', setState, playerIndex,
                                    tempPoints, parentSetState),
                                const SizedBox(width: 12),
                                _buildSpecialKey(
                                  '⌫',
                                  Colors.red,
                                  setState,
                                  () {
                                    _deleteTemp(playerIndex, tempPoints);
                                    parentSetState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Confirm button
                          KSButton(
                            "Xác nhận",
                            fontColor: AppColors.whiteBg,
                            backgroundColor: AppColors.primaryColor,
                            onTap: () {
                              Navigator.pop(context);
                              parentSetState(() {});
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    ),
  );
}

Widget _buildNumberKey(String number, StateSetter setState, int playerIndex,
    Map<int, String> tempPoints, StateSetter parentSetState) {
  return Expanded(
    child: AspectRatio(
      aspectRatio: 1.2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.2),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(15.0),
            onTap: () {
              setState(() {
                _appendToTemp(playerIndex, number, tempPoints);
                parentSetState(() {});
              });
              HapticFeedback.lightImpact();
            },
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void _appendToTemp(int index, String value, Map<int, String> tempPoints) {
  String current = tempPoints[index] ?? '';

  // ✨ Nếu current là '-' (chỉ có dấu), giữ dấu và thêm số
  if (current == '-') {
    tempPoints[index] = '-$value';
    return;
  }

  // Nếu current là '0' hoặc '-0', thay thế bằng số mới
  if (current == '0' || current == '-0') {
    // Nếu là '-0', giữ dấu trừ
    if (current == '-0') {
      tempPoints[index] = '-$value';
    } else {
      tempPoints[index] = value;
    }
    return;
  }

  // Thêm số vào cuối
  tempPoints[index] = current + value;
}

void _toggleSignTemp(int index, Map<int, String> tempPoints) {
  String current = tempPoints[index] ?? '';

  // ✨ Cho phép nhấn +/- ngay cả khi chưa có số
  if (current.isEmpty || current == '0') {
    // Nếu chưa có gì hoặc là '0', đặt thành '-' để sẵn sàng nhập số âm
    tempPoints[index] = '-';
    return;
  }

  if (current == '-') {
    // Nếu chỉ có dấu '-', xóa nó (quay về dương)
    tempPoints[index] = '';
    return;
  }

  if (current == '-0') {
    // Nếu là '-0', chuyển về ''
    tempPoints[index] = '';
    return;
  }

  // Toggle dấu khi đã có số
  if (current.startsWith('-')) {
    tempPoints[index] = current.substring(1);
  } else {
    tempPoints[index] = '-$current';
  }
}

void _deleteTemp(int index, Map<int, String> tempPoints) {
  String current = tempPoints[index] ?? '';
  if (current.isEmpty) return;

  if (current.length == 1 || current == '-0') {
    tempPoints[index] = '0';
  } else if (current.length == 2 && current.startsWith('-')) {
    // Nếu chỉ còn dấu trừ, đặt về 0
    tempPoints[index] = '0';
  } else {
    tempPoints[index] = current.substring(0, current.length - 1);
  }
}

Widget _buildSpecialKey(
    String text, Color color, StateSetter setState, VoidCallback onTap) {
  return Expanded(
    child: AspectRatio(
      aspectRatio: 1.2,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(15.0),
            onTap: () {
              setState(() {
                onTap();
              });
              HapticFeedback.mediumImpact();
            },
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: text == '⌫' ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
