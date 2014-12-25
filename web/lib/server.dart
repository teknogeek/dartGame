import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'entity.dart';
import 'sprite.dart';
import 'package:route/server.dart' show Router;

List<List> map = new List();
List<dynamic> serverEntityList;
void main()
{
	int port = 9223;
	HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, port).then((server)
	{
		print("Search server is running on http://${server.address.address}:$port/");
		var router = new Router(server);
		router.serve("/ws")
			.transform(new WebSocketTransformer())
			.listen(handleWebSocket);
	});
	generateMap(1280, 720);
	entityList = new List<dynamic>();
}

void handleWebSocket(WebSocket webSocket)
{
	webSocket
		.map((string) => JSON.decode(string))
		.listen((json)
		{
			processMessage(json, webSocket);
		}, onError: (error)
		{
			print("Bad WebSocket request. Error: $error");
		});
}

void processMessage(json, WebSocket webSocket)
{
	var message = json['message'];
	var client = json['client'];
	dynamic response = "";
	print("Message from client $client: $message");
	if(message == "getMap")
	{
		response = '{"type": "map", "response": ${JSON.encode(map)}}';
	}
	else if(message == "moveClient")
	{
    	Entity shipEntity;
    	int xOffset = 0, yOffset = 0, mouseX, mouseY;
    	bool isInHitbox = false;
    	for(dynamic entity in serverEntityList)
    	{
    		Sprite entitySprite = (entity as Entity).getSprite(); 
    		if(sprites.getNameForSprite(entitySprite) == "red-airship")
    		{
    			shipEntity = entity;
    			break;
    		}
    	}
    	
    	shipEntity..x = json['x']
    			  ..y = json['y'];
    	entityList = serverEntityList;
	}
	else if(message == "addClient")
	{
		print("ADDCLIENT");
		serverEntityList = entityList;
		print(serverEntityList);
	}
	else
	{
		response = '{"type": "echo", "response": "$message received from client $client."}';
	}
	webSocket.add(response);
}

void generateMap(width, height)
{
	int numY = height ~/ 32;
	int numX = width ~/ 32;
	for(int y = 0; y < numY; y++)
	{
		List xList = new List();
		for(int x = 0; x < numX; x++)
		{
			int tileInt = new Random().nextInt(10);
			tileInt = (0 <= tileInt && tileInt <= 7) ? 0 : 1;
			
			if(y > 0 && x > 0)
			{
				if(map[y - 1][x - 1] != 1 && map[y - 1][x] != 1 && xList[x - 1] != 1 && tileInt == 1)
				{
					map[y - 1][x - 1] = 1;
					map[y - 1][x] = 1;
					xList[x - 1] = 1;
				}
			}
			xList.add(tileInt);
		}
		map.add(xList);
	}
}