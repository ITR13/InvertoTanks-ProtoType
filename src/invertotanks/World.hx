package invertotanks;
import format.neko.Builtins;
import h2d.Graphics;
import h2d.col.Point;
import h2d.col.Ray;
import haxe.macro.Format;

/**
 * ...
 * @author ITR
 */
class World{
	private static inline var tankSize:Float = 8.5;
	
	var airResistance:Float;
	var gravity:Float;
	var wind:Float;
	var wallHeight:Float;

	var heightMap:Array<Float>;
	var tanks:Array<Tank>;

	var bullets:Array<Bullet>;
	var explosions:Array<Explosion>;
	
	public function new(heightMap:Array<Float>, tanks:Array<Tank>){
		this.heightMap = heightMap;
		this.tanks = tanks;
		
		bullets = new Array();
		explosions = new Array();
		
		airResistance = 0.05;
		gravity = 20;
		wind = 0;
		wallHeight = 640;
		
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
		for (tank in tanks){
			tank.update(this);
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
					if (height > localR){
						height = localR;
					}
					heightMap[i] += above==grow? -height:height;
					if (heightMap[i] < -240){
						heightMap[i] = -240;
					}else if (heightMap[i] > 240){
						heightMap[i] = 240;
					}
				}
			}
		}
	}
	
	public function gExplode(explosion:Explosion){
		explosions.push(explosion);
	}
	
	public function travel(x:Float,y:Float,vx:Float,vy:Float,above:Bool){
		var xInt = Std.int(x);
		var inverted = false;
		var outside = false;
		if (xInt < 0){
			xInt = 0;
			outside = true;
		}else if (xInt >= heightMap.length){
			xInt = heightMap.length - 1;
			outside = true;
		}
		y += Main.dt*vy/60;
		if (above){
			if (y <= heightMap[xInt]){
				inverted = true;
			}else{
				vy -= Main.dt*gravity/60;
			}
		}else{
			if (y >= heightMap[xInt]){
				inverted = true;
			}else{
				vy += Main.dt*gravity/60;				
			}
		}
		
		x += Main.dt*vx / 60 + Main.dt*wind / 60;
		xInt = Std.int(x);
		
		if(!outside){
			if (xInt < 0){
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
			}else if (xInt >= heightMap.length){
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
		
		vx -= vx * (Main.dt*airResistance/60);
		vy -= vy * (Main.dt*airResistance/60);
		
		return {x:x, y:y, vx:vx, vy:vy, inverted:inverted};
	}
	
	public function fire(force:Float, degree:Float, b:BulletType, tank:Tank){
		var x = Std.int(tank.x);
		var dx = Math.cos(degree);
		var dy = -Math.sin(degree);
		var height = tank.x-x;
		height = height * heightMap[x] + (1 - height) * heightMap[x + 1];
		bullets.push(new Bullet(tank.x + dx * tankSize * 1.5, height + dy * tankSize * 1.5, b.r, dx * force, 
			dy * force, b.modRadius, b.damageRadius,b.damage, b.builder, b.inverse, tank.above, tank));
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
			var height = tank.x-x;
			height = (1-height) * heightMap[x] + height * heightMap[x + 1];
			height = 240 - height;
			
			g.setColor(0xFFFF00, 0.5);
			g.drawPie(tank.x, height, tankSize * 1.5+tank.force/2, tank.degree-Math.PI/16, Math.PI/8);
			g.beginFill(0x00FF00);
			g.drawPie(tank.x, height, tankSize, deg, Math.PI);
			g.drawPie(tank.x, height, tankSize * 1.5, tank.degree-Math.PI/16, Math.PI/8);
		}
		
		for (bullet in bullets){
			g.beginFill(0x000000);
			g.drawCircle(bullet.x, 240-bullet.y, bullet.r);
			g.beginFill(0xFFFFFF);
			g.drawCircle(bullet.x, 240-bullet.y, bullet.r-1);
		}
		
		for (explosion in explosions){
			g.setColor(0xFF0000,explosion.a*0.3);
			g.drawCircle(explosion.x, 240-explosion.y, explosion.r2);
			g.setColor(0xFFFFFF,explosion.a*0.7);
			g.drawCircle(explosion.x, 240-explosion.y, explosion.r);
		}
	}

}
