import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_flame_game/game/game.dart';

enum PlayserState { idle, running }

class Player extends SpriteAnimationGroupComponent with HasGameRef<MyGame> {
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final String character;
  Player({Vector2? postition, required this.character})
      : super(position: postition);
  final double stepTime = .05;
  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimations();
    return super.onLoad();
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
}
