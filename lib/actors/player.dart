import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flame_game/game/game.dart';

enum PlayserState { idle, running }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<MyGame>, KeyboardHandler {
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final String character;
  Player({Vector2? postition, this.character = 'Ninja Frog'})
      : super(position: postition);
  final double stepTime = .05;
  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;
  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovements(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    // final isUpKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW) ||
    //     keysPressed.contains(LogicalKeyboardKey.arrowUp);
    // final isDownKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyS) ||
    //     keysPressed.contains(LogicalKeyboardKey.arrowDown);
    if (isLeftKeyPressed && isRightKeyPressed) {
      playerDirection = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      playerDirection = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      playerDirection = PlayerDirection.right;
    } else {
      playerDirection = PlayerDirection.none;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() async {
    idleAnimation = _setAnimation(action: 'Idle', amount: 12);
    runningAnimation = _setAnimation(action: 'Run', amount: 12);
    animations = {
      PlayserState.idle: idleAnimation,
      PlayserState.running: runningAnimation,
    };
    current = PlayserState.running;
  }

  SpriteAnimation _setAnimation({required String action, required int amount}) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$action (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updatePlayerMovements(double dt) {
    //if we go left it will be -ve
    //right +ve
    double dirX = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayserState.running;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayserState.running;
        dirX += moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayserState.idle;
        break;
      default:
    }
    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }
}
