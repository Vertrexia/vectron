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
	import flash.display.MovieClip
	import flash.events.Event
	import flash.events.ProgressEvent

	public class ProgBar extends SelfInit
	{
		public function setProgress(e:ProgressEvent):void
		{
			var ratio = e.bytesLoaded / e.bytesTotal;
			part.scaleX = ratio;
		}

		override public function show():void
		{
			part.scaleX = 0;
			visible = true;
		}

		override protected function onStageResize(e:Event):void
		{
			if(!visible)
				return;

			x = _sw / 2 - width / 2;
			y = _sh / 2 - height / 2;
		}
	}
}