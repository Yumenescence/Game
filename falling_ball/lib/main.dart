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
  double ballY = 0;
  double ballSpeed = 5;
  int ballDirection = 1;
  int score = 0;
  bool ballTapped = false;
  bool gameOver = true;
  double height = 0;
  final audio = AudioPlayer();

  @override
  void initState() {
    super.initState();
    audio.setAsset('assets/sound.mp3');
  }

  void startGame() {
    setState(() {
      height = MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom;
      score = 0;
      gameOver = false;
      ballY = 0;
      ballDirection = 1;
    });

    Timer.periodic(const Duration(milliseconds: 16), (timer) {
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

  void changeDirection() async {
    if (gameOver) {
      return;
    }
    audio.seek(Duration.zero);
    audio.play();
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
                stops: const [0.5, 0.5],
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
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                if (gameOver)
                  Center(
                    child: TextButton(
                      onPressed: startGame,
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
