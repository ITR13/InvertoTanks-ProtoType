package invertotanks;

/**
 * ...
 * @author ITR
 */
class Tank
{
	private static inline var vx = 0.1; 
	private var controller:Controller;
	
	public var x(default, null):Float;
	public var above(default, null):Bool;
	public var fuel(default, null):Float;
	
	public var degree(default, null):Float;

	public function new(x:Float,above:Bool,fuel:Float){
		this.x = x;
		this.above = above;
		this.fuel = fuel;
		degree = above?( -Math.PI / 3):(2 * Math.PI / 3);
		counter = 60 * 3;
		counter2 = 0;
		left = !above;
	}

	private var counter:Int;
	private var counter2:Int;
	private var left:Bool;
	public function update(world:World){
		move(left ?1/5 :-1/5);
		degree += Math.PI / 365;
		if (++counter >= 60 * 1.5){
			counter = 0;
			world.fire(Math.random() * 80 + 10, new BulletType(3, Math.random() * 16 + 16, 0, 0, false, counter2++), this);
			counter2 = counter2 % 8;
		}
	}
	
	
	public function move(vx:Float){
		x -= Main.dt*vx;
		if (x < 1){
			x = 1;
			left = false;
		}else if(x>638){
			x = 638;
			left = true;
		}else{
			fuel -= Main.dt*vx/10;
		}
	}
}