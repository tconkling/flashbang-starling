//
// Flashbang

package flashbang.audio {

import aspire.util.Enum;

public final class SoundType extends Enum
{
    public static const SFX :SoundType = new SoundType("SFX");
    public static const MUSIC :SoundType = new SoundType("MUSIC");
    finishedEnumerating(SoundType);

    /**
     * Get the values of the SoundType enum
     */
    public static function values () :Array
    {
        return Enum.values(SoundType);
    }

    /**
     * Get the value of the SoundType enum that corresponds to the specified string.
     * If the value requested does not exist, an ArgumentError will be thrown.
     */
    public static function valueOf (name :String) :SoundType
    {
        return Enum.valueOf(SoundType, name) as SoundType;
    }

    /** @private */
    public function SoundType (name :String)
    {
        super(name);
    }
}
}
