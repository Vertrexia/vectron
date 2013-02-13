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

	public class SelfInit extends MovieClip
	{
		public function SelfInit():void
		{
			addEventListener(Event.ADDED_TO_STAGE,addResizeListener,false,0,true);
		}
		protected function addResizeListener(e:Event):void
		{
			stage.addEventListener(Event.RESIZE,onStageResize);
			onStageResize(null);
			init();
		}
		protected function init():void
		{}

		protected function onStageResize(e:Event):void
		{}

		protected function get _sw():Number
		{
			return stage.stageWidth;
		}
		protected function get _sh():Number
		{
			return stage.stageHeight;
		}

		public function hide():void
		{
			visible = false;
		}
		public function show():void
		{
			visible = true;
		}

		public function forEachChild(callBack:Function):void
		{
			for(var i = 0; i < numChildren; i ++)
				callBack(getChildAt(i));
		}
	}
}