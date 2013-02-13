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
	import flash.events.Event
	import flash.events.MouseEvent
	import flash.events.KeyboardEvent
	import flash.ui.Keyboard
	import flash.events.EventDispatcher
	import flash.utils.Dictionary

	import orfaust.Debug
	import orfaust.containers.LinkedList

	public class UserEvents
	{
		public static var dispatcher:EventDispatcher = new EventDispatcher;
		public static var shortCuts:Array = new Array;

		public static var _mouseLocked:Boolean = false;

		private static var _keysDown:LinkedList = new LinkedList;

		private static var _connections:Dictionary = new Dictionary;

		public static function connect(c:KeyboardConnection):void
		{
			var list = _connections[c.keyCode];
			if(list == null)
				_connections[c.keyCode] = list = new LinkedList;
			list.push(c);
		}

		public static function disconnect(c:KeyboardConnection):void
		{
			var list = _connections[c.keyCode];
			if(list == null)
				return;

			list.remove(c);
		}

		public static function keyIsDown(uint):Boolean
		{
			return _keysDown.find(uint);
		}

		public static function handleKeyboard(e:KeyboardEvent):void
		{
			var keyCode = e.keyCode;
			//Debug.log(keyCode);

			var list:LinkedList;
			switch(e.type)
			{
				case KeyboardEvent.KEY_DOWN:
					if(!_keysDown.find(keyCode))
					{
						_keysDown.push(keyCode);

						var conList = _connections[keyCode];
						if(conList != null)
						{
							conList.each(callBack);
							function callBack(c)
							{
								if(c.ctrl == e.ctrlKey &&
								   c.alt == e.altKey &&
								   c.shift == e.shiftKey)
								{
									c.callBack(c.args);
								}
							}
						}
					}

					// UNDO (u)
					if(keyCode == 85)
						Home.currentMap.history.undo();

					// REDO (g)
					if(keyCode == 71)
						Home.currentMap.history.redo();

					
					// UNDO ctrl + z, REDO crtrl + shift + z
					if(keyCode == 90 && e.ctrlKey)
					{
						if(e.shiftKey)
							Home.currentMap.history.redo();
						else
							Home.currentMap.history.undo();
					}

					break;

				case KeyboardEvent.KEY_UP:
					if(_keysDown.remove(keyCode))
					{
						
					}
					break;
			}
		}

		public static function lockMouse(e:Event = null):Boolean
		{
			if(_mouseLocked)
				return false;

			_mouseLocked = true;
			return true;
		}
		public static function unlockMouse(e:Event = null):void
		{
			_mouseLocked = false;
		}
		public static function get mouseLocked():Boolean
		{
			return _mouseLocked;
		}
	}
}