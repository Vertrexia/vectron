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

package orfaust
{
	import flash.geom.Point

	public class Segment
	{
		public var a:Point;
		public var b:Point;

		public function Segment(_a:Point,_b:Point):void
		{
			a = _a;
			b = _b;
		}

		public function intersects(s:Segment):Boolean
		{
			return ((ccw(a,b,s.a) * ccw(a,b,s.b)) <= 0) && ((ccw(s.a,s.b,a) * ccw(s.a,s.b,b)) <= 0);
		}

		private function ccw(p0:Point,p1:Point,p2:Point):int
		{
			var dx1 = p1.x - p0.x; 
			var dy1 = p1.y - p0.y;
			var dx2 = p2.x - p0.x; 
			var dy2 = p2.y - p0.y;

			if (dx1 * dy2 > dy1 * dx2)
				return 1;

			if (dx1 * dy2 < dy1*dx2)
				return -1;

			if ((dx1 * dx2 < 0) || (dy1 * dy2 < 0))
				return -1;

			if ((dx1 * dx1 + dy1 * dy1) < (dx2 * dx2 + dy2 * dy2))
				return 1;

			return 0;
		}

		public function intersectsCircle(c:Circle):Boolean
		{
			var dist = distanceFromPoint(c.center);
			if(dist >= c.radius)
				return false;

			return Point.distance(a,c.center) >= c.radius && Point.distance(a,c.center) >= c.radius;
		}

		public function distanceFromPoint(p:Point):Number
		{
			var diff = b.subtract(a);

			var r = scalarProduct(p.subtract(a), diff) / squareLength;

			if(r < 0)
				return Point.distance(a,p);

			if(r > 1)
				return Point.distance(b,p);

			var inter:Point = new Point(r * diff.x + a.x,r * diff.y + a.y);
			return Point.distance(inter,p);
		}

		public function scalarProduct(p1:Point,p2:Point):Number
		{
			return p1.x * p2.x + p1.y * p2.y;
		}

		public function get squareLength():Number
		{
			return (b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y);
		}
	}
}