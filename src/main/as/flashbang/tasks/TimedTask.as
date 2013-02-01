//
// Flashbang

package flashbang.tasks {

import flashbang.core.GameObject;
import flashbang.core.ObjectTask;

public class TimedTask
    implements ObjectTask
{
    public function TimedTask (time :Number) {
        _time = time;
    }

    public function update (dt :Number, obj :GameObject) :Boolean {
        _time -= dt;
        return (_time <= 0);
    }

    protected var _time :Number = 0;
}

}
