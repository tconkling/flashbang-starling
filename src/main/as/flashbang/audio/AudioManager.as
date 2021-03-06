//
// Flashbang

package flashbang.audio {

import aspire.util.F;
import aspire.util.Log;

import flash.events.Event;
import flash.media.SoundTransform;
import flash.utils.getTimer;

import flashbang.core.Flashbang;
import flashbang.core.Updatable;
import flashbang.resource.SoundResource;

public class AudioManager
    implements Updatable
{
    public static const LOOP_FOREVER :int = -1;

    public function AudioManager (maxChannels :int = 25) {
        _maxChannels = maxChannels;

        _masterControls = new AudioControls();
        _soundTypeControls = new Vector.<AudioControls>(SoundType.values().length);
        for (var ii :int = 0; ii < _soundTypeControls.length; ++ii) {
            var subControls :AudioControls = new AudioControls(_masterControls);
            subControls.retain(); // these subcontrols will never be cleaned up
            _soundTypeControls[ii] = subControls;
        }
    }

    public function get masterControls () :AudioControls {
        return _masterControls;
    }

    public function get musicControls () :AudioControls {
        return getControlsForSoundType(SoundType.MUSIC);
    }

    public function get sfxControls () :AudioControls {
        return getControlsForSoundType(SoundType.SFX);
    }

    public function get maxActiveChannels () :int {
        return _maxChannels;
    }

    public function get numActiveChannels () :int {
        return _activeChannels.length;
    }

    public function get numFreeChannels () :int {
        return _maxChannels - this.numActiveChannels;
    }

    public function getControlsForSoundType (type :SoundType) :AudioControls {
        return _soundTypeControls[type.ordinal()];
    }

    public function dispose () :void {
        stopAllSounds();
        _activeChannels = null;
        _masterControls = null;
        _soundTypeControls = null;
    }

    public function update (dt :Number) :void {
        _masterControls.update(dt, DEFAULT_AUDIO_STATE);

        // update all playing sound channels
        var hasStoppedChannels :Boolean = false;
        for each (var channel :AudioChannel in _activeChannels) {
            if (channel.isPlaying) {
                var audioState :AudioState = channel._controls.state;
                var channelPaused :Boolean = channel.isPaused;
                if (audioState.stopped) {
                    stop(channel);
                } else if (audioState.paused && !channelPaused) {
                    pause(channel);
                } else if (!audioState.paused && channelPaused) {
                    resume(channel);
                } else if (!channelPaused) {
                    var curTransform :SoundTransform = channel._channel.soundTransform;
                    var curVolume :Number = curTransform.volume;
                    var curPan :Number = curTransform.pan;
                    var newVolume :Number = audioState.actualVolume * channel._sound.volume;
                    var newPan :Number = audioState.pan * channel._sound.pan;
                    if (newVolume != curVolume || newPan != curPan) {
                        channel._channel.soundTransform = new SoundTransform(newVolume, newPan);
                    }
                }
            }

            if (!channel.isPlaying) {
                hasStoppedChannels = true;
            }
        }

        // Remove inactive channels
        if (hasStoppedChannels) {
            _activeChannels = _activeChannels.filter(activeChannelFilter);
        }
    }

    public function playSoundNamed (name :String, parentControls :AudioControls = null,
        loopCount :int = 0) :AudioChannel {

        return playSound(Flashbang.rsrcs.requireResource(name), parentControls, loopCount);
    }

    public function playSound (soundSet :SoundSet, parentControls :AudioControls = null,
        loopCount :int = 0) :AudioChannel {

        // it's acceptable for SoundSet.nextSound to return null
        var sound :SoundResource = soundSet.nextSound();
        if (sound == null) {
            return new AudioChannel();
        }

        // get the appropriate parent controls
        if (null == parentControls) {
            parentControls = getControlsForSoundType(sound.type);
            if (null == parentControls) {
                parentControls = _masterControls;
            }
        }

        // don't play the sound if its parent controls are stopped
        var audioState :AudioState = parentControls.updateStateNow();
        if (audioState.stopped) {
            log.info("Discarding sound '" + sound.name +
                "' (parent controls are stopped)");
            return new AudioChannel();
        }

        var timeNow :int = getTimer();

        // Iterate the active channels to determine if this sound has been played recently.
        // Also look for the lowest-priority active channel.
        var lowestPriorityChannel :AudioChannel = null;
        var lowestPriorityChannelIdx :int = -1;
        for (var ii :int = 0; ii < _activeChannels.length; ++ii) {
            var activeChannel :AudioChannel = _activeChannels[ii];
            if (activeChannel.isPlaying) {
                if (activeChannel._sound == sound &&
                    (timeNow - activeChannel._startTime) < SOUND_PLAYED_RECENTLY_DELTA) {
                    /*log.info("Discarding sound '" + soundResource.resourceName +
                               "' (recently played)");*/
                    return new AudioChannel();
                }
            }

            if (null == lowestPriorityChannel ||
                activeChannel.priority < lowestPriorityChannel.priority) {

                lowestPriorityChannel = activeChannel;
                lowestPriorityChannelIdx = ii;
            }
        }

        // Are we out of channels?
        if (_activeChannels.length >= _maxChannels) {
            // Can we shut down a playing channel?
            if (null != lowestPriorityChannel &&
                sound.priority > lowestPriorityChannel.priority) {
                // steal the channel from a lower-priority sound
                if (lowestPriorityChannel._sound != null) {
                    log.info("Interrupting sound '" + lowestPriorityChannel._sound.name +
                        "' for higher-priority sound '" + sound.name + "'");
                }
                stop(lowestPriorityChannel);
                _activeChannels.removeAt(lowestPriorityChannelIdx);
            } else {
                // We're out of luck
                log.info("Discarding sound '" + sound.name +
                    "' (no free AudioChannels)");
                return new AudioChannel();
            }
        }

        // Create the channel
        var channel :AudioChannel = new AudioChannel();
        channel._completeHandler = F.bind(handleComplete, channel);
        channel._controls = new AudioControls(parentControls);
        channel._controls.retain();
        channel._sound = sound;
        channel._savedPlayPosition = 0;
        channel._startTime = timeNow;
        channel._loopCount = loopCount;

        // start playing
        if (!audioState.paused) {
            playChannel(channel, audioState, 0);

            // Flash must've run out of sound channels
            if (null == channel._channel) {
                log.info("Discarding sound '" + sound.name +
                    "' (Flash is out of channels)");
                return new AudioChannel();
            }
        }

        _activeChannels.push(channel);
        return channel;
    }

    public function stopAllSounds () :void {
        // shutdown all sounds
        for each (var channel :AudioChannel in _activeChannels) {
            stop(channel);
        }
        _activeChannels.length = 0;
    }

    public function stop (channel :AudioChannel) :void {
        if (channel.isPlaying) {
            if (null != channel._channel) {
                channel._channel.removeEventListener(Event.SOUND_COMPLETE, channel._completeHandler);
                channel._channel.stop();
                channel._channel = null;
            }

            channel._controls.release();
            channel._controls = null;

            channel._sound = null;
        }
    }

    public function pause (channel :AudioChannel) :void {
        if (channel.isPlaying && !channel.isPaused) {
            // save the channel's current play position
            channel._savedPlayPosition = channel._channel.position;

            // stop playing
            channel._channel.removeEventListener(Event.SOUND_COMPLETE, channel._completeHandler);
            channel._channel.stop();
            channel._channel = null;
        }
    }

    public function resume (channel :AudioChannel) :void {
        if (channel.isPlaying && channel.isPaused) {
            playChannel(channel, channel._controls.state, channel._savedPlayPosition);
        }
    }

    protected function handleComplete (channel :AudioChannel) :void {
        // does the sound need to loop?
        if (channel._loopCount == 0) {
            stop(channel);
            channel.completed.emit();

        } else if (playChannel(channel, channel._controls.state, 0)) {
            channel._loopCount--;
        }
    }

    protected function playChannel (channel :AudioChannel, audioState :AudioState,
        playPosition :Number) :Boolean
    {
        var volume :Number = audioState.actualVolume * channel._sound.volume;
        var pan :Number = audioState.pan * channel._sound.pan;
        channel._channel = channel._sound.sound.play(playPosition, 0,
            new SoundTransform(volume, pan));

        if (null != channel._channel) {
            channel._channel.addEventListener(Event.SOUND_COMPLETE, channel._completeHandler);
            return true;

        } else {
            stop(channel);
            return false;
        }
    }

    protected static function activeChannelFilter (channel :AudioChannel, ..._) :Boolean {
        return channel.isPlaying;
    }

    protected var _maxChannels :int;
    protected var _activeChannels :Vector.<AudioChannel> = new <AudioChannel>[];
    protected var _masterControls :AudioControls;
    protected var _soundTypeControls :Vector.<AudioControls>;

    protected static const log :Log = Log.getLog(AudioManager);
    protected static const DEFAULT_AUDIO_STATE :AudioState = AudioState.defaultState();
    protected static const SOUND_PLAYED_RECENTLY_DELTA :int = 1000 / 20;
}

}
