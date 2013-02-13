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

	public class Zone extends AamapObject implements AamapObjectInterface
	{
		private var _center:Point;
		private var _radius:Number;
		private var _effect:String;

		private const DEFAULT_EFFECT = 'death';
		private static var zoneColor:Array = new Array;

		public static function init():void
		{
			zoneColor['death'] = 0xFF0000;
			zoneColor['win'] = 0x00FF00;
			zoneColor['fortress'] = 0x0000FF;
		}

		public function Zone(aamap:Aamap,xml:XML,center:Point,rad:Number,effect:String = DEFAULT_EFFECT):void
		{
			super(aamap,xml);

			_center = center;
			_radius = rad;
			_effect = effect;
			render();
		}

		public function moveCenter(center:Point):void
		{
			_center = center;
		}

		public function changeRadius(mouse:Point):void
		{
			var xDist = _center.x - mouse.x;
			var yDist = _center.y - mouse.y;

			_radius = Math.sqrt(xDist * xDist + yDist * yDist);
			render();
		}

		public function get radius():Number
		{
			return _radius;
		}
		public function set radius(r:Number):void
		{
			_radius = r;
			render();
		}

		override public function initXml():XML
		{
			_xml = new XML('<Zone effect="death"/>');
			updateXml();
			return _xml;
		}

		override public function updateXml():void
		{
			_xml.ShapeCircle.@radius = _radius;
			_xml.ShapeCircle.Point.@x = x + _center.x;
			_xml.ShapeCircle.Point.@y = y + _center.y;
		}

		override public function render():void
		{
			_area.graphics.clear();
			_area.graphics.lineStyle(SIZE_SELECTED,COLOR_SELECTED,1,false,LineScaleMode.NONE);
			_area.graphics.drawCircle(_center.x,_center.y,_radius);

			_draw.graphics.clear();
			_draw.graphics.lineStyle(2,zoneColor[_effect],1,false,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER);
			_draw.graphics.drawCircle(_center.x,_center.y,_radius);
		}

		public function get center():Point
		{
			return new Point(x + _center.x,y + _center.y);
		}
	}
}