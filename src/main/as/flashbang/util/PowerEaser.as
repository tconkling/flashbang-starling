//
// Flashbang

package flashbang.util {

public class PowerEaser
{
    public function PowerEaser (pow :int) {
        _pow = pow;
    }

    public function easeIn (from :Number, to :Number, dt :Number, t :Number) :Number {
        if (t == 0) {
            return to;
        }
        return from + ((to - from) * Math.pow(dt / t, _pow));
    }

    public function easeOut (from :Number, to :Number, dt :Number, t :Number) :Number {
        if (t == 0) {
            return to;
        }
        return from + ((to - from) * (1 - Math.pow(1 - dt / t, _pow)));
    }

    public function easeInOut (from :Number, to :Number, dt :Number, t :Number) :Number {
        if (t == 0) {
            return to;
        }

        var mid :Number = from + (to - from) * 0.5;
        t *= 0.5;
        return (dt <= t ? easeIn(from, mid, dt, t) : easeOut(mid, to, dt - t, t));
    }

    protected var _pow :int;
}
}
