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

    public function nextValue (rands :Randoms) :int {
        return rands.getInRange(min, max);
    }

    public function clone () :Object {
        return new IntRange(min, max);
    }
}

}
