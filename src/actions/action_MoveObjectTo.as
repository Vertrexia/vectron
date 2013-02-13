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

package actions
{
	import flash.display.DisplayObject
	import flash.geom.Point

	import orfaust.history.*
	import commands.command_MoveObjectTo

	public class action_MoveObjectTo extends ActionBase implements Action
	{
		public function action_MoveObjectTo(object:AamapObject,dest:Point,from:Point):void
		{
			_object = object;
			_name = 'Move';

			_command = new command_MoveObjectTo(dest.x,dest.y);
			_reverse = new command_MoveObjectTo(from.x,from.y);
		}
	}
}