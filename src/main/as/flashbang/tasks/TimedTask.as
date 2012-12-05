//
// Flashbang

package flashbang.tasks {

import flashbang.GameObject;
import flashbang.ObjectTask;

public class TimedTask
    implements ObjectTask
{
    public function TimedTask (time :Number)
    {
        _time = time;
    }

    public function update (dt :Number, obj :GameObject) :Boolean
    {
        _elapsedTime += dt;

        return (_elapsedTime >= _time);
    }

    public function clone () :ObjectTask
    {
        return new TimedTask(_time);
    }

    protected var _time :Number = 0;
    protected var _elapsedTime :Number = 0;
}

}
