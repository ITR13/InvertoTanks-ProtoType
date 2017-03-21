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
import format.png.Data.Color;

/**
 * ...
 * @author ITR
 */
class GraphicalExplosion
{
	public var x(default,null):Float;
	public var y(default,null):Float;
	public var r(default,null):Float;
	public var r2(default, null):Float;
	public var a(default, null):Float;
	
	var rMax:Float;
	var r2Max:Float;
	var rSpeed:Float;
	var hollow:Bool;
	
	public function new(x:Float,y:Float,rMax:Float,r2Max:Float,rSpeed=60,hollow=false) 
	{
		this.x = x;
		this.y = y;
		this.rMax = rMax;
		this.r2Max = r2Max;
		this.rSpeed = rSpeed;
		this.hollow = hollow;
		
		this.r = 0;
		this.r2 = 0;
		this.a = 1;
	}
	
	public function update():Bool{
		r += rSpeed * Main.dt / 60;
		r2 += rSpeed * Main.dt / 60;
		if (r > rMax){
			if (r2 > r2Max){
				a -= 0.1 * Main.dt;
				if(a<=0){
					return true;
				}
			}
			r = rMax;
		}else if (r2 > r2Max){
			r2 = r2Max;
		}
		return false;
	}
	
	public function move(x:Float,y:Float){
		this.x += x;
		this.y += y;
	}
}