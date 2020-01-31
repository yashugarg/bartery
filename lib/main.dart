import 'package:animation_exp/SwipeAnimation/index.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Bartery',
      // showPerformanceOverlay: true,
      theme: ThemeData.dark(),
      home: new CardDemo(),
    );
  }
}
