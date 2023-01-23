import 'package:Xi_Zach/contact.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({Key? key}) : super(key: key);

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  List<Contact> contacts = List.empty(growable: true);

  int selectedIndex = -1;
  bool isChecked = false;
  var temp = 0;
  String tempname ='';

  // void Sapxep(){
  //   for(var i = 0; i < 100 - 1; i++){
  //     for(var j = i + 1; j < 100; j++){
  //       if(contacts[index].contact < a[j]){
  //         // Hoan vi 2 so a[i] va a[j]
  //         tg = a[i];
  //         a[i] = a[j];
  //         a[j] = tg;
  //       }
  //     }
  //   }
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        title:  const Text('Tiến lên'),
      ),
      body: Container(
        color: Colors.black,
        // padding: const EdgeInsets.all(8.0),

        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Xin cái Tên',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1.0
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),

                    )
                ),
              ),
            ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      //
                      String name = nameController.text.trim();
                      String contact = "0";
                      var myInt = int.parse(contact);
                      assert(myInt is int);
                      if (name.isNotEmpty && contact.isNotEmpty) {
                        setState(() {
                          nameController.text = '';
                          contactController.text = '0';
                          contacts.add(Contact(name: name, contact: myInt));
                        });
                      }
                      //
                    },
                    child: const Text('Save')),
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
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1.0
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),

                    )
                ),
              ),

            ),
            const SizedBox(height: 10),

            contacts.isEmpty
                ? const Text(
              'Éo có người chơi..',
              style: TextStyle(fontSize: 22, color: Colors.white),
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
                    height: 400.0, // Change as per your requirement
                    width: 400.0, // Change as per your requirement
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: contacts.length,
                      itemBuilder: (context, index) => getSapXep(index),
                      // itemBuilder: (BuildContext context, int index) {
                      //   return ListTile(
                      //     // title: Text('${contacts[index].name} đã thắng được ${contacts[index].contact}',  textAlign: TextAlign.center,),
                      //   );
                      // },
                    ),
                  ),
                  actions: <Widget>[
                    // TextButton(
                    //   onPressed: () => Navigator.pop(context, 'Cancel')
                    //   ,
                    //   child: const Text('Cancel'),
                    // ),
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

  Widget getSapXep(int index){
    String Conj = "";
    for(var index= 0; index < contacts.length - 1; index++){
      for(var j = index+ 1; j < contacts.length; j++){
        if( contacts[index].contact  <  contacts[j].contact ){
          // Hoan vi 2 so a[i] va a[j]
          temp = contacts[index].contact;
          tempname = contacts[index].name;
          contacts[index].contact = contacts[j].contact;
          contacts[index].name = contacts[j].name;
          contacts[j].contact = temp;
          contacts[j].name = tempname;
        }
      }
    }
    if(index == 0){
      Conj = "Ăn sập bàn";
    }
    if(contacts[index].contact < 0){
      Conj = "Thua lòi le";
    }else if(contacts[index].contact > 0 && index != 0){
      Conj = "Cũng tạm ổn";
    }
    else if(contacts[index].contact == 0){
      Conj = "Chơi như không";
    }
    return Card(

      child: ListTile(
        // minLeadingWidth: 10,
        leading: CircleAvatar(
          // maxRadius: 20,
          backgroundColor:
          index == 0 ? Colors.red : Colors.green,
          // index % 2 == 0 ? Colors.green[900] : Colors.green,
          foregroundColor: Colors.black,

          child: Text(
            "${index+1}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Row(

          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //
            //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            // ),
            Container(
                width: 60,
                // height: 10,
                // alignment: Alignment.center,
                child: Column(
                  children: [ Text("${contacts[index].name} "),
                    Text("${contacts[index].contact}"),],
                )

            ),
            // const SizedBox(width: 10,),

            const SizedBox(width: 10,),
            Container(
                width: 90,
                // height: 10,

                child:  Text(
                  "${Conj}",
                  style: const TextStyle(fontSize: 13),

                )


              // )
              //
              //    ]
            )
          ],
        ),


      ),
    );

  }

  // Widget buildAnimation(String text) => Marquee(
  //     text: text,
  //     style: const TextStyle(fontSize: 3),
  //     blankSpace: 30,
  // );

  Widget getRow(int index) {

    return Card(
      child: ListTile(
        leading: CircleAvatar(

          backgroundColor:
          // index == 0 ? Colors.red : Colors.green,
          index % 2 == 0 ? Colors.green[900] : Colors.green,
          foregroundColor: Colors.black,

          child: Text(
              contacts[index].name[0],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contacts[index].name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text("${contacts[index].contact}"),
          ],
        ),

        trailing: SizedBox(
          width: 235,
          child: Row(
            children: [
              // const TextField(
              //   obscureText: true,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: 'Password',
              //   ),
              // ),
              InkWell(
                  onTap: () {
                    //
                    nameController.text = contacts[index].name;
                    contactController.text = "${contacts[index].contact}";
                    String name = nameController.text.trim();
                    String contact = contactController.text.trim();
                    var myInt = int.parse(contact);
                    // assert(myInt is int);
                    if (name.isNotEmpty && contact.isNotEmpty) {
                      setState(() {
                        // myInt++;
                        selectedIndex = index;
                        nameController.text = '';
                        contactController.text = '';
                        contacts[selectedIndex].name = name;
                        contacts[selectedIndex].contact -= 2;

                        selectedIndex = -1;
                      });
                    }
                    //
                  },
                  child: const Icon(Icons.exposure_minus_2, size: 28.0,)),
              InkWell(
                  onTap: () {
                    //
                    nameController.text = contacts[index].name;
                    contactController.text = "${contacts[index].contact}";
                    String name = nameController.text.trim();
                    String contact = contactController.text.trim();
                    var myInt = int.parse(contact);
                    // assert(myInt is int);
                    if (name.isNotEmpty && contact.isNotEmpty) {
                      setState(() {
                        // myInt++;
                        selectedIndex = index;
                        nameController.text = '';
                        contactController.text = '';
                        contacts[selectedIndex].name = name;
                        contacts[selectedIndex].contact -= 1;

                        selectedIndex = -1;
                      });
                    }
                  },
                  child: const Icon(Icons.exposure_minus_1, size: 28.0,)),

              InkWell(
                  onTap: () {
                    //
                    nameController.text = contacts[index].name;
                    contactController.text = "${contacts[index].contact}";
                    String name = nameController.text.trim();
                    String contact = contactController.text.trim();
                    String money = moneyController.text.trim();
                    var myInt = int.parse(money);
                    // assert(myInt is int);
                    if (name.isNotEmpty && contact.isNotEmpty) {
                      setState(() {
                        // myInt++;
                        selectedIndex = index;
                        nameController.text = '';
                        contactController.text = '';
                        contacts[selectedIndex].name = name;
                        contacts[selectedIndex].contact -= myInt;

                        selectedIndex = -1;
                      });
                    }
                    //
                  },
                  child: const Icon(Icons.remove_circle_outline, size: 28.0,)),
              InkWell(
                  onTap: () {
                    //
                    nameController.text = contacts[index].name;
                    contactController.text = "${contacts[index].contact}";
                    String name = nameController.text.trim();
                    String contact = contactController.text.trim();
                    String money = moneyController.text.trim();
                    var myInt = int.parse(money);
                    // assert(myInt is int);
                    if (name.isNotEmpty && contact.isNotEmpty) {
                      setState(() {
                        // myInt++;
                        selectedIndex = index;
                        nameController.text = '';
                        contactController.text = '';
                        contacts[selectedIndex].name = name;
                        contacts[selectedIndex].contact += myInt;

                        selectedIndex = -1;
                      });
                    }
                    //
                  },
                  child: const Icon(Icons.add_circle_outline, size: 28.0,)),

              InkWell(

                  onTap: () {
                    //
                    nameController.text = contacts[index].name;
                    contactController.text = "${contacts[index].contact}";
                    String name = nameController.text.trim();
                    String contact = contactController.text.trim();
                    String money = moneyController.text.trim();
                    var myInt = int.parse(contact);
                    // assert(myInt is int);
                    if (name.isNotEmpty && contact.isNotEmpty) {
                      setState(() {
                        // myInt++;
                        selectedIndex = index;
                        nameController.text = '';
                        contactController.text = '';
                        contacts[selectedIndex].name = name;
                        contacts[selectedIndex].contact += 1;

                        selectedIndex = -1;
                      });
                    }
                    //
                  },
                  child: const Icon(Icons.plus_one, size: 28.0,)),
              InkWell(
                  onTap: () {
                    //
                    nameController.text = contacts[index].name;
                    contactController.text = "${contacts[index].contact}";
                    String name = nameController.text.trim();
                    String contact = contactController.text.trim();
                    var myInt = int.parse(contact);
                    // assert(myInt is int);
                    if (name.isNotEmpty && contact.isNotEmpty) {
                      setState(() {
                        // myInt++;
                        selectedIndex = index;
                        nameController.text = '';
                        contactController.text = '';
                        contacts[selectedIndex].name = name;
                        contacts[selectedIndex].contact += 2;

                        selectedIndex = -1;
                      });
                    }
                    //
                  },
                  child: const Icon(Icons.exposure_plus_2, size: 28.0,)),
              const SizedBox(width: 10),
              InkWell(
                  onTap: (() {
                    //
                    setState(() {
                      contacts.removeAt(index);
                    });
                    //
                  }),
                  child: const Icon(Icons.delete)),

            ],
          ),
        ),
      ),
    );
  }
}