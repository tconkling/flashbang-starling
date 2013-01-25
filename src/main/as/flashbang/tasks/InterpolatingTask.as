//
// Flashbang

package flashbang.tasks {

import flashbang.util.Easing;
import flashbang.core.GameObject;
import flashbang.core.ObjectTask;

public class InterpolatingTask
    implements ObjectTask
{
    public function InterpolatingTask (time :Number = 0, easingFn :Function = null)
    {
        _totalTime = Math.max(time, 0);
        // default to linear interpolation
        _easingFn = (easingFn != null ? easingFn : Easing.linear);
    }

    public function update (dt :Number, obj :GameObject) :Boolean
    {
        _elapsedTime += dt;
        return (_elapsedTime >= _totalTime);
    }

    public function clone () :ObjectTask
    {
        return new InterpolatingTask(_totalTime, _easingFn);
    }

    protected function interpolate (from :Number, to :Number) :Number
    {
        return _easingFn(from, to, Math.min(_elapsedTime, _totalTime), _totalTime);
    }

    protected var _totalTime :Number = 0;
    protected var _elapsedTime :Number = 0;

    protected var _easingFn :Function;
}

}
