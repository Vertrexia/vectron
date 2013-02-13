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
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.geom.Point;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import flash.ui.Keyboard;

	import orfaust.Debug;
	import orfaust.containers.List;

	public class ToolSelect extends ToolBase implements ToolInterface
	{
		override protected function mouseDown(mouse:Point,keys:Object):void
		{
			if(!_mouseOverObject && !keys.shift)
				deselectAll();
		}

		private function deselectAll():void
		{
			if(_selected == null)
				return;

			_selected.each(deselect);
			function deselect(obj:AamapObject)
			{
				obj.selected = false;
			}
			_selected = null;
		}

		override protected function mouseUp(mouse:Point,keys:Object):void
		{
			if(_selected != null)
			{
				_selected.each(updateXml);
				function updateXml(obj:AamapObject)
				{
					obj.updateXml();
				}

				setInfo();
			}
			_dragStart = null;
		}
		override protected function mouseMove(mouse:Point,keys:Object):void
		{
			Home.pointer.visible = _mouseOverObject;
			Home.pointer.gotoAndStop(1);

			if(_dragStart == null || _selected == null)
				return;

			_selected.each(moveObj);
			function moveObj(obj:AamapObject)
			{
				var lastPos = obj.lastPos;

				obj.x = lastPos.x + mouse.x - _dragStart.x;
				obj.y = lastPos.y + mouse.y - _dragStart.y;
			}
		}

		override protected function objectMouseDown(obj:AamapObject,cursor:Point,keys:Object):void
		{
			// dragging the map?
			if(keys.ctrl)
				return;

			_dragStart = new Point(cursor.x,cursor.y);

			if(_selected == null)
			{
				_selected = new List;
				_selected.push(obj);
				obj.selected = true;
				obj.dragStart();
			}
			else
			{
				if(keys.shift)
				{
					if(_selected.find(obj))
					{
						_selected.remove(obj);
						obj.selected = false;
						_dragStart = null;
						if(_selected.length == 0)
							_selected = null;
					}
					else
					{
						_selected.push(obj);
						obj.selected = true;
						_dragStart = null;
					}
				}
				else
				{
					if(_selected.find(obj))
					{
						
					}
					else
					{
						_selected.each(deselect);
						function deselect(obj:AamapObject)
						{
							obj.selected = false;
						}
						_selected = new List;
						_selected.push(obj);
						obj.selected = true;
						obj.dragStart();
					}
				}

				_selected.each(dragStart);
				function dragStart(obj:AamapObject)
				{
					obj.dragStart();
				}
			}
		}

		override protected function objectMouseUp(obj:AamapObject,cursor:Point,keys:Object):void
		{
		}

		override protected function objectMouseMove(obj:AamapObject,cursor:Point,keys:Object):void
		{
		}

		override public function handleKeyboard(keyList:List):void
		{
			// remove selected (DELETE)
			if(keyList.find(Keyboard.DELETE))
			{
				removeSelected();
			}

			// select all (CTRL + A)
			else if(keyList.find(Keyboard.CONTROL) && keyList.find(65))
			{
				_selected = _aamap.objects;

				_selected.each(select);
				function select(obj:AamapObject)
				{
					obj.selected = true;
				}
			}

			// deselect all (CTRL + D)
			else if(keyList.find(Keyboard.CONTROL) && keyList.find(68))
			{
				deselectAll();
			}
		}

		public function removeSelected():void
		{
			if(_selected == null)
				return;

			_selected.each(remove);
			function remove(obj:AamapObject)
			{
				obj.remove();
			}
			_selected = null;
		}

		// CLOSE
		override public function close():void
		{
		}

		private function setInfo():void
		{
			if(_selected.length == 1)
			{
				var obj = _selected.front;

				if(obj is Spawn)
				{
					Debug.log('<Spawn x="' + obj.x + '" y="' + obj.y +
							  '" xdir="' + obj.direction.x + '" ydir="' + obj.direction.y + '"/>');
				}
				else if(obj is Zone)
				{
					Debug.log(obj.xml);
				}
				else if(obj is Wall)
				{
					Debug.log(obj.xml);
				}
			}
			else
			{
				//clear info
			}
		}
	}
}