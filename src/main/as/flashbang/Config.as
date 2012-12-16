//
// Flashbang

package flashbang {

public class Config
{
    /** The width (in points) of the Starling stage */
    public var stageWidth :int = 480;

    /** The height (in points) of the Starling stage */
    public var stageHeight :int = 320;

    /** The width (in pixels) of the game's window */
    public var windowWidth :int = 480;

    /** The height (in pixels) of the game's window */
    public var windowHeight :int = 320;

    /** The number of audio channels the AudioManager will use. Defaults to 25. */
    public var maxAudioChannels :int = 25;

    /**
     * If the framerate drops below this value, the MainLoop will artificially reduce the
     * time delta passed to update() functions, causing the game to slow down but animate
     * more smoothly. Defaults to 15.
     */
    public var minFrameRate :Number = 15;
}

}
