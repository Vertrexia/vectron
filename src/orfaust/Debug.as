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
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.events.Event;
	import orfaust.DebugTextField;
	import orfaust.Rgb;
	import orfaust.Const;

	public class Debug
	{
		private static var _debug:DebugTextField;
		private static var _bg:Sprite;

		public function Debug():void
		{
			throw new Error('Debug is a static class and should not be instantiated');
		}

		private static var _hPos:String;
		private static var _vPos:String;
		public static function addToStage(s:Stage,hPos:String,vPos:String):void
		{
			if(_debug) return;

			_hPos = hPos;
			_vPos = vPos;

			_bg = new Sprite;
			_bg.graphics.beginFill(0xFFFFFF,.7);
			_bg.graphics.drawRect(0,0,100,50);
			_bg.graphics.endFill();
			s.addChild(_bg);

			_debug = new DebugTextField(new Rgb(255,255,255),200,50);
			s.addChild(_debug);
			setPosition();
			
			active = true;
		}

		private static var _active:Boolean = true;
		public static function set active(val:Boolean):void
		{
			_active = val;
			_debug.visible = val;
			_bg.visible = val;
			if(_active)
				_debug.stage.addEventListener(Event.RESIZE,onResize);
			else
				_debug.stage.removeEventListener(Event.RESIZE,onResize);
		}

		private static function onResize(e:Event):void
		{
			setPosition();
		}
		public static function setWidth(w:uint):void
		{
			_debug.width = w;
			_bg.width = w;
			setPosition();
		}
		public static function setHeight(h:uint):void
		{
			_debug.height = h;
			_bg.height = h;
			setPosition();
		}
		public static function setSize(w:uint,h:uint):void
		{
			setWidth(w);
			setHeight(h);
		}
		// SET color
		public static function setColor(rgb:Rgb):void
		{
			_debug.rgb = (rgb);
		}

		
		private static function setPosition():void
		{
			var sw = _debug.stage.stageWidth;
			var sh = _debug.stage.stageHeight;

			if(_hPos == Const.LEFT)
				_debug.x = 0;
			else if(_hPos == Const.RIGHT)
				_debug.x = sw - _debug.width - 1;
			else if(_hPos == Const.CENTER)
				_debug.x = sw / 2 - _debug.width / 2;

			if(_vPos == Const.TOP)
				_debug.y = 0;
			else if(_vPos == Const.BOTTOM)
				_debug.y = sh - _debug.height - 1;
			else if(_vPos == Const.CENTER)
				_debug.y = sh / 2 - _debug.height / 2;

			_bg.x = _debug.x;
			_bg.y = _debug.y;
		}
		
		// Debug.log
		private static var _line = 0;
		public static function log(data:*,label:String = ''):void
		{
			if(!_active || !_debug)
				return;

			trace(label + ': ' + data);

			_line ++;
			var string = _line.toString() + ' ' + label + ':\t';

			if(data != null)
				string += data;
			else
				string += 'null';

			_debug.appendText(string + '\n');

			_debug.scrollV = _debug.numLines;
		}

		public static function clear():void
		{
			_debug.text = '';
		}
	}
}