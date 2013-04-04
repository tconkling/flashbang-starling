//
// Flashbang

package flashbang.util {

import aspire.util.Cloneable;
import aspire.util.Randoms;

public class NumRange
    implements Cloneable
{
    public var min :Number;
    public var range :Number;

    public function NumRange (min :Number = 0, range :Number = 0) {
        this.min = min;
        this.range = range;
    }

    public function get max () :Number {
        return min + range;
    }

    public function set max (val :Number) :void {
        range = val - min;
    }

    /** Returns a random Number in [min, min+range) */
    public function random (rands :Randoms) :Number {
        return rands.getNumberInRange(min, min + range);
    }

    public function clone () :Object {
        return new NumRange(min, range);
    }
}

}
