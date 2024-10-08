import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../actors/player.dart';

class Level extends World {
  final String levelName;
  final Player player;
  late TiledComponent level;
  Level({required this.levelName, required this.player});
  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    await addAll([
      level,
    ]);
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    for (final point in spawnPointLayer!.objects) {
      switch (point.class_) {
        case 'Player':
          player.position = Vector2(point.x, point.y);
          await add(player);
          break;
        default:
      }
    }

    return super.onLoad();
  }
}
