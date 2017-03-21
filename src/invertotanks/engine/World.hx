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
import format.neko.Builtins;
import h2d.Graphics;
import h2d.col.Point;
import h2d.col.Ray;
import haxe.macro.Format;
import invertotanks.engine.Tank;

/**
 * ...
 * @author ITR
 */
class World{
	private static inline var tankMaxHeightDist = 7;
	private static inline var bulletBounceLoss = 0.8;
	private static inline var tankSize:Float = 8.5;
	private static inline var healthHeight:Float = tankSize+8;
	private static inline var minPlayerIndicatorArrowHeight:Float = healthHeight+5;
	private static inline var maxPlayerIndicatorArrowHeight:Float = healthHeight+10;
	var playerIndicatorArrowHeight:Float;
	var playerIndicatorArrowDir:Float;
	
	var airResistance:Float;
	var gravity:Float;
	var wind:Float;
	var wallHeight:Float;

	var heightMap:Array<Float>;
	var tanks:Array<Tank>;
	var currentTank:Int;

	var bullets:Array<Bullet>;
	var explosions:Array<GraphicalExplosion>;
	
	public function new(heightMap:Array<Float>, tanks:Array<Tank>){
		this.heightMap = heightMap;
		this.tanks = tanks;
		
		bullets = new Array();
		explosions = new Array();
		
		airResistance = 1-0.05/60;
		gravity = 20;
		wind = 0;
		wallHeight = 640;
		
		currentTank = 0;
		playerIndicatorArrowHeight = minPlayerIndicatorArrowHeight + maxPlayerIndicatorArrowHeight;
		playerIndicatorArrowHeight /= 2;
		playerIndicatorArrowDir = 0.1;
	}
	
	public function update(){
		for (explosion in explosions){
			if (explosion.update()){
				explosions.remove(explosion);
			}
		}
		for (bullet in bullets){
			if (bullet.update(this)){
				bullets.remove(bullet);
			}
		}
		if(bullets.length==0&&explosions.length==0){
			playerIndicatorArrowHeight += playerIndicatorArrowDir * Main.dt;
			if (playerIndicatorArrowHeight >= maxPlayerIndicatorArrowHeight){
				playerIndicatorArrowHeight = maxPlayerIndicatorArrowHeight;
				playerIndicatorArrowDir = -playerIndicatorArrowDir;
			}else if (playerIndicatorArrowHeight < minPlayerIndicatorArrowHeight){
				playerIndicatorArrowHeight = minPlayerIndicatorArrowHeight;
				playerIndicatorArrowDir = -playerIndicatorArrowDir;				
			}
			
			if (tanks[currentTank].update(this)){
				tanks[currentTank].turnEnd();
				currentTank++;
				currentTank = currentTank % tanks.length;
			}
		}
	}

	public function physExplode(x:Float, y:Float, r:Float, above:Bool, grow:Bool){
		var j = -r;
		var r2 = r * r;
		for (i in  Std.int(x - r)...Std.int(x + r)){
			if (i >= 0 && i < heightMap.length){
				var localR = Math.sqrt(r2 - j * j);
				j++;
				var height = above?heightMap[i] - (y - localR):(y + localR) - heightMap[i];
				if (height > 0){
					if (height > localR*2){
						height = localR*2;
					}
					heightMap[i] += above!=grow? -height:height;
					if (heightMap[i] < -240){
						heightMap[i] = -240;
					}else if (heightMap[i] > 240){
						heightMap[i] = 240;
					}
				}
			}
		}
	}
	
	public function gExplode(explosion:GraphicalExplosion){
		explosions.push(explosion);
	}
	
	public function dExplode(x:Float, y:Float, r:Float, d:Float, origin:Tank){
		for (tank in tanks){
			var dx = tank.x - x;
			var dy = getHeight(tank.x) - y;
			r += tankSize;
			if ((dx * dx + dy * dy) <= r*r){
				tank.damage(d);
			}
		}
	}
	
	public function travel(x:Float, y:Float, vx:Float, vy:Float, above:Bool, bounce:Bool){
		var orgX = x;
		var orgY = y;
		
		var inverted = false;
		var outside = false;
		if (x < 0){
			x = 0;
			outside = true;
		}else if (x >= heightMap.length){
			x = heightMap.length - 1;
			outside = true;
		}
		
		var xHeight = getHeight(x);
		
		var startedUnder = y != xHeight;
		if (startedUnder){
			startedUnder = (above == (y < xHeight));
		}
		
		y += Main.dt*vy/60;
		x += Main.dt * vx / 60 + Main.dt * wind / 60;
		
		var nxHeight = getHeight(x);
		if (above){
			if (y <= nxHeight){
				inverted = true;
			}else if(y>nxHeight+0.1){
				vy -= Main.dt * gravity / 60;
			}
		}else{
			if (y >= nxHeight){
				inverted = true;
			}else if(y<nxHeight-0.1){
				vy += Main.dt*gravity/60;				
			}
		}
	
		if (bounce && inverted){
			if (startedUnder){
				vx = vy = 0;
			}else{
				var xInt = Std.int(x);				
				var dx = vx; var dy = vy;
				var wdx = above?1.0:-1.0;
				var wdy = above?heightMap[xInt+1]-heightMap[xInt]:heightMap[xInt]-heightMap[xInt+1];
				
				var l = Math.sqrt(dx * dx + dy * dy);
				var wl = Math.sqrt(1 + wdy * wdy);
				
				wdx /= wl;
				wdy /= wl;
				dx /= l;
				dy /= l;
				
				var angle = 2 * Math.acos(dx * wdx + dy * wdy);
				if(!Math.isNaN(angle)){					
					var nvx = vx * Math.cos(angle) - vy * Math.sin(angle);
					var nvy = vx * Math.sin(angle) + vy * Math.cos(angle);
					trace(angle);
					vx = nvx;
					vy = nvy;
				}else{
					vx = -vx;
					vy = -vy;
				}
				
				//Consider calculating exact point of collision to get better reflection
				x = orgX;
				y = orgY;
				
				vx *= bulletBounceLoss;
				vy *= bulletBounceLoss;
			}
		}
		
		if(!outside){
			if (x < 0){
				if (y >= heightMap[0]){
					if (y < heightMap[0] + wallHeight){
						x = -x;
						vx = -vx;
					}
				}else{
					if (y >= heightMap[0] - wallHeight){
						x = -x;
						vx = -vx;
					}
				}
			}else if (x >= heightMap.length){
				if (y >= heightMap[heightMap.length-1]){
					if (y < heightMap[heightMap.length-1] + wallHeight){
						x = 640-(x-640);
						vx = -vx;
					}
				}else{
					if (y >= heightMap[heightMap.length-1] - wallHeight){
						x = 640-(x-640);
						vx = -vx;
					}
				}
			}
		}
		
		vx *= Math.pow(airResistance, Main.dt);
		vy *= Math.pow(airResistance, Main.dt);
		
		return {x:x, y:y, vx:vx, vy:vy, inverted:inverted};
	}
	
	public function fire(force:Float, degree:Float, inverse:Int, b:BulletType, tank:Tank){
		var dx = Math.cos(degree);
		var dy = -Math.sin(degree);
		var height = getHeight(tank.x);
		
		bullets.push(b.GetBullet(tank.x + dx * tankSize * 1.5, height + dy * tankSize * 1.5, 
			b.r, dx * force, dy * force,inverse,tank));
	}

	public function addBullet(bullet:Bullet){
		bullets.push(bullet);
	}
	
	public function canMove(x:Float, right:Bool,above:Bool):Bool{
		if (above){
			return getHeight(x + (right?1: -1)) -getHeight(x) <= tankMaxHeightDist; 
		}else{
			return getHeight(x) - getHeight(x + (right?1: -1)) <= tankMaxHeightDist; 
		}
	}
	
	private function getHeight(x:Float){
		var xInt = Std.int(x);
		var height = x-xInt;
		height = (1 - height) * heightMap[xInt] + height * heightMap[xInt + 1];
		return height;
	}	
	
	public function draw(g:Graphics){
		g.clear();
		g.beginFill(0x3399FF);
		g.drawRect(0, 0, 640, 480);
		g.beginFill(0xFFFFFF-0x3399FF);
		for (x in 0...640){
			g.drawRect(x, 0, 1, 240 - heightMap[x]);
		}
		
		g.beginFill(0x000000);
		for (x in 0...640){
			g.drawRect(x, 239 - heightMap[x],1,3);
		}
		
		for (tank in tanks){
			var x = Std.int(tank.x);
			var deg = Math.atan2(heightMap[x - 1] - heightMap[x + 1], 2);
			if (tank.above){deg += Math.PI; }
			var height = 240 - getHeight(tank.x);
		
			g.setColor(0xFFFF00, 0.5);
			g.drawPie(tank.x, height, tankSize * 1.5+tank.force/2, tank.degree-Math.PI/16, Math.PI/8);
			g.beginFill(0x007700);
			g.drawPie(tank.x, height, tankSize, deg, Math.PI);
			g.drawPie(tank.x, height, tankSize * 1.5, tank.degree-Math.PI / 16, Math.PI / 8);

			g.beginFill(0x000000);
			g.drawRect(tank.x - tankSize-1, height + (tank.above?-healthHeight-3:healthHeight)-1, 2*tankSize+2,6);
			g.beginFill(0x00FF00);
			g.drawRect(tank.x - tankSize, height + (tank.above? -healthHeight-3:healthHeight), 
					tank.health * tankSize / 50, 4);
			g.beginFill(0x7F7F7F);
			g.drawRect(tank.x - tankSize, height + (tank.above? -healthHeight-1:healthHeight+2), 
					tank.fuel * tankSize / 20, 2);

			tank.invertionsText.x = tank.x-(tank.above?2:3);
			tank.invertionsText.y = height-(tank.above?14:5);
		}
		if(bullets.length!=0){
			for (bullet in bullets){
				if(bullet.r!=0){
					g.beginFill(0x000000);
					g.drawCircle(bullet.x, 240-bullet.y, bullet.r);
					g.beginFill(0xFFFFFF);
					g.drawCircle(bullet.x, 240 - bullet.y, bullet.r - 1);
				}
			}
		}else{
			var tank = tanks[currentTank];
			var height = 240 - getHeight(tank.x);
			g.beginFill(0x00FF00);
			g.drawPie(tank.x, height+(tank.above? -playerIndicatorArrowHeight:playerIndicatorArrowHeight),
					10, tank.above?-2*Math.PI / 3:Math.PI / 3, Math.PI / 3);
		}
		
		for (explosion in explosions){
			g.setColor(0xFF0000,explosion.a*0.3);
			g.drawCircle(explosion.x, 240-explosion.y, explosion.r2);
			g.setColor(0xFFFFFF,explosion.a*0.7);
			g.drawCircle(explosion.x, 240-explosion.y, explosion.r);
		}
	}	
}
