package
{
	import orfaust.Debug

	public class Config
	{
		private static var _xml:XML;

		public static function init(data):void
		{
			_xml = new XML(data);
		}

		public static function getConnections(id:String):Array
		{
			var sCuts = _xml.shortcuts.(@id == id);
			if(sCuts == null)
			{
				throw new Error('shortcuts not found with id: ' + id);
				return;
			}

			var connections = new Array;
			for each(var s in sCuts.connection)
			{
				var con = new KeyboardConnection
				(
					s.attribute('id'),
					s.attribute('name'),
					parseInt(s.attribute('keyCode'))
				);

				var comboAttr:String = s.attribute('combo');
				if(comboAttr.length > 0)
				{
					var combo = comboAttr.split(' ');
					for each(var c in combo)
					{
						con[c] = true;
					}
				}
				connections.push(con);
			}
			return connections
		}
	}
}