//
// Flashbang - a framework for creating Flash games
// Copyright (C) 2008-2012 Three Rings Design, Inc., All Rights Reserved
// http://github.com/threerings/flashbang
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

package flashbang.tasks {

import starling.display.DisplayObject;

import flashbang.GameObject;
import flashbang.ObjectTask;

public class VisibleTask extends DisplayObjectTask
{
    public function VisibleTask (visible :Boolean, disp :DisplayObject = null)
    {
        super(0, null, disp);
        _visible = visible;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean
    {
        getTarget(obj).visible = _visible;
        return true;
    }

    override public function clone () :ObjectTask
    {
        return new VisibleTask(_visible, _display);
    }

    protected var _visible :Boolean;
}

}
