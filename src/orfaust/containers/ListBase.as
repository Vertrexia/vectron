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
	internal class ListBase
	{
		protected var _head:Object;
		protected var _tail:Object;
		protected var _size:uint = 0;;

		// SIZE
		public function get length():uint
		{
			return _size;
		}

		// EMPTY
		public function get empty():Boolean
		{
			return !_size;
		}

		// CHECK
		protected final function check(name:String = 'ListBase'):void
		{
			if(!_head)
				throw new Error(name + ' is empty');
		}

		// APPEND
		protected function append(data:*):void
		{
			var node:Object = {data:data,prev:_tail,next:null};

			if(!_tail)
				_head = node;

			if(_tail)
				_tail.next = node;

			_tail = node;
			_size ++;
		}

		// PREPEND
		protected function prepend(data:*):void
		{
			var node:Object = {data:data,prev:null,next:_head};
			if(!_head)
				_tail = node;
			else
				_head.prev = node;

			_head = node;
			_size ++;
		}

		// REMOVE NODE
		protected function removeNode(node:Object):void
		{
			check();
			if(node.prev)
				node.prev.next = node.next;

			if(node.next)
				node.next.prev = node.prev;

			if(node == _head)
				_head = node.next;

			if(node == _tail)
				_tail = node.prev;

			_size --;
		}

		// FIND NODE
		protected function findNode(data:*):Object
		{
			//check();
			if(_size == 0)
				return null;

			var tmp = _head;
			while(tmp)
			{
				if(tmp.data == data)
					return tmp;
				tmp = tmp.next;
			}
			return null;
		}

		// PRINT ALL
		public function printAll():void
		{
			if(!_head)
			{
				trace('empty');
				return;
			}
			trace('size: ' + _size);
			var counter = 0;
			var tmp = _head;

			while(tmp)
			{
				counter ++;

				if(tmp == _head)
					trace('head');

				trace(counter + ': ' + tmp.data);

				if(tmp == _tail)
					trace('tail');

				tmp = tmp.next;
			}
		}
	}
}