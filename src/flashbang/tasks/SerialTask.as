// Flashbang - a framework for creating Flash games
// http://code.google.com/p/flashbang/
//
// This library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this library.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright 2008 Three Rings Design
//
// $Id: SerialTask.as 6032 2008-10-07 01:48:02Z tim $

package flashbang.tasks {

import flashbang.ObjectTask;

public class SerialTask extends TaskContainer
{
    public function SerialTask (...subtasks)
    {
        super(TaskContainer.TYPE_SERIAL, subtasks);
    }
}

}