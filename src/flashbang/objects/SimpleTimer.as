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
// $Id: SimpleTimer.as 7240 2009-01-23 23:02:53Z tim $

package flashbang.objects {

import flashbang.MainLoop;
import flashbang.SimObject;
import flashbang.tasks.*;

public class SimpleTimer extends SimObject
{
    public static function getTimeLeft (mainLoop :MainLoop, timerName :String) :Number
    {
        var timer :SimpleTimer = mainLoop.topMode.getObjectNamed(timerName) as SimpleTimer;
        return (timer != null ? timer.timeLeft : 0);
    }

    public function SimpleTimer (delay :Number, callback :Function = null,
        repeating :Boolean = false, timerName :String = null)
    {
        _name = timerName;
        _timeLeft["value"] = delay;

        if (repeating) {
            var repeatingTask :RepeatingTask = new RepeatingTask();

            // init _timeLeft to delay
            repeatingTask.addTask(new AnimateValueTask(_timeLeft, delay, 0));

            // animate _timeLeft to 0 over delay seconds
            repeatingTask.addTask(new AnimateValueTask(_timeLeft, 0, delay));

            if (null != callback) {
                // call the callback
                repeatingTask.addTask(new FunctionTask(callback));
            }

            addTask(repeatingTask);

        } else {
            var serialTask :SerialTask = new SerialTask();

            // decrement _timeLeft to 0 over delay seconds
            serialTask.addTask(new AnimateValueTask(_timeLeft, 0, delay));

            if (null != callback) {
                // call the callback
                serialTask.addTask(new FunctionTask(callback));
            }

            // self-destruct when complete
            serialTask.addTask(new SelfDestructTask());

            addTask(serialTask);
        }
    }

    override public function get objectName () :String
    {
        return _name;
    }

    public function get timeLeft () :Number
    {
        return _timeLeft["value"];
    }

    protected var _name :String;
    protected var _timeLeft :Object = {};

}

}