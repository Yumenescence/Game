import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'ball.dart';

class GameManager extends ChangeNotifier {
  late Ball ball;
  bool isGameOver = true;
  int score = 0;
  late AudioPlayer audioPlayer;
  double get ballPositionY => ball.positionY;

  void initAudioplayer() {
    audioPlayer = AudioPlayer();
    audioPlayer.setAsset('assets/sound.mp3');
  }

  void startGame(double screenHeight) {
    initAudioplayer();
    isGameOver = false;
    score = 0;
    ball = Ball(positionY: 0, verticalDirection: 1);

    // Start ball falling
    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (isGameOver) {
        timer.cancel();
        audioPlayer.dispose();
        return;
      } else {
        updateBallPosition(screenHeight);
      }
    });
  }

  void updateBallPosition(double screenHeight) {
    if (!isGameOver) {
      ball.positionY += ball.fallSpeed * ball.verticalDirection;
      notifyListeners();
      // Check if the ball hits the top or bottom boundaries
      if (ballPositionY <= 0 || ballPositionY >= (screenHeight - BALL_SIZE)) {
        ball.positionY = 0;
        isGameOver = true;
        notifyListeners();
      }
    }
  }

  void onTap() {
    if (!isGameOver) {
      ball.reverseDirection();
      playJumpSound();
      score++;
    }
  }

  void playJumpSound() async {
    audioPlayer.seek(Duration.zero);
    await audioPlayer.play();
  }
}
