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
	import flash.display.Loader
	import flash.display.LoaderInfo

	import flash.events.Event
	import flash.events.MouseEvent
	import flash.events.KeyboardEvent
	import flash.ui.Keyboard

	import flash.geom.Point
	
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	import flash.net.FileReference;
	import flash.net.FileFilter;

	import orfaust.Debug
	import orfaust.Segment
	import orfaust.Circle
	import orfaust.containers.LinkedList;
	import orfaust.containers.ListIterator;

	public class Home extends Base
	{
		private var _snapToGrid:Boolean = true;
		
		public static var spawns:Array = new Array();
		public static var walls:Array = new Array();
		public static var zones:Array = new Array();
		
		public static var MapFile:FileReference

		override protected function init():void
		{
			super.loadUrl('xml/config.xml',configLoaded);

			pointer.visible = false;
			Zone.init();
			
			//	give button an event to trigger
			toolBar.save.addEventListener(MouseEvent.CLICK, saveData);
			toolBar.open.addEventListener(MouseEvent.CLICK, loadLevel);
		}
		
		private function loadLevel(e:MouseEvent):void
       {            
            MapFile = new FileReference ( ) ;            
            MapFile.addEventListener ( Event.SELECT, xmlFileSelect ) ;
            MapFile.browse (  ) ;
        }
        private function xmlFileSelect( $evt:Event ):void
        {        
            MapFile.removeEventListener ( Event.SELECT, xmlFileSelect ) ;
            MapFile.addEventListener( Event.COMPLETE, xmlDataLoaded ) ;
            MapFile.load();           
        }
        private function xmlDataLoaded( $evt:Event ) : void
        {            
            MapFile.removeEventListener( Event.COMPLETE, xmlDataLoaded ) ;
            var _loader = new Loader ();
            _loader.contentLoaderInfo.addEventListener ( Event.COMPLETE, xmlFileLoaded ); 
          
            _loader.loadBytes( MapFile.data );
        }
        private function xmlFileLoaded( $evt:Event ):void
        {           
            var loaderInfo:LoaderInfo = ( $evt.target as LoaderInfo );
                 loaderInfo.removeEventListener( Event.COMPLETE, xmlFileLoaded );
            
           var _levelData = XML( $evt.target.content );
        }
		
		private function saveData(e:MouseEvent):void
		{
			var dataStr:String = "";
			
			var spawnData:String = "";
			if (spawns.length > 0)
			{
				for each(var s in spawns)
				{
					if (s as Spawn)
					{
						//trace("Spawn: ", s.x, s.y);
						spawnData += "   <Spawn x=\"" + s.x + "\" y=\"" + s.y + "\" xdir=\"" + int(s.direction.x) + "\" ydir=\"" + int(s.direction.y) + "\"/>\n";
					}
				}
				
				trace("found spawns");
			}
			
			var zonesData:String = "";
			if (zones.length > 0)
			{
				for each(var z in zones)
				{
					if (z as Zone)
					{
						//trace("Zone: ", z.radius, z.effect, z.center.x, z.center.y);
						zonesData += "   <Zone effect=\"" + z.effect + "\">\n";
						zonesData += "    <ShapeCircle radius=\"" + z.radius + "\">\n";
						zonesData += "     <Point x=\"" + z.center.x + "\" y=\"" + z.center.y + "\"/>\n";
						zonesData += "   </Zone>\n";
					}
				}
				
				trace("found zones");
			}
			
			var wallsData:String = "";
			if (walls.length > 0)
			{
				for each(var w in walls)
				{
					if (w as Wall)
					{
						wallsData += "   <Wall height=\"" + w.wallHeight + "\">\n"
						var arrPoints:Array = w.points.getArray;
						for each(var pPoint:Point in arrPoints)
						{
							wallsData += "    <Point x=\"" + pPoint.x + "\" y=\"" + pPoint.y + "\"/>\n"
						}
						//trace(arrPoints);
						
						wallsData += "   </Wall>\n";
					}
				}
				
				trace("found walls");
			}
			
			trace("Working great!");
			trace("Scale: ", Info.scale);
			
			var outputData:String = "";
			outputData += "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" standalone=\"no\"?>\n";
			outputData += "<!DOCTYPE Resource SYSTEM \"AATeam/map-0.2.8.0_rc4.dtd\">\n";
			outputData += "<Resource type=\"aamap\" name=\"map_name\" version=\"1.0\" author=\"author_name\" category=\"polygon/regular\">\n";
			outputData += " <Map version=\"0.2.8\">\n";
			outputData += "  <World>\n";
			outputData += "   <Field>\n";
			outputData += "   <Axes number=\"4\"/>\n";
			outputData += spawnData + zonesData + wallsData;
			outputData += "   </Field>\n";
			outputData += "  </World>\n";
			outputData += " </Map>\n";
			outputData += "</Resource>\n";
			
			MapFile = new FileReference();
			MapFile.save(outputData, "textarea.xml");
			
			//trace(outputData);
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
				snapPointer.x = _currentMap.x + Info.cursor.x;
				snapPointer.y = _currentMap.y - Info.cursor.y;
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