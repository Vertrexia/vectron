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
	import flash.geom.Rectangle;

	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;

	import orfaust.Debug;
	import orfaust.Utils;

	public class Grid extends Sprite
	{
		public var size:Point = new Point(1,1);

		public var color = Utils.getColor(.8,.8,.9);
		public var axesColor = Utils.getColor(.0,.6,.7);

		private const MIN_STEP = 10;

		public function render(aamap:Aamap):void
		{
			if(!visible)
				return;

			var hStep = size.x * aamap.scaleX;
			while(hStep < MIN_STEP)
				hStep *= 2;

			var hStart = aamap.x % hStep;
			
			var vStep = size.y * (-aamap.scaleY);
			while(vStep < MIN_STEP)
				vStep *= 2;

			var vStart = aamap.y % vStep;

			var sW = stage.stageWidth;
			var sH = stage.stageHeight;

			graphics.clear();
			graphics.lineStyle(1,color);

			for(var h = hStart; h < sW; h += hStep)
			{
				graphics.moveTo(h,0);
				graphics.lineTo(h,sH);
			}

			for(var v = vStart; v < sH; v += vStep)
			{
				/*
				if(v == 0)
					graphics.lineStyle(1,axesColor);
				else
				*/
					graphics.lineStyle(1,color);

				graphics.moveTo(0,v);
				graphics.lineTo(sW,v);
			}
		}
	}
}