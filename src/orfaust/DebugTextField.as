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
	import flash.text.TextField;
	import flash.events.*;

	import orfaust.Rgb;

	public class DebugTextField extends TextField
	{
		private var _rgb:Rgb;
		private var _counter:uint = 0;

		public function DebugTextField(rgb:Rgb,w:uint,h:uint):void
		{
			_rgb = rgb;
			textColor = rgb.value;
			border = true;
			borderColor = rgb.value;
			multiline = true;
			wordWrap = false;

			width = w;
			height = h;
		}
		public function set rgb(rgb:Rgb):void
		{
			_rgb = rgb;
			textColor = rgb.value
			borderColor = rgb.value;
		}
	}
}