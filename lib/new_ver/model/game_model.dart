import 'dart:convert';

/// Model cho mỗi người chơi trong game
class Player {
  final int id;
  final String name;
  bool isCai;
  String currentPoint; // Điểm đang nhập
  List<int> roundPoints; // Điểm của từng ván
  int totalScore; // Tổng điểm

  Player({
    required this.id,
    required this.name,
    this.isCai = false,
    this.currentPoint = '',
    List<int>? roundPoints,
    this.totalScore = 0,
  }) : roundPoints = roundPoints ?? [];

  // Convert Player to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isCai': isCai,
      'currentPoint': currentPoint,
      'roundPoints': roundPoints,
      'totalScore': totalScore,
    };
  }

  // Create Player from Map
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      isCai: map['isCai'] ?? false,
      currentPoint: map['currentPoint'] ?? '',
      roundPoints: List<int>.from(map['roundPoints'] ?? []),
      totalScore: map['totalScore'] ?? 0,
    );
  }

  // Convert Player to JSON string
  String toJson() => json.encode(toMap());

  // Create Player from JSON string
  factory Player.fromJson(String source) => Player.fromMap(json.decode(source));

  // Copy with method for immutability
  Player copyWith({
    int? id,
    String? name,
    bool? isCai,
    String? currentPoint,
    List<int>? roundPoints,
    int? totalScore,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      isCai: isCai ?? this.isCai,
      currentPoint: currentPoint ?? this.currentPoint,
      roundPoints: roundPoints ?? this.roundPoints,
      totalScore: totalScore ?? this.totalScore,
    );
  }
}

/// Enum cho trạng thái game
enum GameStatus {
  inProgress, // Đang chơi
  completed, // Đã hoàn thành
}

/// Model cho một game session
class GameSession {
  final String id; // Unique ID cho mỗi game session
  final DateTime startTime; // Thời gian bắt đầu
  DateTime? endTime; // Thời gian kết thúc (null nếu chưa kết thúc)
  GameStatus status; // Trạng thái game
  List<Player> players; // Danh sách người chơi
  List<List<int>> allRounds; // Lịch sử điểm của tất cả các ván
  int currentRound; // Ván hiện tại

  GameSession({
    required this.id,
    required this.startTime,
    this.endTime,
    this.status = GameStatus.inProgress,
    required this.players,
    List<List<int>>? allRounds,
    this.currentRound = 0,
  }) : allRounds = allRounds ?? [];

  // Tính tổng điểm cho tất cả người chơi
  void calculateTotalScores() {
    for (var player in players) {
      player.totalScore = 0;
      for (int i = 0; i < allRounds.length; i++) {
        if (i < allRounds.length && player.id < allRounds[i].length) {
          player.totalScore += allRounds[i][player.id];
        }
      }
    }
  }

  // Thêm một ván mới
  void addRound(List<int> roundScores) {
    allRounds.add(roundScores);
    currentRound++;
    calculateTotalScores();
  }

  // Kết thúc game
  void completeGame() {
    endTime = DateTime.now();
    status = GameStatus.completed;
    calculateTotalScores();
  }

  // Lấy danh sách người chơi sắp xếp theo điểm
  List<Player> getPlayersSortedByScore() {
    List<Player> sortedPlayers = List.from(players);
    sortedPlayers.sort((a, b) => b.totalScore.compareTo(a.totalScore));
    return sortedPlayers;
  }

  // Thời gian chơi (duration)
  Duration getPlayDuration() {
    DateTime end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  // Convert GameSession to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'status': status.toString(),
      'players': players.map((x) => x.toMap()).toList(),
      'allRounds': allRounds,
      'currentRound': currentRound,
    };
  }

  // Create GameSession from Map
  factory GameSession.fromMap(Map<String, dynamic> map) {
    return GameSession(
      id: map['id'] ?? '',
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      status: map['status'] == 'GameStatus.completed'
          ? GameStatus.completed
          : GameStatus.inProgress,
      players: List<Player>.from(
        map['players']?.map((x) => Player.fromMap(x)) ?? [],
      ),
      allRounds: List<List<int>>.from(
        map['allRounds']?.map((x) => List<int>.from(x)) ?? [],
      ),
      currentRound: map['currentRound'] ?? 0,
    );
  }

  // Convert GameSession to JSON string
  String toJson() => json.encode(toMap());

  // Create GameSession from JSON string
  factory GameSession.fromJson(String source) =>
      GameSession.fromMap(json.decode(source));
}

/// Model cho lịch sử game
class GameHistory {
  final List<GameSession> sessions;

  GameHistory({List<GameSession>? sessions}) : sessions = sessions ?? [];

  // Thêm một session mới
  void addSession(GameSession session) {
    sessions.add(session);
  }

  // Lấy session đang chơi dở (nếu có)
  GameSession? getInProgressSession() {
    try {
      return sessions.firstWhere(
        (session) => session.status == GameStatus.inProgress,
      );
    } catch (e) {
      return null;
    }
  }

  // Lấy tất cả session đã hoàn thành
  List<GameSession> getCompletedSessions() {
    return sessions
        .where((session) => session.status == GameStatus.completed)
        .toList();
  }

  // Sắp xếp session theo thời gian (mới nhất trước)
  List<GameSession> getSessionsSortedByDate() {
    List<GameSession> sorted = List.from(sessions);
    sorted.sort((a, b) => b.startTime.compareTo(a.startTime));
    return sorted;
  }

  // Xóa một session
  void deleteSession(String sessionId) {
    sessions.removeWhere((session) => session.id == sessionId);
  }

  // Convert GameHistory to Map
  Map<String, dynamic> toMap() {
    return {
      'sessions': sessions.map((x) => x.toMap()).toList(),
    };
  }

  // Create GameHistory from Map
  factory GameHistory.fromMap(Map<String, dynamic> map) {
    return GameHistory(
      sessions: List<GameSession>.from(
        map['sessions']?.map((x) => GameSession.fromMap(x)) ?? [],
      ),
    );
  }

  // Convert GameHistory to JSON string
  String toJson() => json.encode(toMap());

  // Create GameHistory from JSON string
  factory GameHistory.fromJson(String source) =>
      GameHistory.fromMap(json.decode(source));
}
