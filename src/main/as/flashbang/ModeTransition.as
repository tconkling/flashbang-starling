//
// Flashbang

package flashbang {

import aspire.util.Enum;

public final class ModeTransition extends Enum
{
    public static const PUSH :ModeTransition = new ModeTransition("PUSH", true, false);
    public static const UNWIND :ModeTransition = new ModeTransition("UNWIND", false, false);
    public static const INSERT :ModeTransition = new ModeTransition("INSERT", true, true);
    public static const REMOVE :ModeTransition = new ModeTransition("REMOVE", false, true);
    public static const CHANGE :ModeTransition = new ModeTransition("CHANGE", true, false);
    finishedEnumerating(ModeTransition);

    /**
     * Get the values of the ModeTransition enum
     */
    public static function values () :Array
    {
        return Enum.values(ModeTransition);
    }

    /**
     * Get the value of the ModeTransition enum that corresponds to the specified string.
     * If the value requested does not exist, an ArgumentError will be thrown.
     */
    public static function valueOf (name :String) :ModeTransition
    {
        return Enum.valueOf(ModeTransition, name) as ModeTransition;
    }

    public function get requiresMode () :Boolean
    {
        return _requiresMode;
    }

    public function get requiresIndex () :Boolean
    {
        return _requiresIndex;
    }

    /** @private */
    public function ModeTransition (name :String, requiresMode :Boolean, requiresIndex :Boolean)
    {
        super(name);
        _requiresMode = requiresMode;
        _requiresIndex = requiresIndex;
    }

    protected var _requiresMode :Boolean;
    protected var _requiresIndex :Boolean;
}
}
