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
	import flash.display.MovieClip
	import flash.text.TextField
	import flash.geom.Point

	import orfaust.SelfInit

	public class Info extends SelfInit
	{
		private static var _self:Info;
		private static var _scale:Number = 1;
		private static var _cursor:Point;
		public static var snapCursor:Point;

		public static var cursorTarget:AamapObject;

		override protected function init():void
		{
			_self = this;
		}

		public static function set cursor(c:Point):void
		{
			_cursor = c;
			_self.xVal.text = 'x: ' + _cursor.x.toString();
			_self.yVal.text = 'y: ' + _cursor.y.toString();
		}
		public static function get cursor():Point
		{
			return _cursor;
		}

		public static function set scale(val:Number):void
		{
			_scale = val;
			_self.zoomVal.text = 'zoom: ' + Math.floor(_scale * 100).toString() + '%';
		}
		public static function get scale():Number
		{
			return _scale;
		}
	}
}