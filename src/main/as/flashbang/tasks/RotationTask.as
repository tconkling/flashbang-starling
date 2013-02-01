//
// Flashbang

package flashbang.tasks {

import flashbang.core.GameObject;

import starling.display.DisplayObject;

public class RotationTask extends DisplayObjectTask
{
    public function RotationTask (radians :Number, time :Number = 0,
        easingFn :Function = null, disp :DisplayObject = null)  {
        super(time, easingFn, disp);
        _to = radians;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean {
        if (0 == _elapsedTime) {
            _target = getTarget(obj);
            _from = _target.rotation;
        }

        _elapsedTime += dt;
        _target.rotation = interpolate(_from, _to);
        return (_elapsedTime >= _totalTime);
    }

    protected var _to :Number;
    protected var _from :Number;
}

}
