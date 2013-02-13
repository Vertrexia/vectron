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
	import actions.action_WallAppend
	import orfaust.history.ActionsCollector

	public class ToolWall extends ToolBase implements ToolInterface
	{
		private var _wall:Wall;

		override protected function begin(e:MouseEvent):void
		{
			if(!UserEvents.lockMouse())
				return;

			stage.addEventListener(MouseEvent.MOUSE_MOVE,moveLastPoint,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_UP,storeLastPoint,false,0,true);

			_cursorStart = Info.snapCursor;

			if(_wall == null || (_wall != null && _wall.vertices == 1))
			{
				_wall = new Wall(_aamap,null,_cursorStart);
				_aamap.editing.addChild(_wall);
				_wall.appendPoint(_cursorStart);

				Debug.log(_aamap.editing.numChildren,'editing');
			}
			else
			{
				if(!Info.snapCursor.equals(_wall.lastPoint))
					_wall.appendPoint(Info.snapCursor);
			}
		}

		private function moveLastPoint(e:MouseEvent):void
		{
			_wall.moveLastPoint(Info.snapCursor);
		}

		private function storeLastPoint(e:MouseEvent):void
		{
			if(Info.snapCursor.equals(_wall.lastPoint))
			{
				if(_wall.vertices > 1)
				{
					//_aamap.history.push(new action_AddObject(_aamap,_wall));
				}
				else
				{
					_aamap.editing.removeChild(_wall);
				}

				_wall = null;
				close();
			}
			else
			{
				var appendAction = new action_WallAppend(_wall,Info.snapCursor);

				if(_wall.vertices == 1)
				{
					var collector = new ActionsCollector('Create wall');
					collector.push(new action_AddObject(_aamap,_wall));
					collector.push(appendAction);

					_aamap.history.push(collector);
				}
				else
					_aamap.history.push(appendAction);
			}

			removeListeners();
			UserEvents.unlockMouse();
		}

		private function removeListeners():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveLastPoint);
			stage.removeEventListener(MouseEvent.MOUSE_UP,storeLastPoint);
		}

		override public function close():void
		{
			if(_wall != null)
			{
				_wall.storeLastPoint();
				_aamap.history.push(new action_AddObject(_aamap,_wall));
			}

			removeListeners();
			_wall = null;
			UserEvents.unlockMouse();
		}
	}
}