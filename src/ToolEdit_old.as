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

	import flash.ui.Keyboard;

	import orfaust.Debug;
	import orfaust.containers.List;

	public class ToolEdit extends ToolBase implements ToolInterface
	{
		override protected function mouseDown(mouse:Point,keys:Object):void
		{
		}
		override protected function mouseUp(mouse:Point,keys:Object):void
		{
		}
		override protected function mouseMove(mouse:Point,keys:Object):void
		{
		}

		override protected function objectMouseDown(obj:AamapObject,cursor:Point,keys:Object):void
		{
		}

		override protected function objectMouseUp(obj:AamapObject,cursor:Point,keys:Object):void
		{
		}

		override protected function objectMouseMove(obj:AamapObject,cursor:Point,keys:Object):void
		{
		}

		override public function handleKeyboard(keyList:List):void
		{
		}

		// CLOSE
		override public function close():void
		{
		}
	}
}