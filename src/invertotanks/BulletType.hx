package invertotanks;

/**
 * ...
 * @author ITR
 */
class BulletType{
	static var bulletTypes:Array<BulletType>;
	
	public var r(default, null):Float;
	public var modRadius(default, null):Float;
	public var damageRadius(default, null):Float;
	public var damage(default, null):Float;
	public var builder(default, null):Bool;
	public var bounce(default, null):Bool;
	public var inverse(default, null):Int;
	
	
	public function new(r:Float, modRadius:Float, damageRadius:Float,
			damage:Float,builder:Bool,bounce:Bool,inverse:Int){
		this.r = r;
		this.modRadius = modRadius;
		this.damageRadius = damageRadius;
		this.damage = damage;
		this.builder = builder;
		this.bounce = bounce;
		this.inverse = inverse;
	}
	
}