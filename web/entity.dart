import 'sprite.dart';

class Entity{
  Sprite entitySprite;
  int x = 0,y = 0;
  int health = 100;
  bool selected = false;
  
  Entity(Sprite sprite){
    entitySprite = sprite;
  }
  
  Sprite getSprite(){
    return entitySprite;
  }
}