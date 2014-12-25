import 'sprite_handler.dart';
SpriteHandler sprites;

class Sprite
{
	var image;
	
	Sprite(var newImage)
	{
		image = newImage;
	}
	
	dynamic getImage()
	{
		return image;
	}
}