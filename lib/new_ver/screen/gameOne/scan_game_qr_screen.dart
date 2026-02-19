import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
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

class _ScanGameQRScreenState extends State<ScanGameQRScreen>
    with WidgetsBindingObserver {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isProcessing = false;
  bool flashOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller == null || kIsWeb) return; // Skip trên web vì không support

    if (state == AppLifecycleState.inactive) {
      controller!.pauseCamera();
    } else if (state == AppLifecycleState.resumed) {
      controller!.resumeCamera();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null && !kIsWeb) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Không cần dispose controller nữa - auto dispose
    // controller?.dispose();
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

      // Pause camera để tránh scan nhiều lần (chỉ trên mobile)
      if (!kIsWeb) {
        controller!.pauseCamera();
      }

      // Import game
      final gameController =
          Provider.of<ZiZackController>(context, listen: false);
      bool success = await gameController.importGameFromQR(code);

      if (!mounted) return;

      if (success) {
        // Import thành công
        // Đợi một chút để đảm bảo data đã được lưu
        await Future.delayed(Duration(milliseconds: 300));

        if (!mounted) return;

        // Đóng scan screen
        Navigator.pop(context);

        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                      'Đã load ván chơi từ QR code!\nKiểm tra trong lịch sử.'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        showCustomAlert(
          context,
          type: AlertType.error,
          title: 'Lỗi',
          message: 'Mã QR không hợp lệ hoặc đã hết hạn.\nVui lòng thử lại!',
          onConfirm: () {
            if (!mounted) return;
            setState(() {
              isProcessing = false;
            });
            // Resume camera chỉ trên mobile
            if (!kIsWeb) {
              controller?.resumeCamera();
            }
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

  void _pasteAndImportLink() async {
    try {
      // Lấy dữ liệu từ clipboard
      ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

      if (data == null || data.text == null || data.text!.isEmpty) {
        if (!mounted) return;
        showCustomAlert(
          context,
          type: AlertType.warning,
          title: 'Clipboard trống',
          message: 'Clipboard không có dữ liệu!\nHãy copy link trước khi dán.',
        );
        return;
      }

      setState(() {
        isProcessing = true;
      });

      // Pause camera nếu đang chạy
      if (!kIsWeb && controller != null) {
        controller!.pauseCamera();
      }

      // Import game từ link
      final gameController =
          Provider.of<ZiZackController>(context, listen: false);
      bool success = await gameController.importGameFromQR(data.text!);

      if (!mounted) return;

      if (success) {
        // Import thành công
        // Đợi một chút để đảm bảo data đã được lưu
        await Future.delayed(Duration(milliseconds: 300));

        if (!mounted) return;

        // Đóng scan screen
        Navigator.pop(context);

        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                      'Đã load ván chơi từ link!\nKiểm tra trong lịch sử.'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        showCustomAlert(
          context,
          type: AlertType.error,
          title: 'Lỗi',
          message: 'Link không hợp lệ hoặc đã hết hạn.\nVui lòng thử lại!',
          onConfirm: () {
            if (!mounted) return;
            setState(() {
              isProcessing = false;
            });
            // Resume camera
            if (!kIsWeb && controller != null) {
              controller!.resumeCamera();
            }
          },
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isProcessing = false;
      });

      showCustomAlert(
        context,
        type: AlertType.error,
        title: 'Lỗi',
        message: 'Không thể đọc clipboard: $e',
        onConfirm: () {
          if (!kIsWeb && controller != null) {
            controller!.resumeCamera();
          }
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
            // Thêm các cấu hình để cải thiện hiệu suất scan
            formatsAllowed: const [BarcodeFormat.qrcode],
            onPermissionSet: (ctrl, hasPermission) {
              if (!hasPermission) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cần cấp quyền camera để quét QR'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
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

          // Paste Link button
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: isProcessing ? null : _pasteAndImportLink,
              icon: Icon(Icons.content_paste, size: 20),
              label: Text(
                'Dán Link',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.3),
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
