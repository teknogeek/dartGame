import 'sprite.dart';
import 'dart:collection';

class SpriteHandler{
HashMap<String,Sprite> spriteList;
  
  SpriteHandler(){
    spriteList = new HashMap<String,Sprite>();
  }
  
  void addSprite(Sprite sprite, String name){
    spriteList.putIfAbsent(name, (){return sprite;});
  }
  
  Sprite getSprite(String name){
    if(spriteList[name] != null){
      return spriteList[name];
    } else {
      return null;
    }
  }

}