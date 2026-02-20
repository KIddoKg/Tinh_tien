import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:archive/archive.dart'; // 🗜️ For cross-platform compression

import '../../share/share_widget.dart';
import '../model/game_model.dart';

class ZiZackController extends ChangeNotifier {
  static final ZiZackController instance = ZiZackController._internal();

  factory ZiZackController() {
    return instance;
  }

  List<String> status = ["Ăn", "Thua", "X2", "Đền", "Huề"];

  ZiZackController._internal();

  List<String> listChar = [
    "Bepr",
    "Beprddd",
    "Bepr",
    "Bepr",
    "Bepr",
    "Bepr",
    "Bepr"
  ];

  List<List<int>> point = [];

  List<String> listCharNew = [];

  // Game session management
  GameSession? currentSession;
  GameHistory gameHistory = GameHistory();

  bool showPoint = false;

  // Chế độ chơi
  int fOrc = 0; // 0 = Tự do, 1 = Giới hạn
  int dOrv = 0; // 0 = Điểm, 1 = Ván
  int limitValue = 0; // Giá trị giới hạn (số điểm hoặc số ván)
  bool showTotalScore = false; // Hiện tổng điểm khi chơi

  // Chế độ nhập điểm: 0 = Tính điểm & Cài điểm, 1 = Tính tay
  int inputMode = 1; // Mặc định là Tính tay

  // Lưu trữ điểm "Cài điểm" riêng biệt để không bị reset khi đổi chế độ
  Map<int, String> setMoneyPoints = {};

  void toggleInputMode() {
    inputMode = inputMode == 0 ? 1 : 0;
    print(
        '🔄 Đã chuyển sang chế độ: ${inputMode == 0 ? "Tính điểm & Cài điểm" : "Tính tay"}');
    notifyListeners();
  }

  int countEnd = 0;

  int selectedIndex = -1;

  // Pagination state for game history screen
  int currentPage = 1;
  final int itemsPerPage = 10;
  bool isLoadingMore = false;
  List<GameSession> allSessions = [];
  List<GameSession> displayedSessions = [];

  static Future<void> nothing() async {
    print("nothing");
  }

  void addNewChar(String name) {
    listCharNew.add(name);
    saveListCharNew();
    notifyListeners();
  }

  /// Đổi tên người chơi
  void renamePlayer(int index, String newName) {
    if (index >= 0 && index < listCharNew.length) {
      listCharNew[index] = newName;

      // Cập nhật trong listOfMaps
      if (index < listOfMaps.length) {
        listOfMaps[index]['name'] = newName;
      }

      // Cập nhật trong currentSession - tạo Player mới vì name là final
      if (currentSession != null && index < currentSession!.players.length) {
        Player oldPlayer = currentSession!.players[index];
        currentSession!.players[index] = Player(
          id: oldPlayer.id,
          name: newName,
          isCai: oldPlayer.isCai,
          isOut: oldPlayer.isOut, // 🚪 Giữ nguyên trạng thái out
          currentPoint: oldPlayer.currentPoint,
          roundPoints: oldPlayer.roundPoints,
          totalScore: oldPlayer.totalScore,
        );
      }

      saveListCharNew();
      saveCurrentSession();
      notifyListeners();
    }
  }

  /// Thêm người chơi mới vào game đang chơi
  void addPlayerToExistingGame(String name) {
    print('🎯 addPlayerToExistingGame - START');
    print('   Tên người chơi mới: $name');
    print('   Số ván đã chơi: ${point.length}');

    int newIndex = listCharNew.length;

    // Thêm vào listCharNew
    listCharNew.add(name);

    // Tạo nowPoint với 0 cho các ván đã chơi - PHẢI là growable list
    List<int> nowPointList = List.filled(point.length, 0, growable: true);

    // Tạo map mới cho người chơi
    Map<String, dynamic> newPlayerMap = {
      'id': newIndex,
      'cai': false,
      'name': name,
      'point': '',
      'nowPoint': nowPointList, // Danh sách điểm của từng ván
      'end': 0,
    };
    listOfMaps.add(newPlayerMap);

    print('   Đã thêm vào listOfMaps với nowPoint: $nowPointList');

    // Tạo calPoint map mới
    Map<String, dynamic> newCalPoint = {
      'id': newIndex,
      'win': false,
      'def': false,
      'x2': false,
      'all': false,
      'hue': false,
    };
    calPoint.add(newCalPoint);

    print('   Đã thêm vào calPoint');

    // Thêm điểm 0 cho người chơi mới vào tất cả các ván đã chơi trong point[][]
    for (int i = 0; i < point.length; i++) {
      point[i].add(0);
    }

    print('   Đã thêm 0 vào point[][] cho ${point.length} ván');

    // Cập nhật currentSession nếu có
    if (currentSession != null) {
      // Tạo roundPoints với 0 cho tất cả các ván đã chơi
      List<int> roundPoints = List.filled(point.length, 0);

      Player newPlayer = Player(
        id: newIndex,
        name: name,
        isOut: false, // 🚪 Player mới chưa out
        roundPoints: roundPoints,
        totalScore: 0,
      );
      currentSession!.players.add(newPlayer);

      print('   Đã thêm Player mới vào currentSession');

      // Sync allRounds từ point[][] (KHÔNG thêm trực tiếp để tránh duplicate)
      // Copy toàn bộ point[][] vào allRounds
      currentSession!.allRounds =
          point.map((round) => List<int>.from(round)).toList();

      print('   Đã sync allRounds từ point[][]');
      print(
          '   allRounds[0].length: ${currentSession!.allRounds.isNotEmpty ? currentSession!.allRounds[0].length : 0}');

      // Lưu lại session đã cập nhật
      saveCurrentSession();
    }

    // Lưu lại listCharNew đã cập nhật
    saveListCharNew();

    print('🎯 addPlayerToExistingGame - END');
    print('   listOfMaps.length: ${listOfMaps.length}');
    print('   calPoint.length: ${calPoint.length}');
    print('   listCharNew.length: ${listCharNew.length}');
    print('   point[0].length: ${point.isNotEmpty ? point[0].length : 0}');

    notifyListeners();
  }

  void selectMode(int value) {
    fOrc = value;
    notifyListeners();
  }

  void selectType(int value) {
    dOrv = value;
    notifyListeners();
  }

  void setLimitValue(int value) {
    limitValue = value;
    notifyListeners();
  }

  void setShowTotalScore(bool value) {
    showTotalScore = value;
    notifyListeners();
  }

  /// Reset tất cả dữ liệu game để bắt đầu game mới
  void resetGameData() {
    currentSession = null;
    listCharNew.clear();
    listOfMaps.clear();
    calPoint.clear();
    point.clear();
    fOrc = 0; // Reset về chế độ tự do
    limitValue = 0; // Reset giới hạn
    dOrv = 0; // Reset loại giới hạn
    showTotalScore = false; // Reset hiển thị tổng điểm
    print('🧹 Đã reset sạch dữ liệu game');
    notifyListeners();
  }

  List<Map<String, dynamic>> listOfMaps = [];

  List<Map<String, dynamic>> calPoint = [];

  Future<void> initSt() async {
    calPoint = [];
    listOfMaps = [];
    setMoneyPoints.clear(); // 🔥 Clear điểm "Cài điểm" khi bắt đầu game mới

    // Access the listCharNew
    List<String> yourList = await loadListCharNew();
    print("dđ${yourList}");
    for (int i = 0; i < yourList.length; i++) {
      String name = yourList[i];
      String point = ""; // Set your logic for the 'point' field here;
      int end = 0; // Set your logic for the 'end' field here;
      List<int> nowPoint = []; // Set your logic for the 'nowPoint' field here;
      bool win = false;
      bool def = false;
      bool x2 = false;
      bool all = false;
      // 🎯 Người chơi đầu tiên (id = 0) luôn là "cái" mặc định
      bool cai = (i == 0);

      Map<String, dynamic> currentMap = {
        'id': i,
        'cai': cai,
        'name': name,
        'point': point,
        'nowPoint': nowPoint,
        'end': end,
        'isOut': false, // 🚪 Trạng thái player có out game không
      };

      Map<String, dynamic> currentMapPoint = {
        'id': i,
        'win': win,
        'def': def,
        'x2': x2,
        'all': all,
        'hue': false,
      };
      listOfMaps.add(currentMap);
      // currentMap['nowPoint'] = nowPoint;
      calPoint.add(currentMapPoint);
    }

    print(calPoint);
    print(listOfMaps);
    print(listOfMaps[0]["cai"]);

    // Tạo game session mới nếu chưa có
    if (currentSession == null && yourList.isNotEmpty) {
      await createNewGameSession();
      // In thông báo người chơi đầu tiên là cái
      print(
          '🎯 Người chơi đầu tiên "${yourList[0]}" đã được chọn làm CÁI mặc định');
    }

    notifyListeners();
  }

  // 🚪 Toggle player out/in game
  void togglePlayerOut(int index, BuildContext context) {
    if (index >= 0 && index < listOfMaps.length) {
      bool currentStatus = listOfMaps[index]['isOut'] ?? false;
      listOfMaps[index]['isOut'] = !currentStatus;

      String playerName = listOfMaps[index]['name'];
      String message = !currentStatus
          ? '$playerName đã rời khỏi game'
          : '$playerName đã quay lại game';

      // 🚪 Lưu trạng thái mới vào session
      saveCurrentSession();

      showCustomAlert(
        context,
        type: AlertType.success,
        title: 'Thông báo',
        message: message,
      );

      notifyListeners();
    }
  }

  setCai(BuildContext context) {
    for (var i = 0; i < listOfMaps.length; i++) {
      listOfMaps[i]["cai"] = false;
    }
    listOfMaps[selectedIndex]["cai"] = true;
    showCustomAlert(
      context,
      type: AlertType.success,
      title: 'Thông báo',
      message: 'Đã chọn ${listOfMaps[selectedIndex]["name"]} làm cái trận này',
    );
    notifyListeners();
  }

  Future<List<String>> loadListCharNew() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listCharNew = prefs.getStringList('listCharNew') ?? [];
    return listCharNew;
  }

  void appendToOutput(int index, String value) {
    for (int i = 0; i < listOfMaps.length; i++) {
      if (listOfMaps[i]['id'] == index) {
        // Xử lý trường hợp đặc biệt với số 0
        if (value == '0' &&
            (listOfMaps[i]['point'] == '' || listOfMaps[i]['point'] == '0')) {
          // Không thêm 0 nếu point rỗng hoặc đang là '0'
          return;
        }
        // Add additional data for 'name' == 1
        listOfMaps[i]['point'] = listOfMaps[i]['point'] +=
            value; // Adjust this line with your additional data
        notifyListeners();
      }
      // print(listOfMaps[i]['point']);
    }
    print(listOfMaps[index]['point']);
  }

  void appendDel(int index) {
    for (int i = 0; i < listOfMaps.length; i++) {
      if (listOfMaps[i]['id'] == index) {
        // Add additional data for 'name' == 1
        listOfMaps[i]['point'] = listOfMaps[i]['point'].substring(
            0,
            listOfMaps[i]['point'].length -
                1); // Adjust this line with your additional data
        notifyListeners();
      }
      // print(listOfMaps[i]['point']);
    }
    print(listOfMaps);
  }

  void toggleSign(int index) {
    if (index >= 0 && index < listOfMaps.length) {
      String currentPoint = listOfMaps[index]['point'] ?? '';
      if (currentPoint.isNotEmpty && currentPoint != '0') {
        if (currentPoint.startsWith('-')) {
          // Xóa dấu trừ
          listOfMaps[index]['point'] = currentPoint.substring(1);
        } else {
          // Thêm dấu trừ
          listOfMaps[index]['point'] = '-' + currentPoint;
        }
        notifyListeners();
      }
    }
  }

  // Các hàm quản lý setMoneyPoints (điểm Cài điểm)
  String getSetMoneyPoint(int index) {
    return setMoneyPoints[index] ?? '';
  }

  void updateSetMoneyPoint(int index, String value) {
    setMoneyPoints[index] = value;
    notifyListeners();
  }

  void appendToSetMoney(int index, String value) {
    String current = setMoneyPoints[index] ?? '';
    setMoneyPoints[index] = current + value;
    notifyListeners();
  }

  void deleteLastSetMoney(int index) {
    String current = setMoneyPoints[index] ?? '';
    if (current.isNotEmpty) {
      setMoneyPoints[index] = current.substring(0, current.length - 1);
      notifyListeners();
    }
  }

  void toggleSetMoneySign(int index) {
    String current = setMoneyPoints[index] ?? '';
    if (current.isNotEmpty && current != '0') {
      if (current.startsWith('-')) {
        setMoneyPoints[index] = current.substring(1);
      } else {
        setMoneyPoints[index] = '-' + current;
      }
      notifyListeners();
    }
  }

  void clearSetMoneyPoints() {
    setMoneyPoints.clear();
    notifyListeners();
  }

  setCheckBox(int index, String printValue, bool value) {
    calPoint[index - 1][printValue] = value;

    notifyListeners();
  }

  setCheckAll(bool caiAn, int index, bool value) {
    calPoint = calPoint.map((map) {
      return updateFieldsToFalseExceptId(map);
    }).toList();
    if (caiAn) {
      for (int i = 0; i < index; i++) {
        if (listOfMaps[i]['cai'] == false) {
          calPoint[i]["def"] = value;
        }
      }
    } else {
      for (int i = 0; i < index; i++) {
        if (listOfMaps[i]['cai'] == false) {
          calPoint[i]["win"] = value;
        }
      }
    }

    notifyListeners();
  }

  setCheckAllCaiX2(int index, bool value) {
    calPoint = calPoint.map((map) {
      return updateFieldsToFalseExceptId(map);
    }).toList();
    for (int i = 0; i < index; i++) {
      if (listOfMaps[i]['cai'] == false) {
        calPoint[i]["all"] = value; // "Đền" checkbox - trừ gấp đôi điểm
      }
    }
    notifyListeners();
  }

  // Hàm riêng cho "Cái x2 toàn sàn" - Tất cả Dân bị trừ x2 điểm, Cái ăn tất
  void calculateCaiX2ToanSan() {
    print('🎯 calculateCaiX2ToanSan - START');

    List<int> roundPoints = [];
    int caiIndex = -1;
    int totalDanLoss = 0; // Tổng điểm Dân bị trừ (x2)

    // Tìm Cái và tính điểm cho từng người
    for (int i = 0; i < listOfMaps.length; i++) {
      Map<String, dynamic> currentMap = listOfMaps[i];
      int pointValue = int.tryParse(setMoneyPoints[i] ?? '0') ?? 0;

      if (currentMap['cai'] == true) {
        // Cái - tạm thời set = 0, sẽ tính sau
        caiIndex = i;
        roundPoints.add(0);
        currentMap['nowPoint'].add(0);
      } else {
        // Dân - bị trừ x2 điểm
        int loss = pointValue * 2;
        roundPoints.add(-loss);
        currentMap['nowPoint'].add(-loss);
        totalDanLoss += loss;
      }
    }

    // Cái ăn toàn bộ số điểm Dân bị trừ
    if (caiIndex != -1) {
      roundPoints[caiIndex] = totalDanLoss;
      listOfMaps[caiIndex]['nowPoint']
          [listOfMaps[caiIndex]['nowPoint'].length - 1] = totalDanLoss;
    }

    // Lưu vào point[][]
    point.add(List.from(roundPoints));

    // Reset checkbox về trạng thái ban đầu
    calPoint = calPoint.map((map) {
      return updateFieldsToFalseExceptId(map);
    }).toList();

    print('📊 Kết quả Cái x2 toàn sàn: $roundPoints');
    print('   Cái ăn: +$totalDanLoss');

    // Lưu session
    saveCurrentSession();

    // Kiểm tra điều kiện kết thúc
    checkGameEndCondition();

    notifyListeners();
  }

  Map<String, dynamic> updateFieldsToFalseExceptId(Map<String, dynamic> map) {
    return map.map((key, value) => MapEntry(key, key == 'id' ? value : false));
  }

  checlNewRound() {
    calPoint = calPoint.map((map) {
      return updateFieldsToFalseExceptId(map);
    }).toList();
    print(listOfMaps);
    notifyListeners();
  }

  void updateEnd() {
    // Find the index in the listCharNew based on id
    int index = listCharNew.length;

    if (index >= 0 && index < calPoint.length && index < listOfMaps.length) {
      // Update 'end' based on conditions
      if (listOfMaps[index]['win']) {
        listOfMaps[index]['end'] += calPoint[index]['point'];
      } else if (listOfMaps[index]['def']) {
        listOfMaps[index]['end'] -= calPoint[index]['point'];
      } else if (listOfMaps[index]['x2']) {
        listOfMaps[index]['end'] += calPoint[index]['point'] * 2;
      }

      // Notify listeners about the change
      notifyListeners();
    }
  }

  chooseCon(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void calculateEndForMaps() {
    print('🎯 calculateEndForMaps - START');
    print('   listOfMaps.length: ${listOfMaps.length}');
    print('   calPoint.length: ${calPoint.length}');
    print('   point.length: ${point.length}');
    print('   point[0].length: ${point.isNotEmpty ? point[0].length : 0}');

    List<int> nowPoints = [];
    List<int> y = [];
    int z = -1;
    int cai = -1;
    int pointden = -1;

    for (int i = 0; i < listOfMaps.length; i++) {
      Map<String, dynamic> currentMap = listOfMaps[i];
      Map<String, dynamic> currentMapPoint = calPoint[i];

      if (currentMap['id'] == currentMapPoint['id']) {
        // Sử dụng setMoneyPoints thay vì listOfMaps[i]['point']
        int pointValue = int.tryParse(setMoneyPoints[i] ?? '0') ?? 0;

        if (currentMapPoint['win']) {
          currentMap['nowPoint'].add(pointValue);
        } else if (currentMapPoint['def']) {
          currentMap['nowPoint'].add(-pointValue);
        } else if (currentMapPoint['x2']) {
          currentMap['nowPoint'].add(pointValue * 2);
        } else if (currentMapPoint['all']) {
          // "Đền" checkbox - bị trừ tiền cược + đền thêm cho người ăn (tính sau)
          z = i;
          pointden = pointValue; // Lưu số tiền cược
          currentMap['nowPoint'].add(-pointValue); // Trừ 1 lần tiền cược
        } else if (currentMapPoint['hue']) {
          currentMap['nowPoint'].add(0); // Huề = không ăn không thua
        }
        if (currentMap['cai'] == true) {
          currentMap['nowPoint'].add(0);
          cai = i;
        }
        if (currentMap['nowPoint'] != null &&
            currentMap['nowPoint'].isNotEmpty) {
          nowPoints.add(currentMap['nowPoint'].last);
          print(nowPoints);
        } else {
          print("The 'nowPoint' list is either null or empty.");
        }

        // if(currentMap['cái'] == true){
        //   for (int i = 0; i < listOfMaps.length; i++) {
        //     Map<String, dynamic> currentMapPoint = calPoint[i];
        //     if(calPoint > 0);
        //   }
        //
        // }
      }
    }
    List<List<int>> x = [];
    x.add(List.from(nowPoints));
    // if (z !=-1){
    //   if (x.isNotEmpty && x.last.isNotEmpty) {
    //     print(x);
    print(z);
    //     List<int> lastList = x.last;
    //     int sumOfPos = lastList.where((number) => number > 0).fold(0, (a, b) => a + b);
    //     listOfMaps[z]['nowPoint'].add(sumOfPos);
    //     print("neg $sumOfPos");
    //   } else {
    //     print("The list of lists is either empty or the last list is empty.");
    //   }
    // }
    int sum = 0;
    int den = 0;
    int tienden = 0;

    for (int i = 0; i < listOfMaps.length; i++) {
      Map<String, dynamic> currentMap = listOfMaps[i];
      if (currentMap['cai'] == true) {
        print(x);
        if (x.isNotEmpty && x.last.isNotEmpty) {
          sum = x.last.reduce((value, element) => value + element);
          if (z != -1) {
            den = x.last.where((number) => number < 0).fold(0, (a, b) => a + b);
            tienden =
                x.last.where((number) => number > 0).fold(0, (a, b) => a + b);
          }
          print("The sum of the last list is: $sum");
        } else {
          print("The list of lists is either empty or the last list is empty.");
        }
      }

      if (currentMap['nowPoint'] != null && currentMap['nowPoint'].isNotEmpty) {
        y.add(currentMap['nowPoint'].last);
      } else {
        print("The 'nowPoint' list is either null or empty.");
      }
    }
    if (den == 0) {
      setElementAtPosition(y, cai, -sum);
      print("object");
      print(listOfMaps[cai]['nowPoint']);
      setElementAtPosition(listOfMaps[cai]['nowPoint'],
          listOfMaps[cai]['nowPoint'].length - 1, -sum);
      print(listOfMaps[cai]['nowPoint']);
      print(x.last);
    } else {
      setElementAtPosition(y, cai, -den);
      setElementAtPosition(y, z, (-pointden - tienden));
      setElementAtPosition(listOfMaps[cai]['nowPoint'],
          listOfMaps[cai]['nowPoint'].length - 1, -den);
      setElementAtPosition(listOfMaps[z]['nowPoint'],
          listOfMaps[z]['nowPoint'].length - 1, (-pointden - tienden));
    }

    point.add(List.from(y));
    print(point);

    // Reset lại điểm Tính tay (listOfMaps['point']) sau khi tính toán xong
    // KHÔNG reset setMoneyPoints để giữ điểm Cài điểm cho các ván tiếp theo
    for (int i = 0; i < listOfMaps.length; i++) {
      listOfMaps[i]['point'] = '';
    }

    calPoint = calPoint.map((map) {
      return updateFieldsToFalseExceptId(map);
    }).toList();

    // Lưu session sau mỗi ván
    saveCurrentSession();

    // Kiểm tra điều kiện kết thúc game
    checkGameEndCondition();

    notifyListeners();
  }

  void calculateDirectPoints() {
    List<int> roundPoints = [];

    // Duyệt qua tất cả người chơi và lấy điểm đã nhập
    for (int i = 0; i < listOfMaps.length; i++) {
      Map<String, dynamic> currentMap = listOfMaps[i];
      int pointValue = int.tryParse(currentMap['point'] ?? '0') ?? 0;

      // Thêm điểm vào nowPoint của người chơi
      currentMap['nowPoint'].add(pointValue);
      roundPoints.add(pointValue);
    }

    // Thêm ván này vào danh sách point
    point.add(List.from(roundPoints));

    // Reset lại điểm đã nhập
    for (int i = 0; i < listOfMaps.length; i++) {
      listOfMaps[i]['point'] = '';
    }

    print("Direct points added: $roundPoints");
    print("All points: $point");

    // Lưu session sau mỗi ván
    saveCurrentSession();

    // Kiểm tra điều kiện kết thúc game
    checkGameEndCondition();

    notifyListeners();
  }

  /// Kiểm tra điều kiện kết thúc game và trả về true nếu đạt điều kiện
  bool checkGameEndCondition() {
    // Nếu chế độ Tự do -> không tự động kết thúc
    if (fOrc == 0) {
      return false;
    }

    // Chế độ Giới hạn
    if (fOrc == 1 && limitValue > 0) {
      // Giới hạn theo Điểm
      if (dOrv == 0) {
        // Tính tổng điểm cho từng người chơi
        List<int> totalScores = List.filled(listOfMaps.length, 0);
        for (var round in point) {
          for (int i = 0; i < round.length && i < totalScores.length; i++) {
            totalScores[i] += round[i];
          }
        }

        // Kiểm tra xem có ai đạt điểm giới hạn không
        int maxScore = totalScores.reduce((a, b) => a > b ? a : b);
        if (maxScore >= limitValue) {
          print(
              '🏆 Game kết thúc: Người cao nhất đạt $maxScore điểm (giới hạn: $limitValue)');
          return true;
        }
      }
      // Giới hạn theo Ván
      else if (dOrv == 1) {
        int currentRoundCount = point.length;
        if (currentRoundCount >= limitValue) {
          print(
              '🏆 Game kết thúc: Đã chơi $currentRoundCount ván (giới hạn: $limitValue)');
          return true;
        }
      }
    }

    return false;
  }

  // === QR CODE SHARE GAME METHODS ===

  /// Export game hiện tại thành JSON string để tạo QR code
  String exportGameToQR() {
    if (point.isEmpty) {
      throw Exception('Không có ván nào để chia sẻ!');
    }

    Map<String, dynamic> gameData = {
      'version': '1.0', // Version để tương thích sau này
      'listCharNew': listCharNew,
      'listOfMaps': listOfMaps.map((map) {
        // 🎯 Chỉ export thông tin cần thiết
        return {
          'id': map['id'],
          'name': map['name'],
          'cai': map['cai'],
          'isOut': map['isOut'] ?? false, // 🚪 Export trạng thái out
          // Bỏ 'point' và 'end' vì có thể tính lại từ 'nowPoint'
          'nowPoint': List<int>.from(map['nowPoint'] ?? []),
        };
      }).toList(),
      'point': point,
      'fOrc': fOrc,
      'dOrv': dOrv,
      'limitValue': limitValue,
      // Bỏ các field không cần thiết để giảm size
      // 'showTotalScore': showTotalScore,
      // 'inputMode': inputMode,
      // 'setMoneyPoints': setMoneyPoints,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    String jsonString = jsonEncode(gameData);
    print('📤 Export game to QR:');
    print('   Original JSON: ${jsonString.length} bytes');
    
    // 🗜️ LUÔN NÉN dữ liệu bằng gzip để giảm tối đa size
    try {
      // Nén bằng GZip từ package:archive (work trên web + mobile)
      List<int> jsonBytes = utf8.encode(jsonString);
      List<int> compressed = GZipEncoder().encode(jsonBytes)!;
      String base64Compressed = base64Encode(compressed);
      
      // Thêm prefix để biết là data đã nén
      String compressedData = 'GZIP:$base64Compressed';
      
      print('   Compressed: ${compressedData.length} bytes');
      print('   Compression ratio: ${(compressedData.length / jsonString.length * 100).toStringAsFixed(1)}%');
      
      // Kiểm tra xem sau khi nén còn quá lớn không
      if (compressedData.length > 10000) {
        print('⚠️ QR code vẫn quá lớn sau khi nén (${compressedData.length} bytes)');
        print('   → Khuyến nghị dùng "Copy Link" thay vì scan QR');
      }
      
      return compressedData;
    } catch (e) {
      print('❌ Không thể nén dữ liệu: $e');
      print('   → Sử dụng JSON gốc (có thể quá lớn cho QR)');
      return jsonString;
    }
  }  /// Import game từ QR code JSON string
  Future<bool> importGameFromQR(String qrData) async {
    try {
      print('📥 importGameFromQR - START');
      print('   Data length: ${qrData.length} characters');

      String jsonString;
      
      // 🗜️ Kiểm tra xem data có được nén không
      if (qrData.startsWith('GZIP:')) {
        print('🔓 Detected compressed data, decompressing...');
        try {
          // Loại bỏ prefix "GZIP:"
          String base64Data = qrData.substring(5);
          
          // Decode base64
          List<int> compressed = base64Decode(base64Data);
          
          // Giải nén gzip bằng package:archive
          List<int> decompressed = GZipDecoder().decodeBytes(compressed);
          
          // Convert bytes về string
          jsonString = utf8.decode(decompressed);
          
          print('✅ Decompressed: ${jsonString.length} bytes');
        } catch (e) {
          print('❌ Failed to decompress: $e');
          return false;
        }
      } else {
        // Không nén, dùng trực tiếp
        jsonString = qrData;
      }

      Map<String, dynamic> gameData = jsonDecode(jsonString);
      print('✅ JSON decode successful');

      // Validate version
      if (gameData['version'] != '1.0') {
        print('⚠️ QR code version không tương thích: ${gameData['version']}');
        return false;
      }
      print('✅ Version OK: ${gameData['version']}');

      // Validate data - chỉ cần listCharNew và listOfMaps
      if (gameData['listCharNew'] == null || gameData['listOfMaps'] == null) {
        print('⚠️ Dữ liệu QR không hợp lệ');
        print('   listCharNew: ${gameData['listCharNew']}');
        print('   listOfMaps: ${gameData['listOfMaps']}');
        return false;
      }
      print('✅ Data validation passed');

      // Clear current game
      point.clear();
      listOfMaps.clear();
      calPoint.clear();
      listCharNew.clear();
      setMoneyPoints.clear();
      print('✅ Cleared current game data');

      // Import data
      listCharNew = List<String>.from(gameData['listCharNew']);
      print('✅ Imported ${listCharNew.length} players');

      // Rebuild listOfMaps
      List<dynamic> importedMaps = gameData['listOfMaps'];
      for (var mapData in importedMaps) {
        listOfMaps.add({
          'id': mapData['id'],
          'name': mapData['name'] ?? '',
          'cai': mapData['cai'],
          'isOut': mapData['isOut'] ?? false, // 🚪 Import trạng thái out
          'point': '', // ♻️ Khôi phục field đã xóa
          'nowPoint': List<int>.from(mapData['nowPoint'] ?? []),
          'end': 0, // ♻️ Khôi phục field đã xóa
        });
      }
      print('✅ Imported ${listOfMaps.length} player maps');

      // Import points - xây lại từ nowPoint
      point.clear();
      if (importedMaps.isNotEmpty) {
        int maxRounds = importedMaps.map((m) => (m['nowPoint'] as List).length).reduce((a, b) => a > b ? a : b);
        for (int round = 0; round < maxRounds; round++) {
          point.add(List<int>.filled(importedMaps.length, 0));
          for (int player = 0; player < importedMaps.length; player++) {
            List<int> nowPoint = List<int>.from(importedMaps[player]['nowPoint'] ?? []);
            if (round < nowPoint.length) {
              point[round][player] = nowPoint[round];
            }
          }
        }
      }
      print('✅ Reconstructed ${point.length} rounds from nowPoint');

      // Import settings (khôi phục từ dữ liệu hiện tại nếu không có trong QR)
      fOrc = gameData['fOrc'] ?? 0;
      dOrv = gameData['dOrv'] ?? 0;
      limitValue = gameData['limitValue'] ?? 0;
      showTotalScore = false; // ♻️ Reset về mặc định
      inputMode = 1; // ♻️ Reset về mặc định
      setMoneyPoints.clear(); // ♻️ Reset về rỗng
      print('✅ Imported settings (restored defaults for removed fields)');

      // Rebuild calPoint
      for (int i = 0; i < listOfMaps.length; i++) {
        calPoint.add({
          'id': listOfMaps[i]['id'],
          'win': false,
          'def': false,
          'x2': false,
          'all': false,
          'hue': false,
        });
      }
      print('✅ Rebuilt calPoint');

      print('📥 Import game từ QR thành công!');
      print('   Người chơi: ${listCharNew.length}');
      print('   Số ván đã chơi: ${point.length}');

      // Tạo session mới
      print('🔄 Creating new game session...');
      await createNewGameSession();

      // LƯU session vào game history
      print('💾 Saving current session...');
      await saveCurrentSession();

      // Refresh game history để hiển thị trong UI
      print('🔄 Refreshing game history...');
      await refreshGameHistory();

      notifyListeners();
      print('✅ importGameFromQR - COMPLETE');
      return true;
    } catch (e, stackTrace) {
      print('❌ Lỗi khi import game từ QR: $e');
      print('📍 Stack trace: $stackTrace');
      return false;
    }
  }

  void saveListCharNew() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('listCharNew', listCharNew);
  }

  // === GAME SESSION METHODS ===

  /// Tạo session game mới
  Future<void> createNewGameSession() async {
    String sessionId = DateTime.now().millisecondsSinceEpoch.toString();

    List<Player> players = [];
    for (int i = 0; i < listCharNew.length; i++) {
      players.add(Player(
        id: i,
        name: listCharNew[i],
        isCai: (i == 0), // 🎯 Người chơi đầu tiên là "cái" mặc định
        isOut: false, // 🚪 Mới bắt đầu game, chưa ai out
      ));
    }

    currentSession = GameSession(
      id: sessionId,
      startTime: DateTime.now(),
      players: players,
    );

    await loadGameHistory();
    notifyListeners();
  }

  /// Lưu game session hiện tại
  Future<void> saveCurrentSession() async {
    print('🟢 saveCurrentSession STARTED');

    if (currentSession == null) {
      print('⚠️ currentSession is NULL in saveCurrentSession!');
      return;
    }

    print('📝 Updating session data...');
    // Cập nhật dữ liệu vào session
    currentSession!.allRounds = List.from(point);
    currentSession!.currentRound = point.length;

    print('📝 allRounds: ${currentSession!.allRounds.length}');
    print('📝 currentRound: ${currentSession!.currentRound}');

    // Cập nhật player data
    for (int i = 0; i < listOfMaps.length; i++) {
      if (i < currentSession!.players.length) {
        currentSession!.players[i].isCai = listOfMaps[i]['cai'] ?? false;
        currentSession!.players[i].isOut =
            listOfMaps[i]['isOut'] ?? false; // 🚪 Lưu trạng thái out
        currentSession!.players[i].currentPoint = listOfMaps[i]['point'] ?? '';
        currentSession!.players[i].roundPoints =
            List<int>.from(listOfMaps[i]['nowPoint'] ?? []);
      }
    }

    currentSession!.calculateTotalScores();

    print('📝 Total scores calculated');

    // Lưu vào history
    await loadGameHistory();

    print(
        '📚 Game history loaded. Current sessions: ${gameHistory.sessions.length}');

    // Xóa session cũ nếu đã tồn tại
    gameHistory.sessions.removeWhere((s) => s.id == currentSession!.id);

    // Thêm session hiện tại
    gameHistory.addSession(currentSession!);

    print(
        '📚 Session added. Total sessions now: ${gameHistory.sessions.length}');
    print('📚 Session status: ${currentSession!.status}');

    // Lưu vào SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = gameHistory.toJson();

    print('💾 JSON data length: ${jsonData.length} characters');
    print('💾 Saving to SharedPreferences...');

    await prefs.setString('gameHistory', jsonData);

    print('✅ Saved to SharedPreferences successfully!');

    // Verify save
    String? savedData = prefs.getString('gameHistory');
    print('✅ Verification - Saved data exists: ${savedData != null}');
    if (savedData != null) {
      print(
          '✅ Verification - Saved data length: ${savedData.length} characters');
    }

    print('🟢 saveCurrentSession FINISHED');

    notifyListeners();
  }

  /// Load lịch sử game
  Future<void> loadGameHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? historyJson = prefs.getString('gameHistory');

    if (historyJson != null && historyJson.isNotEmpty) {
      try {
        gameHistory = GameHistory.fromJson(historyJson);
      } catch (e) {
        print('Error loading game history: $e');
        gameHistory = GameHistory();
      }
    } else {
      gameHistory = GameHistory();
    }

    // Load all sessions và reset pagination
    allSessions = gameHistory.sessions;
    currentPage = 1;
    displayedSessions.clear();
    loadMoreItems();

    notifyListeners();
  }

  /// Load more items for pagination
  void loadMoreItems() {
    // Không load nếu đang loading hoặc đã load hết
    if (isLoadingMore || displayedSessions.length >= allSessions.length) {
      print(
          '[LOAD] Stopped - isLoading: $isLoadingMore, displayed: ${displayedSessions.length}, total: ${allSessions.length}');
      return;
    }

    print('[LOAD] Starting to load more items...');
    isLoadingMore = true;
    notifyListeners();

    // Simulate loading delay
    Future.delayed(Duration(milliseconds: 300), () {
      int startIndex = (currentPage - 1) * itemsPerPage;
      int endIndex = startIndex + itemsPerPage;

      if (startIndex < allSessions.length) {
        int itemsToAdd =
            (endIndex > allSessions.length ? allSessions.length : endIndex) -
                startIndex;
        displayedSessions.addAll(
          allSessions.sublist(
            startIndex,
            endIndex > allSessions.length ? allSessions.length : endIndex,
          ),
        );
        currentPage++;
        print(
            '[LOAD] Loaded $itemsToAdd items - Now showing ${displayedSessions.length}/${allSessions.length}');
      }

      isLoadingMore = false;
      notifyListeners();
    });
  }

  /// Refresh game history
  Future<void> refreshGameHistory() async {
    currentPage = 1;
    displayedSessions.clear();
    await loadGameHistory();
  }

  /// Tiếp tục game đang chơi dở
  Future<void> continueInProgressGame() async {
    await loadGameHistory();

    GameSession? inProgressSession = gameHistory.getInProgressSession();

    if (inProgressSession != null) {
      currentSession = inProgressSession;

      print('🔄 Continuing in-progress game:');
      print('   Session ID: ${inProgressSession.id}');
      print('   Players: ${inProgressSession.players.length}');
      print('   Rounds: ${inProgressSession.allRounds.length}');

      // Khôi phục dữ liệu người chơi
      listCharNew = inProgressSession.players.map((p) => p.name).toList();

      // Khôi phục tất cả các ván đã chơi (DEEP COPY để có thể thêm điểm mới)
      point = inProgressSession.allRounds
          .map((round) => List<int>.from(round))
          .toList();

      // TẠO LẠI listOfMaps và calPoint từ session data
      // KHÔNG gọi initSt() vì nó sẽ ghi đè dữ liệu!
      listOfMaps = [];
      calPoint = [];

      for (int i = 0; i < inProgressSession.players.length; i++) {
        Player player = inProgressSession.players[i];

        // Tạo currentMap với dữ liệu từ session
        // QUAN TRỌNG: nowPoint phải khớp với số ván trong point[][] và phải là GROWABLE list
        List<int> nowPointList;
        if (player.roundPoints.length > point.length) {
          // Nếu roundPoints dài hơn, cắt bớt - phải dùng .toList() để tạo growable list
          nowPointList = player.roundPoints.sublist(0, point.length).toList();
        } else if (player.roundPoints.length < point.length) {
          // Nếu roundPoints ngắn hơn, thêm 0 vào
          nowPointList = List<int>.from(player.roundPoints);
          nowPointList
              .addAll(List.filled(point.length - nowPointList.length, 0));
        } else {
          // Độ dài khớp - tạo growable list từ roundPoints
          nowPointList = List<int>.from(player.roundPoints, growable: true);
        }

        Map<String, dynamic> currentMap = {
          'id': i,
          'cai': player.isCai,
          'isOut': player.isOut, // 🚪 Restore trạng thái out
          'name': player.name,
          'point': player.currentPoint,
          'nowPoint': nowPointList,
          'end': player.totalScore,
        };

        // Tạo calPoint với giá trị mặc định (reset checkbox)
        Map<String, dynamic> currentMapPoint = {
          'id': i,
          'win': false,
          'def': false,
          'x2': false,
          'all': false,
          'hue': false,
        };

        listOfMaps.add(currentMap);
        calPoint.add(currentMapPoint);
      }

      // Reset selectedIndex
      selectedIndex = -1;

      print('✅ Game data restored successfully:');
      print('   listCharNew: $listCharNew');
      print('   point (rounds): ${point.length} ván');
      print('   listOfMaps players: ${listOfMaps.length}');
      for (int i = 0; i < listOfMaps.length; i++) {
        print(
            '   Player ${i}: ${listOfMaps[i]['name']} - isCai: ${listOfMaps[i]['cai']} - point: "${listOfMaps[i]['point']}" - end: ${listOfMaps[i]['end']}');
      }

      notifyListeners();
      return;
    }

    print('⚠️ No in-progress game found');
  }

  /// Kiểm tra xem có game đang chơi dở không
  Future<bool> hasInProgressGame() async {
    await loadGameHistory();
    return gameHistory.getInProgressSession() != null;
  }

  /// Hoàn thành game session
  Future<void> completeCurrentSession() async {
    print('🔵 completeCurrentSession STARTED');

    if (currentSession == null) {
      print('⚠️ currentSession is NULL! Cannot complete.');
      return;
    }

    print('✅ currentSession ID: ${currentSession!.id}');
    print('✅ Players: ${currentSession!.players.length}');
    print('✅ Rounds: ${currentSession!.allRounds.length}');

    currentSession!.completeGame();

    print('✅ Status changed to: ${currentSession!.status}');

    await saveCurrentSession();

    print('✅ saveCurrentSession completed');
    print('🔵 completeCurrentSession FINISHED');

    notifyListeners();
  }

  /// Xóa một session từ lịch sử
  Future<void> deleteGameSession(String sessionId) async {
    await loadGameHistory();
    gameHistory.deleteSession(sessionId);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('gameHistory', gameHistory.toJson());

    notifyListeners();
  }

  /// Lấy danh sách lịch sử game đã hoàn thành
  Future<List<GameSession>> getCompletedGames() async {
    await loadGameHistory();

    print('📊 getCompletedGames called:');
    print('   Total sessions: ${gameHistory.sessions.length}');
    print(
        '   Completed sessions: ${gameHistory.getCompletedSessions().length}');

    return gameHistory.getCompletedSessions();
  }

  /// Reset game và bắt đầu mới
  Future<void> resetAndStartNewGame() async {
    // Nếu có session đang chơi, hoàn thành nó trước
    if (currentSession != null &&
        currentSession!.status == GameStatus.inProgress) {
      await completeCurrentSession();
    }

    // Reset dữ liệu
    point.clear();
    listOfMaps.clear();
    calPoint.clear();
    listCharNew.clear();
    setMoneyPoints.clear(); // 🔥 Clear điểm "Cài điểm"
    selectedIndex = -1;
    currentSession = null;

    // Reset các cài đặt chế độ chơi về mặc định
    fOrc = 0; // Tự do
    dOrv = 0; // Điểm
    limitValue = 0; // Không giới hạn
    showTotalScore = false; // Không hiện tổng điểm

    saveListCharNew();
    notifyListeners();
  }

  void setElementAtPosition(List<int> list, int position, int newValue) {
    if (position >= 0 && position < list.length) {
      list[position] = newValue;
    }
    notifyListeners();
  }

  /// Debug: In ra gameHistory để kiểm tra
  Future<void> printGameHistory() async {
    await loadGameHistory();

    print('========== GAME HISTORY ==========');
    print('Tổng số sessions: ${gameHistory.sessions.length}');
    print('');

    if (gameHistory.sessions.isEmpty) {
      print('⚠️ Không có lịch sử game nào!');
      print('==================================');
      return;
    }

    for (int i = 0; i < gameHistory.sessions.length; i++) {
      GameSession session = gameHistory.sessions[i];
      print('--- Session ${i + 1} ---');
      print('ID: ${session.id}');
      print(
          'Trạng thái: ${session.status == GameStatus.completed ? "✅ Đã hoàn thành" : "🎮 Đang chơi"}');
      print('Thời gian bắt đầu: ${session.startTime}');
      print('Thời gian kết thúc: ${session.endTime ?? "Chưa kết thúc"}');
      print('Số ván đã chơi: ${session.currentRound}');
      print('Người chơi (${session.players.length}):');

      for (Player player in session.players) {
        print('  - ${player.name}: ${player.totalScore} điểm');
        print('    Điểm từng ván: ${player.roundPoints}');
      }

      print('Điểm tất cả các ván:');
      for (int j = 0; j < session.allRounds.length; j++) {
        print('  Ván ${j + 1}: ${session.allRounds[j]}');
      }
      print('');
    }

    print('==================================');
  }

  /// Debug: In ra currentSession hiện tại
  void printCurrentSession() {
    print('========== CURRENT SESSION ==========');

    if (currentSession == null) {
      print('⚠️ Không có session nào đang chơi!');
      print('=====================================');
      return;
    }

    print('ID: ${currentSession!.id}');
    print(
        'Trạng thái: ${currentSession!.status == GameStatus.completed ? "✅ Đã hoàn thành" : "🎮 Đang chơi"}');
    print('Thời gian bắt đầu: ${currentSession!.startTime}');
    print('Số ván hiện tại: ${currentSession!.currentRound}');
    print('Người chơi (${currentSession!.players.length}):');

    for (Player player in currentSession!.players) {
      print('  - ${player.name}: ${player.totalScore} điểm');
      print('    Điểm từng ván: ${player.roundPoints}');
      print('    Là cái: ${player.isCai ? "✅" : "❌"}');
    }

    print('Điểm tất cả các ván:');
    for (int j = 0; j < currentSession!.allRounds.length; j++) {
      print('  Ván ${j + 1}: ${currentSession!.allRounds[j]}');
    }

    print('=====================================');
  }

// Method to load listCharNew from shared preferences
}
