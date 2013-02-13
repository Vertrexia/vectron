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
	public class Rgb
	{
		private static const MIN:uint = 0;
		private static const MAX:uint = 255;
		private var _r:uint;
		private var _g:uint;
		private var _b:uint;
		
		public function Rgb(red:uint = 0,green:uint = 0,blue:uint = 0):void
		{
			_r = checkVal(red);
			_g = checkVal(green);
			_b = checkVal(blue);
		}

		private function checkVal(val:uint):uint
		{
			if(val < MIN) return MIN;
			if(val > MAX) return MAX;
			return val;
		}
		public function set red(val:uint):void		{_r = checkVal(val);}
		public function get red():uint				{return _r;}

		public function set green(val:uint):void	{_g = checkVal(val);}
		public function get green():uint			{return _g;}

		public function set blue(val:uint):void		{_b = checkVal(val);}
		public function get blue():uint				{return _b;}
		
		public function get value():uint			{return _r * 65536 + _g * 256 + _b;}
	}
}