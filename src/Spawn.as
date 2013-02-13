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
	import flash.display.Sprite;
	import flash.geom.Point;

	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;

	import orfaust.Debug;
	import orfaust.Utils;

	public class Spawn extends AamapObject implements AamapObjectInterface
	{
		private var _direction:Point = new Point(1,0);

		private const COLOR = Utils.getColor(1,0,.8);

		public function Spawn(aamap:Aamap,xml:XML,center:Point,dir = null):void
		{
			super(aamap,xml);

			x = center.x;
			y = center.y;

			if(dir != null)
				direction = dir;

			render();
		}
		public function set direction(dir:Point):void
		{
			if(dir.x == _direction.x && dir.y == _direction.y)
				return;

			_direction = dir;
			var rad = Math.atan2(_direction.y,_direction.x);
			rotation = rad / Math.PI * 180;

			render();
		}

		public function get direction():Point
		{
			return _direction;
		}

		override public function initXml():XML
		{
			_xml = new XML('<Spawn/>');
			updateXml();
			return _xml;
		}

		override public function updateXml():void
		{
			_xml.@x = x;
			_xml.@y = y;
			_xml.@xdir = _direction.x;
			_xml.@ydir = _direction.y;
		}

		override public function render():void
		{
			_area.graphics.clear();
			_area.graphics.lineStyle(SIZE_SELECTED,COLOR_SELECTED,1,false,LineScaleMode.NONE);
			_area.graphics.moveTo(0,0);
			_area.graphics.lineTo(10,0);
			_area.graphics.moveTo(5,5);
			_area.graphics.lineTo(10,0);
			_area.graphics.lineTo(5,-5);

			_draw.graphics.lineStyle(2,COLOR,1,false,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER);
			_draw.graphics.moveTo(0,0);
			_draw.graphics.lineTo(10,0);
			_draw.graphics.moveTo(5,5);
			_draw.graphics.lineTo(10,0);
			_draw.graphics.lineTo(5,-5);
		}
	}
}