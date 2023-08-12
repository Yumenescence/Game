import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'ball.dart';
import 'game_manager.dart';

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

class FallingBallGame extends StatelessWidget {
  const FallingBallGame({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => GameManager(), child: const _Screen());
  }
}

class _Screen extends StatelessWidget {
  const _Screen();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final bool isGameOver = context.select<GameManager, bool>(
        (GameManager gameManager) => gameManager.isGameOver);
    final GameManager gameManager = context.read<GameManager>();

    return ChangeNotifierProvider(
      create: (context) => GameManager(),
      child: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () => gameManager.onTap(),
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
                      top: context.select<GameManager, double>(
                          (GameManager gameManager) =>
                              gameManager.ballPositionY),
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
                        onPressed: () {
                          gameManager.startGame(screenHeight);
                        },
                        child: const Text('Start game'),
                      ),
                    ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Text(
                      'Score: ${context.select<GameManager, int>((GameManager gameManager) => gameManager.score)}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
