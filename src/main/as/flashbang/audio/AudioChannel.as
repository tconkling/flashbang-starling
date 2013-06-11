//
// Flashbang

package flashbang.audio {

import flash.media.SoundChannel;

import flashbang.resource.SoundResource;

import react.UnitSignal;

public class AudioChannel
{
    /**
     * Dispatched when the AudioChannel has completed playing. If the channel loops, the signal will
     * dispatch after it has completed looping.
     * The signal will not dispatch if the channel is manually stopped.
     */
    public const completed :UnitSignal = new UnitSignal();

    public function get isPlaying () :Boolean  {
        return (null != sound);
    }

    public function get priority () :int {
        return (null != sound ? sound.priority : int.MIN_VALUE);
    }

    public function get isPaused () :Boolean {
        return (null != sound && null == channel);
    }

    public function get audioControls () :AudioControls {
        return (null != controls ? controls : DUMMY_CONTROLS);
    }

    /**
     * Returns the length of the sound in milliseconds, or 0 if the sound doesn't exist.
     */
    public function get length () :Number {
        return null == sound ? 0 : sound.sound.length;
    }

    // managed by AudioManager

    internal var completeHandler :Function;
    internal var controls :AudioControls;
    internal var sound :SoundResource;
    internal var channel :SoundChannel;
    internal var playPosition :Number;
    internal var startTime :int;
    internal var loopCount :int;

    internal static const DUMMY_CONTROLS :AudioControls = new AudioControls();
}

}
