import 'dart:html';
import 'lib/client.dart';
import 'lib/gameLoop.dart';
import 'lib/sprite_handler.dart';
import 'lib/sprite.dart';
import 'lib/entity.dart';
import 'lib/map.dart';

SpriteHandler sprites;
List<dynamic> entityList;
LevelMap lvlMap;

void main()
{
	entityList = new List<dynamic>();
	lvlMap = new LevelMap(maxWidth, maxHeight);
	init();
	loopInit();
	spriteInit();
	entityInit();
}

void spriteInit()
{
	sprites = new SpriteHandler();
	sprites.addSprite(new Sprite(new ImageElement(src:"sprites/missingTex.png")), "missing_texture");
	sprites.addSprite(new Sprite(new ImageElement(src:"sprites/grass.png")), "ground");
	sprites.addSprite(new Sprite(new ImageElement(src:"sprites/red_airship.png")), "red-airship");
	sprites.addSprite(new Sprite(new ImageElement(src:"sprites/water.png")), "water");
}

void entityInit()
{
	entityList.add(new Entity(sprites.getSprite("red-airship")));
}

void log(String s)
{
	querySelector("#log").text = querySelector("#log").text + "\n $s";
}