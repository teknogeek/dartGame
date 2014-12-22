import 'dart:convert';
import 'dart:io';
import 'package:route/server.dart' show Router;

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
			print("Bad WebSocket request.");
		});
}

void processMessage(json, WebSocket webSocket)
{
	var message = json['message'];
	var client = json['client'];
	String response = "";
	print("Message from client $client: $message");
	if(message == "moveTile")
	{
		int x = json['movement']['x'];
		int y = json['movement']['y'];
		response = '{"response": "moveClient"}';
	}
	else
	{
		response = '{"response": "$message received from client $client."}';
	}
	webSocket.add(response);
}