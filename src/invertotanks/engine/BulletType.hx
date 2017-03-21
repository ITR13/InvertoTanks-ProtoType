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
import invertotanks.engine.Tank;

/**
 * ...
 * @author ITR
 */
class BulletType{
	
	public var r(default, null):Float;
	public var modRadius(default, null):Float;
	public var damageRadius(default, null):Float;
	public var damage(default, null):Float;
	public var builder(default, null):Bool;
	public var bounce(default, null):Bool;
	
	public function new(r:Float, modRadius:Float, damageRadius:Float,
			damage:Float,builder:Bool,bounce:Bool){
		this.r = r;
		this.modRadius = modRadius;
		this.damageRadius = damageRadius;
		this.damage = damage;
		this.builder = builder;
		this.bounce = bounce;
	}
	
	public function GetBullet(x:Float,y:Float,r:Float,xForce:Float,yForce:Float,inverse:Int,tank:Tank):Bullet{
		return new Bullet(x, y, r, xForce, yForce, modRadius, damageRadius, damage, builder, bounce, inverse, tank.above, tank);
	}
}

