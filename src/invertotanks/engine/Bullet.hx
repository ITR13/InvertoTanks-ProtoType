/*
    This file is part of InvertoTanks.

    InvertoTanks is free software: you can redistribute it and/or modify
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
	
package invertotanks.engine;
import format.gif.Data.Extension;
import invertotanks.engine.GraphicalExplosion;
import invertotanks.engine.Tank;
import invertotanks.engine.World;

/**
 * ...
 * @author ITR
 */
class Bullet{
	private static inline var bulletSpeedUp = 3;
	public var x(default,null):Float;
	public var y(default,null):Float;
	public var r(default,null):Float;
	var vx:Float;
	var vy:Float;
	
	var modRadius:Float;
	var damageRadius:Float;
	var damage:Float;
	var builder:Bool;
	
	var bounce:Bool;
	var inverse:Int;
	var above:Bool;
	var originallyAbove:Bool;
	
	var origin:Tank;
	
	public function new(x:Float, y:Float, r:Float, vx:Float, vy:Float, modRadius:Float
			,damageRadius:Float,damage:Float,builder:Bool, bounce:Bool,inverse:Int,above:Bool,origin:Tank){
		this.x = x; this.y = y; this.r = r;
		this.vx = vx; this.vy = vy;
		this.modRadius = modRadius;
		this.damageRadius = damageRadius;
		this.damage = damage;
		this.builder = builder;
		this.bounce = bounce;
		this.inverse = inverse;
		this.above = above;
		this.originallyAbove = above;
		this.origin = origin;
	}
	
	public function update(world:World){
		for (i in 0...bulletSpeedUp){
			if(inverse>0){
				if (travel(world)){
					return true;
				}
			}else{
				if (travelFinal(world)){
					return true;
				}
			}
		}
		return false;
	}
	
	private function travel(world:World):Bool{
		var newPos = world.travel(x, y, vx, vy,above,false);
		x = newPos.x;
		y = newPos.y;
		vx = newPos.vx;
		vy = newPos.vy;
		if (newPos.inverted){
			inverse--;
			above = !above;
		}
		return false;
	}
	
	private function travelFinal(world:World):Bool{
		var newPos = world.travel(x, y, vx, vy,above,bounce);
		x = newPos.x;
		y = newPos.y;
		vx = newPos.vx;
		vy = newPos.vy;
		if (newPos.inverted){
			if (bounce){
				if (Math.sqrt(vx*vx + vy*vy) < 2){
					explode(world);
					return true;
				}
			}else{
				explode(world);
				return true;
			}
		}
		return false;
	}
	
	private function explode(world:World){
		world.dExplode(x, y, damageRadius, damage, origin);
		world.physExplode(x, y, modRadius, originallyAbove, builder);
		world.gExplode(new GraphicalExplosion(x, y, modRadius, damageRadius));
	}
}