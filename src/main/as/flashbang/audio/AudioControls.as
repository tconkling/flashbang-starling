//
// Flashbang

package flashbang.audio {

import aspire.util.MathUtil;

public class AudioControls
{
    public function AudioControls (parentControls :AudioControls = null) {
        if (null != parentControls) {
            _parentControls = parentControls;
            _parentControls.attachChild(this);
        }
    }

    public function get curVolume () :Number {
        return _localState.volume;
    }

    public function get curPan () :Number {
        return _localState.pan;
    }

    public function get isPaused () :Boolean {
        return _localState.paused;
    }

    public function get isMuted () :Boolean {
        return _localState.muted;
    }

    public function get isStopped () :Boolean {
        return _localState.stopped;
    }

    /**
     * Increments the refcount on this instance. Controls that have their refcounts reduced to 0
     * will be cleaned up (i.e. no longer updated) by the AudioManager. If you manually create
     * an AudioControls instance, you should retain it immediately after creation and release it
     * when it will no longer be used.
     */
    public function retain () :AudioControls {
        ++_refCount;
        return this;
    }

    /** Decrements the refcount on this instance */
    public function release () :void {
        if (--_refCount < 0) {
            throw new Error("Cannot release() below a refCount of 0");
        }
    }

    public function volume (volume :Number) :AudioControls {
        _localState.volume = MathUtil.clamp(volume, 0, 1);
        return this;
    }

    public function volumeTo (targetVolume :Number, time :Number) :AudioControls {
        if (time <= 0) {
            volume(targetVolume);
            _targetVolumeTotalTime = 0;
        } else {
            _initialVolume = _localState.volume;
            targetVolume = MathUtil.clamp(targetVolume, 0, 1);
            _targetVolumeDelta = targetVolume - _initialVolume;
            _targetVolumeElapsedTime = 0;
            _targetVolumeTotalTime = time;
        }

        return this;
    }

    public function fadeOut (time :Number) :AudioControls  {
        return volumeTo(0, time);
    }

    public function fadeIn (time :Number) :AudioControls {
        return volumeTo(1, time);
    }

    public function fadeOutAndStop (time :Number) :AudioControls {
        return fadeOut(time).stopAfter(time);
    }

    public function pan (pan :Number) :AudioControls {
        _localState.pan = MathUtil.clamp(pan, -1, 1);
        return this;
    }

    public function panTo (targetPan :Number, time :Number) :AudioControls {
        if (time <= 0) {
            pan(targetPan);
            _targetPanTotalTime = 0;
        } else {
            _initialPan = _localState.pan;
            targetPan = MathUtil.clamp(targetPan, -1, 1);
            _targetPanDelta = targetPan - _initialPan;
            _targetPanElapsedTime = 0;
            _targetPanTotalTime = time;
        }

        return this;
    }

    public function setPaused (paused :Boolean) :AudioControls {
        _localState.paused = paused;
        _pauseCountdown = 0;
        _unpauseCountdown = 0;
        return this;
    }

    public function pause () :AudioControls {
        return setPaused(true);
    }

    public function unpause () :AudioControls {
        return setPaused(false);
    }

    public function pauseAfter (time :Number) :AudioControls {
        if (time <= 0) {
            setPaused(true);
        } else {
            _pauseCountdown = time;
        }
        return this;
    }

    public function unpauseAfter (time :Number) :AudioControls {
        if (time <= 0) {
            setPaused(false);
        } else {
            _unpauseCountdown = time;
        }
        return this;
    }

    public function setMuted (muted :Boolean) :AudioControls {
        _localState.muted = muted;
        _muteCountdown = 0;
        _unmuteCountdown = 0;
        return this;
    }

    public function mute () :AudioControls {
        return setMuted(true);
    }

    public function unmute () :AudioControls {
        return setMuted(false);
    }

    public function muteAfter (time :Number) :AudioControls {
        if (time <= 0) {
            setMuted(true);
        } else {
            _muteCountdown = time;
        }
        return this;
    }

    public function unmuteAfter (time :Number) :AudioControls {
        if (time <= 0) {
            setMuted(false);
        } else {
            _unmuteCountdown = time;
        }
        return this;
    }

    public function setStopped (stopped :Boolean) :AudioControls {
        _localState.stopped = stopped;
        _stopCountdown = 0;
        _playCountdown = 0;
        return this;

    }

    public function stop () :AudioControls {
        return setStopped(true);
    }

    public function play () :AudioControls {
        return setStopped(false);
    }

    public function stopAfter (time :Number) :AudioControls {
        if (time <= 0) {
            setStopped(true);
        } else {
            _stopCountdown = time;
        }
        return this;
    }

    public function playAfter (time :Number) :AudioControls {
        if (time <= 0) {
            setStopped(false);
        } else {
            _playCountdown = time;
        }
        return this;
    }

    internal function update (dt :Number, parentState :AudioState) :void {
        if (_targetVolumeTotalTime > 0) {
            _targetVolumeElapsedTime =
                Math.min(_targetVolumeElapsedTime + dt, _targetVolumeTotalTime);
            var volumeTransition :Number = _targetVolumeElapsedTime / _targetVolumeTotalTime;
            _localState.volume = _initialVolume + (_targetVolumeDelta * volumeTransition);

            if (_targetVolumeElapsedTime >= _targetVolumeTotalTime) {
                _targetVolumeTotalTime = 0;
            }
        }

        if (_targetPanTotalTime > 0) {
            _targetPanElapsedTime = Math.min(_targetPanElapsedTime + dt, _targetPanTotalTime);
            var panTransition :Number = _targetPanElapsedTime / _targetPanTotalTime;
            _localState.pan = _initialPan + (_targetPanDelta * panTransition);

            if (_targetPanElapsedTime >= _targetPanTotalTime) {
                _targetPanTotalTime = 0;
            }
        }

        if (_pauseCountdown > 0) {
            _pauseCountdown = Math.max(_pauseCountdown - dt, 0);
            if (_pauseCountdown == 0) {
                _localState.paused = true;
            }
        }

        if (_unpauseCountdown > 0) {
            _unpauseCountdown = Math.max(_unpauseCountdown - dt, 0);
            if (_unpauseCountdown == 0) {
                _localState.paused = false;
            }
        }

        if (_muteCountdown > 0) {
            _muteCountdown = Math.max(_muteCountdown - dt, 0);
            if (_muteCountdown == 0) {
                _localState.muted = true;
            }
        }

        if (_unmuteCountdown > 0) {
            _unmuteCountdown = Math.max(_unmuteCountdown - dt, 0);
            if (_unmuteCountdown == 0) {
                _localState.muted = false;
            }
        }

        if (_stopCountdown > 0) {
            _stopCountdown = Math.max(_stopCountdown - dt, 0);
            if (_stopCountdown == 0) {
                _localState.stopped = true;
            }
        }

        if (_playCountdown > 0) {
            _playCountdown = Math.max(_playCountdown - dt, 0);
            if (_playCountdown == 0) {
                _localState.stopped = false;
            }
        }

        _globalState = AudioState.combine(_localState, parentState, _globalState);

        // update children
        for (var ii :int = 0; ii < _children.length; ++ii) {
            var childController :AudioControls = _children[ii];
            childController.update(dt, _globalState);
            if (childController.needsCleanup) {
                // @TODO - use a linked list?
                _children.removeAt(ii--);
            }
        }
    }

    internal function updateStateNow () :AudioState {
        if (null != _parentControls) {
            _globalState =
                AudioState.combine(_localState, _parentControls.updateStateNow(), _globalState);
            return _globalState;
        } else {
            return _localState;
        }
    }

    internal function get state () :AudioState  {
        return (null != _parentControls ? _globalState : _localState);
    }

    internal function get needsCleanup () :Boolean {
        return (_refCount <= 0 && _children.length == 0);
    }

    internal function attachChild (child :AudioControls) :void {
        _children.push(child);
    }

    protected var _parentControls :AudioControls;
    protected var _children :Vector.<AudioControls> = new <AudioControls>[];

    protected var _refCount :int;

    protected var _localState :AudioState = new AudioState();
    protected var _globalState :AudioState = new AudioState();

    protected var _initialVolume :Number = 0;
    protected var _targetVolumeDelta :Number = 0;
    protected var _targetVolumeElapsedTime :Number = 0;
    protected var _targetVolumeTotalTime :Number = 0;

    protected var _initialPan :Number = 0;
    protected var _targetPanDelta :Number = 0;
    protected var _targetPanElapsedTime :Number = 0;
    protected var _targetPanTotalTime :Number = 0;

    protected var _pauseCountdown :Number = 0;
    protected var _unpauseCountdown :Number = 0;
    protected var _muteCountdown :Number = 0;
    protected var _unmuteCountdown :Number = 0;
    protected var _stopCountdown :Number = 0;
    protected var _playCountdown :Number = 0;
}

}
