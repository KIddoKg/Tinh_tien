# Hệ Thống Quản Lý Game Session

## Tổng quan

Hệ thống này cung cấp khả năng lưu trữ và quản lý lịch sử trò chơi với các tính năng:
- Lưu tự động sau mỗi ván chơi
- Tiếp tục game đang chơi dở
- Xem lịch sử các game đã hoàn thành
- Quản lý nhiều session game

## Cấu trúc Model

### 1. Player Model
```dart
Player({
  int id,              // ID người chơi
  String name,         // Tên người chơi
  bool isCai,          // Có phải "cái" không
  String currentPoint, // Điểm đang nhập
  List<int> roundPoints, // Điểm của từng ván
  int totalScore,      // Tổng điểm
})
```

### 2. GameSession Model
```dart
GameSession({
  String id,           // Unique ID (timestamp)
  DateTime startTime,  // Thời gian bắt đầu
  DateTime? endTime,   // Thời gian kết thúc (null nếu chưa xong)
  GameStatus status,   // inProgress | completed
  List<Player> players, // Danh sách người chơi
  List<List<int>> allRounds, // Lịch sử điểm các ván
  int currentRound,    // Ván hiện tại
})
```

### 3. GameHistory Model
```dart
GameHistory({
  List<GameSession> sessions, // Danh sách tất cả sessions
})
```

## Cách sử dụng

### 1. Khởi tạo game mới

```dart
// Trong initState hoặc khi bắt đầu game
await controller.createNewGameSession();
```

### 2. Lưu tự động

Hệ thống tự động lưu sau mỗi ván chơi trong:
- `calculateEndForMaps()` - Khi tính điểm theo luật cái
- `calculateDirectPoints()` - Khi nhập điểm trực tiếp

### 3. Kiểm tra và tiếp tục game đang chơi dở

```dart
// Trong màn hình chọn người chơi hoặc trước khi bắt đầu
import 'package:Xi_Zach/new_ver/screen/gameOne/continue_game_dialog.dart';

bool continued = await checkAndShowContinueGameDialog(context);
if (continued) {
  // Người dùng chọn tiếp tục - chuyển đến màn hình game
  Navigator.push(context, MaterialPageRoute(
    builder: (context) => HomeZiZach(),
  ));
}
```

### 4. Hoàn thành game

```dart
// Khi người dùng nhấn nút "Kết thúc" trong dialog
await controller.completeCurrentSession();
```

### 5. Xem lịch sử

```dart
// Chuyển đến màn hình lịch sử
Navigator.push(context, MaterialPageRoute(
  builder: (context) => GameHistoryScreen(),
));
```

### 6. Xóa session

```dart
await controller.deleteGameSession(sessionId);
```

## Tích hợp vào màn hình hiện có

### A. Màn hình chọn người chơi (trước khi vào game)

```dart
// Thêm vào nút bắt đầu game
onPressed: () async {
  // Kiểm tra game đang chơi dở
  bool continued = await checkAndShowContinueGameDialog(context);
  
  if (continued) {
    // Đã load game cũ, chuyển màn
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => HomeZiZach(),
    ));
  } else {
    // Bắt đầu game mới
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => HomeZiZach(),
    ));
  }
}
```

### B. Thêm nút xem lịch sử

```dart
// Trong AppBar hoặc menu
IconButton(
  icon: Icon(Icons.history),
  onPressed: () {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => GameHistoryScreen(),
    ));
  },
)
```

### C. Cập nhật hàm showExitDialog

Hàm đã được cập nhật để:
- Hoàn thành session khi thoát
- Reset dữ liệu về null

## Lưu trữ dữ liệu

Dữ liệu được lưu trong SharedPreferences với key:
- `gameHistory` - Toàn bộ lịch sử game (JSON)
- `listCharNew` - Danh sách người chơi hiện tại (List<String>)

## Format JSON

```json
{
  "sessions": [
    {
      "id": "1234567890123",
      "startTime": "2024-02-16T10:30:00.000",
      "endTime": "2024-02-16T11:45:00.000",
      "status": "GameStatus.completed",
      "currentRound": 5,
      "players": [
        {
          "id": 0,
          "name": "Player 1",
          "isCai": false,
          "currentPoint": "",
          "roundPoints": [100, -50, 200, 0, -100],
          "totalScore": 150
        }
      ],
      "allRounds": [
        [100, -100],
        [-50, 50],
        [200, -200],
        [0, 0],
        [-100, 100]
      ]
    }
  ]
}
```

## API Controller

### Methods mới trong ZiZackController

```dart
// Tạo session mới
Future<void> createNewGameSession()

// Lưu session hiện tại
Future<void> saveCurrentSession()

// Load lịch sử
Future<void> loadGameHistory()

// Tiếp tục game đang chơi dở
Future<void> continueInProgressGame()

// Kiểm tra có game đang chơi dở không
Future<bool> hasInProgressGame()

// Hoàn thành session
Future<void> completeCurrentSession()

// Xóa session
Future<void> deleteGameSession(String sessionId)

// Lấy danh sách game đã hoàn thành
Future<List<GameSession>> getCompletedGames()

// Reset và bắt đầu mới
Future<void> resetAndStartNewGame()
```

## Dependencies cần thêm

Thêm vào `pubspec.yaml`:

```yaml
dependencies:
  intl: ^0.18.0  # Cho format ngày tháng
```

## Lưu ý quan trọng

1. **Tự động lưu**: Hệ thống tự động lưu sau mỗi ván, không cần gọi thủ công
2. **Session lifecycle**: 
   - `inProgress` khi đang chơi
   - `completed` khi kết thúc
3. **Dữ liệu cũ**: Tương thích ngược với hệ thống cũ (listOfMaps, point)
4. **Performance**: Nên giới hạn số lượng session lưu trữ (vd: 50 games gần nhất)

## Testing

```dart
// Test tạo session
await controller.createNewGameSession();
assert(controller.currentSession != null);

// Test lưu
await controller.saveCurrentSession();

// Test load
await controller.loadGameHistory();
assert(controller.gameHistory.sessions.isNotEmpty);

// Test tiếp tục
bool hasInProgress = await controller.hasInProgressGame();
if (hasInProgress) {
  await controller.continueInProgressGame();
}
```

## Roadmap

- [ ] Export lịch sử ra file
- [ ] Share kết quả qua mạng xã hội
- [ ] Thống kê chi tiết (win rate, avg score...)
- [ ] Cloud sync với Firebase
- [ ] Multiplayer mode
