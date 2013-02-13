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
	import flash.display.MovieClip

	import flash.events.Event
	import flash.events.MouseEvent
	import flash.events.KeyboardEvent
	import flash.ui.Keyboard

	import flash.geom.Point

	import orfaust.Debug
	import orfaust.Segment
	import orfaust.Circle

	public class Home extends Base
	{
		private var _snapToGrid:Boolean = true;

		override protected function init():void
		{
			super.loadUrl('xml/config.xml',configLoaded);

			pointer.visible = false;
			Zone.init();
		}

		private function configLoaded(e:Event):void
		{
			Config.init(e.target.data);
			toolBar.connect();

			var aamapUrl = 'aamap/vectron-1.0.aamap.xml';
			progBar.show();
			super.loadUrl(aamapUrl,initMap,progBar.setProgress);
		}


/* Aamap */

		private static var _currentMap:Aamap;
		public static function get currentMap():Aamap
		{
			return _currentMap;
		}

		private function initMap(e:Event):void
		{
			progBar.hide();

			try
			{
				_currentMap = new Aamap(e.target.data);
			}
			catch(e)
			{
				Debug.log(e);
				return;
			}
			mapContainer.addChild(_currentMap);

			stage.addEventListener(KeyboardEvent.KEY_DOWN,UserEvents.handleKeyboard);
			stage.addEventListener(KeyboardEvent.KEY_UP,UserEvents.handleKeyboard);

			stage.addEventListener(MouseEvent.MOUSE_DOWN,begin);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,setInfo);

			stage.addEventListener(MouseEvent.MOUSE_WHEEL,zoom);

			_currentMap.addEventListener(MouseEvent.ROLL_OVER,showSelectPointer,true);
			_currentMap.addEventListener(MouseEvent.ROLL_OUT,hideSelectPointer);

			grid.size = new Point(10,10);
			//grid.visible = false;
			grid.render(_currentMap);

			toolBar.active.connect();
		}

		private function showSelectPointer(e:MouseEvent):void
		{
			pointer.visible = true;
			if(e.target is SelectableArea)
				Info.cursorTarget = e.target.parent as AamapObject;				
			else
				Info.cursorTarget = e.target as AamapObject;
		}
		private function hideSelectPointer(e:MouseEvent):void
		{
			pointer.visible = false;
			Info.cursorTarget = null;
		}


/* zoom */

		private function zoom(e:MouseEvent):void
		{
			if(e.delta > 0)
				_currentMap.zoomIn();
			else
				_currentMap.zoomOut();

			grid.render(_currentMap);
			setInfo();
		}

		private function setInfo(e:MouseEvent = null):void
		{
			pointer.x = stage.mouseX;
			pointer.y = stage.mouseY;

			var xCursor = (stage.mouseX - _currentMap.x) / _currentMap.scaleX;
			var yCursor = (stage.mouseY - _currentMap.y) / _currentMap.scaleY;

			if(_snapToGrid)
			{
				var gridSize = grid.size;

				var xSnap = Math.floor((xCursor + gridSize.x / 2) / gridSize.x) * gridSize.x;
				var ySnap = Math.floor((yCursor + gridSize.y / 2) / gridSize.y) * gridSize.y;

				snapPointer.x = _currentMap.x + xSnap * _currentMap.scaleX;
				snapPointer.y = _currentMap.y + ySnap * _currentMap.scaleY;

				Info.snapCursor = new Point(xSnap,ySnap);
			}
			else
			{
				snapPointer.x = _currentMap.x + Info.cursor.x * Info.scale;
				snapPointer.y = _currentMap.y - Info.cursor.y * Info.scale;
				Info.snapCursor = new Point(xCursor,yCursor);
			}

			Info.cursor = new Point(xCursor,yCursor);
		}



/* drag map */

		private function begin(e:MouseEvent):void
		{
			if(UserEvents.keyIsDown(Keyboard['SPACE']))
			{
				if(!UserEvents.lockMouse())
					return;

				_currentMap.startDrag();
				stage.addEventListener(MouseEvent.MOUSE_MOVE,updateGrid);
				stage.addEventListener(MouseEvent.MOUSE_UP,end);
			}
		}
		private function end(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,updateGrid);
			stage.removeEventListener(MouseEvent.MOUSE_UP,end);
			_currentMap.stopDrag();
			UserEvents.unlockMouse();
		}
		private function updateGrid(e:MouseEvent):void
		{
			grid.render(_currentMap);
		}
	}
}