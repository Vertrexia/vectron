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

	public class ToolZone extends ToolBase implements ToolInterface
	{
		public var defaultRadius:Number = 50;

		private var _zone:Zone;
		public var effect = 'death';

		override protected function begin(e:MouseEvent):void
		{
			if(!UserEvents.lockMouse())
				return;

			if(_zone != null)
				error('_zone != null');

			_cursorStart = Info.snapCursor;
			_zone = new Zone(_aamap,null,_cursorStart,defaultRadius,effect);
			_aamap.editing.addChild(_zone);

			stage.addEventListener(MouseEvent.MOUSE_MOVE,updateZone,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_UP,addZone,false,0,true);
		}

		private function updateZone(e:MouseEvent):void
		{
			var dist = Point.distance(_cursorStart,Info.snapCursor)

			if(e.altKey)
			{
				var center = Point.interpolate(_cursorStart,Info.snapCursor,.5);
				var radius = dist / 2;
			}
			else
			{
				center = _cursorStart;
				radius = dist;
			}
			_zone.moveCenter(center);
			_zone.radius = radius;
		}

		private function addZone(e:MouseEvent):void
		{
			if(_zone == null)
				error('_zone == null');

			_aamap.history.push(new action_AddObject(_aamap,_zone));
			close();
		}

		override public function close():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,updateZone);
			stage.removeEventListener(MouseEvent.MOUSE_UP,addZone);
			_zone = null;
			UserEvents.unlockMouse();
		}
	}
}