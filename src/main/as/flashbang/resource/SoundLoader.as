//
// flashbang

package flashbang.resource {

import flash.errors.IOError;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.media.Sound;
import flash.net.URLRequest;

import aspire.util.F;

import flashbang.audio.SoundType;

public class SoundLoader extends ResourceLoader
{
    /** Load params */

    /** The name of the Sound */
    public static const NAME :String = "name";

    /** A String containing the URL to load the Sound from.
     * (Mutually exclusive with EMBEDDED_CLASS).*/
    public static const URL :String = "url";

    /** The [Embed]'d class to load the Sound from. (Mutually exclusive with URL.) */
    public static const EMBEDDED_CLASS :String = "embeddedClass";

    /** The sound type. String. Valid values: "sfx", "music". Defaults to "sfx". */
    public static const TYPE :String = "type";

    /**
     * The sound's priority (if the AudioManager is out of sound channels, lower-priority sounds
     * will have their channels taken by higher-priority ones). int. Defaults to 0.
     */
    public static const PRIORITY :String = "priority";

    /** The sound's base volume. Number, between 0 and 1. Defaults to 1. */
    public static const VOLUME :String = "volume";

    /** The sound's base pan. Number, between -1 and 1. Defaults to 0. */
    public static const PAN :String = "pan";

    /**
     * A Boolean specifying whether this sound should be streamed. Streaming sounds can begin
     * playing immediately; they don't need to be completely downloaded first. Defaults to false.
     */
    public static const STREAM :String = "stream";

    public function SoundLoader (params :Object)
    {
        super(params);
    }

    override protected function doLoad () :void
    {
        // parse loadParams
        var name :String = getLoadParam(NAME);
        var typeName :String = getLoadParam(TYPE, SoundType.SFX.name());
        var type :SoundType = SoundType.valueOf(typeName.toUpperCase());
        var priority :int = getLoadParam(PRIORITY, 0);
        var volume :Number = getLoadParam(VOLUME, 1);
        var pan :Number = getLoadParam(PAN, 0);

        // load the sound
        if (hasLoadParam(URL)) {
            _sound = new Sound();

            // Immediately set up the error listener to protect against blowing up
            _sound.addEventListener(IOErrorEvent.IO_ERROR, function (e :IOErrorEvent) :void {
                fail(new IOError(e.text, e.errorID));
            });

            // And THEN start it loading
            _sound.load(new URLRequest(getLoadParam(URL)));

            var result :SoundResource = new SoundResource(name, _sound, type, priority, volume, pan);

            // If this is a streaming sound, we don't wait for it to finish loading before
            // we make it available. Sounds loaded in this manner can be played without
            // issue as long as they download quickly enough.
            if (getLoadParam(STREAM, false)) {
                succeed(result);
            } else {
                _sound.addEventListener(Event.COMPLETE, F.callback(succeed, result));
            }

        } else if (hasLoadParam(EMBEDDED_CLASS)) {
            var embeddedClass :Class = getLoadParam(EMBEDDED_CLASS);
            _sound = Sound(new embeddedClass());
            succeed(new SoundResource(name, _sound, type, priority, volume, pan));

        } else {
            throw new Error("either 'url' or 'embeddedClass' must be specified in loadParams");
        }
    }

    override protected function onLoadCanceled () :void
    {
        if (_sound != null) {
            try { _sound.close() }
            catch (e :Error) { /* swallow */ }
            _sound = null;
        }
    }

    protected var _sound :Sound;
}
}
