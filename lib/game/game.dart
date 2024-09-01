import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_game/actors/player.dart';
import 'package:flutter_flame_game/levels/level.dart';

class MyGame extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  final Player player = Player(character: 'Mask Dude');
  late JoystickComponent joystick;
  bool showJoyStick = true;
  @override
  FutureOr<void> onLoad() async {
    final level = Level(levelName: 'Level-02', player: player);
    //load images in the cache
    await images.loadAllImages();
    cam = CameraComponent.withFixedResolution(
        width: 640, height: 360, world: level);
    cam.priority = 1;
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([
      cam,
      level,
    ]);
    if (showJoyStick) {
      addJoyStick();
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoyStick) {
      _updatePlayerPostitionWithJoyStick();
    }
    super.update(dt);
  }

  void addJoyStick() {
    joystick = JoystickComponent(
      priority: 2,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      knobRadius: 39,
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick);
  }

  void _updatePlayerPostitionWithJoyStick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.playerDirection = PlayerDirection.right;
        break;
      default:
        player.playerDirection = PlayerDirection.none;
        break;
    }
  }
}
