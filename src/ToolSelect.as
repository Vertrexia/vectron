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
	import flash.events.MouseEvent
	import flash.ui.Keyboard
	import flash.geom.Point

	import orfaust.Debug
	import orfaust.containers.LinkedList
	import orfaust.history.*
	import actions.*

	public class ToolSelect extends ToolBase implements ToolInterface
	{
		private var _selected:LinkedList = new LinkedList;
		private var _cursorMoved:Boolean = false;
		private var _dragStart:Point;
		private var _target:AamapObject;
		private var _selectArea:SelectArea;

		private var _connections:Array;

		override protected function begin(e:MouseEvent):void
		{
			if(UserEvents.mouseLocked)
				return;

			_cursorStart = Info.cursor;
			_snapCursorStart = Info.snapCursor;
			var target = Info.cursorTarget;

			if(target == null || UserEvents.keyIsDown(Keyboard.SHIFT))
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE,updateSelection);
				stage.addEventListener(MouseEvent.MOUSE_UP,endSelection);
			}
			else
			{
				if(!target.selected)
				{
					var collector = new ActionsCollector('Select: ' + target);
					deselectAll(collector);
					select(target,collector);
					_aamap.history.push(collector);
				}

				_selected.each(foreach);
				function foreach(object)
				{
					object.dragStart();
				}
				stage.addEventListener(MouseEvent.MOUSE_MOVE,moveSelected);
				stage.addEventListener(MouseEvent.MOUSE_UP,releaseSelected);
			}
		}

		private function updateSelection(e:MouseEvent):void
		{
			if(!_cursorMoved)
			{
				_cursorMoved = true;
				_selectArea = new SelectArea(_cursorStart);
				_aamap.addChild(_selectArea);
			}
			_selectArea.render(Info.cursor);
		}

		private function endSelection(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,updateSelection);
			stage.removeEventListener(MouseEvent.MOUSE_UP,endSelection);

			var shift = UserEvents.keyIsDown(Keyboard.SHIFT);

			if(_cursorMoved)
			{
				_cursorMoved = false;
				var collector = new ActionsCollector('Select area');

				if(_selected.length > 0 && !shift)
					deselectAll(collector);

				var objectsHit:Boolean = false;

				_selectArea.init();

				_aamap.objects.each(test);
				function test(object)
				{
					if(_selectArea.intersects(object))
					{
						if(!objectsHit)
							objectsHit = true;

						if(shift)
							toggleSelection(object,collector);
						else
							select(object,collector);
					}
				}
				if(!objectsHit)
					collector.name = 'Deselect all';

				if(collector.length > 0)
					_aamap.history.push(collector);

				_aamap.removeChild(_selectArea);
				_selectArea = null;
			}

			// _cursorMoved == false
			else
			{
				var target = Info.cursorTarget;

				if(shift)
				{
					if(target)
						toggleSelection(target,_aamap.history);
				}
				else
				{
					if(target == null && _selected.length > 0)
					{
						collector = new ActionsCollector('Deselect all');
						deselectAll(collector);
						_aamap.history.push(collector);
					}
				}
			}
		}

		private function toggleSelection(target:AamapObject,actionsContainer):void
		{
			if(_selected.find(target))
				deselect(target,actionsContainer);
			else
				select(target,actionsContainer);
		}

		private function moveSelected(e:MouseEvent):void
		{
			if(!_cursorMoved)
				_cursorMoved = true;

			_selected.each(move)
			function move(obj)
			{
				obj.x = Info.snapCursor.x + obj.lastPos.x - _snapCursorStart.x;
				obj.y = Info.snapCursor.y + obj.lastPos.y - _snapCursorStart.y;
			}
		}

		private function releaseSelected(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveSelected);
			stage.removeEventListener(MouseEvent.MOUSE_UP,releaseSelected);
			if(!_cursorMoved)
				return;

			_cursorMoved = false;
			var history = _aamap.history;

			if(_selected.length == 1)
			{
				moveObject(_selected.front as AamapObject,history);
			}
			else
			{
				var collector = new ActionsCollector('Move objects');
				_selected.each(move);
				function move(object)
				{
					moveObject(object,collector);
				}
				history.push(collector);
			}
		}

		private function moveObject(object:AamapObject,actionsContainer):void
		{
			var lastPos = object.lastPos;
			var dest = new Point(object.x,object.y);
			actionsContainer.push(new action_MoveObjectTo(object,dest,lastPos));
		}

		private function select(target:AamapObject,actionsContainer):void
		{
			actionsContainer.push(new action_SelectObject(_selected,target));
		}
		private function deselect(target:AamapObject,actionsContainer):void
		{
			actionsContainer.push(new action_DeselectObject(_selected,target));
		}

		private function deselectAll(actions:ActionsCollector):void
		{
			_selected.each(callBack);
			function callBack(object)
			{
				deselect(object,actions);
			}
		}

		private function dragStop(e:MouseEvent):void
		{
			close();
		}


		override public function close():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveSelected);
			stage.removeEventListener(MouseEvent.MOUSE_UP,dragStop);
		}

		override public function connect():void
		{
			if(_connected)
				return;

			_aamap = Home.currentMap;

			if(_connections == null)
				_connections = Config.getConnections('toolSelect');

			for each(var con in _connections)
			{
				if(con.id == 'REMOVE_OBJECTS')
					con.callBack = removeSelected;
				else if(con.id == 'SELECT_ALL')
					con.callBack = keybSelectAll;
				else if(con.id == 'DESELECT_ALL')
					con.callBack = keybDeselectAll;
				else if(con.id == 'INVERT_SELECTION')
					con.callBack = keybInvertSelection;

				var toolName = con.name.substr(5);

				UserEvents.connect(con);
			}

			stage.addEventListener(MouseEvent.MOUSE_DOWN,begin);
			_connected = true;
		}

		override public function disconnect():void
		{
			if(!_connected)
				return;

			stage.removeEventListener(MouseEvent.MOUSE_DOWN,begin);

			for each(var con in _connections)
			{
				UserEvents.disconnect(con);
			}
			keybDeselectAll();

			_connected = false;
			close();
		}

		private function removeSelected(e:* = null):void
		{
			if(_selected.length == 0)
				return;

			var collector = new ActionsCollector('RemoveObjects');

			deselectAll(collector);

			_selected.each(remove);
			function remove(object)
			{
				collector.push(new action_RemoveObject(_aamap,object));
			}
			_aamap.history.push(collector);
		}

		private function keybSelectAll(e:* = null):void
		{
			if(_selected.length == _aamap.objects.length)
				return;

			var collector = new ActionsCollector('Select all');
			_aamap.objects.each(sel);
			function sel(object)
			{
				select(object,collector);
			}
			if(collector.length > 0)
				_aamap.history.push(collector);
		}

		private function keybDeselectAll(e:* = null):void
		{
			if(_selected.length == 0)
				return;

			var collector = new ActionsCollector('Deselect all');
			deselectAll(collector);
			_aamap.history.push(collector);
		}

		private function keybInvertSelection(e:* = null):void
		{
			if(_aamap.objects.length == 0)
				return;

			var collector = new ActionsCollector('Invert selection');
			_aamap.objects.each(toggle);
			function toggle(object)
			{
				toggleSelection(object,collector);
			}
			_aamap.history.push(collector);
		}
	}
}