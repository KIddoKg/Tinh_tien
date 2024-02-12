import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RandomNumberPage extends StatefulWidget {
  @override
  _RandomNumberPageState createState() => _RandomNumberPageState();
}

class _RandomNumberPageState extends State<RandomNumberPage> {
  Random _random = Random();
  int _randomNumber = 0;
  bool _isSpinning = false;

  void _generateRandomNumber() {
    setState(() {
      _isSpinning = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _randomNumber = _random.nextInt(100);
        _isSpinning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Number Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedDefaultTextStyle(
              style: TextStyle(fontSize: 20, color: Colors.black),
              duration: Duration(milliseconds: 500),
              child: Text('Random Number:'),
            ),
            SizedBox(height: 10),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: _isSpinning
                  ? SpinKitFadingCircle(
                color: Colors.blue,
                size: 40,
              )
                  : Text(
                '$_randomNumber',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                key: ValueKey<int>(_randomNumber),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSpinning ? null : _generateRandomNumber,
              child: Text('Generate Random Number'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RandomNumberPage(),
  ));
}
