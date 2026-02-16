import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../share/app_styles.dart';
import '../../../share/share_widget.dart';

/// Dialog hướng dẫn cách chơi game với 2 chế độ
Future<void> showGameGuideDialog(BuildContext context) {
  return showCupertinoModalBottomSheet(
    topRadius: Radius.circular(36),
    context: context,
    backgroundColor: Colors.transparent,
    expand: false,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return Material(
          color: Colors.transparent,
          child: Container(
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
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tiêu đề chính
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.help_outline,
                                size: 60,
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(height: 12),
                              Text(
                                "Hướng dẫn chơi game",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Tìm hiểu cách sử dụng 2 chế độ chơi",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30),

                        // ==================== CHẾ ĐỘ 1: TÍNH ĐIỂM ====================
                        _buildModeSection(
                          icon: Icons.calculate_outlined,
                          iconColor: Colors.blue,
                          title: "Chế độ 1: Tính điểm",
                          subtitle:
                              "Hệ thống tự động tính điểm dựa trên kết quả ván chơi",
                          steps: [
                            _GuideStep(
                              number: "1",
                              title: "Cài điểm",
                              description:
                                  "Nhấn nút 'Cài điểm' để chọn người làm cái. Người làm cái sẽ được đánh dấu màu xanh trên bảng. Vaà ở đây bạn có thể cài đặt điểm của từng người chơi.",
                              icon: Icons.settings,
                            ),
                            _GuideStep(
                              number: "2",
                              title: "Chọn kết quả",
                              description:
                                  "Sau đó nhấn 'Tính điểm' và chọn các trạng thái:\n• Thắng: Người thắng ván\n• Thua: Người thua thêm điểm\n• x2: Nhân đôi điểm\n• All: Tất cả cùng ăn. Ở đây sẽ lấy số điểm trong phần cài điểm để tính điểm cho mọi người.",
                              icon: Icons.check_circle_outline,
                            ),
                            _GuideStep(
                              number: "3",
                              title: "Tự động tính",
                              description:
                                  "Hệ thống sẽ tự động tính điểm dựa trên các trạng thái đặc biệt (x2, All) sẽ ảnh hưởng đến số điểm",
                              icon: Icons.auto_awesome,
                            ),
                          ],
                        ),

                        SizedBox(height: 30),
                        Divider(thickness: 2),
                        SizedBox(height: 30),

                        // ==================== CHẾ ĐỘ 2: TÍNH TAY ====================
                        _buildModeSection(
                          icon: Icons.back_hand_outlined,
                          iconColor: Colors.orange,
                          title: "Chế độ 2: Tính tay",
                          subtitle: "Tự nhập điểm cho từng người chơi",
                          steps: [
                            _GuideStep(
                              number: "1",
                              title: "Chuyển chế độ",
                              description:
                                  "Nhấn nút biểu tượng ở góc trên phải để chuyển sang chế độ Tính tay.",
                              icon: Icons.swap_horiz,
                            ),
                            _GuideStep(
                              number: "2",
                              title: "Nhập điểm thủ công",
                              description:
                                  "Nhấn nút 'Tính tay' ở phía dưới màn hình. Nhập điểm trực tiếp cho từng người chơi trong ván hiện tại.",
                              icon: Icons.edit,
                            ),
                            _GuideStep(
                              number: "3",
                              title: "Xác nhận",
                              description:
                                  "Sau khi nhập đủ điểm cho tất cả người chơi, nhấn 'Xác nhận' để lưu kết quả ván chơi.",
                              icon: Icons.done_all,
                            ),
                          ],
                        ),

                        SizedBox(height: 30),
                        Divider(thickness: 2),
                        SizedBox(height: 30),

                        // ==================== MẸO VÀ LƯU Ý ====================
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade50,
                                Colors.orange.shade50,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.orange.shade200,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: Colors.orange.shade700,
                                    size: 28,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Mẹo & Lưu ý",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade900,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              _buildTipItem(
                                "🎯",
                                "Chọn chế độ phù hợp",
                                "Dùng 'Tính điểm' cho game theo luật chuẩn, 'Tính tay' cho các biến thể hoặc điều chỉnh đặc biệt.",
                              ),
                              _buildTipItem(
                                "⚡",
                                "Chuyển đổi linh hoạt",
                                "Bạn có thể chuyển đổi giữa 2 chế độ bất kỳ lúc nào trong quá trình chơi.",
                              ),
                              _buildTipItem(
                                "📊",
                                "Kiểm tra tổng điểm",
                                "Bật 'Hiện tổng điểm' trong Cài đặt để theo dõi tổng điểm của mỗi người.",
                              ),
                              _buildTipItem(
                                "🏆",
                                "Chế độ giới hạn",
                                "Đặt giới hạn điểm hoặc số ván để game tự động kết thúc khi đạt mục tiêu.",
                              ),
                              _buildTipItem(
                                "💾",
                                "Lưu tự động",
                                "Game sẽ tự động lưu lại sau mỗi ván. Bạn có thể tiếp tục chơi sau bất cứ lúc nào.",
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30),

                        // ==================== CÁC NÚT CHỨC NĂNG ====================
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.blue.shade200,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.touch_app,
                                    color: Colors.blue.shade700,
                                    size: 28,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Các nút chức năng",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              _buildButtonGuide(
                                Icons.settings,
                                "Cài đặt",
                                "Thay đổi cài đặt game, thêm/sửa người chơi, chọn chế độ giới hạn",
                              ),
                              _buildButtonGuide(
                                Icons.calculate_outlined,
                                "Chuyển chế độ",
                                "Chuyển đổi giữa 'Tính điểm' và 'Tính tay'",
                              ),
                              _buildButtonGuide(
                                Icons.emoji_events,
                                "Kết thúc",
                                "Kết thúc game và xem kết quả cuối cùng",
                              ),
                              _buildButtonGuide(
                                Icons.arrow_back,
                                "Quay lại",
                                "Thoát game (sẽ lưu tiến trình để tiếp tục sau)",
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Nút đóng
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
                    onTap: () {
                      Navigator.pop(context);
                    },
                    "Đã hiểu",
                    backgroundColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

// Widget cho từng bước hướng dẫn
class _GuideStep {
  final String number;
  final String title;
  final String description;
  final IconData icon;

  _GuideStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });
}

// Widget hiển thị section cho mỗi chế độ
Widget _buildModeSection({
  required IconData icon,
  required Color iconColor,
  required String title,
  required String subtitle,
  required List<_GuideStep> steps,
}) {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: iconColor.withOpacity(0.05),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: iconColor.withOpacity(0.3),
        width: 2,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 20),

        // Steps
        ...steps.asMap().entries.map((entry) {
          final step = entry.value;
          final isLast = entry.key == steps.length - 1;

          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Number badge
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      step.number,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(step.icon, size: 20, color: iconColor),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              step.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        step.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    ),
  );
}

// Widget cho mỗi tip
Widget _buildTipItem(String emoji, String title, String description) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          emoji,
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Widget hướng dẫn các nút
Widget _buildButtonGuide(IconData icon, String title, String description) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue.shade700, size: 24),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
