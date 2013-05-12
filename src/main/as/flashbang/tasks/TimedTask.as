//
// Flashbang

package flashbang.tasks {

import flashbang.core.GameObject;
import flashbang.core.ObjectTask;
import flashbang.core.Updatable;

public class TimedTask extends ObjectTask
    implements Updatable
{
    public function TimedTask (time :Number) {
        _time = time;
    }

    public function update (dt :Number) :void {
        _time -= dt;
        if (_time <= 0) {
            destroySelf();
        }
    }

    protected var _time :Number = 0;
}

}
