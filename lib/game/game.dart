import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_game/levels/level.dart';

class MyGame extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  final level = Level(levelName: 'Level-01');
  @override
  FutureOr<void> onLoad() async {
    //load images in the cache
    await images.loadAllImages();
    cam = CameraComponent.withFixedResolution(
        width: 640, height: 360, world: level);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([
      cam,
      level,
    ]);
    return super.onLoad();
  }
}
