import 'dart:html';
import 'client.dart';
import 'gameLoop.dart';
import 'sprite_handler.dart';
import 'sprite.dart';
import 'entity.dart';
import 'map.dart';

SpriteHandler sprites;
List<dynamic> entityList;
LevelMap map;

void main(){
  entityList = new List<dynamic>();
  map = new LevelMap();
  init();
  loopInit();
  spriteInit();
  entityInit();
}

void spriteInit(){
  sprites = new SpriteHandler();
  sprites.addSprite(new Sprite(new ImageElement(src:"sprites/missingTex.png")), "missing_texture");
  sprites.addSprite(new Sprite(new ImageElement(src:"sprites/grass.png")), "ground");
  sprites.addSprite(new Sprite(new ImageElement(src:"sprites/red_airship.png")), "red-airship");
  sprites.addSprite(new Sprite(new ImageElement(src:"sprites/water.png")), "water");
}

void entityInit(){
  entityList.add(new Entity(sprites.getSprite("red-airship")));
}

void log(String s){
  querySelector("#log").text = querySelector("#log").text + "\n $s"; 
}