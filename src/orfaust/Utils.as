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
	public class Utils
	{
		// get 0-1 RGB values transformed into a 24 bits color value
		private static const FACTOR_8BITS = 255;
		private static const RED_FACTOR = 65536; // 256 ^ 2
		private static const GREEN_FACTOR = 256;

		public static function getColor(r:Number,g:Number,b:Number):uint
		{
			if(r > 1 || g > 1 || b > 1)
				throw(new Error('color value out of range (0-1)'));

			var r8bits = Math.floor(r * FACTOR_8BITS);
			var g8bits = Math.floor(g * FACTOR_8BITS);
			var b8bits = Math.floor(b * FACTOR_8BITS);

			return r8bits * RED_FACTOR + g8bits * GREEN_FACTOR + b8bits;
		}
	}
}