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

package orfaust.history
{
	public class ActionsCollector implements Action
	{
		private var _name:String;
		private var _actions:Array = new Array;

		public function ActionsCollector(name:String):void
		{
			_name = name;
		}

		public function push(action:Action):void
		{
			_actions.push(action);
		}

		public function execute():void
		{
			for each(var a in _actions)
				a.execute();
		}

		public function unexecute():void
		{
			for each(var a in _actions)
				a.unexecute();
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get name():String
		{
			return _name;// + ' (' + _actions.length + ')';
		}

		public function get length():uint
		{
			return _actions.length;
		}
	}
}