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
import hxd.Key;

import js.Lib;

import hxd.App;
class Main extends App {	
	var world:World;
	var g:Graphics;
	public static var dt(default, null):Float;
	
	var counter:Int;
	override function init() {
		g = new Graphics(s2d);
		onResize();
		
		var heightMap = new Array<Float>();
		for (i in 0...640){
			//var j = 160 - i / 2;
			//heightMap.push(j);
			heightMap.push(0);
		}
		
		var p1 = new Controller(Key.W, Key.S, Key.A, Key.D,
			Key.Q, Key.E, Key.R, Key.F, Key.SPACE, Key.SHIFT);

		var p2 = new Controller(Key.UP, Key.DOWN, Key.LEFT, Key.RIGHT,
			Key.U, Key.I, Key.J, Key.K, Key.L, Key.O);

		var tanks = new Array<Tank>();
		tanks.push(new Tank(640 / 4, true, 100,p1));
		tanks.push(new Tank(3*640 / 4, false, 100,p2));
		
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
}
