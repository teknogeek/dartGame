import 'dart:html';
import 'client.dart';
import 'gameLoop.dart';
import 'sprite_handler.dart';
import 'sprite.dart';

SpriteHandler sprites;

void main(){
  init();
  loopInit();
  sprites = new SpriteHandler();
  sprites.addSprite(new Sprite("Somehow get the image"), "test");
}

void log(String s){
  querySelector("#log").text = querySelector("#log").text + "\n $s"; 
}