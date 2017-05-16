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
        return (null != _sound);
    }

    public function get priority () :int {
        return (null != _sound ? _sound.priority : int.MIN_VALUE);
    }

    public function get isPaused () :Boolean {
        return (null != _sound && null == _channel);
    }

    public function get audioControls () :AudioControls {
        return (null != _controls ? _controls : DUMMY_CONTROLS);
    }

    /**
     * Returns the length of the sound in milliseconds, or 0 if the sound doesn't exist.
     */
    public function get length () :Number {
        return null == _sound ? 0 : _sound.sound.length;
    }

    /**
     * Returns the elapsed time of the playing sounds, in milliseconds. If the channel has no
     * sound attached, or if it is stopped or paused, 0 will be returned.
     */
    public function get position () :Number {
        return null == _channel ? 0 : _channel.position;
    }

    // managed by AudioManager

    internal var _completeHandler :Function;
    internal var _controls :AudioControls;
    internal var _sound :SoundResource;
    internal var _channel :SoundChannel;
    internal var _savedPlayPosition :Number;
    internal var _startTime :int;
    internal var _loopCount :int;

    internal static const DUMMY_CONTROLS :AudioControls = new AudioControls();
}

}
