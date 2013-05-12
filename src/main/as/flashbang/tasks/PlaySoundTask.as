//
// Flashbang

package flashbang.tasks {

import flashbang.audio.AudioChannel;
import flashbang.audio.AudioControls;
import flashbang.core.Flashbang;
import flashbang.core.ObjectTask;
import flashbang.core.Updatable;

public class PlaySoundTask extends ObjectTask
    implements Updatable
{
    public function PlaySoundTask (soundName :String, waitForComplete :Boolean = false,
        parentControls :AudioControls = null) {
        _soundName = soundName;
        _waitForComplete = waitForComplete;
        _parentControls = parentControls;
    }

    public function update (dt :Number) :void {
        if (null == _channel) {
            _channel = Flashbang.audio.playSoundNamed(_soundName, _parentControls);
        }

        if (!_waitForComplete || !_channel.isPlaying) {
            destroySelf();
        }
    }

    protected var _soundName :String;
    protected var _waitForComplete :Boolean;
    protected var _parentControls :AudioControls;
    protected var _channel :AudioChannel;
}

}
