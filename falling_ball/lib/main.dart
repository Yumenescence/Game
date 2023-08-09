import 'package:flutter/material.dart';
import 'dart:async';

import 'package:just_audio/just_audio.dart';

const BALL_SIZE = 40.0;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FallingBallGame',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FallingBallGame(),
    );
  }
}

class FallingBallGame extends StatefulWidget {
  const FallingBallGame({super.key});

  @override
  State<FallingBallGame> createState() => _FallingBallGameState();
}

class _FallingBallGameState extends State<FallingBallGame> {
  double ballPositionY = 0;
  double ballFallSpeed = 5;
  int ballVerticalDirection = 1;
  int score = 0;
  bool isBallTapped = false;
  bool isGameOver = true;
  double screenHeight = 0;
  final audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    audioPlayer.setAsset('assets/sound.mp3');
  }

  void initializeGame() {
    setState(() {
      screenHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom;
      score = 0;
      isGameOver = false;
      ballPositionY = 0;
      ballVerticalDirection = 1;
    });

    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (isGameOver) {
        return;
      }
      setState(() {
        ballPositionY += ballFallSpeed * ballVerticalDirection;

        if (ballPositionY <= 0 || ballPositionY >= (screenHeight - BALL_SIZE)) {
          isGameOver = true;
          timer.cancel();
        }
      });
    });
  }

  void reverseBallDirection() async {
    if (isGameOver) {
      return;
    }
    audioPlayer.seek(Duration.zero);
    audioPlayer.play();
    setState(() {
      ballVerticalDirection *= -1;
      score++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: reverseBallDirection,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.amber.shade100],
                begin: Alignment.topCenter,
                stops: const [0.5, 0.5],
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: [
                if (!isGameOver)
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 - 20,
                    top: ballPositionY,
                    child: Container(
                      width: BALL_SIZE,
                      height: BALL_SIZE,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                if (isGameOver)
                  Center(
                    child: TextButton(
                      onPressed: initializeGame,
                      child: const Text('Start game'),
                    ),
                  ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Text(
                    'Score: $score',
                    style: const TextStyle(fontSize: 20),
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
