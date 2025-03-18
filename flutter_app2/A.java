import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedBoxScreen(),
    );
  }
}

class AnimatedBoxScreen extends StatefulWidget {
  @override
  _AnimatedBoxScreenState createState() => _AnimatedBoxScreenState();
}

class _AnimatedBoxScreenState extends State<AnimatedBoxScreen> {
  double _width = 100;
  double _height = 100;
  Color _color = Colors.blue;

  void _animateBox() {
    final random = Random();
    setState(() {
      _width = random.nextInt(200).toDouble() + 50;
      _height = random.nextInt(200).toDouble() + 50;
      _color = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Box')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(seconds: 1),
              width: _width,
              height: _height,
              color: _color,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _animateBox,
              child: Text('Animate'),
            ),
          ],
        ),
      ),
    );
  }
}