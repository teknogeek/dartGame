import 'dart:html';
import 'dart:convert';
import 'dart:async';
import '../starter.dart';
import 'gameLoop.dart';
import 'entity.dart';
import 'sprite.dart';

List clients;
DivElement clientsDiv;

void init()
{
	for(int i = 1; i <= 1; i++)
	{
		connect("127.0.0.1", 9223, "ws", i);
	}
	clientsDiv = querySelector("#clients");
}

void connect(String server, int port, String path, int clientNumber)
{
	var webSocket = new WebSocket("ws://$server:$port/$path");
	webSocket.onOpen.first.then((_)
	{
		onConnected(clientNumber, webSocket);
		webSocket.onClose.first.then((_)
		{
			print("Connection disconnected to ${webSocket.url}");
			onDisconnected(clientNumber);
		});
	});
	
	webSocket.onError.first.then((_)
	{
		print("Failed to connect to ${webSocket.url}. Please run lib/server.dart and try again.");
	});
}

void onConnected(int clientNumber, WebSocket webSocket)
{
	webSocket.onMessage.listen((e)
	{
		onMessage(e.data);
	});
	
	addNewClient(clientNumber, webSocket);
}

void onDisconnected(int clientNumber)
{
	DivElement clientDiv = querySelector("#client$clientNumber");
	clientsDiv.children.remove(clientDiv);
	print("Client #$clientNumber disconnected. Trying again in 3 seconds.");
	new Timer(new Duration(seconds:3),()
	{
		connect("127.0.0.1", 9223, "ws", clientNumber);
	});
}

void onMessage(data)
{
	var responseFromServer = JSON.decode(data);
	if(responseFromServer['type'] == "map")
	{
		List<List> serverMap = responseFromServer['response'];
		lvlMap.map = serverMap;
	}
	else
	{
		var echoFromServer = JSON.decode(data);
		print("Recieved message from server: ${echoFromServer['response']}");
	}
}

void updateButton(Event e)
{
	InputElement box = (e.target as InputElement);
	Element parent = box.parent;
	ButtonElement sendButton = parent.querySelector("#sendButton");
	
	String boxData = box.value;
	sendButton.disabled = boxData.isEmpty;
}

void sendWs(String message, WebSocket webSocket, int clientNumber, [bool isStandard = true])
{
	var request;
	if(isStandard)
	{
		request = '{"message": "$message", "client": "$clientNumber"}';
	}
	else
	{
		request = message;
	}
	print("Send message to server: $request");
	webSocket.send(request);
}

void sendData(Event e, WebSocket webSocket, int clientNumber)
{
	Element parent = (e.target as ButtonElement).parent;
	InputElement inputBox = parent.querySelector("#inputBox");
	sendWs(inputBox.value, webSocket, clientNumber);
}

void addNewClient(int clientNumber, WebSocket webSocket)
{
	sendWs("addCLient", webSocket, clientNumber);
	entityList.add(new Entity(sprites.getSprite("red-airship")));
	
	//client div
	DivElement clientDiv = new DivElement();
	clientDiv.id = "client$clientNumber";
	
	//client input box
	InputElement clientInput = new InputElement();
	clientInput.id = "inputBox";
	
	//client send button
	ButtonElement clientButton = new ButtonElement();
	clientButton..id = "sendButton"
				..value = "$clientNumber"
				..disabled = true
				..text = "Send text from client $clientNumber";
	
	clientDiv.children..add(clientInput)
			 		  ..add(clientButton)
			 		  ..add(new BRElement());
	
	clientsDiv.children.add(clientDiv);
	
	ButtonElement sendButton = querySelector("#client$clientNumber").querySelector("#sendButton");
	sendButton.onClick.listen((event) => sendData(event, webSocket, clientNumber));
	
	InputElement inputBox = querySelector("#client$clientNumber").querySelector("#inputBox");
	inputBox.onInput.listen(updateButton);
	
	canvas.onMouseDown.listen((event) => handleMouseInput(event, webSocket, clientNumber));
}