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
import h2d.Graphics;
import hxd.Key;
import js.html.MenuItemElement;

/**
 * ...
 * @author ITR
 */
class Renderer{
	public static var backgroundHeightMap:Array<Float>;
	public static var menuElements:Array<MenuElement>;
	public static var selectedMenuElement:Int;
	public static var exitElement:MenuItemElement
	
	public static function update(){	
		if (Key.isPressed(Key.UP) || Key.isPressed(Key.W)){
			selectedMenuElement = (selectedMenuElement + menuElements.length - 1) % menuElements.length;
		}else if (Key.isPressed(Key.DOWN) || Key.isPressed(Key.S)){
			selectedMenuElement = (selectedMenuElement + 1) % menuElements.length;
		}else if (Key.isPressed(Key.LEFT) || Key.isPressed(Key.A)||Key.isPressed(Key.ESCAPE)||Key.isPressed(Key.BACKSPACE)){
			if (exitElement != null){
				exitElement.execute();
			}
		}else if (Key.isPressed(Key.RIGHT) || Key.isPressed(Key.D) || Key.isPressed(Key.ENTER)||Key.isPressed(Key.SPACE)){
			menuElements[selectedMenuElement].execute();
		}
		
	}
	
	public static function draw(g:Graphics){
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
		
		for (menuElement in menuElements){
			if (selectedMenuElement){
				g.beginFill(0xFFDF00);
			}else{
				g.beginFill(0x009900);
			}
			g.drawRect(menuElement.x, menuElement.y, menuElement.w, menuElement.h);
			
			g.beginFill(0x00FF00);
			g.drawRect(menuElement.x+2, menuElement.y+2, menuElement.w-4, menuElement.h-4);			
		}
	}	

}