import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../share/app_styles.dart';
import '../../viewModel/zizach_Controller.dart';
import '../../model/game_model.dart';

/// Test screen để kiểm tra scroll và pull-to-refresh
class TestScrollScreen extends StatefulWidget {
  const TestScrollScreen({super.key});

  @override
  State<TestScrollScreen> createState() => _TestScrollScreenState();
}

class _TestScrollScreenState extends State<TestScrollScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load data khi màn hình mở
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<ZiZackController>(context, listen: false);
      controller.loadGameHistory();
    });

    // Lắng nghe scroll
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final controller = Provider.of<ZiZackController>(context, listen: false);

    // Kiểm tra khi scroll gần đến cuối
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      print(
          '📜 [SCROLL] Near bottom - Loading more... (${controller.displayedSessions.length}/${controller.allSessions.length})');
      controller.loadMoreItems();
    }
  }

  Future<void> _onRefresh() async {
    print('🔄 [REFRESH] Pull to refresh triggered');
    final controller = Provider.of<ZiZackController>(context, listen: false);
    await controller.refreshGameHistory();
    print('✅ [REFRESH] Completed');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Scroll & Refresh'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Consumer<ZiZackController>(
        builder: (context, controller, child) {
          return Column(
            children: [
              // Header thông tin
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                color: Colors.blue[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📊 Thông tin:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Tổng sessions: ${controller.allSessions.length}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      '• Đang hiển thị: ${controller.displayedSessions.length}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      '• Đang load: ${controller.isLoadingMore ? "✅ Yes" : "❌ No"}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '💡 Hướng dẫn:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[900],
                      ),
                    ),
                    Text(
                      '• Kéo xuống để refresh',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                    Text(
                      '• Scroll xuống để load thêm',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),

              // Danh sách sessions
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: AppColors.primaryColor,
                  child: controller.displayedSessions.isEmpty
                      ? _buildEmptyState()
                      : _buildListView(controller),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final controller =
              Provider.of<ZiZackController>(context, listen: false);
          print('🔄 Manual refresh triggered');
          controller.refreshGameHistory();
        },
        backgroundColor: AppColors.primaryColor,
        icon: Icon(Icons.refresh, color: Colors.white),
        label: Text('Refresh', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Không có dữ liệu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Kéo xuống để refresh',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(ZiZackController controller) {
    // Sort sessions
    List<GameSession> sortedSessions = List.from(controller.displayedSessions);
    sortedSessions.sort((a, b) => b.startTime.compareTo(a.startTime));

    return ListView.builder(
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      itemCount: sortedSessions.length +
          (controller.isLoadingMore &&
                  controller.displayedSessions.length <
                      controller.allSessions.length
              ? 1
              : 0),
      itemBuilder: (context, index) {
        // Loading indicator ở cuối
        if (index == sortedSessions.length) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Đang tải thêm...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        GameSession session = sortedSessions[index];
        bool isInProgress = session.status == GameStatus.inProgress;

        return Card(
          margin: EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isInProgress
                ? BorderSide(color: Colors.orange, width: 2)
                : BorderSide.none,
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isInProgress
                    ? Colors.orange.withOpacity(0.2)
                    : AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        isInProgress ? Colors.orange : AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            title: Text(
              'Game #${session.id.substring(session.id.length - 5)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  '👥 ${session.players.length} người • 🎮 ${session.allRounds.length} ván',
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 2),
                Text(
                  '⏰ ${_formatDateTime(session.startTime)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            trailing: isInProgress
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Đang chơi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Icon(Icons.check_circle, color: Colors.green),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
