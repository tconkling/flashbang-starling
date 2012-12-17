//
// flashbang

package flashbang.debug {

import flash.utils.clearInterval;
import flash.utils.getTimer;
import flash.utils.setInterval;

import aspire.util.Arrays;

import flashbang.GameObject;

public class Framerate extends GameObject
{
    // init with optimistic numbers to avoid special cases later
    public var fpsCur :Number = 30;
    public var frameTimeCur :Number = 1000 / fpsCur;
    public var fpsMean :Number = 30;
    public var fpsMin :Number = 30;
    public var fpsMax :Number = 30;

    public function Framerate (timeWindow :int = DEFAULT_TIME_WINDOW)
    {
        // keep enough historty for the number of 1/60 frames in timeWindow
        // TODO: if this all flies, establish a way to use historySize or approxTimeWindow
        setHistorySize(timeWindow * 60 / 1000);

        // calculate mean, min, max every so often
        _statsInterval = setInterval(calcStats, AVERAGE_INTERVAL);
    }

    public function setHistorySize (histSize :int) :void
    {
        // start with all 30 to avoid edge special cases in sampler
        _fpsBuffer = Arrays.create(histSize, 30);
        _fpsOffset = 0;
    }

    override protected function cleanup () :void
    {
        clearInterval(_statsInterval);
    }

    override protected function update (dt :Number) :void
    {
        if (_lastTime <= 0) {
            _lastTime = flash.utils.getTimer();
            return;
        }

        // calculate sample
        var time :int = flash.utils.getTimer();
        frameTimeCur = time - _lastTime;
        fpsCur = 1000 / frameTimeCur;

        // record sample
        _fpsBuffer[_fpsOffset] = fpsCur;
        _fpsOffset = (_fpsOffset + 1) % _fpsBuffer.length;

        _lastTime = time;
    }

    protected function calcStats () :void
    {
        var fpsSum :Number = 0;
        fpsMin = Number.MAX_VALUE;
        fpsMax = Number.MIN_VALUE;
        for each (var num :Number in _fpsBuffer) {
            fpsSum += num;
            fpsMin = Math.min(fpsMin, num);
            fpsMax = Math.max(fpsMax, num);
        };
        fpsMean = fpsSum / _fpsBuffer.length;
    }

    protected var _fpsBuffer :Array;
    protected var _fpsOffset :int;
    protected var _lastTime :int = 0;
    protected var _statsInterval :uint;

    protected static const DEFAULT_TIME_WINDOW :int = 5 * 1000; // 5 seconds
    protected static const AVERAGE_INTERVAL :int = 500; // half second
}
}
