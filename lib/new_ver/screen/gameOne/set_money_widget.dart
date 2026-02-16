import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../../share/app_styles.dart';
import '../../../share/share_widget.dart';
import '../../viewModel/zizach_Controller.dart';

Future<BuildContext?> showPopupSetPoint(BuildContext context) {
  return showCupertinoModalBottomSheet(
      topRadius: Radius.circular(36),
      context: context,
      backgroundColor: Colors.transparent,
      // Đảm bảo transparent
      expand: false,
      // 👈 Rất quan trọng để chiều cao có tác dụng
      builder: (context) => StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Consumer<ZiZackController>(
                builder: (context, result, child) {
              return Material(
                color: Colors.transparent,
                // borderRadius: const BorderRadius.vertical(top: Radius.circular(60)),
                child: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.85,
                    color:
                        Colors.white, // Đổi từ decoration sang color đơn giản
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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
                          // Phần danh sách players (có thể scroll)
                          Expanded(
                            child: SingleChildScrollView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: List.generate(
                                  (result.listCharNew.length / 3).ceil(),
                                  (rowIndex) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12.0),
                                      child: Row(
                                        children: [
                                          // Player 1 (cột 1)
                                          Expanded(
                                            child: _buildPlayerCardSetMoney(
                                              context,
                                              setState,
                                              result,
                                              rowIndex * 3,
                                            ),
                                          ),
                                          // Spacing
                                          if (rowIndex * 3 + 1 <
                                              result.listCharNew.length)
                                            const SizedBox(width: 8),
                                          // Player 2 (cột 2)
                                          if (rowIndex * 3 + 1 <
                                              result.listCharNew.length)
                                            Expanded(
                                              child: _buildPlayerCardSetMoney(
                                                context,
                                                setState,
                                                result,
                                                rowIndex * 3 + 1,
                                              ),
                                            )
                                          else
                                            Expanded(child: Container()),
                                          // Spacing
                                          if (rowIndex * 3 + 2 <
                                              result.listCharNew.length)
                                            const SizedBox(width: 8),
                                          // Player 3 (cột 3)
                                          if (rowIndex * 3 + 2 <
                                              result.listCharNew.length)
                                            Expanded(
                                              child: _buildPlayerCardSetMoney(
                                                context,
                                                setState,
                                                result,
                                                rowIndex * 3 + 2,
                                              ),
                                            )
                                          else
                                            Expanded(child: Container()),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          // Phần nút cố định ở cuối
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: KSButton(onTap: () {
                                    Provider.of<ZiZackController>(context,
                                            listen: false)
                                        .setCai(context);
                                  },
                                      backgroundColor: AppColors.sixColor,
                                      "Làm Cái"),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: KSButton(onTap: () {
                                    Navigator.pop(context);
                                  },
                                      backgroundColor: AppColors.primaryColor,
                                      "Xong"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ), // Đóng ClipRRect
                ),
              );
            });
          }));
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

// Future<BuildContext?> showNumberKeyboard(
//     BuildContext context ) {
//   return showCupertinoModalBottomSheet(
//     expand: false,
//     context: context,
//     backgroundColor: Colors.transparent,
//     builder: (context) => StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//           return    Container(
//             height: 1100,
//             color: AppColors.accent,
//           );},
//   ));
// }

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

Future<BuildContext?> showNumberKeyboard(BuildContext context,
    {Function(String)? onNumberTap}) {
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

                  //Display current value cho selectedIndex
                  if (controller.selectedIndex >= 0)
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
                              controller.selectedIndex <
                                      controller.listCharNew.length
                                  ? '${controller.listCharNew[controller.selectedIndex]}: '
                                  : 'Player: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          Text(
                            controller.selectedIndex <
                                    controller.listOfMaps.length
                                ? (controller
                                            .listOfMaps[controller
                                                .selectedIndex]['point']
                                            ?.isEmpty ??
                                        true
                                    ? '0'
                                    : controller.listOfMaps[
                                        controller.selectedIndex]['point'])
                                : '0',
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

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Row 1: 1, 2, 3
                          Expanded(
                            child: Row(
                              children: [
                                _buildNumberKey('1', setState, (value) {
                                  controller.appendToOutput(
                                      controller.selectedIndex, value);
                                }),
                                const SizedBox(width: 12),
                                _buildNumberKey('2', setState, (value) {
                                  controller.appendToOutput(
                                      controller.selectedIndex, value);
                                }),
                                const SizedBox(width: 12),
                                _buildNumberKey('3', setState, (value) {
                                  controller.appendToOutput(
                                      controller.selectedIndex, value);
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Row 2: 4, 5, 6
                          Expanded(
                            child: Row(
                              children: [
                                _buildNumberKey('4', setState, (value) {
                                  controller.appendToOutput(
                                      controller.selectedIndex, value);
                                }),
                                const SizedBox(width: 12),
                                _buildNumberKey('5', setState, (value) {
                                  controller.appendToOutput(
                                      controller.selectedIndex, value);
                                }),
                                const SizedBox(width: 12),
                                _buildNumberKey('6', setState, (value) {
                                  controller.appendToOutput(
                                      controller.selectedIndex, value);
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Row 3: 7, 8, 9
                          Expanded(
                            child: Row(
                              children: [
                                _buildNumberKey('7', setState, (value) {
                                  controller.appendToOutput(
                                      controller.selectedIndex, value);
                                }),
                                const SizedBox(width: 12),
                                _buildNumberKey('8', setState, (value) {
                                  controller.appendToOutput(
                                      controller.selectedIndex, value);
                                }),
                                const SizedBox(width: 12),
                                _buildNumberKey('9', setState, (value) {
                                  controller.appendToOutput(
                                      controller.selectedIndex, value);
                                }),
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
                                  Colors.orange,
                                  setState,
                                  () {
                                    // Toggle dấu +/- sử dụng method từ controller
                                    controller
                                        .toggleSign(controller.selectedIndex);
                                  },
                                ),
                                const SizedBox(width: 12),
                                _buildNumberKey('0', setState, (value) {
                                  controller.appendToOutput(
                                      controller.selectedIndex, value);
                                }),
                                const SizedBox(width: 12),
                                _buildSpecialKey(
                                  '⌫',
                                  Colors.red,
                                  setState,
                                  () {
                                    controller
                                        .appendDel(controller.selectedIndex);
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
                            onTap: () {
                              Navigator.pop(context);
                              if (onNumberTap != null &&
                                  controller.selectedIndex >= 0) {
                                String finalValue = controller.selectedIndex <
                                        controller.listOfMaps.length
                                    ? (controller.listOfMaps[controller
                                            .selectedIndex]['point'] ??
                                        '0')
                                    : '0';
                                onNumberTap(finalValue);
                              }
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

Widget _buildNumberKey(
    String number, StateSetter setState, Function(String) onTap) {
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
                onTap(number);
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

Widget _buildPlayerCardSetMoney(BuildContext context,
    StateSetter parentSetState, ZiZackController result, int index) {
  if (index >= result.listCharNew.length) {
    return Container();
  }

  final String name = result.listCharNew[index];
  final bool isCai = result.listOfMaps[index]['cai'] == true;
  final String currentPoint = result.listOfMaps[index]['point'] ?? '0';

  return InkWell(
    onTap: () {
      result.chooseCon(index);
      showNumberKeyboard(context, onNumberTap: (value) {
        print("Xác nhận giá trị cuối cùng: $value cho index $index");
      });
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: isCai
            ? AppColors.primaryColor.withOpacity(0.1)
            : AppColors.sixColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: result.selectedIndex == index
              ? AppColors.primaryColor
              : Colors.grey.withOpacity(0.3),
          width: result.selectedIndex == index ? 2.5 : 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tên người chơi
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
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
              color: Colors.white,
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
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
