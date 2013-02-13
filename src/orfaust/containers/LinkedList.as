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
	import orfaust.Debug

	public class LinkedList
	{
		private var _head:Object;
		private var _tail:Object;
		private var _length:uint;

		public function push(data:Object):void
		{
			var node = {prev:_tail,next:null,data:data};
			if(_tail)
				_tail.next = node;
			else
				_head = node;

			_tail = node;
			_length ++;
		}

		public function pop():Object
		{
			if(_tail == null)
				return null;

			var node = _tail;
			removeNode(node);
			return node.data;
		}

		public function get front():Object
		{
			return _tail.data;
		}
		public function get back():Object
		{
			return _head.data;
		}

		public function find(data:Object):Boolean
		{
			var node = findNode(data);
			return node != null;
		}
		public function remove(data:Object):Boolean
		{
			var node = findNode(data);
			if(node)
			{
				removeNode(node);
				return true;
			}
			return false;
		}

		private function findNode(data:Object):Object
		{
			var node = _head;
			while(node)
			{
				if(node.data == data)
					return node;
				node = node.next;
			}
			return null;
		}

		private function removeNode(node:Object):void
		{
			if(node.prev)
				node.prev.next = node.next;

			if(node.next)
				node.next.prev = node.prev;

			if(node == _head)
				_head = node.next;

			if(node == _tail)
				_tail = node.prev;

			_length --;
		}

		public function get length():uint
		{
			return _length;
		}

		public function get iterator():ListIterator
		{
			return new ListIterator(this,_head);
		}

		public function empty():void
		{
			each(remove);
		}

		public function each(callBack:Function):void
		{
			var node = _head;
			while(node != null)
			{
				callBack(node.data);
				node = node.next;
			}
		}
	}
}