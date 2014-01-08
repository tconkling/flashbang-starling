//
// flashbang

package flashbang.resource {

import flash.errors.IOError;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.media.Sound;
import flash.net.URLRequest;

import aspire.util.ClassUtil;
import aspire.util.F;

import flashbang.audio.SoundType;

public class SoundResourceLoader extends ResourceLoader
{
    /** Load params */

    /** The name of the Sound (required) */
    public static const NAME :String = "name";

    /** a String containing a URL to load the Sound from OR an [Embed]ed Sound class (required) */
    public static const DATA :String = "data";

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

    public function SoundResourceLoader (params :Object) {
        super(params);
    }

    override protected function doLoad () :void {
        // parse loadParams
        var name :String = getLoadParam(NAME);
        var typeName :String = getLoadParam(TYPE, SoundType.SFX.name());
        var type :SoundType = SoundType.valueOf(typeName.toUpperCase());
        var priority :int = getLoadParam(PRIORITY, 0);
        var volume :Number = getLoadParam(VOLUME, 1);
        var pan :Number = getLoadParam(PAN, 0);

        var data :Object = requireLoadParam(DATA, Object);
        if (data is String) {

            _sound = new Sound();

            // Immediately set up the error listener to protect against blowing up
            _sound.addEventListener(IOErrorEvent.IO_ERROR, function (e :IOErrorEvent) :void {
                fail(new IOError(e.text, e.errorID));
            });

            // And THEN start it loading
            _sound.load(new URLRequest(data as String));

            var result :SoundResource = new SoundResource(name, _sound, type, priority, volume, pan);

            // If this is a streaming sound, we don't wait for it to finish loading before
            // we make it available. Sounds loaded in this manner can be played without
            // issue as long as they download quickly enough.
            if (getLoadParam(STREAM, false)) {
                succeed(result);
            } else {
                _sound.addEventListener(Event.COMPLETE, F.bind(succeed, result));
            }

        } else if (data is Class) {
            var clazz :Class = Class(data);
            _sound = Sound(new clazz());
            succeed(new SoundResource(name, _sound, type, priority, volume, pan));

        } else {
            throw new Error("Unrecognized Sound data source: '" +
                ClassUtil.tinyClassName(data) + "'");
        }
    }

    override protected function onCanceled () :void {
        if (_sound != null) {
            try { _sound.close(); }
            catch (e :Error) { /* swallow */ }
            _sound = null;
        }
    }

    protected var _sound :Sound;
}
}
