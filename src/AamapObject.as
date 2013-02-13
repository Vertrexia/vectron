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

	import orfaust.Debug;

	public class AamapObject extends Sprite implements AamapObjectInterface
	{
		protected var _draw:SelectableArea;
		protected var _area:SelectableArea;
		protected const SIZE_SELECTED = 7;
		protected const COLOR_SELECTED = 0x7777FF;

		protected var _aamap:Aamap;
		protected var _xml:XML;

		protected var _lastPos:Point;

		public function AamapObject(aamap:Aamap,xml:XML):void
		{
			_aamap = aamap;
			_xml = xml;

			_area = new SelectableArea;
			_area.alpha = 0;
			addChild(_area);

			_draw = new SelectableArea;
			addChild(_draw);
		}

		public function updateXml():void
		{}

		public function get xml():XML
		{
			return _xml;
		}
		public function initXml():XML
		{
			return null;
		}

		public function render():void
		{}

		public function get selected():Boolean
		{
			return _area.alpha != 0;
		}
		public function set selected(state:Boolean):void
		{
			_area.alpha = int(state) * .5;
		}

		public function dragStart():void
		{
			_lastPos = new Point(x,y);
		}
		public function get lastPos():Point
		{
			return _lastPos;
		}

		public function remove():void
		{
			_aamap.removeObject(this);
		}
	}
}