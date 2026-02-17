import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svg_flutter/svg_flutter.dart';
import '../../../router/route.dart';
import '../../../share/app_styles.dart';
import '../../../share/share_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import '../../viewModel/zizach_Controller.dart';
import '../../model/game_model.dart';
import 'game_history_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ZiZachScreen extends StatefulWidget {
  const ZiZachScreen({super.key});

  @override
  State<ZiZachScreen> createState() => _ZiZachScreenState();
}

class _ZiZachScreenState extends State<ZiZachScreen> {
  TextEditingController test = TextEditingController();
  TextEditingController limitController = TextEditingController();
  bool switchValue = false;

  // Scroll controller
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load lịch sử game khi màn hình được mở
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<ZiZackController>(context, listen: false);
      controller.loadGameHistory();
    });

    // Lắng nghe scroll để load more
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Kiểm tra nếu scrollController có position hợp lệ
    if (!_scrollController.hasClients) return;

    final controller = Provider.of<ZiZackController>(context, listen: false);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Gần đến cuối danh sách
      print(
          '[SCROLL] Detected - Loading more items... (Current: ${controller.displayedSessions.length}/${controller.allSessions.length})');
      controller.loadMoreItems();
    }
  }

  // Pull to refresh
  Future<void> _onRefresh() async {
    final controller = Provider.of<ZiZackController>(context, listen: false);
    await controller.refreshGameHistory();
  }

  // Tạo dữ liệu test
  Future<void> _generateTestData() async {
    final controller = Provider.of<ZiZackController>(context, listen: false);

    print('🎲 Bắt đầu tạo dữ liệu test...');

    // Load game history hiện tại
    await controller.loadGameHistory();

    List<String> playerNames = [
      'Minh',
      'Hùng',
      'Linh',
      'Trang',
      'Tuấn',
      'Anh',
      'Hương',
      'Dũng',
      'Mai',
      'Long'
    ];

    Random random = Random();

    // Tạo 25 game sessions
    for (int i = 0; i < 25; i++) {
      // Random số người chơi (2-6 người)
      int numPlayers = 2 + random.nextInt(5);

      // Random chọn người chơi
      List<String> selectedPlayers = [];
      List<String> availablePlayers = List.from(playerNames);
      for (int j = 0; j < numPlayers; j++) {
        int randomIndex = random.nextInt(availablePlayers.length);
        selectedPlayers.add(availablePlayers[randomIndex]);
        availablePlayers.removeAt(randomIndex);
      }

      // Tạo players với id
      List<Player> players = [];
      for (int j = 0; j < selectedPlayers.length; j++) {
        players.add(Player(
          id: j,
          name: selectedPlayers[j],
        ));
      }

      // Random số ván chơi (3-10 ván)
      int numRounds = 3 + random.nextInt(8);

      // Tạo game session
      DateTime startTime =
          DateTime.now().subtract(Duration(days: i, hours: random.nextInt(24)));
      GameSession session = GameSession(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_$i',
        players: players,
        startTime: startTime,
        endTime: startTime.add(Duration(minutes: 30 + random.nextInt(90))),
        status: i == 0
            ? GameStatus.inProgress
            : GameStatus.completed, // Game đầu tiên là in-progress
      );

      // Tạo các ván chơi với điểm random
      for (int roundNum = 0; roundNum < numRounds; roundNum++) {
        List<int> roundScores = [];

        for (int playerIndex = 0; playerIndex < players.length; playerIndex++) {
          // Random điểm từ -50 đến 50
          int score = -50 + random.nextInt(101);
          roundScores.add(score);
        }

        // Thêm ván vào session
        session.addRound(roundScores);
      }

      // Thêm vào game history
      controller.gameHistory.sessions.add(session);

      print(
          '✅ Đã tạo game ${i + 1}/25: ${selectedPlayers.join(", ")} - $numRounds ván');
    }

    // Lưu vào SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('gameHistory', controller.gameHistory.toJson());

    print(
        '💾 Đã lưu ${controller.gameHistory.sessions.length} game sessions vào storage');

    // Refresh UI
    await controller.refreshGameHistory();
  }

  // Xóa tất cả dữ liệu test
  Future<void> _clearAllData() async {
    final controller = Provider.of<ZiZackController>(context, listen: false);

    print('🗑️ Xóa tất cả dữ liệu...');

    // Clear tất cả sessions
    controller.gameHistory.sessions.clear();

    // Lưu vào SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('gameHistory', controller.gameHistory.toJson());

    print('✅ Đã xóa tất cả dữ liệu');

    // Refresh UI
    await controller.refreshGameHistory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    test.dispose();
    limitController.dispose();
    super.dispose();
  }

  // Method để tính toán chiều rộng của text
  double _calculateTextWidth(String text, double fontSize) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
      ),
      maxLines: 1,
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: "Zi Zách",
        leading: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            CircleAvatar(
              backgroundColor: AppColors.backgroundColor,
              child: IconButton(
                icon: SvgPicture.asset(
                  AppSVG.back,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        // actions: Row(
        //   children: [
        //     CircleAvatar(
        //       backgroundColor: AppColors.backgroundColor,
        //       child: IconButton(
        //         icon: Icon(
        //           Icons.add_circle,
        //           color: Colors.green,
        //         ),
        //         tooltip: 'Tạo dữ liệu test',
        //         onPressed: () async {
        //           await _generateTestData();
        //           showCustomAlert(
        //             context,
        //             type: AlertType.success,
        //             title: 'Thành công',
        //             message: 'Đã tạo 25 game sessions test!',
        //           );
        //         },
        //       ),
        //     ),
        //     const SizedBox(width: 10),
        //     CircleAvatar(
        //       backgroundColor: AppColors.backgroundColor,
        //       child: IconButton(
        //         icon: Icon(
        //           Icons.delete_forever,
        //           color: Colors.red,
        //         ),
        //         tooltip: 'Xóa tất cả dữ liệu',
        //         onPressed: () async {
        //           // Hiển thị dialog xác nhận
        //           bool? confirmed = await showDialog<bool>(
        //             context: context,
        //             builder: (context) => AlertDialog(
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(16),
        //               ),
        //               title: Row(
        //                 children: [
        //                   Icon(Icons.warning, color: Colors.red),
        //                   SizedBox(width: 8),
        //                   Text('Xác nhận'),
        //                 ],
        //               ),
        //               content:
        //                   Text('Bạn có chắc muốn xóa TẤT CẢ dữ liệu game?'),
        //               actions: [
        //                 TextButton(
        //                   onPressed: () => Navigator.pop(context, false),
        //                   child: Text('Hủy'),
        //                 ),
        //                 ElevatedButton(
        //                   style: ElevatedButton.styleFrom(
        //                     backgroundColor: Colors.red,
        //                   ),
        //                   onPressed: () => Navigator.pop(context, true),
        //                   child: Text('Xóa tất cả',
        //                       style: TextStyle(color: Colors.white)),
        //                 ),
        //               ],
        //             ),
        //           );
        //
        //           if (confirmed == true) {
        //             await _clearAllData();
        //             showCustomAlert(
        //               context,
        //               type: AlertType.success,
        //               title: 'Thành công',
        //               message: 'Đã xóa tất cả dữ liệu!',
        //             );
        //           }
        //         },
        //       ),
        //     ),
        //     const SizedBox(width: 10),
        //     CircleAvatar(
        //       backgroundColor: AppColors.backgroundColor,
        //       child: IconButton(
        //         icon: Icon(
        //           Icons.bug_report,
        //           color: AppColors.primary,
        //         ),
        //         tooltip: 'Debug - Xem dữ liệu',
        //         onPressed: () async {
        //           print(
        //               '\n🔍 DEBUG: Checking game history from ZiZach Screen...\n');
        //           final controller =
        //               Provider.of<ZiZackController>(context, listen: false);
        //           await controller.printGameHistory();
        //           controller.printCurrentSession();
        //
        //           // Refresh để load lại data
        //           await controller.refreshGameHistory();
        //
        //           showCustomAlert(
        //             context,
        //             type: AlertType.success,
        //             title: 'Debug',
        //             message:
        //                 'Đã in gameHistory ra console!\nKiểm tra debug console để xem chi tiết.',
        //           );
        //         },
        //       ),
        //     ),
        //     const SizedBox(width: 10),
        //     CircleAvatar(
        //       backgroundColor: AppColors.backgroundColor,
        //       child: IconButton(
        //         icon: Icon(
        //           Icons.science,
        //           color: Colors.purple,
        //         ),
        //         tooltip: 'Test Scroll Screen',
        //         onPressed: () {
        //           Navigator.pushNamed(context, AppRoute.testScroll);
        //         },
        //       ),
        //     ),
        //     const SizedBox(width: 10),
        //     CircleAvatar(
        //       backgroundColor: AppColors.backgroundColor,
        //       child: IconButton(
        //         icon: Icon(
        //           Icons.history,
        //           color: AppColors.primary,
        //         ),
        //         tooltip: 'Lịch sử trò chơi',
        //         onPressed: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => GameHistoryScreen(),
        //             ),
        //           );
        //         },
        //       ),
        //     ),
        //     const SizedBox(width: 10),
        //   ],
        // ),
      ),
      body: Column(
        children: [
          // Phần lịch sử game - Dùng Consumer để lắng nghe thay đổi từ Provider
          Expanded(
            child: Consumer<ZiZackController>(
              builder: (context, controller, child) {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: AppColors.primaryColor,
                  child: controller.displayedSessions.isEmpty
                      ? LayoutBuilder(
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
                                        Icons.history,
                                        size: 100,
                                        color: Colors.grey[300],
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Chưa có lịch sử trò chơi',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Bấm nút + để bắt đầu trò chơi mới',
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
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.all(16),
                          itemCount: controller.displayedSessions.length +
                              (controller.isLoadingMore &&
                                      controller.displayedSessions.length <
                                          controller.allSessions.length
                                  ? 1
                                  : 0),
                          itemBuilder: (context, index) {
                            // Hiển thị loading indicator ở cuối
                            if (index == controller.displayedSessions.length) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              );
                            }

                            // Sort sessions theo thời gian
                            List<GameSession> sortedSessions =
                                List.from(controller.displayedSessions);
                            sortedSessions.sort(
                                (a, b) => b.startTime.compareTo(a.startTime));

                            GameSession session = sortedSessions[index];
                            List<Player> sortedPlayers =
                                session.getPlayersSortedByScore();

                            // Kiểm tra xem game đang chơi dở hay đã hoàn thành
                            bool isInProgress =
                                session.status == GameStatus.inProgress;

                            return Card(
                              margin: EdgeInsets.only(bottom: 16),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                // Viền màu cam cho game đang chơi
                                side: isInProgress
                                    ? BorderSide(color: Colors.orange, width: 2)
                                    : BorderSide.none,
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () async {
                                  if (isInProgress) {
                                    // Game đang chơi dở - Tiếp tục chơi
                                    final controller =
                                        Provider.of<ZiZackController>(context,
                                            listen: false);
                                    await controller.continueInProgressGame();
                                    Navigator.of(context)
                                        .pushNamed(AppRoute.homeGameZiZach);
                                  } else {
                                    // Game đã xong - Xem chi tiết
                                    _showGameDetailDialog(context, session);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primaryColor
                                            .withOpacity(0.05),
                                        Colors.white,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Header
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .primaryColor
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Icon(
                                                      Icons.calendar_today,
                                                      color: AppColors
                                                          .primaryColor,
                                                      size: 18,
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _formatDateTime(
                                                              session
                                                                  .startTime),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: AppColors
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                        SizedBox(height: 2),
                                                        Text(
                                                          _formatDuration(session
                                                              .getPlayDuration()),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete_outline,
                                                  color: Colors.red[400]),
                                              onPressed: () {
                                                final controller = Provider.of<
                                                        ZiZackController>(
                                                    context,
                                                    listen: false);
                                                _showDeleteConfirmDialog(
                                                    context,
                                                    controller,
                                                    session);
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),

                                        // Info badges
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            // Badge "Đang chơi" nếu là in-progress
                                            if (isInProgress)
                                              _buildInfoBadge(
                                                Icons.play_circle_fill,
                                                'Đang chơi',
                                                Colors.orange,
                                              ),
                                            _buildInfoBadge(
                                              Icons.people,
                                              '${session.players.length} người',
                                              Colors.blue,
                                            ),
                                            _buildInfoBadge(
                                              Icons.gamepad,
                                              '${session.allRounds.length} ván',
                                              Colors.green,
                                            ),
                                          ],
                                        ),

                                        Divider(height: 24, thickness: 1),

                                        // Top 3 players
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.emoji_events,
                                              color: Colors.amber,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              'Kết quả:',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),

                                        ...sortedPlayers.take(3).map((player) {
                                          int rank =
                                              sortedPlayers.indexOf(player) + 1;
                                          Color? medalColor;

                                          if (rank == 1) {
                                            medalColor = Colors.amber;
                                          } else if (rank == 2) {
                                            medalColor = Colors.grey[400];
                                          } else if (rank == 3) {
                                            medalColor = Colors.brown[300];
                                          }

                                          return Padding(
                                            padding: EdgeInsets.only(bottom: 8),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: medalColor
                                                        ?.withOpacity(0.1) ??
                                                    Colors.grey[50],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: medalColor
                                                          ?.withOpacity(0.3) ??
                                                      Colors.grey[200]!,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.emoji_events,
                                                    color: medalColor,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      player.name,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: rank <= 3
                                                            ? FontWeight.bold
                                                            : FontWeight.w500,
                                                        color: Colors.grey[800],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          player.totalScore >= 0
                                                              ? Colors.green
                                                              : Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Text(
                                                      '${player.totalScore >= 0 ? "+" : ""}${player.totalScore}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),

                                        if (sortedPlayers.length > 3)
                                          Padding(
                                            padding: EdgeInsets.only(top: 4),
                                            child: Center(
                                              child: Text(
                                                'Bấm để xem chi tiết...',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.primaryColor,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),

                                        // Hint cho game đang chơi
                                        if (isInProgress)
                                          Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.orange
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.touch_app,
                                                      size: 16,
                                                      color: Colors.orange),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    'Bấm để tiếp tục chơi',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.orange[800],
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Kiểm tra có game đang chơi dở không trước khi mở popup
          final controller =
              Provider.of<ZiZackController>(context, listen: false);
          bool hasInProgress = await controller.hasInProgressGame();

          if (hasInProgress) {
            // Có game đang chơi dở - Hiển thị dialog xác nhận
            bool? shouldContinue = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Trò chơi chưa hoàn thành',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                content: Text(
                  'Bạn có trò chơi đang chơi dở. Bạn muốn tiếp tục chơi hay bắt đầu ván mới?',
                  style: TextStyle(fontSize: 15),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: Text(
                      'Bắt đầu ván mới',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: Text(
                      'Tiếp tục chơi',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );

            if (shouldContinue == true) {
              // Tiếp tục game cũ
              await controller.continueInProgressGame();
              Navigator.of(context).pushNamed(AppRoute.homeGameZiZach);
              return; // Không mở popup
            } else if (shouldContinue == false) {
              // Bắt đầu game mới - Kết thúc game cũ trước
              print('🎮 Kết thúc game cũ và bắt đầu game mới');

              // Load game history để lấy game đang chơi
              await controller.loadGameHistory();
              GameSession? inProgressSession =
                  controller.gameHistory.getInProgressSession();

              if (inProgressSession != null) {
                // Cập nhật status thành completed
                inProgressSession.status = GameStatus.completed;
                inProgressSession.endTime = DateTime.now();

                // Lưu lại vào SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString(
                    'gameHistory', controller.gameHistory.toJson());
                print('✅ Đã kết thúc và lưu game cũ');
              }

              // Reset TẤT CẢ dữ liệu game cũ
              controller.resetGameData();

              // Mở popup để setup game mới
              await showPopupInfoOne(context);
              await controller.refreshGameHistory();
            }
            // Nếu shouldContinue == null (nhấn ngoài dialog) thì không làm gì
          } else {
            // Không có game đang chơi dở - Mở popup bình thường
            await showPopupInfoOne(context);
            await controller.refreshGameHistory();
          }

          if (kDebugMode) {
            print('Floating Action Button Pressed');
          }
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ), // Set your desired button color
      ),
    );
  }

  Future<BuildContext?> showPopupInfoOne(BuildContext context) {
    // Sync giá trị từ controller vào TextField
    final controller = Provider.of<ZiZackController>(context, listen: false);
    limitController.text =
        controller.limitValue > 0 ? controller.limitValue.toString() : '';

    return showCupertinoModalBottomSheet(
        topRadius: Radius.circular(36),
        context: context,
        backgroundColor: Colors.transparent,
        // Đảm bảo transparent
        expand: false,
        builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.85,
            maxChildSize: 0.85,
            expand: false,
            builder: (_, controller) {
              return StatefulBuilder(builder: (BuildContext context,
                  StateSetter setState /*You can rename this!*/) {
                return Consumer<ZiZackController>(
                    builder: (context, result, child) {
                  return Material(
                    color: Colors.transparent,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          )),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.all(8.0).copyWith(top: 8),
                            child: Container(
                              width: 60, // Độ rộng của hình chữ nhật
                              height: 8, // Chiều cao của hình chữ nhật
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                // Màu nền của hình chữ nhật
                                borderRadius: BorderRadius.circular(
                                    20), // Bán kính bo tròn
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: SingleChildScrollView(
                                  // physics: NeverScrollableScrollPhysics(),
                                  // shrinkWrap: true,
                                  controller: controller,
                                  child: Column(
                                    children: [
                                      // Hiển thị số lượng người chơi
                                      if (result.listCharNew.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: AppColors.primaryColor,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Text(
                                              '${result.listCharNew.length} người chơi',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),

                                      SizedBox(
                                        height: 10,
                                      ),
                                      // Wrap trong IgnorePointer để tránh xung đột scroll
                                      IgnorePointer(
                                        ignoring: false,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Wrap(
                                              alignment: WrapAlignment.start,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              spacing:
                                                  8.0, // Khoảng cách giữa các item theo chiều ngang
                                              runSpacing:
                                                  8.0, // Khoảng cách giữa các hàng
                                              children: result.listCharNew
                                                  .map((playerName) {
                                                final index = result.listCharNew
                                                    .indexOf(playerName);

                                                // Tính toán chiều rộng phù hợp dựa trên độ dài tên
                                                double textWidth =
                                                    _calculateTextWidth(
                                                            playerName, 17) +
                                                        60; // +60 cho padding và icon
                                                double containerWidth =
                                                    textWidth.clamp(
                                                        100.0,
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.45);

                                                return Container(
                                                  width: containerWidth,
                                                  height: 60,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 8.0),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.sixColor
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          playerName,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            result.listCharNew
                                                                .removeAt(
                                                                    index);
                                                          });
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .primaryRedOr
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: Icon(
                                                            Icons.close,
                                                            color: AppColors
                                                                .primaryRedOr,
                                                            size: 16,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextField(
                                                      controller: test,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Nhập tên người chơi',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                          borderSide: BorderSide(
                                                              color: AppColors
                                                                  .primaryColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    width: 100,
                                                    child: KSButton(
                                                      onTap: () {
                                                        String newName =
                                                            test.text.trim();

                                                        // Kiểm tra không được bỏ trống
                                                        if (newName.isEmpty) {
                                                          showCustomAlert(
                                                            context,
                                                            type: AlertType
                                                                .warning,
                                                            title: 'Cảnh báo',
                                                            message:
                                                                'Tên người chơi không được để trống!',
                                                          );
                                                          return;
                                                        }

                                                        // Kiểm tra không được trùng tên
                                                        final controller = Provider
                                                            .of<ZiZackController>(
                                                                context,
                                                                listen: false);

                                                        bool isDuplicate = controller
                                                            .listCharNew
                                                            .any((name) =>
                                                                name.toLowerCase() ==
                                                                newName
                                                                    .toLowerCase());

                                                        if (isDuplicate) {
                                                          showCustomAlert(
                                                            context,
                                                            type: AlertType
                                                                .warning,
                                                            title: 'Cảnh báo',
                                                            message:
                                                                'Tên "$newName" đã tồn tại!\nVui lòng chọn tên khác.',
                                                          );
                                                          return;
                                                        }

                                                        // Thêm người chơi mới
                                                        controller.addNewChar(
                                                            newName);
                                                        test.clear();
                                                      },
                                                      "Thêm",
                                                      backgroundColor: AppColors
                                                          .primaryColor,
                                                    ))
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Hiện tổng điểm khi chơi',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontSize: 18),
                                                ),
                                                Switch(
                                                  value: result.showTotalScore,
                                                  activeColor:
                                                      AppColors.primaryColor,
                                                  onChanged: (value) {
                                                    Provider.of<ZiZackController>(
                                                            context,
                                                            listen: false)
                                                        .setShowTotalScore(
                                                            value);
                                                  },
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 18.0),
                                              child: Text(
                                                "Chế độ chơi",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            AnimatedToggle(
                                              valueChoose: result.fOrc == 0
                                                  ? true
                                                  : false,
                                              size: 450,
                                              height: 50,
                                              values: ['Tự do', 'Giới hạn'],
                                              onToggleCallback: (value) {
                                                Provider.of<ZiZackController>(
                                                        context,
                                                        listen: false)
                                                    .selectMode(value);
                                              },
                                              lock: false,
                                              KSButton: AppColors.primaryColor,
                                              backgroundColor:
                                                  const Color(0xFFB5C1CC),
                                              textColor:
                                                  const Color(0xFFFFFFFF),
                                            ),
                                            result.fOrc == 0
                                                ? Container(
                                                    child: Text(
                                                      "Chế dộ chơi tự do không giới hạn lượt chơi",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  )
                                                : Container(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              width: 220,
                                                              child:
                                                                  AnimatedToggle(
                                                                height: 50,
                                                                size: 300,
                                                                values: [
                                                                  'Điểm',
                                                                  'Ván'
                                                                ],
                                                                valueChoose:
                                                                    result.dOrv ==
                                                                            0
                                                                        ? true
                                                                        : false,
                                                                onToggleCallback:
                                                                    (value) {
                                                                  Provider.of<ZiZackController>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .selectType(
                                                                          value);
                                                                },
                                                                lock: false,
                                                                KSButton: AppColors
                                                                    .primaryColor,
                                                                backgroundColor:
                                                                    const Color(
                                                                        0xFFB5C1CC),
                                                                textColor:
                                                                    const Color(
                                                                        0xFFFFFFFF),
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 50,
                                                              width: 100,
                                                              child: TextField(
                                                                controller:
                                                                    limitController,
                                                                maxLines:
                                                                    1, // ⭐ BẮT BUỘC
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                textAlignVertical:
                                                                    TextAlignVertical
                                                                        .center,

                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .digitsOnly,
                                                                ],

                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),

                                                                decoration:
                                                                    InputDecoration(
                                                                  filled: true,
                                                                  fillColor: AppColors
                                                                      .sixColor
                                                                      .withOpacity(
                                                                          0.5),

                                                                  isDense:
                                                                      true, // ⭐ rất quan trọng
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    vertical:
                                                                        14, // chỉnh cho vừa chiều cao
                                                                    horizontal:
                                                                        0,
                                                                  ),

                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                            color:
                                                                                Colors.white),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                            color:
                                                                                Colors.white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            // result.dOrv == 0
                                                            //     ? Text(
                                                            //         "điểm",
                                                            //         style: TextStyle(
                                                            //             fontWeight:
                                                            //                 FontWeight
                                                            //                     .w600,
                                                            //             fontSize:
                                                            //                 18,
                                                            //             color: AppColors
                                                            //                 .primaryColor),
                                                            //       )
                                                            //     : Text(
                                                            //         "ván",
                                                            //         style: TextStyle(
                                                            //             fontWeight:
                                                            //                 FontWeight
                                                            //                     .w600,
                                                            //             fontSize:
                                                            //                 18,
                                                            //             color: AppColors
                                                            //                 .primaryColor),
                                                            //       )
                                                          ],
                                                        ),
                                                        result.dOrv == 0
                                                            ? Container(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "Ai ăn nhiều nhất thì nghỉ thui, chứ lấy gì bù lỗ.",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                    Text(
                                                                        "* Có thể thay đổi chế độ chơi sau khi đã tạo ván.",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontSize: 15))
                                                                  ],
                                                                ),
                                                              )
                                                            : Container(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      "Chơi đủ ván rồi nghỉ thui, lời lỗ không quan trọng zui là được.",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                    Text(
                                                                        "* Có thể thay đổi chế độ chơi sau khi đã tạo ván.",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontSize: 15))
                                                                  ],
                                                                ),
                                                              )
                                                      ],
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Nút "Bắt đầu thôi" ở ngoài SingleChildScrollView - luôn cố định ở cuối
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
                              onTap: () async {
                                // Kiểm tra số lượng người chơi
                                if (result.listCharNew.length < 2) {
                                  showCustomAlert(
                                    context,
                                    type: AlertType.warning,
                                    title: 'Thông báo',
                                    message:
                                        'Cần ít nhất 2 người chơi để bắt đầu!',
                                  );
                                  return;
                                }

                                Navigator.pop(context);

                                // Bắt đầu game mới - Gọi initSt() để khởi tạo
                                print('🎮 Bắt đầu game mới - gọi initSt()');
                                await result.initSt();
                                Navigator.of(context)
                                    .pushNamed(AppRoute.homeGameZiZach);
                              },
                              "Bắt đầu thôi",
                              backgroundColor: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              });
            }));
  }

  // Helper methods for formatting
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

  Widget _buildInfoBadge(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(
      BuildContext context, ZiZackController controller, GameSession session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Xác nhận xóa'),
          ],
        ),
        content: Text(
          'Bạn có chắc muốn xóa lịch sử trò chơi này?\nHành động này không thể hoàn tác.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              await controller.deleteGameSession(session.id);
              Navigator.pop(context);
              showCustomAlert(
                context,
                type: AlertType.success,
                title: 'Thông báo',
                message: 'Đã xóa lịch sử trò chơi',
              );
              await controller.refreshGameHistory(); // Refresh UI
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.emoji_events, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Chi tiết trò chơi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thông tin game
                      _buildDetailInfoRow(
                        Icons.calendar_today,
                        'Thời gian',
                        _formatDateTime(session.startTime),
                      ),
                      SizedBox(height: 12),
                      _buildDetailInfoRow(
                        Icons.timer,
                        'Thời lượng',
                        _formatDuration(session.getPlayDuration()),
                      ),
                      SizedBox(height: 12),
                      _buildDetailInfoRow(
                        Icons.gamepad,
                        'Số ván chơi',
                        '${session.allRounds.length} ván',
                      ),

                      Divider(height: 32, thickness: 2),

                      // Bảng xếp hạng
                      Row(
                        children: [
                          Icon(
                            Icons.leaderboard,
                            color: AppColors.primaryColor,
                            size: 22,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Bảng xếp hạng',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

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
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: rank <= 3
                                ? iconColor?.withOpacity(0.08)
                                : Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: rank <= 3
                                  ? iconColor!.withOpacity(0.3)
                                  : Colors.grey[200]!,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              if (icon != null)
                                Icon(icon, color: iconColor, size: 26)
                              else
                                CircleAvatar(
                                  radius: 13,
                                  backgroundColor: AppColors.sixColor,
                                  child: Text(
                                    '$rank',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  player.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: rank <= 3
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: player.totalScore >= 0
                                        ? [Colors.green, Colors.green[700]!]
                                        : [Colors.red, Colors.red[700]!],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (player.totalScore >= 0
                                              ? Colors.green
                                              : Colors.red)
                                          .withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '${player.totalScore >= 0 ? "+" : ""}${player.totalScore}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
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

  Widget _buildDetailInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppColors.primaryColor),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
