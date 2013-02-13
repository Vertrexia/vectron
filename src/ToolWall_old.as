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

	public class ToolWall extends ToolBase implements ToolInterface
	{
		private var _wall:Wall;

		override protected function mouseDown(mouse:Point,keys:Object):void
		{
			if(_wall == null)
			{
				_wall = new Wall(_aamap,null,mouse);
				dispatchEvent(new CustomEvent('ADD_EDITING_OBJECT',_wall));

				_wall.appendPoint(mouse);
			}
			else
			{
				var last = _wall.lastPoint;
				if(pointsEqual(mouse,last))
				{
					if(_wall.vertices == 0)
						dispatchEvent(new Event('REMOVE_EDITING_OBJECT'));
					else
						dispatchEvent(new Event('EDITING_OBJECT_COMPLETE'));

					_wall = null;
				}
				else
				{
					_wall.appendPoint(mouse);
				}
			}
		}
		override protected function mouseUp(mouse:Point,keys:Object):void
		{
			if(_wall == null)
				return;

			var last = _wall.lastPoint;
			if(pointsEqual(mouse,last))
			{
				if(_wall.vertices > 1)
					dispatchEvent(new Event('EDITING_OBJECT_COMPLETE'));
				else
					dispatchEvent(new Event('REMOVE_EDITING_OBJECT'));

				_wall = null;
			}
			else
				_wall.storeLastPoint();
		}
		override protected function mouseMove(mouse:Point,keys:Object):void
		{
			if(!_mouseDown || _wall == null)
				return;

			_wall.moveLastPoint(mouse);
		}

		// CLOSE
		override public function close():void
		{
			if(_wall == null)
				return;

			_wall.storeLastPoint();
			dispatchEvent(new Event('EDITING_OBJECT_COMPLETE'));
			_wall = null;

			_mouseDown = false;
		}
	}
}