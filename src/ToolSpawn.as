/*
*************************************************************************

Vectron - map editor for Armagetron Advanced.
Copyright (C) 2010 Carlo Veneziano (carlorfeo@gmail.com)

**************************************************************************

This file is part of Vectron.

Vectron is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Vectron is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Vectron.  If not, see <http://www.gnu.org/licenses/>.

*/

package
{
	import flash.display.SimpleButton
	import flash.geom.Point

	import flash.events.Event
	import flash.events.MouseEvent

	import orfaust.Debug
	import actions.action_AddObject

	public class ToolSpawn extends ToolBase implements ToolInterface
	{
		private var _spawn:Spawn;

		override protected function begin(e:MouseEvent):void
		{
			if(!UserEvents.lockMouse())
				return;

			if(_spawn != null)
				error('_spawn != null');

			_cursorStart = Info.snapCursor;
			_spawn = new Spawn(_aamap,null,_cursorStart);
			_aamap.editing.addChild(_spawn);

			stage.addEventListener(MouseEvent.MOUSE_MOVE,updateDirection,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_UP,addSpawn,false,0,true);
		}

		private function updateDirection(e:MouseEvent):void
		{
			var axes = _aamap.axes;

			// get mouse cursor's distance from spawn's center
			var diff = Info.cursor.subtract(_cursorStart);

			// get the real angle in radians
			var rad = Math.atan2(diff.y,diff.x);

			// add half axes portion for better interaction
			// i.e. let the arrow follow the mouse cursor
			rad += Math.PI / axes;

			// divide the circumference by current map axes
			// (snap spawn rotation to axes)
			var fraction = Math.floor(rad / Math.PI * axes / 2);

			// recalculate the snapped angle in radians
			var snapRad = (Math.PI * fraction) / axes * 2;

			// get sine and cosine
			var xDir = Math.cos(snapRad);
			var yDir = Math.sin(snapRad);

			// sin and cos functions return weird numbers in some cases...
			// fix required
			if(snapRad == Math.PI / 2 || snapRad == -Math.PI / 2)
				xDir = 0;
			else if(snapRad == Math.PI || snapRad == -Math.PI)
				yDir = 0;

			_spawn.direction = new Point(xDir,yDir);
		}

		private function addSpawn(e:MouseEvent):void
		{
			_aamap.history.push(new action_AddObject(_aamap,_spawn));
			close();
		}


		override public function close():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,updateDirection);
			stage.removeEventListener(MouseEvent.MOUSE_UP,addSpawn);
			_spawn = null;
			UserEvents.unlockMouse();
		}
	}
}