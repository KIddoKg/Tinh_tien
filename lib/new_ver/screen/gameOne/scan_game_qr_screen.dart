import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
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
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isProcessing = false;
  bool flashOn = false;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController qrController) {
    setState(() {
      controller = qrController;
    });

    controller!.scannedDataStream.listen((scanData) async {
      if (isProcessing) return;
      
      final String? code = scanData.code;
      if (code == null || code.isEmpty) return;

      setState(() {
        isProcessing = true;
      });

      // Pause camera
      await controller!.pauseCamera();

      // Import game
      final gameController = Provider.of<ZiZackController>(context, listen: false);
      bool success = await gameController.importGameFromQR(code);

      if (!mounted) return;

      if (success) {
        showCustomAlert(
          context,
          type: AlertType.success,
          title: 'Thành công',
          message: 'Đã load ván chơi từ QR code!\nBạn có thể tiếp tục chơi ngay.',
          onConfirm: () {
            Navigator.pop(context); // Đóng alert
            Navigator.pop(context, true); // Đóng scan screen
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
            controller?.resumeCamera();
          },
        );
      }
    });
  }

  void _toggleFlash() async {
    if (controller != null) {
      await controller!.toggleFlash();
      setState(() {
        flashOn = !flashOn;
      });
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
            icon: Icon(flashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: _toggleFlash,
            tooltip: 'Bật/tắt đèn',
          ),
          IconButton(
            icon: Icon(Icons.cameraswitch),
            onPressed: () => controller?.flipCamera(),
            tooltip: 'Đổi camera',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera view
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: AppColors.primaryColor,
              borderRadius: 20,
              borderLength: 40,
              borderWidth: 6,
              cutOutSize: 300,
            ),
          ),

          // Instructions
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
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
                child: Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Đang xử lý...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
