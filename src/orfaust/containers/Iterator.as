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

package orfaust.containers
{
	public class Iterator
	{
		private var _node:Object;
		private var _list:ListBase;

		public function Iterator(list:ListBase,node:Object):void
		{
			_list = list;
			_node = node;
		}
		public function next():void
		{
			if(_node != null)
				_node = _node.next;
		}
		public function prev():void
		{
			if(_node != null)
				_node = _node.prev;
		}
		public function get data():*
		{
			if(_node != null)
				return _node.data;
		}
		public function set data(d:*):void
		{
			if(_node != null)
				_node.data = d;
		}
		public function get end():Boolean
		{
			return _node == null;
		}
		public function get begin():Boolean
		{
			return _node.prev == null;
		}
	}
}