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
	import flash.display.SimpleButton;
	import flash.geom.Point;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import orfaust.Debug;
	import orfaust.CustomEvent;

	public class ToolZone extends ToolBase implements ToolInterface
	{
		public var defaultRadius:Number = 50;

		private var _zone:Zone;
		private var _a:Point;
		private var _b:Point;

		override protected function mouseDown(mouse:Point,keys:Object):void
		{
			if(_zone != null)
			{
				error('newzone != null');
				return;
			}

			_a = mouse;
			_zone = new Zone(_aamap,null,_a,defaultRadius);
			dispatchEvent(new CustomEvent('ADD_EDITING_OBJECT',_zone));
		}
		override protected function mouseUp(mouse:Point,keys:Object):void
		{
			close();
		}
		override protected function mouseMove(mouse:Point,keys:Object):void
		{
			if(!_mouseDown)
				return;

			if(_zone == null)
			{
				error('mouseDown but _zone == null');
				return;
			}

			_b = mouse;

			if(keys.alt)
			{
				var xDest = (_a.x + _b.x) / 2;
				var yDest = (_a.y + _b.y) / 2;

				var center = new Point(xDest,yDest);
				var radius = getDistance(_a,_b) / 2;

				_zone.moveCenter(center);
				_zone.radius = radius;
			}
			else
			{
				_zone.moveCenter(_a);
				_zone.changeRadius(_b);
			}
		}

		// CLOSE
		override public function close():void
		{
			if(_zone == null)
				return;

			_mouseDown = false;

			if(_zone.radius == 0)
				dispatchEvent(new Event('REMOVE_EDITING_OBJECT'));
			else
				dispatchEvent(new Event('EDITING_OBJECT_COMPLETE'));

			_zone = null;
		}
	}
}