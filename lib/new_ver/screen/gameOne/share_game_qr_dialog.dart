import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../share/app_styles.dart';
import '../../../share/share_widget.dart';
import '../../viewModel/zizach_Controller.dart';

/// Dialog hiển thị QR code để share game
Future<void> showShareGameQRDialog(BuildContext context) async {
  final controller = Provider.of<ZiZackController>(context, listen: false);

  // Kiểm tra có ván nào để share không
  if (controller.point.isEmpty) {
    showCustomAlert(
      context,
      type: AlertType.warning,
      title: 'Không thể chia sẻ',
      message: 'Chưa có ván nào để chia sẻ!\nHãy chơi ít nhất 1 ván trước.',
    );
    return;
  }

  try {
    // Export game data thành QR string
    String qrData = controller.exportGameToQR();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Row(
                  children: [
                    Icon(Icons.qr_code_2,
                        color: AppColors.primaryColor, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Chia sẻ ván đang chơi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Description
                Text(
                  'Người khác có thể quét mã QR này để tiếp tục chơi ván này trên thiết bị của họ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),

                // QR Code
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 250.0,
                    backgroundColor: Colors.white,
                    errorCorrectionLevel:
                        QrErrorCorrectLevel.H, // 🔧 Tăng lên HIGH cho web
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: Size(40, 40),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Game info
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.sixColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.people, 'Người chơi',
                          '${controller.listCharNew.length} người'),
                      SizedBox(height: 8),
                      _buildInfoRow(Icons.confirmation_number, 'Số ván',
                          '${controller.point.length} ván'),
                      if (controller.fOrc == 1 &&
                          controller.limitValue > 0) ...[
                        SizedBox(height: 8),
                        _buildInfoRow(
                          Icons.flag,
                          'Giới hạn',
                          controller.dOrv == 0
                              ? '${controller.limitValue} điểm'
                              : '${controller.limitValue} ván',
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Copy Link button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: qrData));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Đã copy link vào clipboard!'),
                            ],
                          ),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: Icon(Icons.copy),
                    label: Text(
                      'Copy Link',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                      side: BorderSide(color: AppColors.primaryColor, width: 2),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),

                // Close button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Đóng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  } catch (e) {
    showCustomAlert(
      context,
      type: AlertType.error,
      title: 'Lỗi',
      message: 'Không thể tạo mã QR: $e',
    );
  }
}

Widget _buildInfoRow(IconData icon, String label, String value) {
  return Row(
    children: [
      Icon(icon, size: 18, color: AppColors.primaryColor),
      SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
      Spacer(),
      Text(
        value,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
