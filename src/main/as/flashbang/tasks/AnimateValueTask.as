//
// Flashbang

package flashbang.tasks {

import flashbang.GameObject;
import flashbang.ObjectTask;
import flashbang.util.BoxedNumber;

public class AnimateValueTask extends InterpolatingTask
{
    public function AnimateValueTask (value :BoxedNumber, targetValue :Number, time :Number = 0,
        easingFn :Function = null)
    {
        super(time, easingFn);

        if (null == value) {
            throw new Error("value must be non null");
        }

        _to = targetValue;
        _value = value;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean
    {
        if (0 == _elapsedTime) {
            _from = _value.value;
        }

        _elapsedTime += dt;
        _value.value = interpolate(_from, _to);
        return (_elapsedTime >= _totalTime);
    }

    override public function clone () :ObjectTask
    {
        return new AnimateValueTask(_value, _to, _totalTime, _easingFn);
    }

    protected var _to :Number;
    protected var _from :Number;
    protected var _value :BoxedNumber;
}

}
