package invertotanks;
import format.gif.Data.Extension;

/**
 * ...
 * @author ITR
 */
class Bullet{
	private static inline var bulletSpeedUp = 3;
	public var x(default,null):Float;
	public var y(default,null):Float;
	public var r(default, null):Float;
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
				var newPos = world.travel(x, y, vx, vy,above,false);
				x = newPos.x;
				y = newPos.y;
				vx = newPos.vx;
				vy = newPos.vy;
				if (newPos.inverted){
					inverse--;
					above = !above;
				}
			}else{
				var newPos = world.travel(x, y, vx, vy,above,bounce);
				trace(x + "," + y + "->" + newPos.x + "," + newPos.y);
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
			}
		}
		return false;
	}
	
	private function explode(world:World){
		world.dExplode(x, y, damageRadius, damage, origin);
		world.physExplode(x, y, modRadius, originallyAbove, builder);
		world.gExplode(new Explosion(x, y, modRadius, damageRadius));
	}
}