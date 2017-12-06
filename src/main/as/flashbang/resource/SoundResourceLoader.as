//
// flashbang

package flashbang.resource {

import aspire.util.ClassUtil;

import flash.media.Sound;

import flashbang.audio.SoundType;
import flashbang.loader.SoundLoader;

import react.Executor;
import react.Future;
import react.NumberView;

public class SoundResourceLoader implements ResourceLoader {
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
        _name = Params.require(params, NAME, String);
        _loadSize = Params.get(params, LOAD_SIZE, 1);

        var priority :Number = Params.get(params, PRIORITY, 0);
        var volume :Number = Params.get(params, VOLUME, 1);
        var pan :Number = Params.get(params, PAN, 0);
        var type :SoundType = SoundType.valueOf(Params.get(params, TYPE, SoundType.SFX.name()));
        var url :String = Params.require(params, URL, String);
        var stream :Boolean = Params.get(params, STREAM, false);

        _loader = new SoundLoader(url, stream);
        _result = _loader.result.map(function (sound :Sound) :SoundResource {
            return new SoundResource(_name, sound, type, priority, volume, pan);
        });
    }

    public function get processSize () :Number {
        return _loadSize;
    }

    public function get result () :Future {
        return _result;
    }

    public function get progress () :NumberView {
        return _loader.progress;
    }

    public function executor (exec :Executor) :void {
        _exec = exec;
    }

    public function begin () :Future {
        if (!_began) {
            _began = true;
            if (_exec != null) {
                _exec.submit(_loader.begin);
            } else {
                _loader.begin();
            }
        }
        return _result;
    }

    public function toString () :String {
        return _name + " (" + ClassUtil.tinyClassName(this) + ")";
    }

    protected var _name :String;
    protected var _loadSize :Number;

    protected var _exec :Executor;
    protected var _result :Future;
    protected var _loader :SoundLoader;
    protected var _began :Boolean;
}
}
