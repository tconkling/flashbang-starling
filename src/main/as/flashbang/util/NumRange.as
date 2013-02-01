//
// Flashbang

package flashbang.util {

import aspire.util.Randoms;

public class NumRange
{
    public var min :Number;
    public var max :Number;
    public var rands :Randoms;

    public function NumRange (min :Number, max :Number, rands :Randoms) {
        this.min = min;
        this.max = max;
        this.rands = rands;
    }

    public function next () :Number {
        return rands.getNumberInRange(min, max);
    }

    public function clone () :NumRange {
        return new NumRange(min, max, rands);
    }
}

}
