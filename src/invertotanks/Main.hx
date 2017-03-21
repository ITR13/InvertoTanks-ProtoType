/*
    This file is part of InvertoTanks.

    Foobar is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    InvertoTanks is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with InvertoTanks.  If not, see <http://www.gnu.org/licenses/>.
*/


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
import invertotanks.Controller;
import invertotanks.engine.Tank;
import invertotanks.engine.World;
import js.html.Uint8ClampedArray;
import hxd.Key;

import js.Lib;

import hxd.App;
class Main extends App {	
	public var world:World;
	public var showMenu:Bool;
	var g:Graphics;
	var font:h2d.Font;
	public static var dt(default, null):Float;
	
	static var instance:Main;
	
	var counter:dt;
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
	}
	
	override function update(dt:Float) {
		if (dt > 1.2){
			Main.dt = 1.2;
		}else{
			Main.dt = dt;
		}
		if (world != null&&showMenu){
			world.update();
			world.draw(g);	
		}else{
			showMenu.update();
			showMenu.draw(g);
		}
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
