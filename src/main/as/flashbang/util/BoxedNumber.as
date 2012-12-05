//
// Flashbang

package flashbang.util {

/**
 * An object that wraps a Number. Used by AnimateValueTask.
 */
public class BoxedNumber
{
    public var value :Number;

    public function BoxedNumber (value :Number = 0)
    {
        this.value = value;
    }

    public function toString () :String
    {
        return "" + value;
    }
}

}
