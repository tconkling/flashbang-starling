//
// Flashbang

package flashbang.tasks {

import flashbang.util.BoxedNumber;

public class AnimateValueTask extends InterpolatingTask
{
    public function AnimateValueTask (value :BoxedNumber, targetValue :Number, time :Number = 0,
        easingFn :Function = null) {
        super(time, easingFn);

        if (null == value) {
            throw new Error("value must be non null");
        }

        _to = targetValue;
        _boxed = value;
    }

    override protected function updateValues () :void {
        if (isNaN(_from)) {
            _from = _boxed.value;
        }
        _boxed.value = interpolate(_from, _to);
    }

    protected var _to :Number;
    protected var _from :Number = NaN;
    protected var _boxed :BoxedNumber;
}

}
