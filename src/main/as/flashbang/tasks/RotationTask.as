//
// Flashbang

package flashbang.tasks {

import starling.display.DisplayObject;

import flashbang.GameObject;
import flashbang.ObjectTask;

public class RotationTask extends DisplayObjectTask
{
    public function RotationTask (rotationDegrees :Number, time :Number = 0,
        easingFn :Function = null, disp :DisplayObject = null)
    {
        super(time, easingFn, disp);
        _to = rotationDegrees;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean
    {
        if (0 == _elapsedTime) {
            _target = getTarget(obj);
            _from = _target.rotation;
        }

        _elapsedTime += dt;
        _target.rotation = interpolate(_from, _to);
        return (_elapsedTime >= _totalTime);
    }

    override public function clone () :ObjectTask
    {
        return new RotationTask(_to, _totalTime, _easingFn, _display);
    }

    protected var _to :Number;
    protected var _from :Number;
}

}
