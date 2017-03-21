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
	
package invertotanks.engine;

import h2d.Anim;
import h2d.Text;
import hxd.Res;
import hxd.res.DynamicText;
import invertotanks.Controller;
/**
 * ...
 * @author ITR
 */
class Tank
{
	private static inline var vx = 0.65; 
	private static inline var vf = 0.5; 
	private static inline var vd = 0.0981747704/3;
	private static inline var pm = 0.5;
	private static inline var sTime = 1.5;
	private static inline var maxHealth = 100.0;
	private static inline var maxFuel = 40.0;

	private var c:Controller;
	
	public var x(default, null):Float;
	public var above(default, null):Bool;
	public var fuel(default, null):Float;
	
	public var degree(default, null):Float;
	public var force(default, null):Float;
	public var invertions(default, null):Int;

	public var health(default, null):Float;
	public var invertionsText(default, null):Text;

	public function new(x:Float,above:Bool,controller:Controller){
		this.x = x;
		this.above = above;
		this.c = controller;

		degree = above?( -Math.PI / 3):(2 * Math.PI / 3);
		force = 50;
		invertions = 0;
		health = maxHealth;
		fuel = maxFuel/2;
		
		invertionsText = Main.makeText(Std.string(invertions));
	}

	public function turnEnd(){
		fuel += maxFuel/20;
		if (fuel > maxFuel){
			fuel = maxFuel;
		}
	}
	
	public function update(world:World):Bool{
		if (c != null){
			var precise = c.precise;
			if(c.fire){
				world.fire(force, degree, invertions,new BulletType(3, 24, 12, 20, false, true), this);
				return true;
			}
			if(c.left){
				if(!c.right){			
					move(precise?-vx*pm:-vx,world);
				}
			}else if(c.right){
				move(precise?vx*pm:vx,world);
			}

			if(c.up){
				if(!c.down){
					moveDeg(precise?pm*vd:vd);
				}
			}else if(c.down){
				moveDeg(precise?-pm*vd:-vd);
			}

			if(c.forceUp){
				if(!c.forceDown){
					moveForce(precise?pm*vf:vf);
				}
			}else if(c.forceDown){
				moveForce(precise?-pm*vf:-vf);
			}

			if (c.cycleLeft){
				moveInvertions(1);
			}
			if(c.cycleRight){
				moveInvertions(-1);
			}
		}
		return false;
	}
		
	public function move(vx:Float,world:World){
		if (vx == 0||fuel<=0){
			return;
		}
		if (!world.canMove(x, vx > 0,above)){
			return;
		}
		x += Main.dt*vx;
		if (x < 1){
			x = 1;
		}else if(x>638){
			x = 638;
		}else{
			fuel -= Math.abs(Main.dt*vx/10);
		}
	}

	public function moveDeg(vd:Float){
		degree += vd*Main.dt;
		if(degree<0){
			degree += 2*Math.PI;
		}if(degree>=2*Math.PI){
			degree -= 2*Math.PI;
		}
	}

	public function moveForce(vf:Float){
		force += vf*Main.dt;
		if(force<0){
			force = 0;
		}else if(force>100){
			force = 100;
		}
	}
	
	public function moveInvertions(dir:Int){
		invertions += dir;
		if (invertions < 0){
			invertions = 0;
		}else if (invertions > 5){
			invertions = 5;
		}
		invertionsText.text = Std.string(invertions);
	}

	public function damage(d:Float){
		health -= d;
		if (health <= 0){
			health = 0;
			return true;
		}
		return false;
	}
}
