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
	
package invertotanks.menu;

/**
 * ...
 * @author ITR
 */
abstract MenuElement{
	public var name(default, null):String;
	public var x(default, null):Int;
	public var y(default, null):Int;
	public var w(default, null):Int;
	public var h(default, null):Int;
	public function new(name:String,x:Int,y:Int,w:Int,h:Int){
		this.name = name;
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}
	
	public override execute(){
		trace("Forgot to override execute() in "+name);
	}
}

class StartWorld extends MenuElement{
	public function new(x:Int,y:Int,w:Int,h:Int){
		super("Start");
		
	}
	
	public override execute(){
		
	}
}