# 🚪 Player Out Game Feature

## Tính năng mới: Cho phép player rời game (Out Game)

### 📋 Mô tả
- Player có thể "out" (rời khỏi game) trong quá trình chơi
- Player đã out sẽ không tham gia các ván tiếp theo
- Data các ván đã chơi vẫn được giữ nguyên

### ✨ Thay đổi

#### 1. **Model Data**
```dart
// zizach_Controller.dart - initSt()
Map<String, dynamic> currentMap = {
  'id': i,
  'cai': cai,
  'name': name,
  'point': point,
  'nowPoint': nowPoint,
  'end': end,
  'isOut': false, // 🚪 Trạng thái out game
};
```

#### 2. **Controller Method**
```dart
// zizach_Controller.dart
void togglePlayerOut(int index, BuildContext context) {
  if (index >= 0 && index < listOfMaps.length) {
    bool currentStatus = listOfMaps[index]['isOut'] ?? false;
    listOfMaps[index]['isOut'] = !currentStatus;
    
    String playerName = listOfMaps[index]['name'];
    String message = !currentStatus 
        ? '$playerName đã rời khỏi game'
        : '$playerName đã quay lại game';
    
    showCustomAlert(context, ...);
    notifyListeners();
  }
}
```

#### 3. **UI Changes**

**game_home.dart - Header (Tên người chơi):**
- ✅ Background màu xám với opacity 0.5
- ✅ Text màu xám (Colors.grey.shade600)
- ✅ Text có gạch ngang (TextDecoration.lineThrough)
- ✅ Tổng điểm cũng màu xám

**game_home.dart - Body (Điểm các ván):**
- ✅ Background màu xám với opacity 0.3
- ✅ Số ván và điểm màu xám (Colors.grey.shade600)

**set_money_widget.dart - Popup "Cài điểm":**
- ✅ Lọc và ẩn player đã out
- ✅ Chỉ hiển thị active players (isOut != true)
- ✅ Layout tự động điều chỉnh theo số player còn lại

### 🎯 Cách sử dụng

#### Toggle player out:
```dart
// Gọi từ UI (ví dụ: long press trên tên player)
Provider.of<ZiZackController>(context, listen: false)
    .togglePlayerOut(playerIndex, context);
```

#### Kiểm tra player có out không:
```dart
bool isOut = result.listOfMaps[playerIndex]['isOut'] ?? false;
```

### 📊 Luồng hoạt động

1. **Player chơi bình thường**
   - isOut = false
   - Hiển thị đầy đủ trong game_home và popups

2. **Player out game** (toggle)
   - isOut = true
   - UI bị xám và gạch ngang
   - Bị ẩn khỏi popup "Cài điểm" và "Tính điểm"
   - Data cũ vẫn giữ nguyên

3. **Player quay lại** (toggle lại)
   - isOut = false
   - Trở lại trạng thái bình thường

### ⚠️ Lưu ý

1. **Data persistence**: 
   - Tên và điểm các ván đã chơi vẫn hiển thị trong game_home
   - Chỉ ẩn khỏi các popup nhập điểm

2. **Các ván mới**: 
   - Player đã out sẽ không có điểm trong các ván mới
   - Cần implement logic để tự động set điểm = 0 cho player out

3. **UI trigger**: 
   - Cần thêm button/gesture để toggle (chưa implement UI trigger)
   - Suggest: Long press trên tên player trong game_home

### 🔜 TODO - Thêm UI trigger

Đề xuất thêm vào `game_home.dart`:

```dart
// Wrap Container của header với GestureDetector
GestureDetector(
  onLongPress: () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Player Out'),
        content: Text('Cho phép $name out game?'),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Xác nhận'),
            onPressed: () {
              result.togglePlayerOut(playerIndex, context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  },
  child: Container(
    // ... existing code
  ),
)
```

### ✅ Đã hoàn thành
- [x] Thêm field `isOut` vào model
- [x] Tạo method `togglePlayerOut()`
- [x] UI xám hóa player out trong game_home
- [x] Lọc player out khỏi popup "Cài điểm"
- [ ] Thêm UI trigger (long press/button)
- [ ] Lọc player out khỏi popup "Tính điểm" 
- [ ] Lọc player out khỏi popup "Tính tay"
- [ ] Auto set điểm = 0 cho player out trong ván mới
