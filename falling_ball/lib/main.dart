import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

const BALL_SIZE = 40.0;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Падающий шар',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyGame(),
    );
  }
}

class MyGame extends StatefulWidget {
  @override
  _MyGameState createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> {
  double ballY = 0;
  double ballSpeed = 5;
  int ballDirection = 1;
  int score = 0;
  bool ballTapped = false;
  bool gameOver = true;
  double height = 0;

  void startGame() {
    setState(() {
      height = MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom;
      score = 0;
      gameOver = false;
      ballY = 0;
    });
    Timer.periodic(Duration(milliseconds: 16), (timer) {
      if (gameOver) {
        return;
      }
      setState(() {
        ballY += ballSpeed * ballDirection;

        if (ballY <= 0 || ballY >= (height - BALL_SIZE)) {
          gameOver = true;
          timer.cancel();
        }
      });
    });
  }

  void changeDirection() {
    if (gameOver) {
      return;
    }
    setState(() {
      ballDirection *= -1;
      score++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: changeDirection,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.amber.shade100],
                begin: Alignment.topCenter,
                stops: [0.5, 0.5],
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: [
                if (!gameOver)
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 - 20,
                    top: ballY,
                    child: Container(
                      width: BALL_SIZE,
                      height: BALL_SIZE,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                if (gameOver)
                  Center(
                    child: TextButton(
                      child: Text('Start game'),
                      onPressed: startGame,
                    ),
                  ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Text(
                    'Score: $score',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
