//
// Flashbang

package flashbang.tasks {

import flashbang.core.GameObject;

import starling.display.DisplayObject;

public class ScaleTask extends DisplayObjectTask
{
    public function ScaleTask (x :Number, y :Number, time :Number = 0,
        easingFn :Function = null, disp :DisplayObject = null) {
        super(time, easingFn, disp);
        _toX = x;
        _toY = y;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean {
        if (0 == _elapsedTime) {
            _target = getTarget(obj);
            _fromX = _target.scaleX;
            _fromY = _target.scaleY;
        }

        _elapsedTime += dt;
        _target.scaleX = interpolate(_fromX, _toX);
        _target.scaleY = interpolate(_fromY, _toY);
        return (_elapsedTime >= _totalTime);
    }

    protected var _toX :Number;
    protected var _toY :Number;
    protected var _fromX :Number;
    protected var _fromY :Number;
}

}
