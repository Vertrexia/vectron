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
	import flash.display.Sprite
	import flash.display.LineScaleMode
	import flash.geom.Point
	import flash.geom.Rectangle

	import orfaust.Segment
	import orfaust.Circle
	import orfaust.containers.LinkedList
	import orfaust.Debug

	public class SelectArea extends Sprite
	{
		var _corner:Point = new Point(0,0);

		public function SelectArea(pos:Point):void
		{
			x = pos.x;
			y = pos.y;
		}

		public function render(corner:Point):void
		{
			graphics.clear();
			graphics.beginFill(0x0088FF,.2);
			graphics.lineStyle(1,0x0088FF,1,false,LineScaleMode.NONE);
			graphics.drawRect(0,0,corner.x - x,corner.y - y);
			_corner = corner;
		}

		public function intersects(object:AamapObject):Boolean
		{
			// if area does not even hit the object, skip any further testing
			if(!hitTestObject(object))
				return false;

			// area contains the object?
			if(getRect(Home.currentMap).containsRect(object.getRect(Home.currentMap)))
				return true;

			// WALL
			if(object is Wall)
			{
				if(Wall(object).vertices < 2)
					return false;

				var points:LinkedList = Wall(object).points;

				var it = points.iterator;
				var p1 = points.back;
				var p2;

				while(true)
				{
					it.next();
					if(it.valid)
						p2 = it.data;
					else
						break;

					var realP1 = new Point(object.x + p1.x,object.y + p1.y);
					var realP2 = new Point(object.x + p2.x,object.y + p2.y);

					var seg:Segment = new Segment(realP1,realP2);

					var intersectionFound = false;
					_segments.each(testSegment);
					function testSegment(s)
					{
						if(intersectionFound)
							return;

						if(s.intersects(seg))
							intersectionFound = true;
					}
					if(intersectionFound)
						return true;

					p1 = p2;
				}
			}

			// ZONE
			else if(object is Zone)
			{
				var circle = new Circle(Zone(object).center,Zone(object).radius);

				intersectionFound = false;
				_segments.each(testCircle);
				function testCircle(s)
				{
					if(intersectionFound)
						return;

					if(s.intersectsCircle(circle))
						intersectionFound = true;
				}
				if(intersectionFound)
					return true;
			}
			return false;
		}

		private var _segments:LinkedList;
		public function init():void
		{
			var p1 = new Point(x,y);
			var p2 = new Point(_corner.x,y);
			var p3 = new Point(_corner.x,_corner.y);
			var p4 = new Point(x,_corner.y);

			_segments = new LinkedList;
			_segments.push(new Segment(p1,p2));
			_segments.push(new Segment(p2,p3));
			_segments.push(new Segment(p3,p4));
			_segments.push(new Segment(p4,p1));
		}
	}
}