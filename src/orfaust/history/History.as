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
	import orfaust.Debug

	import flash.events.Event

	public class History
	{
		private var _undo:Array = new Array;
		private var _redo:Array = new Array;

		private const VERBOSE = true;

		public function push(action:Action,execute:Boolean = true):void
		{
			if(redoAble)
				_redo = new Array;

			if(VERBOSE)
				Debug.log(action.name,'Action');

			_undo.push(action);
			if(execute)
				action.execute();
		}

		public function get undoAble():Boolean
		{
			return _undo.length > 0;
		}

		public function get redoAble():Boolean
		{
			return _redo.length > 0;
		}

		public function undo(e:Event = null):void
		{
			if(!undoAble)
			{
				//Debug.log('no undo available');
				return;
			}
			var action = _undo.pop();
			action.unexecute();
			_redo.push(action);

			if(VERBOSE)
				Debug.log(action.name,'(' + _undo.length + ')\tUndo\t');
		}

		public function redo(e:Event = null):void
		{
			if(!redoAble)
			{
				//Debug.log('no redo available');
				return;
			}
			var action = _redo.pop();
			action.execute();
			_undo.push(action);

			if(VERBOSE)
				Debug.log(action.name,'(' + _redo.length + ')\tRedo\t');
		}
	}
}