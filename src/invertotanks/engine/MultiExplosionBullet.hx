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
import format.swf.Constants.TagId;
import invertotanks.engine.World;

/**
 * ...
 * @author ITR
 */
class MultiExplosionBullet extends Bullet
{
	var explodeOnInverse:Bool;
	var explosionTimer:Float;

	var exploding:Bool;
	var pattern:Array <MultiExplosionPiece>;
	var index:Int;
	
	public function new(x:Float, y:Float, r:Float, vx:Float, vy:Float, pattern:Array<MultiExplosionBullet>, 
			bounce:Bool, inverse:Int, above:Bool, explodeOnInverse:Bool, origin:Tank){
		super(x, y, r, vx, vy, 0, 0, 0, 0, bounce, inverse, above, origin);
		this.explodeOnInverse = explodeOnInverse;
		explosionTimer = false;
		exploding = false;
		index = 0;
	}
	
	private function new(x:Float, y:Float, pattern:Array<MultiExplosionBullet>,originallyAbove:Bool,origin:Tank){
		super(x, y, 0, 0, 0, 0, 0, 0, false, false, 0, originallyAbove, origin);
		this.pattern = pattern;
		this.exploding = exploding;
		index = 0;
	}
	
	override function travel(world:World):Bool{
		x = newPos.x;
		y = newPos.y;
		vx = newPos.vx;
		vy = newPos.vy;
		if (newPos.inverted){
			inverse--;
			above = !above;
			if (explodeOnInverse){
				world.addBullet(new MultiExplosionBullet(x, y, pattern, originallyAbove, origin));
			}
		}
		return false;
	}
	
	override function travelFinal(world:World):Bool{
		if (exploding){
			if (explosionTimer > 0){
				explosionTimer -= Main.dt;
			}else{
				return explode();
			}
			return false;
		}else{
			return super.travelFinal(world);
		}		
	}
	
	override function explode(world:World):Bool{
		exploding = true;
		world.dExplode(x, y, pattern[index].damageRadius, pattern[index].damage, origin);
		world.physExplode(x, y, pattern[index].modRadius, originallyAbove, pattern[index].builder);
		world.gExplode(pattern[index].graphic);
		explosionTimer = pattern[index].wait;
		index++;
		return index == pattern.length;
	}
}

class MultiExplosionPiece{
	var graphic:GraphicalExplosion;
	var x:Float;
	var y:Float;
	var wait:Float;
	
	var modRadius:Float;
	var damageRadius:Float;
	var damage:Float;
	var builder:Bool;
	
	public function new(x:Float, y:Float, wait:Float, modRadius:Float, damageRadius:Float, damage:Float, builder:Bool, graphic:GraphicalExplosion){
		this.x = x; this.y = y;
		this.modRadius = modRadius;
		this.damageRadius = damageRadius;
		this.damage = this.damage; 
		this.builder = builder;
		this.graphic = graphic;
	}
}