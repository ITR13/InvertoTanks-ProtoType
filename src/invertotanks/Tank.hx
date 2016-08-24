package invertotanks;

/**
 * ...
 * @author ITR
 */
class Tank
{
	private static inline var vx = 1.0; 
	private static inline var vf = 0.5; 
	private static inline var vd = Math.PI/32;
	private static inline var sm = 0.1;
	private static inline var sTime = 5.0;

	private var c:Controller;
	
	public var x(default, null):Float;
	public var above(default, null):Bool;
	public var fuel(default, null):Float;
	
	public var degree(default, null):Float;
	public var force(default, null):Float;
	public var invertions(default, null):Int;


	public function new(x:Float,above:Bool,fuel:Float,controller:Controller){
		this.x = x;
		this.above = above;
		this.fuel = fuel;
		this.c = controller;

		shotTimer = 0;
		degree = above?( -Math.PI / 3):(2 * Math.PI / 3);
		force = 50;
		invertions = 1;
	}

	private var shotTimer:Float;
	public function update(world:World){
		shotTimer += Main.dt;
		if(controller!=null){			
			if(c.fire){	
				if(shotTimer>=sTime){
					shotTimer-=sTime;
					if(shotTimer>=sTime/2){
						shotTimer = 0;
					}
					world.fire(force, degree, new BulletType(3, 32, 0, 0, false, invertions), this);
				}
			}
			if(c.left){
				if(!c.right){			
					move(c.precise?-vx*sm:-vx);
				}
			}else if(c.right){
				move(c.precise?vx*sm:vx);
			}

			if(c.up){
				if(!c.down){
					moveDeg(precise?sm*vd:vd);
				}
			}else if(c.down){
				moveDeg(precise?-sm*vd:-vd);
			}

			if(c.forceUp){
				if(!f.forceDown){
					moveForce(precise?sm*vf:vf);
				}
			}else if(f.forceDown){
				moveForce(precise?-sm*vf:-vf);
			}

			if(c.cycleLeft){
				invertions--;
			}
			if(c.cycleRight){
				invertions++;
			}
		}
	}
		
	public function move(vx:Float){
		x -= Main.dt*vx;
		if (x < 1){
			x = 1;
		}else if(x>638){
			x = 638;
		}else{
			fuel -= Main.dt*vx/10;
		}
	}

	public function moveDeg(vd:Float){
		degree += vd*Main.dt;
		if(degree<0){
			degree += Math.Pi;
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
}
