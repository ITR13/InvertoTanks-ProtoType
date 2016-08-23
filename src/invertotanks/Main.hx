package invertotanks;
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

import js.Lib;

import hxd.App;
class Main extends App {	
	var world:World;
	var g:Graphics;
	public static var dt(default, null):Float;
	
	var counter:Int;
	override function init() {
		g = new Graphics(s2d);
		g.x = Std.int(s2d.width / 2)-320;
		g.y = Std.int(s2d.height / 2)-240;
		
		var heightMap = new Array<Float>();
		for (i in 0...640){
			var j = 160 - i / 2;
			heightMap.push(j);
		}
		
		var tanks = new Array<Tank>();
		tanks.push(new Tank(640 / 4, true, 100));
		tanks.push(new Tank(3*640 / 4, false, 100));
		
		world = new World(heightMap,tanks);
		world.draw(g);
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
		new Main();
	}
	
	override function onResize() {
		g.x = Std.int(s2d.width / 2)-320;
		g.y = Std.int(s2d.height / 2)-240;
	}
	
}