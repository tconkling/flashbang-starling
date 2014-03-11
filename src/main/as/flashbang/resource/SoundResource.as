//
// flashbang

package flashbang.resource {

import flash.media.Sound;

import flashbang.core.Flashbang;
import flashbang.audio.SoundType;

public class SoundResource extends Resource
{
    /** Returns the SoundResource with the given name, or null if it doesn't exist */
    public static function get (name :String) :SoundResource {
        return Flashbang.rsrcs.getResource(name);
    }

    /** Returns the SoundResource with the given name. Throws an error if it doesn't exist */
    public static function require (name :String) :SoundResource {
        return Flashbang.rsrcs.requireResource(name);
    }

    public function SoundResource (name :String, sound :Sound, type :SoundType, priority :int,
        volume :Number, pan :Number)
    {
        super(name);
        _sound = sound;
        _type = type;
        _priority = priority;
        _volume = volume;
        _pan = pan;
    }

    override protected function dispose () :void {
        if (_sound != null) {
            try {
                _sound.close();
            } catch (e :Error) {
                // The sound may or may not be currently streaming data.
                // We'll get an error if it isn't and we try to close its stream- but we don't care.
            }
            _sound = null;
        }
    }

    public function get sound () :Sound { return _sound; }
    public function get type () :SoundType { return _type; }
    public function get priority () :int { return _priority; }
    public function get volume () :Number { return _volume; }
    public function get pan () :Number { return _pan; }

    protected var _sound :Sound;
    protected var _type :SoundType;
    protected var _priority :int;
    protected var _volume :Number;
    protected var _pan :Number;
}
}
