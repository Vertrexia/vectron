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
	import flash.display.MovieClip;

	import flash.text.TextField;
	import flash.text.TextFormat;

	import flash.events.Event;
	import flash.events.TimerEvent;

	import flash.utils.Timer;
	import flash.system.System;

	public class Monitor extends MovieClip
	{
		public function Monitor(ms:uint = 1000):void
		{
			_clock = new Timer(ms)
			addEventListener(Event.ADDED_TO_STAGE,init,false,0,true);
		}

		private var _ram:TextField = new TextField;
		private var _textFormat:TextFormat;
		private var _clock:Timer;

		private function init(e:Event):void
		{
			_ram.text = 'RAM 0';

			_textFormat = _ram.getTextFormat();
			_textFormat.font = 'Arial';
			_textFormat.size = 10;

			_ram.setTextFormat(_textFormat);
			addChild(_ram);

			if(visible)
			{
				_clock.addEventListener(TimerEvent.TIMER,onClock,false,0,true);
				_clock.start();
			}
		}
		private function onClock(e:TimerEvent):void
		{
			var usedRam = System.totalMemory / (1024);
			_ram.text = 'RAM ' + int(usedRam).toString();
			_ram.setTextFormat(_textFormat);
		}
	}
}