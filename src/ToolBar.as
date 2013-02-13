package
{
	import flash.display.MovieClip
	import flash.display.SimpleButton

	import flash.events.Event
	import flash.events.MouseEvent

	import orfaust.SelfInit
	import orfaust.Debug

	public class ToolBar extends SelfInit
	{
		private static var _active:ToolBase;

		public static function get activeTool():ToolBase
		{
			return _active;
		}

		override protected function init():void
		{
			_active = tools.select;
			addEventListener(MouseEvent.CLICK,switchTool);
			addEventListener(MouseEvent.ROLL_OVER,UserEvents.lockMouse);
			addEventListener(MouseEvent.ROLL_OUT,UserEvents.unlockMouse);
		}

		public function connect():void
		{
			var connections = Config.getConnections('toolBar');
			for each(var con in connections)
			{
				if(con.name.substr(0,5) == 'tool ')
				{
					con.callBack = chooseTool;
					var toolName = con.name.substr(5);
					con.args = tools.getChildByName(toolName);
				}
				UserEvents.connect(con);
			}
		}

		private function chooseTool(tool:ToolBase):void
		{
			if(tool == _active)
				return;

			_active.disconnect();
			_active = tool as ToolBase;
			overlay.x = tools.x + tool.x;
			_active.connect();
		}

		private function switchTool(e:MouseEvent):void
		{
			if(e.target is ToolBase)
			{
				if(e.target == _active)
					return;

				_active.disconnect();
				_active = e.target as ToolBase;
				overlay.x = tools.x + e.target.x;
				_active.connect();
			}
		}

		override protected function onStageResize(e:Event):void
		{
			x = stage.stageWidth;
		}

		public function get active():ToolBase
		{
			return _active;
		}
	}
}