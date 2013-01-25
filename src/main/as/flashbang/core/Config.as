//
// Flashbang

package flashbang.core {

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

    /** The MainLoop will not pass time deltas larger than this value to update() functions. */
    public var maxUpdateDelta :Number = 1.0 / 15.0;
}

}
