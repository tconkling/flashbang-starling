//
// Flashbang

package flashbang.util {

import aspire.util.Randoms;

public class IntRange
{
    public var min :int;
    public var max :int;
    public var rands :Randoms;

    public function IntRange (min :int, max :int, rands :Randoms) {
        this.min = min;
        this.max = max;
        this.rands = rands;
    }

    public function next () :int {
        return rands.getInRange(min, max);
    }

    public function clone () :IntRange {
        return new IntRange(min, max, rands);
    }
}

}
