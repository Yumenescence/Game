const BALL_SIZE = 40.0;

class Ball {
  double positionY;
  int verticalDirection; // 1 - down, -1 - up
  final int fallSpeed;

  Ball({
    required this.positionY,
    required this.verticalDirection,
    this.fallSpeed = 5,
  });

  void reverseDirection() {
    verticalDirection *= -1;
  }
}
