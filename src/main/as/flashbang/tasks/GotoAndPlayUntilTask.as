//
// Flashbang

package flashbang.tasks {

import flash.display.MovieClip;

import flashbang.GameObject;
import flashbang.ObjectTask;

public class GotoAndPlayUntilTask extends MovieTask
{
    /**
     * Plays movie starting at frame until stopFrame. If the start frame isn't given, it defaults
     * to 1. If the stopFrame isn't given, it defaults to the movie's totalFrames. If movie isn't
     * given, it defaults to the displayObject of the DisplayComponent this task is on.
     */
    public function GotoAndPlayUntilTask (frame :Object = null, stopFrame :Object = null,
        movie :MovieClip = null)
    {
        super(0, null, movie);
        _startFrame = frame;
        _stopFrame = stopFrame;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean
    {
        if (_target == null) {
            _target = getTarget(obj);

            if (_startFrame == null) {
                _startFrame = 1;
            }
            if (_stopFrame == null) {
                _stopFrame = _target.totalFrames;
            }
            _target.gotoAndPlay(_startFrame);
        }

        if ((_stopFrame is String && _target.currentFrameLabel == String(_stopFrame)) ||
            (_stopFrame is int && _target.currentFrame == int(_stopFrame))) {
            _target.gotoAndStop(_target.currentFrame);
            return true;
        } else {
            return false;
        }
    }

    override public function clone () :ObjectTask
    {
        return new GotoAndPlayUntilTask(_startFrame, _stopFrame, _movie);
    }

    protected var _startFrame :Object;
    protected var _stopFrame :Object;
}

}
