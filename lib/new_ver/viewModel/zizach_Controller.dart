import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../share/share_widget.dart';

class ZiZackController extends ChangeNotifier {
  static final ZiZackController instance = ZiZackController._internal();

  factory ZiZackController() {
    return instance;
  }

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

  bool showPoint = false;

  int fOrc = 0;
  int dOrv = 0;

  int countEnd = 0;

  int selectedIndex = -1;

  static Future<void> nothing() async {
    print("nothing");
  }

  void addNewChar(String name) {
    listCharNew.add(name);
    saveListCharNew();
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

  List<Map<String, dynamic>> listOfMaps = [];

  List<Map<String, dynamic>> calPoint = [];

  Future<void> initSt() async {
    calPoint = [];
    listOfMaps = [];
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
      bool cai = false;

      Map<String, dynamic> currentMap = {
        'id': i,
        'cai': cai,
        'name': name,
        'point': point,
        'nowPoint': nowPoint,
        'end': end,
      };

      Map<String, dynamic> currentMapPoint = {
        'id': i,
        'win': win,
        'def': def,
        'x2': x2,
        'all': all,
      };
      listOfMaps.add(currentMap);
      // currentMap['nowPoint'] = nowPoint;
      calPoint.add(currentMapPoint);
    }

    print(calPoint);
    print(listOfMaps);
    print(listOfMaps[0]["cai"]);
    notifyListeners();
  }

  setCai(BuildContext context) {
    for (var i = 0; i < listOfMaps.length; i++) {
      listOfMaps[i]["cai"] = false;
    }
    listOfMaps[selectedIndex]["cai"] = true;
    showAlert(context, 'Thông báo',
        'Đã chọn ${listOfMaps[selectedIndex]["name"]} làm cái trận này');
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

  Map<String, dynamic> updateFieldsToFalseExceptId(Map<String, dynamic> map) {
    return map.map((key, value) => MapEntry(key, key == 'id' ? value : false));
  }

  checlNewRound(){
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
  chooseCon(int index){
    selectedIndex = index;
    notifyListeners();
  }

  void calculateEndForMaps() {
    List<int> nowPoints = [];
    List<int> y = [];
    int z = -1;
    int cai = -1;
    int pointden = -1;

    for (int i = 0; i < listOfMaps.length; i++) {
      Map<String, dynamic> currentMap = listOfMaps[i];
      Map<String, dynamic> currentMapPoint = calPoint[i];

      if (currentMap['id'] == currentMapPoint['id']) {
        int pointValue = int.tryParse(currentMap['point'] ?? '0') ?? 0;

        if (currentMapPoint['win']) {
          currentMap['nowPoint'].add(pointValue);
        } else if (currentMapPoint['def']) {
          currentMap['nowPoint'].add(-pointValue);
        } else if (currentMapPoint['x2']) {
          currentMap['nowPoint'].add(pointValue * 2);
        }else if (currentMapPoint['all']) {
          z =i;
          pointden = pointValue;
          currentMap['nowPoint'].add(-pointValue);
        }
        if (currentMap['cai'] == true){
          currentMap['nowPoint'].add(0);
          cai = i;
        }
        if (currentMap['nowPoint'] != null && currentMap['nowPoint'].isNotEmpty) {
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
      if (currentMap['cai'] == true){
        print(x);
        if (x.isNotEmpty && x.last.isNotEmpty) {
          sum = x.last.reduce((value, element) => value + element);
          if(z !=-1) {
            den = x.last.where((number) => number < 0).fold(0, (a, b) => a + b);
            tienden = x.last.where((number) => number > 0).fold(0, (a, b) => a + b);
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
    if(den == 0){
      setElementAtPosition(y, cai, -sum);
      print("object");
      print(listOfMaps[cai]['nowPoint']);
      setElementAtPosition(listOfMaps[cai]['nowPoint'], listOfMaps[cai]['nowPoint'].length-1, -sum);
      print(listOfMaps[cai]['nowPoint']);
      print(x.last);
    }else{
      setElementAtPosition(y, cai, -den);
      setElementAtPosition(y, z, (-pointden - tienden));
      setElementAtPosition(listOfMaps[cai]['nowPoint'], listOfMaps[cai]['nowPoint'].length-1, -den);
      setElementAtPosition(listOfMaps[z]['nowPoint'], listOfMaps[z]['nowPoint'].length-1, (-pointden - tienden));

    }


    point.add(List.from(y));
    print(point);



    calPoint = calPoint.map((map) {
      return updateFieldsToFalseExceptId(map);
    }).toList();
    notifyListeners();
  }

  void saveListCharNew() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('listCharNew', listCharNew);
  }

  void setElementAtPosition(List<int> list, int position, int newValue) {
    if (position >= 0 && position < list.length) {
      list[position] = newValue;
    }
    notifyListeners();
  }
// Method to load listCharNew from shared preferences
// Future<void> loadListCharNew() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   listCharNew = prefs.getStringList('listCharNew') ?? [];
//   notifyListeners();
// }
}
