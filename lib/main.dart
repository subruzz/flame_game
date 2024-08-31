import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_game/game/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  MyGame game = MyGame();
  //only for testing we create instance direclty here so
  //every time it will be create new one and kind of act like reload
  runApp(GameWidget(game: kDebugMode ? MyGame() : game));
}
