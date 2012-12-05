//
// Flashbang

package flashbang {

public class Config
{
    /** The number of audio channels the AudioManager will use. Optional. Defaults to 25. */
    public var maxAudioChannels :int = 25;

    /**
     * If the framerate drops below this value, the MainLoop will artificially reduce the
     * time delta passed to update() functions, causing the game to slow down but animate
     * more smoothly. Defaults to 15.
     */
    public var minFrameRate :Number = 15;
}

}
