//
// Flashbang

package flashbang.tasks {

import flash.display.MovieClip;

import flashbang.GameObject;
import flashbang.ObjectTask;

public class WaitForFrameTask extends MovieTask
{
    public function WaitForFrameTask (frameLabelOrNumber :*, movie :MovieClip = null)
    {
        super(0, null, movie);

        if (frameLabelOrNumber is int) {
            _frameNumber = frameLabelOrNumber as int;
        } else if (frameLabelOrNumber is String) {
            _frameLabel = frameLabelOrNumber as String;
        } else {
            throw new Error("frameLabelOrNumber must be a String or an int");
        }
    }

    override public function update (dt :Number, obj :GameObject) :Boolean
    {
        if (_target == null) {
            _target = getTarget(obj);
        }

        return (null != _frameLabel ? _target.currentLabel == _frameLabel :
                                      _target.currentFrame == _frameNumber);
    }

    override public function clone () :ObjectTask
    {
        return new WaitForFrameTask(null != _frameLabel ? _frameLabel : _frameNumber, _movie);
    }

    protected var _frameLabel :String;
    protected var _frameNumber :int;

}

}
