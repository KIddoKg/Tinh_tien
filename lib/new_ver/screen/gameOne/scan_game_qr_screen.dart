import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../../share/app_styles.dart';
import '../../../share/share_widget.dart';
import '../../viewModel/zizach_Controller.dart';

class ScanGameQRScreen extends StatefulWidget {
  const ScanGameQRScreen({super.key});

  @override
  State<ScanGameQRScreen> createState() => _ScanGameQRScreenState();
}

class _ScanGameQRScreenState extends State<ScanGameQRScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isProcessing = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() {
      isProcessing = true;
    });

    // Stop camera
    await cameraController.stop();

    // Import game
    final controller = Provider.of<ZiZackController>(context, listen: false);
    bool success = await controller.importGameFromQR(code);

    if (!mounted) return;

    if (success) {
      showCustomAlert(
        context,
        type: AlertType.success,
        title: 'Thành công',
        message: 'Đã load ván chơi từ QR code!\nBạn có thể tiếp tục chơi ngay.',
        onConfirm: () {
          // Quay về màn hình game
          Navigator.pop(context); // Đóng alert
          Navigator.pop(context, true); // Đóng scan screen và trả về true
        },
      );
    } else {
      showCustomAlert(
        context,
        type: AlertType.error,
        title: 'Lỗi',
        message: 'Mã QR không hợp lệ hoặc đã hết hạn.\nVui lòng thử lại!',
        onConfirm: () {
          setState(() {
            isProcessing = false;
          });
          cameraController.start();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quét mã QR'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.flash_on),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: Icon(Icons.cameraswitch),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera view
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
          ),

          // Overlay with instructions
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),

          // Scan frame
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryColor,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // Corners decoration
          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                children: [
                  // Top-left corner
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.primaryColor, width: 6),
                          left: BorderSide(color: AppColors.primaryColor, width: 6),
                        ),
                      ),
                    ),
                  ),
                  // Top-right corner
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.primaryColor, width: 6),
                          right: BorderSide(color: AppColors.primaryColor, width: 6),
                        ),
                      ),
                    ),
                  ),
                  // Bottom-left corner
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.primaryColor, width: 6),
                          left: BorderSide(color: AppColors.primaryColor, width: 6),
                        ),
                      ),
                    ),
                  ),
                  // Bottom-right corner
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.primaryColor, width: 6),
                          right: BorderSide(color: AppColors.primaryColor, width: 6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Instructions
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 48,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Quét mã QR để tiếp tục chơi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Đặt mã QR vào trong khung để quét',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Processing indicator
          if (isProcessing)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
