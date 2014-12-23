import 'dart:html';
import 'package:game_loop/game_loop_html.dart';

final targetFPS = 60;
int gameWidth = 300;
int gameHeight = 300;
double avgFPS = 0.0;
GameLoopHtml gameLoop;

final CanvasElement canvas = 
  (querySelector("#canvas") as CanvasElement); 
final CanvasRenderingContext2D context = canvas.context2D;


void loopInit(){
  gameLoop = new GameLoopHtml(canvas);
  gameLoop.onUpdate = ((gameLoop) {
    // Update game logic here
    doGameUpdates;
    updateFPS();
  });
  gameLoop.onRender = ((gameLoop) {
    // Draw game into canvasElement using WebGL or CanvasRenderingContext here.
    // The interpolation factor can be used to draw correct inter-frame
    render();
  });
  gameLoop.start();
}

void doGameUpdates(){
  
}

void render(){
  
}

void checkRes(){
  gameWidth = int.parse(querySelector('#width').text);
  gameHeight = int.parse(querySelector('#height').text);
   querySelector('#height').text = gameHeight.toString();
  (querySelector('#canvas') as CanvasElement).width = gameWidth;
  (querySelector('#canvas') as CanvasElement).height = gameHeight;
}

void updateFPS(){
  avgFPS = gameLoop.frame / gameLoop.gameTime;
  querySelector('#fps').text = 'FPS: ${avgFPS.toInt()}';
}