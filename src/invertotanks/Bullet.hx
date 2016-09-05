package invertotanks;
import format.gif.Data.Extension;

/**
 * ...
 * @author ITR
 */
class Bullet{
	private static inline var bulletSpeedUp = 4;
	public var x(default,null):Float;
	public var y(default,null):Float;
	public var r(default, null):Float;
	var vx:Float;
	var vy:Float;
	
	var modRadius:Float;
	var damageRadius:Float;
	var damage:Float;
	var builder:Bool;
	
	var inverse:Int;
	var above:Bool;
	var originallyAbove:Bool;
	
	var origin:Tank;
	
	public function new(x:Float, y:Float, r:Float, vx:Float, vy:Float, modRadius:Float
			,damageRadius:Float,damage:Float,builder:Bool,inverse:Int,above:Bool,origin:Tank){
		this.x = x; this.y = y; this.r = r;
		this.vx = vx; this.vy = vy;
		this.modRadius = modRadius;
		this.damageRadius = damageRadius;
		this.damage = damage;
		this.builder = builder;
		this.inverse = inverse;
		this.above = above;
		this.originallyAbove = above;
		this.origin = origin;
	}
	
	public function update(world:World){
		for (i in 0...bulletSpeedUp){
			var newPos = world.travel(x, y, vx, vy,above);
			x = newPos.x;
			y = newPos.y;
			vx = newPos.vx;
			vy = newPos.vy;
			if (newPos.inverted){
				if (inverse--<=0){
					explode(world);
					return true;
				}
				above = !above;
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