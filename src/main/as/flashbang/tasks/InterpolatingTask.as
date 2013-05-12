//
// Flashbang

package flashbang.tasks {

import flashbang.core.ObjectTask;
import flashbang.core.Updatable;
import flashbang.util.Easing;

public class InterpolatingTask extends ObjectTask
    implements Updatable
{
    public function InterpolatingTask (time :Number = 0, easingFn :Function = null) {
        _totalTime = Math.max(time, 0);
        // default to linear interpolation
        _easingFn = (easingFn != null ? easingFn : Easing.linear);
    }

    public function update (dt :Number) :void {
        _elapsedTime = Math.min(_elapsedTime + dt, _totalTime);
        updateValues();
        if (_elapsedTime >= _totalTime) {
            destroySelf();
        }
    }

    protected function updateValues () :void {
        // subclasses do processing here
    }

    protected function interpolate (from :Number, to :Number) :Number {
        return _easingFn(from, to, Math.min(_elapsedTime, _totalTime), _totalTime);
    }

    protected var _totalTime :Number = 0;
    protected var _elapsedTime :Number = 0;

    protected var _easingFn :Function;
}

}
