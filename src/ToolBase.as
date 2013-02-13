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

	import flash.events.MouseEvent

	import orfaust.Debug

	public class ToolBase extends SimpleButton implements ToolInterface
	{
		protected var _aamap:Aamap;
		protected var _cursorStart;
		protected var _snapCursorStart;
		protected var _connected:Boolean = false;

		public function connect():void
		{
			if(_connected)
				return;

			_aamap = Home.currentMap;

			stage.addEventListener(MouseEvent.MOUSE_DOWN,begin);
			_connected = true;
		}

		public function disconnect():void
		{
			if(!_connected)
				return;

			stage.removeEventListener(MouseEvent.MOUSE_DOWN,begin);
			_connected = false;
			close();
		}

		public function close():void
		{
			forceOverride('close()');
		}

		protected function begin(e:MouseEvent):void
		{
			forceOverride('begin()');
		}




/* errors */

		protected function forceOverride(f:String):void
		{
			error(f + ' should be overridden');
		}
		protected function error(e:String):void
		{
			throw new Error(e);
		}
	}
}