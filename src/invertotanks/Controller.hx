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

	public inline function getP(i:Int):Bool {
		if (key[i] == null){
			return false;
		}
		//Consider using isReleased or alternative method to stop registering repeat
		return Key.isPressed(key[i]);
	}
	
	function get_up(){return get(0); };
	function get_down(){return get(1); };
	function get_left(){return get(2); };
	function get_right(){return get(3); };
	
	function get_cycleRight(){return getP(4); };
	function get_cycleLeft(){return getP(5); };
	function get_forceUp(){return get(6); };
	function get_forceDown(){return get(7); };
	
	function get_fire(){return getP(8); };
	function get_precise(){return get(9); };
	
}
