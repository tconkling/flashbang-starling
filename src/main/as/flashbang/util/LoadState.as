//
// Flashbang

package flashbang.util {

import aspire.util.Enum;

public final class LoadState extends Enum
{
    public static const INIT :LoadState = new LoadState("INIT");
    public static const LOADING :LoadState = new LoadState("LOADING");
    public static const SUCCEEDED :LoadState = new LoadState("SUCCEEDED");
    public static const FAILED :LoadState = new LoadState("FAILED");
    public static const CANCELED :LoadState = new LoadState("CANCELED");
    finishedEnumerating(LoadState);

    /**
     * Get the values of the LoadState enum
     */
    public static function values () :Array {
        return Enum.values(LoadState);
    }

    /**
     * Get the value of the LoadState enum that corresponds to the specified string.
     * If the value requested does not exist, an ArgumentError will be thrown.
     */
    public static function valueOf (name :String) :LoadState {
        return Enum.valueOf(LoadState, name) as LoadState;
    }

    /** @private */
    public function LoadState (name :String) {
        super(name);
    }
}
}


