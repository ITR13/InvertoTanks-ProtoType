package invertotanks;
import format.agal.Data.Tex;
import h2d.Anim;
import h2d.Bitmap;
import h2d.Graphics;
import h2d.Sprite;
import h2d.Text;
import h2d.Tile;
import haxe.Timer;
import haxe.io.Bytes;
import hxd.Pixels;
import hxd.Res;
import hxd.res.Font;
import js.html.Uint8ClampedArray;
import hxd.Key;

import js.Lib;

import hxd.App;
class Main extends App {	
	var world:World;
	var g:Graphics;
	var font:h2d.Font;
	public static var dt(default, null):Float;
	
	static var instance:Main;
	
	var counter:Int;
	override function init() {
		g = new Graphics(s2d);
		onResize();
		
		Res.initEmbed();
		
		font = Res.TITUSCBZ.build(16);
				
		var heightMap = new Array<Float>();
		for (i in 0...128){
			heightMap.push(0);
		}
		for (i in 0...64){
			heightMap.push(i);
		}
		for (i in 0...64){
			heightMap.push(64-i);
		}
		for (i in 0...128){
			heightMap.push(0);
		}
		for (i in 0...64){
			heightMap.push(-i);
		}		
		for (i in 0...64){
			heightMap.push(i-64);
		}
		for (i in 0...128){
			heightMap.push(0);
		}
		/*for (i in 0...640){
			heightMap.push(320 / 0.8 - i / 0.8);
			trace(heightMap[i]);
		}*/
		
		
		var p = new Controller(Key.W, Key.S, Key.A, Key.D,
			Key.Q, Key.E, Key.R, Key.F, Key.SPACE, Key.SHIFT);
			
		var tanks = new Array<Tank>();
		tanks.push(new Tank(640 / 4, true, p));
		tanks.push(new Tank(3*640 / 4, false,p));
		
		world = new World(heightMap,tanks);
		world.draw(g);
		
		/*for (dx in -2...2){
			for (dy in -1...1){
				World.reflect(dx, dy, 1, 0);
				World.reflect(dx, dy, -1, 0);
				World.reflect(dx, dy, 0, 1);
				World.reflect(dx, dy, 0, -1);
			}			
		}*/
	}
	
	override function update(dt:Float) {
		if (dt > 1.2){
			Main.dt = 1.2;
		}else{
			Main.dt = dt;
		}
		
		world.update();
		world.draw(g);
	}
	
	static function main() {
		instance = new Main();
	}
	
	override function onResize() {
		g.scaleX = s2d.width / 640;
		g.scaleY = s2d.height / 480;
		if (g.scaleX < g.scaleY){
			g.scaleY = g.scaleX;
		}else{
			g.scaleX = g.scaleY;
		}
		g.x = Std.int(s2d.width / 2)-g.scaleX*320;
		g.y = Std.int(s2d.height / 2) - g.scaleY*240;
	}

	public static function makeText(text:String):Text{
		return instance.makeTextI(text);
	}
	
	function makeTextI(text:String):Text{
		var ret = new Text(font, s2d);
		ret.text = text;
		ret.scaleX = 0.7;
		ret.scaleY = 0.7;
		ret.textColor = 0;
		g.addChild(ret);
		return ret;
	}
	
}
