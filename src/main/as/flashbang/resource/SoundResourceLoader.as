//
// flashbang

package flashbang.resource {

import aspire.util.ClassUtil;

import flashbang.audio.SoundType;
import flashbang.loader.SoundLoader;

public class SoundResourceLoader extends SoundLoader implements ResourceLoader {
    /** The name of the Sound (required) */
    public static const NAME :String = "name";

    /** a String containing a URL to load the Sound (required) */
    public static const URL :String = "url";

    /** The sound type. String. Valid values: "sfx", "music". (optional, @default "sfx") */
    public static const TYPE :String = "soundType";

    /**
     * The sound's priority (if the AudioManager is out of sound channels, lower-priority sounds
     * will have their channels taken by higher-priority ones). int. (optional, @default 0)
     */
    public static const PRIORITY :String = "priority";

    /** The sound's base volume. Number, between 0 and 1. (optional, @default 1) */
    public static const VOLUME :String = "volume";

    /** The sound's base pan. Number, between -1 and 1. (optional, @default 0) */
    public static const PAN :String = "pan";

    /**
     * A Boolean specifying whether this sound should be streamed. Streaming sounds can begin
     * playing immediately; they don't need to be completely downloaded first.
     * (optional, @default false)
     */
    public static const STREAM :String = "stream";

    /** The loadSize of the resource (optional, defaults to 1) */
    public static const LOAD_SIZE :String = "loadSize";

    public function SoundResourceLoader (params :Object) {
        super(Params.require(params, URL, String), Params.get(params, STREAM, false));

        _name = Params.require(params, NAME, String);
        _priority = Params.get(params, PRIORITY, 0);
        _volume = Params.get(params, VOLUME, 1);
        _pan = Params.get(params, PAN, 0);
        _type = SoundType.valueOf(Params.get(params, TYPE, SoundType.SFX.name()));
        _loadSize = Params.get(params, LOAD_SIZE, 1);
    }

    public function get processSize () :Number {
        return _loadSize;
    }

    override protected function onSoundReady () :void {
        _result.succeed(new SoundResource(_name, _sound, _type, _priority, _volume, _pan));
    }

    public function toString () :String {
        return _name + " (" + ClassUtil.tinyClassName(this) + ")";
    }

    protected var _name :String;
    protected var _volume :Number;
    protected var _pan :Number;
    protected var _priority :Number;
    protected var _type :SoundType;
    protected var _loadSize :Number;
}
}
