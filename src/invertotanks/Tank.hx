package invertotanks;

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
	private static inline var maxHeightDist = 3;

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
		shotTimer += Main.dt/60;
		if (c != null){
			var precise = c.precise;
			if(c.fire){	
				if(shotTimer>=sTime){
					shotTimer-=sTime;
					if(shotTimer>=sTime/2){
						shotTimer = 0;
					}
					world.fire(force, degree, new BulletType(3, 16, 24, 0, false, invertions), this);
				}
			}
			if(c.left){
				if(!c.right){			
					move(precise?-vx*pm:-vx);
				}
			}else if(c.right){
				move(precise?vx*pm:vx);
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

			if(c.cycleLeft){
				invertions--;
			}
			if(c.cycleRight){
				invertions++;
			}
		}
	}
		
	public function move(vx:Float){		
		x += Main.dt*vx;
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
	}
}
