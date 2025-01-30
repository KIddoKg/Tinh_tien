// import 'package:Xi_Zach/contact.dart';
// import 'package:Xi_Zach/share/share_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:marquee/marquee.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController contactController = TextEditingController();
//   TextEditingController moneyController = TextEditingController();
//   List<Contact> contacts = List.empty(growable: true);
//
//   int selectedIndex = -1;
//   bool isChecked = false;
//   var temp = 0;
//   String tempname ='';
//
//   // void Sapxep(){
//   //   for(var i = 0; i < 100 - 1; i++){
//   //     for(var j = i + 1; j < 100; j++){
//   //       if(contacts[index].contact < a[j]){
//   //         // Hoan vi 2 so a[i] va a[j]
//   //         tg = a[i];
//   //         a[i] = a[j];
//   //         a[j] = tg;
//   //       }
//   //     }
//   //   }
//   //
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//
//         centerTitle: true,
//         title:  const Text('Xì Dách'),
//       ),
//       body: Container(
//         color: Colors.black,
//         // padding: const EdgeInsets.all(8.0),
//
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 56,
//               child: TextField(
//                 controller: nameController,
//                 decoration: const InputDecoration(
//                   hintText: 'Xin cái Tên',
//                   filled: true,
//                   fillColor: Colors.white,
//                   enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.green, width: 1.0),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(10),
//                       )
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.green, width: 1.0
//                       ),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(10),
//
//                       )
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                     onPressed: () {
//                       //
//                       String name = nameController.text.trim();
//                       String contact = "0";
//                       var setInt = int.parse(contact);
//
//                       if (name.isNotEmpty && contact.isNotEmpty) {
//                         setState(() {
//                           nameController.text = '';
//                           contactController.text = '0';
//                           contacts.add(Contact(name: name, contact: setInt));
//                         });
//                       }
//                       //
//                     },
//                     child: const Text('Save')),
//                 // ElevatedButton(
//                 //     onPressed: () {
//                 //       //
//                 //       String name = nameController.text.trim();
//                 //       String contact = contactController.text.trim();
//                 //       var myInt = int.parse(contact);
//                 //       // assert(myInt is int);
//                 //       if (name.isNotEmpty && contact.isNotEmpty) {
//                 //         setState(() {
//                 //           // myInt++;
//                 //           nameController.text = '';
//                 //           contactController.text = '';
//                 //           contacts[selectedIndex].name = name;
//                 //           contacts[selectedIndex].contact = myInt;
//                 //           selectedIndex = -1;
//                 //         });
//                 //       }
//                 //       //
//                 //     },
//                 //     child: const Text('Update')),
//               ],
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: moneyController,
//               keyboardType: TextInputType.number,
//               maxLength: 10,
//               decoration: const InputDecoration(
//                 hintText: "Tiền nè",
//                 filled: true,
//                 fillColor: Colors.white,
//                 enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.green, width: 1.0),
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(10),
//                     )
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.green, width: 1.0
//                     ),
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(10),
//
//                     )
//                 ),
//               ),
//
//             ),
//             const SizedBox(height: 10),
//
//             contacts.isEmpty
//                 ? const Text(
//               'Éo có người chơi..',
//               style: TextStyle(fontSize: 22, color: Colors.white),
//             )
//                 : Expanded(
//               child: ListView.builder(
//                 itemCount: contacts.length,
//                 itemBuilder: (context, index) => getRow(index),
//               ),
//             ),
//
//         TextButton(
//           onPressed: () => showDialog<String>(
//
//             context: context,
//             builder: (BuildContext context) => AlertDialog(
//
//               title: const Text('Tổng kết tiền nè'),
//               content: Container(
//                 height: 400.0, // Change as per your requirement
//                 width: 400.0, // Change as per your requirement
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: contacts.length,
//                   itemBuilder: (context, index) => getSapXep(index),
//                   // itemBuilder: (BuildContext context, int index) {
//                   //   return ListTile(
//                   //     // title: Text('${contacts[index].name} đã thắng được ${contacts[index].contact}',  textAlign: TextAlign.center,),
//                   //   );
//                   // },
//                 ),
//               ),
//               actions: <Widget>[
//                 // TextButton(
//                 //   onPressed: () => Navigator.pop(context, 'Cancel')
//                 //   ,
//                 //   child: const Text('Cancel'),
//                 // ),
//                 TextButton(
//                   onPressed: () => Navigator.pop(context, 'OK'),
//                   child: const Text('OK'),
//                 ),
//               ],
//             ),
//           ),
//           child: const Text('Tổng kết thôi'),
//         ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget getSapXep(int index){
//     String Conj = "";
//
//     for(var index= 0; index < contacts.length - 1; index++){
//       for(var j = index+ 1; j < contacts.length; j++){
//         if( contacts[index].contact  <  contacts[j].contact ){
//           // Hoan vi 2 so a[i] va a[j]
//           temp = contacts[index].contact;
//           tempname = contacts[index].name;
//           contacts[index].contact = contacts[j].contact;
//           contacts[index].name = contacts[j].name;
//           contacts[j].contact = temp;
//           contacts[j].name = tempname;
//         }
//       }
//     }
//     if(index == 0){
//       Conj = "Ăn sập bàn";
//     }
//     if(contacts[index].contact < 0){
//       Conj = "Thua lòi le";
//     }else if(contacts[index].contact > 0 && index != 0){
//       Conj = "Cũng tạm ổn";
//     }
//     else if(contacts[index].contact == 0){
//       Conj = "Chơi như không";
//     }
//     return Card(
//
//
//       child: ListTile(
//         // minLeadingWidth: 10,
//         leading: CircleAvatar(
//           // maxRadius: 20,
//           backgroundColor:
//           index == 0 ? Colors.red : Colors.green,
//           // index % 2 == 0 ? Colors.green[900] : Colors.green,
//           foregroundColor: Colors.black,
//
//           child: Text(
//             "${index+1}",
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         title: Row(
//
//           // crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Text(
//             //
//             //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             // ),
//             Container(
//               width: 60,
//               // height: 10,
//               // alignment: Alignment.center,
//               child: Column(
//                 children: [ Text("${contacts[index].name}"),
//                   Text("${contacts[index].contact}"),],
//               )
//
//             ),
//             // const SizedBox(width: 10,),
//
//             const SizedBox(width: 10,),
//             Container(
//               width: 90,
//               // height: 10,
//
//               child:  Text(
//                       "${Conj}",
//                 style: const TextStyle(fontSize: 13),
//
//             )
//
//
//             // )
//             //
//             //    ]
//             )
//           ],
//         ),
//
//
//       ),
//     );
//
//   }
//
//   // Widget buildAnimation(String text) => Marquee(
//   //     text: text,
//   //     style: const TextStyle(fontSize: 3),
//   //     blankSpace: 30,
//   // );
//
//   Widget getRow(int index) {
//     String NameCai = '';
//     int setso = 0;
//     if (index == 0) {
//       NameCai = "Cái";
//     } else {
//       NameCai = contacts[index].name[0];
//     }
//
//     return Padding(
//       padding: const EdgeInsets.only(top: 8.0),
//       child: Slidable(
//         // Specify a key if the Slidable is dismissible.
//         key: const ValueKey(0),
//
//         // The start action pane is the one at the left or the top side.
//         startActionPane: ActionPane(
//           // A motion is a widget used to control how the pane animates.
//           motion: const ScrollMotion(),
//
//           // A pane can dismiss the Slidable.
//           dismissible: DismissiblePane(onDismissed: () {}),
//
//           // All actions are defined in the children parameter.
//           children:   [
//
//             SlidableAction(
//               onPressed: (context){
//                 setState(() {
//                   String tempName = contacts[index].name;
//                   int tempInt = contacts[index].contact;
//                   String tempName1 = contacts[0].name;
//                   int tempInt1 = contacts[0].contact;
//                   bool fakebool = contacts[index].value;
//                   bool fakebool1 = contacts[0].value;
//                   contacts[0].name = tempName;
//                   contacts[0].contact = tempInt;
//                   contacts[index].name = tempName1;
//                   contacts[index].contact = tempInt1;
//
//                   contacts[index].value =true;
//                   contacts[0].value = fakebool;
//                   contacts[index].value = fakebool1;
//                   selectedIndex = index;
//                 });
//               },
//               backgroundColor: const Color(0xFF7BC043),
//               foregroundColor: Colors.white,
//               icon: Icons.select_all,
//               label: 'Chọn',
//             ),
//
//           ],
//         ),
//
//         // The end action pane is the one at the right or the bottom side.
//         endActionPane: ActionPane(
//           motion: const ScrollMotion(),
//           children: [
//             SlidableAction(
//               onPressed: (context){
//                 showAlertIOS(context, "Thông báo", "Bạn có muốn xoá người này ? ", onTap: () {
//                   setState(() {
//                     contacts.removeAt(index);
//                   });
//                 });
//
//               },
//               backgroundColor: Color(0xFFFE4A49),
//               foregroundColor: Colors.white,
//               icon: Icons.delete,
//               label: 'Xoá',
//             ),
//
//           ],
//         ),
//
//        child:  Container(
//          color: Colors.white,
//          child: Card(
//            elevation: 0,
//            color: Colors.white,
//            shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(0), // Optional rounded corners
//              side: BorderSide.none, // Removes border
//            ),
//             child: ListTile(
//               leading: CircleAvatar(
//
//                 backgroundColor:
//                 index == 0 ? Colors.red : Colors.green,
//                 // index % 2 == 0 ? Colors.green[900] : Colors.green,
//                 foregroundColor: Colors.black,
//
//                 child: Text(
//                   NameCai,
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               title: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AutoSizeText(
//                     maxLines: 1,
//                     minFontSize: 12,
//                     contacts[index].name,
//                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                   ),
//                   Text("${contacts[index].contact}"),
//                 ],
//               ),
//
//               trailing: SizedBox(
//                 width: MediaQuery.sizeOf(context).width *0.5,
//                 child: Row(
//                   children: [
//
//                     Flexible(
//                       child: InkWell(
//                           onTap: () {
//                             //
//                             nameController.text = contacts[index].name;
//                             contactController.text = "${contacts[index].contact}";
//                             String name = nameController.text.trim();
//                             String contact = contactController.text.trim();
//
//                             // assert(myInt is int);
//                             if (name.isNotEmpty && contact.isNotEmpty) {
//                               setState(() {
//                                 // myInt++;
//                                 selectedIndex = index;
//                                 nameController.text = '';
//                                 contactController.text = '';
//                                 contacts[selectedIndex].name = name;
//                                 contacts[selectedIndex].contact -= 2;
//                                 contacts[0].contact += 2;
//                                 selectedIndex = -1;
//                               });
//                             }
//                             //
//                           },
//                           child: const Icon(Icons.exposure_minus_2, size: 28.0,)),
//                     ),
//                     Spacer(),
//                     Flexible(
//                       child: InkWell(
//                           onTap: () {
//                             //
//                             nameController.text = contacts[index].name;
//                             contactController.text = "${contacts[index].contact}";
//                             String name = nameController.text.trim();
//                             String contact = contactController.text.trim();
//                             String money = moneyController.text.trim();
//                             var myInt = int.parse(money);
//                             // assert(myInt is int);
//                             if (name.isNotEmpty && contact.isNotEmpty) {
//                               setState(() {
//                                 // myInt++;
//                                 selectedIndex = index;
//                                 nameController.text = '';
//                                 contactController.text = '';
//                                 contacts[selectedIndex].name = name;
//                                 setso = myInt;
//                                 contacts[selectedIndex].contact -= myInt;
//                                 contacts[0].contact += myInt;
//                                 selectedIndex = -1;
//                               });
//                             }
//                             //
//                           },
//                           child: const Icon(Icons.remove_circle_outline, size: 28.0,)),
//                     ),
//                     Spacer(),
//                     Flexible(
//                       child: InkWell(
//                           onTap: () {
//                             //
//                             nameController.text = contacts[index].name;
//                             contactController.text = "${contacts[index].contact}";
//                             String name = nameController.text.trim();
//                             String contact = contactController.text.trim();
//                             String money = moneyController.text.trim();
//                             var myInt = int.parse(money);
//                             // assert(myInt is int);
//                             if (name.isNotEmpty && contact.isNotEmpty) {
//                               setState(() {
//                                 // myInt++;
//                                 selectedIndex = index;
//                                 nameController.text = '';
//                                 contactController.text = '';
//                                 contacts[selectedIndex].name = name;
//                                 contacts[selectedIndex].contact += myInt;
//                                 contacts[0].contact -= myInt;
//                                 selectedIndex = -1;
//                               });
//                             }
//                             //
//                           },
//                           child: const Icon(Icons.add_circle_outline, size: 28.0,)),
//                     ),
//                     Spacer(),
//                     Flexible(
//                       child: InkWell(
//                           onTap: () {
//                             //
//                             nameController.text = contacts[index].name;
//                             contactController.text = "${contacts[index].contact}";
//                             String name = nameController.text.trim();
//                             String contact = contactController.text.trim();
//
//                             // assert(myInt is int);
//                             if (name.isNotEmpty && contact.isNotEmpty) {
//                               setState(() {
//                                 // myInt++;
//                                 selectedIndex = index;
//                                 nameController.text = '';
//                                 contactController.text = '';
//                                 contacts[selectedIndex].name = name;
//                                 contacts[selectedIndex].contact += 2;
//                                 contacts[0].contact -= 2;
//                                 selectedIndex = -1;
//                               });
//                             }
//                             //
//                           },
//                           child: const Icon(Icons.exposure_plus_2, size: 28.0,)),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           // );
//              ),
//        )),
//     );
//   }
// }

// import 'package:Xi_Zach/contact.dart';
// import 'package:Xi_Zach/share/share_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:marquee/marquee.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController contactController = TextEditingController();
//   TextEditingController moneyController = TextEditingController();
//   List<Contact> contacts = List.empty(growable: true);
//
//   int selectedIndex = -1;
//   bool isChecked = false;
//   var temp = 0;
//   String tempname ='';
//
//   // void Sapxep(){
//   //   for(var i = 0; i < 100 - 1; i++){
//   //     for(var j = i + 1; j < 100; j++){
//   //       if(contacts[index].contact < a[j]){
//   //         // Hoan vi 2 so a[i] va a[j]
//   //         tg = a[i];
//   //         a[i] = a[j];
//   //         a[j] = tg;
//   //       }
//   //     }
//   //   }
//   //
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//
//         centerTitle: true,
//         title:  const Text('Xì Dách'),
//       ),
//       body: Container(
//         color: Colors.black,
//         // padding: const EdgeInsets.all(8.0),
//
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 56,
//               child: TextField(
//                 controller: nameController,
//                 decoration: const InputDecoration(
//                   hintText: 'Xin cái Tên',
//                   filled: true,
//                   fillColor: Colors.white,
//                   enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.green, width: 1.0),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(10),
//                       )
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.green, width: 1.0
//                       ),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(10),
//
//                       )
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                     onPressed: () {
//                       //
//                       String name = nameController.text.trim();
//                       String contact = "0";
//                       var setInt = int.parse(contact);
//
//                       if (name.isNotEmpty && contact.isNotEmpty) {
//                         setState(() {
//                           nameController.text = '';
//                           contactController.text = '0';
//                           contacts.add(Contact(name: name, contact: setInt));
//                         });
//                       }
//                       //
//                     },
//                     child: const Text('Save')),
//                 // ElevatedButton(
//                 //     onPressed: () {
//                 //       //
//                 //       String name = nameController.text.trim();
//                 //       String contact = contactController.text.trim();
//                 //       var myInt = int.parse(contact);
//                 //       // assert(myInt is int);
//                 //       if (name.isNotEmpty && contact.isNotEmpty) {
//                 //         setState(() {
//                 //           // myInt++;
//                 //           nameController.text = '';
//                 //           contactController.text = '';
//                 //           contacts[selectedIndex].name = name;
//                 //           contacts[selectedIndex].contact = myInt;
//                 //           selectedIndex = -1;
//                 //         });
//                 //       }
//                 //       //
//                 //     },
//                 //     child: const Text('Update')),
//               ],
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: moneyController,
//               keyboardType: TextInputType.number,
//               maxLength: 10,
//               decoration: const InputDecoration(
//                 hintText: "Tiền nè",
//                 filled: true,
//                 fillColor: Colors.white,
//                 enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.green, width: 1.0),
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(10),
//                     )
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.green, width: 1.0
//                     ),
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(10),
//
//                     )
//                 ),
//               ),
//
//             ),
//             const SizedBox(height: 10),
//
//             contacts.isEmpty
//                 ? const Text(
//               'Éo có người chơi..',
//               style: TextStyle(fontSize: 22, color: Colors.white),
//             )
//                 : Expanded(
//               child: ListView.builder(
//                 itemCount: contacts.length,
//                 itemBuilder: (context, index) => getRow(index),
//               ),
//             ),
//
//             TextButton(
//               onPressed: () => showDialog<String>(
//
//                 context: context,
//                 builder: (BuildContext context) => AlertDialog(
//
//                   title: const Text('Tổng kết tiền nè'),
//                   content: Container(
//                     height: 400.0, // Change as per your requirement
//                     width: 400.0, // Change as per your requirement
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: contacts.length,
//                       itemBuilder: (context, index) => getSapXep(index),
//                       // itemBuilder: (BuildContext context, int index) {
//                       //   return ListTile(
//                       //     // title: Text('${contacts[index].name} đã thắng được ${contacts[index].contact}',  textAlign: TextAlign.center,),
//                       //   );
//                       // },
//                     ),
//                   ),
//                   actions: <Widget>[
//                     // TextButton(
//                     //   onPressed: () => Navigator.pop(context, 'Cancel')
//                     //   ,
//                     //   child: const Text('Cancel'),
//                     // ),
//                     TextButton(
//                       onPressed: () => Navigator.pop(context, 'OK'),
//                       child: const Text('OK'),
//                     ),
//                   ],
//                 ),
//               ),
//               child: const Text('Tổng kết thôi'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget getSapXep(int index){
//     String Conj = "";
//
//     for(var index= 0; index < contacts.length - 1; index++){
//       for(var j = index+ 1; j < contacts.length; j++){
//         if( contacts[index].contact  <  contacts[j].contact ){
//           // Hoan vi 2 so a[i] va a[j]
//           temp = contacts[index].contact;
//           tempname = contacts[index].name;
//           contacts[index].contact = contacts[j].contact;
//           contacts[index].name = contacts[j].name;
//           contacts[j].contact = temp;
//           contacts[j].name = tempname;
//         }
//       }
//     }
//     if(index == 0){
//       Conj = "Ăn sập bàn";
//     }
//     if(contacts[index].contact < 0){
//       Conj = "Thua lòi le";
//     }else if(contacts[index].contact > 0 && index != 0){
//       Conj = "Cũng tạm ổn";
//     }
//     else if(contacts[index].contact == 0){
//       Conj = "Chơi như không";
//     }
//     return Card(
//
//
//       child: ListTile(
//         // minLeadingWidth: 10,
//         leading: CircleAvatar(
//           // maxRadius: 20,
//           backgroundColor:
//           index == 0 ? Colors.red : Colors.green,
//           // index % 2 == 0 ? Colors.green[900] : Colors.green,
//           foregroundColor: Colors.black,
//
//           child: Text(
//             "${index+1}",
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         title: Row(
//
//           // crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Text(
//             //
//             //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             // ),
//             Container(
//                 width: 60,
//                 // height: 10,
//                 // alignment: Alignment.center,
//                 child: Column(
//                   children: [ Text("${contacts[index].name}"),
//                     Text("${contacts[index].contact}"),],
//                 )
//
//             ),
//             // const SizedBox(width: 10,),
//
//             const SizedBox(width: 10,),
//             Container(
//                 width: 90,
//                 // height: 10,
//
//                 child:  Text(
//                   "${Conj}",
//                   style: const TextStyle(fontSize: 13),
//
//                 )
//
//
//               // )
//               //
//               //    ]
//             )
//           ],
//         ),
//
//
//       ),
//     );
//
//   }
//
//   // Widget buildAnimation(String text) => Marquee(
//   //     text: text,
//   //     style: const TextStyle(fontSize: 3),
//   //     blankSpace: 30,
//   // );
//
//   Widget getRow(int index) {
//     String NameCai = '';
//     int setso = 0;
//     if (index == 0) {
//       NameCai = "Cái";
//     } else {
//       NameCai = contacts[index].name[0];
//     }
//
//     return Padding(
//       padding: const EdgeInsets.only(top: 8.0),
//       child: Slidable(
//         // Specify a key if the Slidable is dismissible.
//           key: const ValueKey(0),
//
//           // The start action pane is the one at the left or the top side.
//           startActionPane: ActionPane(
//             // A motion is a widget used to control how the pane animates.
//             motion: const ScrollMotion(),
//
//             // A pane can dismiss the Slidable.
//             dismissible: DismissiblePane(onDismissed: () {}),
//
//             // All actions are defined in the children parameter.
//             children:   [
//
//               SlidableAction(
//                 onPressed: (context){
//                   setState(() {
//                     String tempName = contacts[index].name;
//                     int tempInt = contacts[index].contact;
//                     String tempName1 = contacts[0].name;
//                     int tempInt1 = contacts[0].contact;
//                     bool fakebool = contacts[index].value;
//                     bool fakebool1 = contacts[0].value;
//                     contacts[0].name = tempName;
//                     contacts[0].contact = tempInt;
//                     contacts[index].name = tempName1;
//                     contacts[index].contact = tempInt1;
//
//                     contacts[index].value =true;
//                     contacts[0].value = fakebool;
//                     contacts[index].value = fakebool1;
//                     selectedIndex = index;
//                   });
//                 },
//                 backgroundColor: const Color(0xFF7BC043),
//                 foregroundColor: Colors.white,
//                 icon: Icons.select_all,
//                 label: 'Chọn',
//               ),
//
//             ],
//           ),
//
//           // The end action pane is the one at the right or the bottom side.
//           endActionPane: ActionPane(
//             motion: const ScrollMotion(),
//             children: [
//               SlidableAction(
//                 onPressed: (context){
//                   showAlertIOS(context, "Thông báo", "Bạn có muốn xoá người này ? ", onTap: () {
//                     setState(() {
//                       contacts.removeAt(index);
//                     });
//                   });
//
//                 },
//                 backgroundColor: Color(0xFFFE4A49),
//                 foregroundColor: Colors.white,
//                 icon: Icons.delete,
//                 label: 'Xoá',
//               ),
//
//             ],
//           ),
//
//           child:  Container(
//             color: Colors.white,
//             child: Card(
//               elevation: 0,
//               color: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(0), // Optional rounded corners
//                 side: BorderSide.none, // Removes border
//               ),
//               child: ListTile(
//                 leading: CircleAvatar(
//
//                   backgroundColor:
//                   index == 0 ? Colors.red : Colors.green,
//                   // index % 2 == 0 ? Colors.green[900] : Colors.green,
//                   foregroundColor: Colors.black,
//
//                   child: Text(
//                     NameCai,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AutoSizeText(
//                       maxLines: 1,
//                       minFontSize: 12,
//                       contacts[index].name,
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                     ),
//                     Text("${contacts[index].contact}"),
//                   ],
//                 ),
//
//                 trailing: SizedBox(
//                   width: MediaQuery.sizeOf(context).width *0.5,
//                   child: Row(
//                     children: [
//
//                       Flexible(
//                         child: InkWell(
//                             onTap: () {
//                               //
//                               nameController.text = contacts[index].name;
//                               contactController.text = "${contacts[index].contact}";
//                               String name = nameController.text.trim();
//                               String contact = contactController.text.trim();
//
//                               // assert(myInt is int);
//                               if (name.isNotEmpty && contact.isNotEmpty) {
//                                 setState(() {
//                                   // myInt++;
//                                   selectedIndex = index;
//                                   nameController.text = '';
//                                   contactController.text = '';
//                                   contacts[selectedIndex].name = name;
//                                   contacts[selectedIndex].contact -= 2;
//                                   contacts[0].contact += 2;
//                                   selectedIndex = -1;
//                                 });
//                               }
//                               //
//                             },
//                             child: const Icon(Icons.exposure_minus_2, size: 28.0,)),
//                       ),
//                       Spacer(),
//                       Flexible(
//                         child: InkWell(
//                             onTap: () {
//                               //
//                               nameController.text = contacts[index].name;
//                               contactController.text = "${contacts[index].contact}";
//                               String name = nameController.text.trim();
//                               String contact = contactController.text.trim();
//                               String money = moneyController.text.trim();
//                               var myInt = int.parse(money);
//                               // assert(myInt is int);
//                               if (name.isNotEmpty && contact.isNotEmpty) {
//                                 setState(() {
//                                   // myInt++;
//                                   selectedIndex = index;
//                                   nameController.text = '';
//                                   contactController.text = '';
//                                   contacts[selectedIndex].name = name;
//                                   setso = myInt;
//                                   contacts[selectedIndex].contact -= myInt;
//                                   contacts[0].contact += myInt;
//                                   selectedIndex = -1;
//                                 });
//                               }
//                               //
//                             },
//                             child: const Icon(Icons.remove_circle_outline, size: 28.0,)),
//                       ),
//                       Spacer(),
//                       Flexible(
//                         child: InkWell(
//                             onTap: () {
//                               //
//                               nameController.text = contacts[index].name;
//                               contactController.text = "${contacts[index].contact}";
//                               String name = nameController.text.trim();
//                               String contact = contactController.text.trim();
//                               String money = moneyController.text.trim();
//                               var myInt = int.parse(money);
//                               // assert(myInt is int);
//                               if (name.isNotEmpty && contact.isNotEmpty) {
//                                 setState(() {
//                                   // myInt++;
//                                   selectedIndex = index;
//                                   nameController.text = '';
//                                   contactController.text = '';
//                                   contacts[selectedIndex].name = name;
//                                   contacts[selectedIndex].contact += myInt;
//                                   contacts[0].contact -= myInt;
//                                   selectedIndex = -1;
//                                 });
//                               }
//                               //
//                             },
//                             child: const Icon(Icons.add_circle_outline, size: 28.0,)),
//                       ),
//                       Spacer(),
//                       Flexible(
//                         child: InkWell(
//                             onTap: () {
//                               //
//                               nameController.text = contacts[index].name;
//                               contactController.text = "${contacts[index].contact}";
//                               String name = nameController.text.trim();
//                               String contact = contactController.text.trim();
//
//                               // assert(myInt is int);
//                               if (name.isNotEmpty && contact.isNotEmpty) {
//                                 setState(() {
//                                   // myInt++;
//                                   selectedIndex = index;
//                                   nameController.text = '';
//                                   contactController.text = '';
//                                   contacts[selectedIndex].name = name;
//                                   contacts[selectedIndex].contact += 2;
//                                   contacts[0].contact -= 2;
//                                   selectedIndex = -1;
//                                 });
//                               }
//                               //
//                             },
//                             child: const Icon(Icons.exposure_plus_2, size: 28.0,)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // );
//             ),
//           )),
//     );
//   }
// }

import 'package:Xi_Zach/share/share_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Contact {
  String name;
  int contact;
  bool value;

  Contact({required this.name, required this.contact, this.value = false});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contact': contact,
      'value': value,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      contact: json['contact'],
      value: json['value'] ?? false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  List<Contact> contacts = [];

  int selectedIndex = -1;
  bool isChecked = false;
  var temp = 0;
  String tempname = '';

  @override
  void initState() {
    super.initState();
    _showStartGameDialog(); // Hiển thị hộp thoại khi trang được load
  }

  // Hiển thị hộp thoại để chọn bắt đầu ván mới hay sử dụng bản ghi cũ
  Future<void> _showStartGameDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasData = prefs.containsKey('contacts'); // Kiểm tra có bản ghi cũ không
if(hasData) {
  showAlertIOS(
      context,
      "Thông báo",
      "Bạn muốn sử dụng bản ghi cũ ?",
      autoPop: false,
      onTapLeft: () {
        _clearContacts();
      },
      onTap: () {
        if (hasData) {
          _loadContacts();
        }
      },
    );
}
    // showDialog<String>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: const Text('Chọn một lựa chọn'),
    //       content: const Text('Bạn muốn bắt đầu ván mới hay sử dụng bản ghi cũ?'),
    //       actions: <Widget>[
    //         TextButton(
    //           onPressed: () {
    //             if (hasData) {
    //               _loadContacts();  // Nếu có bản ghi cũ thì load dữ liệu
    //             }
    //             Navigator.pop(context);  // Đóng hộp thoại
    //           },
    //           child: const Text('Sử dụng bản ghi cũ'),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             _clearContacts();  // Xóa danh sách cũ và bắt đầu ván mới
    //             Navigator.pop(context);  // Đóng hộp thoại
    //           },
    //           child: const Text('Bắt đầu ván mới'),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  // Lưu danh sách contacts vào SharedPreferences
  Future<void> _saveContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> contactList = contacts.map((contact) => jsonEncode(contact.toJson())).toList();
    await prefs.setStringList('contacts', contactList);
  }

  // Đọc danh sách contacts từ SharedPreferences
  Future<void> _loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? contactList = prefs.getStringList('contacts');

    if (contactList != null) {
      setState(() {
        contacts = contactList.map((contactStr) => Contact.fromJson(jsonDecode(contactStr))).toList();
      });
    }
  }

  // Xóa danh sách contacts và bắt đầu ván mới
  Future<void> _clearContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('contacts'); // Xóa dữ liệu cũ khỏi SharedPreferences
    setState(() {
      contacts.clear(); // Xóa danh sách contacts hiện tại
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),  // Biểu tượng nút quay lại
          onPressed: () {
            showAlertIOS(context, "Thông báo", "Dữ liệu sẽ tự động lưu. Bạn có muốn thoát ?", onTap: () {
              Navigator.pop(context);
            });

          },
        ),
        centerTitle: true,
        title: const Text('Xì Dách'),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Xin cái Tên',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), // Điều chỉnh chiều cao
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 1.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )),
                    ),
                  ),
                ),
                SizedBox(width: 8,)
                ,Container(
                  height: 46,

                  decoration: BoxDecoration(
                    color: Colors.white, // Màu nền của container
                    borderRadius: BorderRadius.all(Radius.circular(10.0)), // Bo tròn tất cả các góc
                  ),
                  child: TextButton(
                    onPressed: () {
                      String name = nameController.text.trim();
                      if (name.isNotEmpty) {
                        setState(() {
                          contacts.add(Contact(name: name, contact: 0));
                          nameController.clear();
                          _saveContacts(); // Lưu dữ liệu khi thêm người chơi
                        });
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            TextField(
              controller: moneyController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: const InputDecoration(
                hintText: "Tiền nè",
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    )),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    )),
              ),
            ),
            const SizedBox(height: 10),
            contacts.isEmpty
                ? Expanded(
                  child: Center(
                    child: const Text(
                        'Éo có người chơi..',
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                  ),
                )
                : Expanded(
                    child: ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) => getRow(index),
                    ),
                  ),
            TextButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Tổng kết tiền nè'),
                  content: Container(
                    height: 400.0,
                    width: 400.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: contacts.length,
                      itemBuilder: (context, index) => getSapXep(index),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
              child: const Text('Tổng kết thôi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSapXep(int index) {
    String Conj = "";

    for (var index = 0; index < contacts.length - 1; index++) {
      for (var j = index + 1; j < contacts.length; j++) {
        if (contacts[index].contact < contacts[j].contact) {
          temp = contacts[index].contact;
          tempname = contacts[index].name;
          contacts[index].contact = contacts[j].contact;
          contacts[index].name = contacts[j].name;
          contacts[j].contact = temp;
          contacts[j].name = tempname;
        }
      }
    }
    if (index == 0) {
      Conj = "Ăn sập bàn";
    }
    if (contacts[index].contact < 0) {
      Conj = "Thua lòi le";
    } else if (contacts[index].contact > 0 && index != 0) {
      Conj = "Cũng tạm ổn";
    } else if (contacts[index].contact == 0) {
      Conj = "Chơi như không";
    }
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: index == 0 ? Colors.red : Colors.green,
          foregroundColor: Colors.black,
          child: Text(
            "${index + 1}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 60,
              child: Column(
                children: [
                  Text("${contacts[index].name}"),
                  Text("${contacts[index].contact}"),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 90,
              child: Text(
                "${Conj}",
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRow(int index) {
    String NameCai = '';
    int setso = 0;
    if (index == 0) {
      NameCai = "Cái";
    } else {
      NameCai = contacts[index].name[0];
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Slidable(
        key: ValueKey(index),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                setState(() {
                  String tempName = contacts[index].name;
                  int tempInt = contacts[index].contact;
                  String tempName1 = contacts[0].name;
                  int tempInt1 = contacts[0].contact;
                  contacts[0].name = tempName;
                  contacts[0].contact = tempInt;
                  contacts[index].name = tempName1;
                  contacts[index].contact = tempInt1;
                  _saveContacts(); // Lưu dữ liệu sau khi chọn
                });
              },
              backgroundColor: const Color(0xFF7BC043),
              foregroundColor: Colors.white,
              icon: Icons.select_all,
              label: 'Chọn',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                showAlertIOS(context, "Thông báo", "Bạn có muốn xoá người này ?", onTap: () {
                  setState(() {
                    contacts.removeAt(index);
                    _saveContacts(); // Lưu dữ liệu khi xóa
                  });
                  Navigator.of(context).pop();
                });
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Xoá',
            ),
          ],
        ),
        child: Container(
          color: Colors.white,

          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0), // Optional rounded corners
              side: BorderSide.none, // Removes border
            ),
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: index == 0 ? Colors.red : Colors.green,
                foregroundColor: Colors.black,
                child: Text(
                  NameCai,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    minFontSize: 12,
                    maxLines: 1,
                    contacts[index].name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text("${contacts[index].contact}"),
                ],
              ),
              trailing: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          contacts[index].contact -= 2;
                          contacts[0].contact += 2;
                          _saveContacts(); // Lưu dữ liệu sau khi cập nhật
                        });
                      },
                      icon: const Icon(Icons.exposure_minus_2, size: 28.0),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        int money = int.parse(moneyController.text.trim());
                        setState(() {
                          contacts[index].contact -= money;
                          contacts[0].contact += money;
                          _saveContacts(); // Lưu dữ liệu sau khi cập nhật
                        });
                      },
                      icon: const Icon(Icons.remove_circle_outline, size: 28.0),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        int money = int.parse(moneyController.text.trim());
                        setState(() {
                          contacts[index].contact += money;
                          contacts[0].contact -= money;
                          _saveContacts(); // Lưu dữ liệu sau khi cập nhật
                        });
                      },
                      icon: const Icon(Icons.add_circle_outline, size: 28.0),
                    ),
              Spacer(),
              Flexible(
                          child: InkWell(
                              onTap: () {
                                //
                                nameController.text = contacts[index].name;
                                contactController.text = "${contacts[index].contact}";
                                String name = nameController.text.trim();
                                String contact = contactController.text.trim();

                                // assert(myInt is int);
                                if (name.isNotEmpty && contact.isNotEmpty) {
                                  setState(() {
                                    // myInt++;
                                    selectedIndex = index;
                                    nameController.text = '';
                                    contactController.text = '';
                                    contacts[selectedIndex].name = name;
                                    contacts[selectedIndex].contact += 2;
                                    contacts[0].contact -= 2;
                                    selectedIndex = -1;
                                  });
                                }
                                //
                              },
                              child: const Icon(Icons.exposure_plus_2, size: 28.0,)),
                        ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
