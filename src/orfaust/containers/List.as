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
	public class List extends ListBase implements IList
	{
		// PUSH
		public function push(data:*):void
		{
			append(data);
		}

		// POP
		public function pop():*
		{
			check('List');
			var ret = _head.data;
			removeNode(_head);
			return ret;
		}

		// FIND
		public function find(data:*):Boolean
		{
			//check('List');
			return(findNode(data) != null);
		}

		// FRONT
		public function get front():*
		{
			check('List');
			return _head.data;
		}

		// BACK
		public function get back():*
		{
			check('List');
			return _tail.data;
		}

		// REMOVE
		public function remove(data:*):Boolean
		{
			check('List');
			var node = findNode(data);
			if(node)
			{
				removeNode(node);
				return true;
			}
			return false;
		}

		// GET ITERATOR
		public function get iterator():Iterator
		{
			return new Iterator(this,_head);
		}

		// EACH call the given function for each element in list 
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