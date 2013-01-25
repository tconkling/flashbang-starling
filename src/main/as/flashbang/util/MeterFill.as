//
// Flashbang

package flashbang.util {

import aspire.util.Enum;

public final class MeterFill extends Enum
{
    public static const LEFT_TO_RIGHT :MeterFill = new MeterFill("LEFT_TO_RIGHT");
    public static const RIGHT_TO_LEFT :MeterFill = new MeterFill("RIGHT_TO_LEFT");
    public static const TOP_TO_BOTTOM :MeterFill = new MeterFill("TOP_TO_BOTTOM");
    public static const BOTTOM_TO_TOP :MeterFill = new MeterFill("BOTTOM_TO_TOP");
    finishedEnumerating(MeterFill);
    
    /**
     * Get the values of the MeterFill enum
     */
    public static function values () :Array
    {
        return Enum.values(MeterFill);
    }
    
    /**
     * Get the value of the MeterFill enum that corresponds to the specified string.
     * If the value requested does not exist, an ArgumentError will be thrown.
     */
    public static function valueOf (name :String) :MeterFill
    {
        return Enum.valueOf(MeterFill, name) as MeterFill;
    }
    
    /** @private */
    public function MeterFill (name :String)
    {
        super(name);
    }
}
}
