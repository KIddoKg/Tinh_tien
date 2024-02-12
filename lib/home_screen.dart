import 'package:Xi_Zach/contact.dart';
import 'package:Xi_Zach/home_screen_2.dart';
import 'package:Xi_Zach/router.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import 'home_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        title:  const Text('Chọn trò chơi nào !!!'),
      ),
      body: Container(
        color: Colors.black,
        // padding: const EdgeInsets.all(8.0),

        child: Center(
          child:
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
            //
            Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
          //
      },
                    child: const Text('Xi Zach')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeScreen2(),
                      ));
                      //
                    },
                    child: const Text('Tien Len')),
              ],
            ),


        ),
      ),
    );
  }
}