package invertotanks;
import format.abc.Data.Function;
import hxd.Key;

/**
 * ...
 * @author ITR
 */
class Controller{
	public var up(get,null):Bool;
	public var down(get,null):Bool;
	public var left(get,null):Bool;
	public var right(get,null):Bool;
	
	public var cycleLeft(get,null):Bool;
	public var cycleRight(get,null):Bool;
	public var forceUp(get,null):Bool;
	public var forceDown(get,null):Bool;
	
	public var fire(get,null):Bool;
	public var precise(get,null):Bool;

	private var key:Array<Int>;
	
	public function new(up:Int, down:Int, left:Int, right:Int, cycleLeft:Int,
			cycleRight:Int, forceUp:Int,forceDown:Int,fire:Int,precise:Int){
		key = new Array();
		key.push(up);
		key.push(down);
		key.push(left);
		key.push(right);
		key.push(cycleLeft);
		key.push(cycleRight);
		key.push(forceUp);
		key.push(forceDown);
		key.push(fire);
		key.push(precise);
	}
	
	@:arrayAccess
	public inline function get(i:Int):Bool {
		if (key[i] == null){
			return false;
		}
		return Key.isDown(key[i]);
	}
	
	function get_up(){return get(0); };
	function get_down(){return get(1); };
	function get_left(){return get(2); };
	function get_right(){return get(3); };
	
	function get_cycleRight(){return get(4); };
	function get_cycleLeft(){return get(5); };
	function get_forceUp(){return get(6); };
	function get_forceDown(){return get(7); };
	
	function get_fire(){return get(8); };
	function get_precise(){return get(9); };
	
}