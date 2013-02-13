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
	import flash.display.MovieClip;
	import flash.display.Sprite;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import flash.net.FileReference;

	import orfaust.Debug;
	import orfaust.CustomEvent;
	import orfaust.containers.List;
	

	public class Home extends Base
	{
		private var _aamap:Aamap;

		private var _tool:ToolInterface;
		private static var _pointer:MovieClip;
		private static var _snapToGrid:Boolean = true;

		private const ZOOM_FACTOR = .95;
		private var _scale = 1;
		private static var _cursor:Point = new Point(0,0);

		private var _infoHandlerMouseDown:Boolean = false;
		private const INFO_MAX_WIDTH = 230;

		private var _draggingMap:Boolean = false;
		private var _keyDown:List = new List;




		override protected function init():void
		{
			pointer.visible = false;
			_pointer = pointer;

			// testing urls to load external maps

			//var xmlUrl = 'aamap.php?url=';

			//xmlUrl += 'resource.armagetronad.net/resource/ZURD/race/Crossdeath-1.0.1.aamap.xml';
			//xmlUrl += 'resource.armagetronad.net/resource/ZURD/race/ecdmazed-1.aamap.xml';
			//xmlUrl += 'resource.armagetronad.net/resource/hoop/motorace/tester-0.1.aamap.xml';
			//xmlUrl += 'resource.armagetronad.net/resource/hoop/race/alba-1.6.aamap.xml';
			//xmlUrl += 

			//var xmlUrl = 'aamap/default-1.0.1.aamap.xml';
			var xmlUrl = 'aamap/vectron-1.0.aamap.xml';

			Zone.init();

			stage.addEventListener(Event.RESIZE,onStageResize,false,0,true);
			onStageResize(null);

			infoHandler.addEventListener(MouseEvent.MOUSE_DOWN,handleInfoSize,false,0,true);
			infoHandler.addEventListener(MouseEvent.MOUSE_UP,handleInfoSize,false,0,true);
			infoHandler.addEventListener(MouseEvent.ROLL_OVER,infoHandlerHover,false,0,true);
			infoHandler.addEventListener(MouseEvent.ROLL_OUT,infoHandlerHover,false,0,true);
			infoHandler.addEventListener(MouseEvent.MOUSE_MOVE,infoHandlerHover,false,0,true);

			toolBar.tools.addEventListener(MouseEvent.CLICK,onToolClick,false,0,true);
			toolBar.addEventListener(MouseEvent.ROLL_OVER,breakToolEvents,false,0,true);
			toolBar.addEventListener(MouseEvent.ROLL_OUT,breakToolEvents,false,0,true);

			info.addEventListener(MouseEvent.ROLL_OVER,breakToolEvents,false,0,true);
			info.addEventListener(MouseEvent.ROLL_OUT,breakToolEvents,false,0,true);
			infoHandler.addEventListener(MouseEvent.ROLL_OVER,breakToolEvents,false,0,true);
			infoHandler.addEventListener(MouseEvent.ROLL_OUT,breakToolEvents,false,0,true);

			_tool = toolBar.tools.select;

			stage.addEventListener(KeyboardEvent.KEY_DOWN,handleKeyboard,false,0,true);
			stage.addEventListener(KeyboardEvent.KEY_UP,handleKeyboard,false,0,true);

			super.loadUrl(xmlUrl,initMap,loadingProgress);
		}

		private function handleInfoSize(e:MouseEvent):void
		{
			if(e.type == MouseEvent.MOUSE_DOWN)
				infoHandler.startDrag(false,new Rectangle(0,0,INFO_MAX_WIDTH,0));
			else
				infoHandler.stopDrag();
		}
		private function infoHandlerHover(e:MouseEvent):void
		{
			pointer.visible = true;
			pointer.gotoAndStop(2);

			if(e.type == MouseEvent.ROLL_OVER || e.type == MouseEvent.MOUSE_MOVE)
			{
				infoMask.width = infoHandler.x;
				pointer.x = stage.mouseX;
				pointer.y = stage.mouseY;
			}
			else
			{
				pointer.visible = false;
			}
		}



		public static function get mapCursor():Point
		{
			return _cursor;
		}
		public static function set snapToGrid(val:Boolean)
		{
			_snapToGrid = val;
		}

		public static function get pointer():MovieClip
		{
			return _pointer;
		}



/* zoom */

		private function zoom(e:MouseEvent):void
		{
			if(e.delta > 0)
				zoomIn();
			else
				zoomOut();
		}

		private function zoomIn():void
		{
			if(_scale > 50)
				return;

			var factor = _scale;
			_scale /= ZOOM_FACTOR;

			setScale();
			factor = _scale - factor;

			_aamap.x -= _cursor.x * factor;
			_aamap.y -= -_cursor.y * factor;

			grid.render(_aamap);
			setInfo();
		}
		private function zoomOut():void
		{
			if(_scale < .05)
				return;

			var factor = _scale;
			_scale *= ZOOM_FACTOR;

			setScale();
			factor -= _scale;

			_aamap.x += _cursor.x * factor;
			_aamap.y += -_cursor.y * factor;

			grid.render(_aamap);
			setInfo();
		}

		private function setScale():void
		{
			_aamap.scaleX = _scale;
			_aamap.scaleY = -_scale;
		}

		private function setInfo():void
		{
			_cursor.x = (stage.mouseX - _aamap.x) / _scale;
			_cursor.y = (-stage.mouseY + _aamap.y) / _scale;

			snapPointer.visible = _snapToGrid;
			if(_snapToGrid)
			{
				var gridSize = grid.size;

				var xSnap = Math.floor((_cursor.x + gridSize.x / 2) / gridSize.x);
				var ySnap = Math.floor((_cursor.y + gridSize.y / 2) / gridSize.y);

				_cursor.x = xSnap * gridSize.x;
				_cursor.y = ySnap * gridSize.y;

				snapPointer.x = _aamap.x + _cursor.x * _aamap.scaleX;
				snapPointer.y = _aamap.y + _cursor.y * _aamap.scaleY;
			}

			info.txt.text =
				'x: ' + _cursor.x.toString() + '\n' + 
				'y: ' + (_cursor.y).toString() + '\n' +
				'zoom: ' + Math.floor(_scale * 100).toString() + '%';
		}




/* tools */

		private function breakToolEvents(e:MouseEvent):void
		{
			if(e.type == 'rollOver')
			{
				//removeMapListeners();
				_tool.close();
				snapPointer.visible = false;
			}
			else
			{
				//addMapListeners();
			}
		}

		private function onToolClick(e:MouseEvent):void
		{
			switchTool(e.target);
		}

		private function switchTool(selected:*):void
		{
			if(selected == _tool || selected == toolBar || selected == toolBar.overlay)
				return;

			pointer.visible = false;

			_tool.close();
			//removeToolListeners();

			_tool = selected;
			toolBar.overlay.x = toolBar.tools.x + selected.x;
			//addToolListeners();
		}

		private function addToolListeners():void
		{
			_tool.addEventListener('ADD_EDITING_OBJECT',addEditingObject,false,0,true);
			_tool.addEventListener('EDITING_OBJECT_COMPLETE',editingObjectComplete,false,0,true);
			_tool.addEventListener('REMOVE_EDITING_OBJECT',removeEditingObject,false,0,true);

			if(_tool == toolBar.tools.select)
			{
				_aamap.addEventListener(MouseEvent.MOUSE_DOWN,handleObjectMouseEvent,false,0,true);
				_aamap.addEventListener(MouseEvent.MOUSE_UP,handleObjectMouseEvent,false,0,true);
				_aamap.addEventListener(MouseEvent.MOUSE_MOVE,handleObjectMouseEvent,false,0,true);
				_aamap.addEventListener('OBJECT_ROLL_OVER',handleObjectHover,false,0,true);
				_aamap.addEventListener('OBJECT_ROLL_OUT',handleObjectHover,false,0,true);
			}
		}

		private function removeToolListeners():void
		{
			_tool.removeEventListener('ADD_EDITING_OBJECT',addEditingObject);
			_tool.removeEventListener('EDITING_OBJECT_COMPLETE',editingObjectComplete);
			_tool.removeEventListener('REMOVE_EDITING_OBJECT',removeEditingObject);

			if(_tool == toolBar.tools.select)
			{
				_aamap.removeEventListener(MouseEvent.MOUSE_DOWN,handleObjectMouseEvent);
				_aamap.removeEventListener(MouseEvent.MOUSE_UP,handleObjectMouseEvent);
				_aamap.removeEventListener(MouseEvent.MOUSE_MOVE,handleObjectMouseEvent);
				_aamap.removeEventListener('OBJECT_ROLL_OVER',handleObjectHover);
				_aamap.removeEventListener('OBJECT_ROLL_OUT',handleObjectHover);
			}
		}






/* map */

		private function initMap(e:Event):void
		{
			progBar.visible = false;

			try
			{
				_aamap = new Aamap(e.target.data);
			}
			catch(e)
			{
				Debug.log(e);
				return;
			}

			mapContainer.addChild(_aamap);
			_aamap.scaleY = -1;

			_aamap.x = _sW / 2;
			_aamap.y = _sH / 2;

			//addToolListeners();
			//addMapListeners();
			stage.addEventListener(MouseEvent.MOUSE_WHEEL,zoom,false,0,true);

			toolBar.save.addEventListener(MouseEvent.CLICK,saveXml,false,0,true);
			toolBar.open.addEventListener(MouseEvent.CLICK,loadXml,false,0,true);

			grid.size = new Point(10,10);
			//grid.visible = false;
			grid.render(_aamap);
			setInfo();
		}


		private function removeSelected(e:MouseEvent):void
		{
			toolBar.tools.select.removeSelected();
		}

		private function saveXml(e:MouseEvent):void
		{
			Debug.clear();
			Debug.log('\n' + _aamap.xml);
		}

		private function loadXml(e:MouseEvent):void
		{
			
		}



		private function addMapListeners():void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN,handleStageMouseEvent,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_UP,handleStageMouseEvent,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,handleStageMouseEvent,true,0,true);
		}
		private function removeMapListeners():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,handleStageMouseEvent);
			stage.removeEventListener(MouseEvent.MOUSE_UP,handleStageMouseEvent);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,handleStageMouseEvent);
		}




/* editing */

		private function handleStageMouseEvent(e:MouseEvent):void
		{
			Debug.log(e.target);

			// drag map
			if(e.ctrlKey && e.type != MouseEvent.MOUSE_MOVE && !_tool.objectDragging || _draggingMap)
			{
				switch(e.type)
				{
					case MouseEvent.MOUSE_DOWN:
						_aamap.startDrag();
						_draggingMap = true;
						_pointer.visible = false;
						break;

					case MouseEvent.MOUSE_UP:
						_aamap.stopDrag();
						_draggingMap = false;
						break;

					case MouseEvent.MOUSE_MOVE:
						grid.render(_aamap);
						break;
				}
			}

			else
			{
				if(e.type == MouseEvent.MOUSE_MOVE)
				{
					pointer.x = stage.mouseX;
					pointer.y = stage.mouseY;
				}
				_tool.handleMouse(e,_aamap);
			}

			setInfo();
		}

		private function handleObjectMouseEvent(e:MouseEvent):void
		{
			_tool.handleObjectMouseEvent(e,_cursor);
		}

		private function handleObjectHover(e:CustomEvent):void
		{
			_tool.handleObjectMouseHover(e);
		}


		// KEYBOARD
		private function handleKeyboard(e:KeyboardEvent):void
		{
			//Debug.log(e.keyCode);
			var ch = e.keyCode;

			switch(e.type)
			{
				case KeyboardEvent.KEY_DOWN:
					if(!_keyDown.find(ch))
						_keyDown.push(ch);

					if(!e.ctrlKey && !e.altKey && ! e.shiftKey)
						shortCuts(ch);

					break;

				case KeyboardEvent.KEY_UP:
					if(_keyDown.find(ch))
						_keyDown.remove(ch);

					break;
			}
			_tool.handleKeyboard(_keyDown);
		}

		private function shortCuts(ch):void
		{
			switch(ch)
			{
				case 65:	// A -> edit tool
					switchTool(toolBar.tools.edit);
					break;

				case 83:	// S -> spawn tool
					switchTool(toolBar.tools.spawn);
					break;

				case 86:	// V -> select tool
					switchTool(toolBar.tools.select);
					break;

				case 87:	// W -> wall tool
					switchTool(toolBar.tools.wall);
					break;

				case 90:	// Z -> zone tool
					switchTool(toolBar.tools.zone);
					break;
			}
		}



/* tool listeners */

		private function addEditingObject(e:CustomEvent):void
		{
			if(_aamap.editing.numChildren != 0)
				error('editing is not empty');
			else
			{
				_aamap.editing.addChild(e.data);
			}
		}
		private function editingObjectComplete(e:Event):void
		{
			if(_aamap.editing.numChildren == 0)
				error('editing is empty');

			else if(_aamap.editing.numChildren > 1)
				error('editing contains more than 1 object');

			else
			{
				var obj = _aamap.editing.getChildAt(0);
				_aamap.addObject(obj);
			}
		}
		private function removeEditingObject(e:Event):void
		{
			if(_aamap.editing.numChildren == 0)
				error('editing is empty');

			else if(_aamap.editing.numChildren > 1)
				error('editing contains more than 1 object');

			else
			{
				var obj = _aamap.editing.getChildAt(0);
				_aamap.editing.removeChild(obj);
			}
		}

		private function objectDragStart(e:CustomEvent):void
		{
			var obj = e.data as AamapObject;
			obj.startDrag();
		}

		private function objectDragStop(e:CustomEvent):void
		{
			var obj = e.data as AamapObject;
			obj.stopDrag();
		}



/* loading */

		// LOADING PROGRESS
		private function loadingProgress(e:ProgressEvent):void
		{
			progBar.setProgress(e.bytesLoaded,e.bytesTotal);
		}


/* resize */

		private function onStageResize(e:Event):void
		{
			toolBar.x = _sW;

			if(progBar.visible)
			{
				progBar.x = _sW / 2 - progBar.width / 2;
				progBar.y = _sH / 2 - progBar.height / 2;
			}
		}
	}
}