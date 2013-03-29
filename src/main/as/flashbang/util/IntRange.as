//
// Flashbang

package flashbang.util {

import aspire.util.Cloneable;
import aspire.util.Randoms;

public class IntRange
    implements Cloneable
{
    public var min :int;
    public var max :int;

    public function IntRange (min :int, max :int) {
        this.min = min;
        this.max = max;
    }

    /** Returns a random int in [min, max) */
    public function random (rands :Randoms) :int {
        return rands.getIntInRange(min, max);
    }

    public function clone () :Object {
        return new IntRange(min, max);
    }
}

}
