import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewModel/zizach_Controller.dart';
import '../../model/game_model.dart';
import '../../../share/app_styles.dart';
import '../../../share/share_widget.dart';

class GameHistoryScreen extends StatefulWidget {
  const GameHistoryScreen({Key? key}) : super(key: key);

  @override
  State<GameHistoryScreen> createState() => _GameHistoryScreenState();
}

class _GameHistoryScreenState extends State<GameHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Load lịch sử game khi màn hình được tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ZiZackController>(context, listen: false).loadGameHistory();
    });
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours giờ $minutes phút';
    } else {
      return '$minutes phút';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ZiZackController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: CustomAppBar(
            context: context,
            title: 'Lịch sử trò chơi',
            leading: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.backgroundColor,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.primary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
          body: FutureBuilder<List<GameSession>>(
            future: controller.getCompletedGames(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Chưa có lịch sử trò chơi',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              List<GameSession> completedGames = snapshot.data!;
              completedGames.sort((a, b) => b.startTime.compareTo(a.startTime));

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: completedGames.length,
                itemBuilder: (context, index) {
                  GameSession session = completedGames[index];
                  List<Player> sortedPlayers =
                      session.getPlayersSortedByScore();

                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        _showGameDetailDialog(context, session);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: AppColors.primaryColor,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      _formatDateTime(session.startTime),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _showDeleteConfirmDialog(
                                        context, controller, session);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 8),

                            // Info
                            Row(
                              children: [
                                Icon(Icons.timer, size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(
                                  _formatDuration(session.getPlayDuration()),
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                SizedBox(width: 16),
                                Icon(Icons.people,
                                    size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(
                                  '${session.players.length} người chơi',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                SizedBox(width: 16),
                                Icon(Icons.gamepad,
                                    size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(
                                  '${session.allRounds.length} ván',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),

                            Divider(height: 24),

                            // Top 3 players
                            Text(
                              'Kết quả:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            SizedBox(height: 8),

                            ...sortedPlayers.take(3).map((player) {
                              int rank = sortedPlayers.indexOf(player) + 1;
                              IconData? icon;
                              Color? iconColor;

                              if (rank == 1) {
                                icon = Icons.emoji_events;
                                iconColor = Colors.amber;
                              } else if (rank == 2) {
                                icon = Icons.emoji_events;
                                iconColor = Colors.grey[400];
                              } else if (rank == 3) {
                                icon = Icons.emoji_events;
                                iconColor = Colors.brown[300];
                              }

                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    if (icon != null)
                                      Icon(icon, color: iconColor, size: 20)
                                    else
                                      SizedBox(width: 20),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        player.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: rank <= 3
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: player.totalScore >= 0
                                            ? Colors.green
                                            : Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${player.totalScore}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),

                            if (sortedPlayers.length > 3)
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  'Xem chi tiết để thấy thêm...',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showDeleteConfirmDialog(
      BuildContext context, ZiZackController controller, GameSession session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa lịch sử trò chơi này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              controller.deleteGameSession(session.id);
              Navigator.pop(context);
              showCustomAlert(
                context,
                type: AlertType.success,
                title: 'Thông báo',
                message: 'Đã xóa lịch sử trò chơi',
              );
            },
            child: Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showGameDetailDialog(BuildContext context, GameSession session) {
    List<Player> sortedPlayers = session.getPlayersSortedByScore();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chi tiết trò chơi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thông tin game
                      _buildInfoRow(Icons.calendar_today, 'Thời gian',
                          _formatDateTime(session.startTime)),
                      _buildInfoRow(Icons.timer, 'Thời lượng',
                          _formatDuration(session.getPlayDuration())),
                      _buildInfoRow(Icons.gamepad, 'Số ván chơi',
                          '${session.allRounds.length} ván'),

                      Divider(height: 24),

                      // Bảng xếp hạng
                      Text(
                        'Bảng xếp hạng:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: 12),

                      ...sortedPlayers.asMap().entries.map((entry) {
                        int rank = entry.key + 1;
                        Player player = entry.value;
                        IconData? icon;
                        Color? iconColor;

                        if (rank == 1) {
                          icon = Icons.emoji_events;
                          iconColor = Colors.amber;
                        } else if (rank == 2) {
                          icon = Icons.emoji_events;
                          iconColor = Colors.grey[400];
                        } else if (rank == 3) {
                          icon = Icons.emoji_events;
                          iconColor = Colors.brown[300];
                        }

                        return Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: rank <= 3
                                ? iconColor?.withOpacity(0.1)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: rank <= 3 ? iconColor! : Colors.grey[300]!,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              if (icon != null)
                                Icon(icon, color: iconColor, size: 24)
                              else
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: AppColors.sixColor,
                                  child: Text(
                                    '$rank',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  player.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: rank <= 3
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: player.totalScore >= 0
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '${player.totalScore}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),
          SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
