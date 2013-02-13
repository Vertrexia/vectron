package
{
	public class KeyboardConnection
	{
		public var id:String;
		public var name:String;
		public var keyCode:uint;

		public var ctrl:Boolean = false;
		public var shift:Boolean = false;
		public var alt:Boolean = false;

		public var callBack:Function;
		public var args:*;
	
		public function KeyboardConnection(_id:String,_name:String,_keyCode:uint):void
		{
			id = _id;
			name = _name;
			keyCode = _keyCode;
		}
	}
}