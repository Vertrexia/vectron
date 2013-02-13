package orfaust
{
	import flash.geom.Point

	public class Circle
	{
		public var center:Point;
		public var radius:Number;

		public function Circle(c:Point,r:Number):void
		{
			center = c;
			radius = r;
		}
	}
}