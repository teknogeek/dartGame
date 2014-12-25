import 'dart:html';
import 'package:game_loop/game_loop_html.dart';
import '../starter.dart';
import 'sprite.dart';
import 'entity.dart';
import 'client.dart';
import 'dart:async';

final targetFPS = 60;
final maxWidth = 1280;
final maxHeight = 720;
int xInc = 0, yInc = 0;
var fpsCorrection = false;
int frames = 0;
int gameWidth = maxWidth;
int gameHeight = maxHeight;
double avgFPS = 0.0;
GameLoopHtml gameLoop;

final CanvasElement canvas = (querySelector("#canvas") as CanvasElement); 
final CanvasRenderingContext2D context = canvas.context2D;


void loopInit()
{
	gameLoop = new GameLoopHtml(canvas);
	gameLoop.pointerLock.lockOnClick = false;
	gameLoop.onUpdate = ((gameLoop) 
	{
	  // Update game logic here
	  doGameUpdates();
	  updateFPS();
	});
	gameLoop.onRender = ((gameLoop)
	{
	  // Draw game into canvasElement using WebGL or CanvasRenderingContext here.
	  // The interpolation factor can be used to draw correct inter-frame
	  render();
	});
	gameLoop.start();
}

void doGameUpdates()
{
	
}

void handleMouseInput(e, WebSocket webSocket, int clientNumber)
{
	Entity shipEntity;
	int xOffset = 0, yOffset = 0, mouseX, mouseY;
	bool isInHitbox = false;
	for(dynamic entity in entityList)
	{
		Sprite entitySprite = (entity as Entity).getSprite(); 
		if(sprites.getNameForSprite(entitySprite) == "red-airship")
		{
			shipEntity = entity;
			break;
		}
	}

	xOffset = shipEntity.x - e.client.x;
	yOffset = shipEntity.y - e.client.y;
	if(e.client.x <= shipEntity.x + 32 && e.client.x >= shipEntity.x && e.client.y <= shipEntity.y + 32 && e.client.y >= shipEntity.y)
	{
		isInHitbox = true;
	}
	
	StreamSubscription mouseMoveStream = canvas.onMouseMove.listen((onData)
	{
		mouseX = onData.client.x;
		mouseY = onData.client.y;
		
		if(isInHitbox)
		{
			if((mouseX - shipEntity.x).abs() > 32 || (mouseY - shipEntity.y).abs() > 32)
			{
				int newX = (mouseX ~/ 32) * 32;
				int newY = (mouseY ~/ 32) * 32;
				
				shipEntity..x = newX
                   		  ..y = newY;
				
				String moveData = '{"message": "moveClient", "client": "$clientNumber", "x": "${shipEntity.x}", "y": "${shipEntity.y}"}'; 
				sendWs(moveData, webSocket, clientNumber, false);
			}
			//shipEntity..x = mouseX + xOffset
    		//		  ..y = mouseY + yOffset;
		}
	});

	canvas.onMouseUp.listen((onData)
	{
    	 mouseMoveStream.cancel();
    	 isInHitbox = false;
	});
}

void render()
{
	clearCanvas();
	drawBackground();
	renderEntity();
	frames++;
}

void renderEntity()
{
    entityList.forEach((dynamic entity)
    {
        draw((entity as Entity).getSprite(), (entity as Entity).x, (entity as Entity).y);
    });
}

void drawBackground()
{
	for(int y = 0; y < (gameHeight ~/ 32); y++)
	{
		for(int x = 0; x < (gameWidth ~/ 32); x++)
		{
			if(y < lvlMap.map.length && x < lvlMap.map[y].length)
			{
				draw(getSpriteFromInt(lvlMap.map[y][x].toString()), x*32, y*32);
			}
		}
	}
}

void draw(Sprite image, int x, int y)
{
	context..beginPath()
			..drawImage(image.getImage(), x, y)
			..closePath()
			..stroke();
}

void clearCanvas()
{
	context.clearRect(0, 0, gameWidth, gameHeight);
}

Sprite getSpriteFromInt(String i)
{
	switch(i)
	{
		case "0":
			return sprites.getSprite("ground");
			
		case "1":
			return sprites.getSprite("water");
			
		default:
			return sprites.getSprite("ground");
	}
}

void updateFPS()
{
	if(fpsCorrection)
	{
		if(avgFPS < targetFPS - 5)
		{
    		gameWidth = (gameWidth ~/ 2);
			gameHeight = (gameHeight ~/ 2);
		}
		else
		{
			gameWidth = maxWidth;
			gameHeight = maxHeight;
		}
	}
	avgFPS = frames / gameLoop.gameTime;
	querySelector('#fps').text = 'FPS: ${avgFPS.toInt()} - Frames: ${frames}';
}