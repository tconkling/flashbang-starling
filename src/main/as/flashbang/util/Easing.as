//
// Flashbang

package flashbang.util {

public class Easing
{
    public static const quadratic :PowerEaser = new PowerEaser(2);
    public static const cubic :PowerEaser = new PowerEaser(3);
    public static const quartic :PowerEaser = new PowerEaser(4);
    public static const quintic :PowerEaser = new PowerEaser(5);

    public static const easeIn :Function = cubic.easeIn;
    public static const easeOut :Function = cubic.easeOut;
    public static const easeInOut :Function = cubic.easeInOut;

    public static function linear (from :Number, to :Number, dt :Number, t :Number) :Number {
        if (t == 0) {
            return to;
        }
        return from + ((to - from) * (dt / t));
    }

    public static function none (from :Number, to :Number, dt :Number, t :Number) :Number {
        return (dt >= t ? to : from);
    }
}
}
