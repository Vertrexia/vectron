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
	public class ListIterator
	{
		private var _node:Object;
		private var _list:LinkedList;

		public function ListIterator(list:LinkedList,node:Object):void
		{
			_node = node;
			_list = list;
		}
		public function get data():Object
		{
			check();
			return _node.data;
		}
		public function next():void
		{
			check();
			_node = _node.next;
		}
		public function prev():void
		{
			check();
			_node = _node.prev;
		}
		public function get valid():Boolean
		{
			return _node != null;
		}
		public function get begin():Boolean
		{
			check();
			return _node.data == _list.back;
		}
		public function get end():Boolean
		{
			check();
			return _node.data == _list.front;
		}

		private function check():void
		{
			if(_node == null)
				throw new Error('ListIterator pointing nothing');
		}
	}
}