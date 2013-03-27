//
// Flashbang

package flashbang.util {

import aspire.util.Cloneable;
import aspire.util.Randoms;

public class NumRange
    implements Cloneable
{
    public var min :Number;
    public var max :Number;

    public function NumRange (min :Number, max :Number) {
        this.min = min;
        this.max = max;
    }

    public function nextValue (rands :Randoms) :Number {
        return rands.getNumberInRange(min, max);
    }

    public function clone () :Object {
        return new NumRange(min, max);
    }
}

}
