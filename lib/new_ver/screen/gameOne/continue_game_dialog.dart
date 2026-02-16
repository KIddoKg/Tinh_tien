import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/zizach_Controller.dart';
import '../../../share/app_styles.dart';

Future<bool> checkAndShowContinueGameDialog(BuildContext context) async {
  final controller = Provider.of<ZiZackController>(context, listen: false);
  bool hasInProgress = await controller.hasInProgressGame();

  if (!hasInProgress) {
    return false;
  }

  bool? shouldContinue = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.primaryColor),
          SizedBox(width: 8),
          Text(
            'Trò chơi chưa hoàn thành',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bạn có một trò chơi đang chơi dở.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Bạn muốn tiếp tục hay bắt đầu trò chơi mới?',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline,
                    color: Colors.blue[700], size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Nếu bắt đầu mới, trò chơi cũ sẽ được lưu vào lịch sử',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        OutlinedButton.icon(
          icon: Icon(Icons.add_circle_outline),
          label: Text('Bắt đầu mới'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            side: BorderSide(color: AppColors.primaryColor),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.play_arrow),
          label: Text('Tiếp tục'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    ),
  );

  if (shouldContinue == true) {
    await controller.continueInProgressGame();
    return true;
  } else if (shouldContinue == false) {
    // Người dùng chọn bắt đầu mới - hoàn thành game cũ
    await controller.resetAndStartNewGame();
    return false;
  }

  return false;
}
