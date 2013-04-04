//
// Flashbang

package flashbang.util {

import aspire.util.Cloneable;
import aspire.util.Randoms;

public class IntRange
    implements Cloneable
{
    public var min :int;
    public var range :int;

    public function IntRange (min :int = 0, range :int = 0) {
        this.min = min;
        this.range = range;
    }

    public function get max () :int {
        return min + range - 1;
    }

    public function set max (val :int) :void {
        range = val - min + 1;
    }

    /** Returns a random int in [min, min+range) */
    public function random (rands :Randoms) :int {
        return rands.getIntInRange(min, min + range);
    }

    public function clone () :Object {
        return new IntRange(min, range);
    }
}

}
