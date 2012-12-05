//
// Flashbang

package flashbang.tasks {

import flash.display.MovieClip;

import flashbang.GameObject;
import flashbang.ObjectTask;

public class PlayFramesTask extends MovieTask
{
    public function PlayFramesTask (startFrame :int, endFrame :int, totalTime :Number,
        easingFn :Function = null, movie :MovieClip = null)
    {
        super(totalTime, easingFn, movie);
        _startFrame = startFrame;
        _endFrame = endFrame;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean
    {
        super.update(dt, obj);

        if (_target == null) {
            _target = getTarget(obj);
        }

        var curFrame :int = interpolate(_startFrame, _endFrame);
        _target.gotoAndStop(curFrame);

        return _elapsedTime >= _totalTime;
    }

    override public function clone () :ObjectTask
    {
        return new PlayFramesTask(_startFrame, _endFrame, _totalTime, _easingFn, _movie);
    }

    protected var _startFrame :int;
    protected var _endFrame :int;
}

}
