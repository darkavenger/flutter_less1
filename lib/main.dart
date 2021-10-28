// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String millisecondsText = "";
  GameState gameState = GameState.readyToStart;
  Timer? waitingTimer;
  Timer? stoppableTimer;

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      backgroundColor: Color(0xFF282E3D),
      body: Stack(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Align(
            alignment: Alignment(0, -0.9),
            child: Text(
              "Test your \nreaction speed",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ColoredBox(
              color: Color(0xFF6D6D6D),
              child: SizedBox(
                height: 160,
                width: 300,
                child: Center(
                  child: Text(
                    millisecondsText,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.9),
            child: GestureDetector(
              onTap: () => setState(() {
                switch (gameState) {
                  case GameState.readyToStart:
                    gameState = GameState.waiting;
                    millisecondsText = "...";
                    _startWaitingTimer();
                    break;
                  case GameState.waiting:
                    break;
                  case GameState.canBeStoped:
                    gameState = GameState.readyToStart;
                    stoppableTimer?.cancel();
                    break;
                }
              }),
              child: _getButton(),
            ),
          ),
        ],
      ),
    );
  }

  ColoredBox _getButton() {
    String buttonName;
    Color buttonColor;

    switch (gameState) {
      case GameState.readyToStart:
        buttonName = "START";
        buttonColor = Color(0xFF40CA88);
        break;
      case GameState.waiting:
        buttonName = "WAIT";
        buttonColor = Color(0xFFE0982D);
        break;
      case GameState.canBeStoped:
        buttonName = "STOP";
        buttonColor = Color(0xFFE02D47);
        break;
      default:
        throw Exception("Unnavaible state of GameState: $gameState");
    }

    return ColoredBox(
      color: buttonColor,
      child: SizedBox(
        width: 200,
        height: 200,
        child: Center(
          child: Text(
            buttonName,
            style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _startWaitingTimer() {
    final int rndMls = Random().nextInt(4000) + 1000;
    waitingTimer = Timer(Duration(milliseconds: rndMls), () {
      setState(() {
        gameState = GameState.canBeStoped;
      });
      _startStoppableTimer();
    });
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = "${timer.tick * 16} ms";
      });
    });
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }
}

enum GameState { readyToStart, waiting, canBeStoped }
