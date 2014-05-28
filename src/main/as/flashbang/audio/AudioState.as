//
// Flashbang

package flashbang.audio {

internal class AudioState
{
    public var volume :Number = 1;
    public var pan :Number = 0;
    public var paused :Boolean;
    public var muted :Boolean;
    public var stopped :Boolean;

    public function get actualVolume () :Number {
        return (muted ? 0 : volume);
    }

    public static function defaultState () :AudioState {
        return new AudioState();
    }

    public static function combine (a :AudioState, b :AudioState, into :AudioState = null)
        :AudioState
    {
        if (null == into) {
            into = new AudioState();
        }

        into.volume = a.volume * b.volume;
        into.pan = (a.pan + b.pan) * 0.5;
        into.paused = a.paused || b.paused;
        into.muted = a.muted || b.muted;
        into.stopped = a.stopped || b.stopped;

        return into;
    }
}

}
