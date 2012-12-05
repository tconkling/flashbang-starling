//
// Flashbang

package flashbang.tasks {

import starling.display.DisplayObject;

import flashbang.GameObject;
import flashbang.ObjectTask;

public class ComplexLocationTask extends LocationTask
{
    public function ComplexLocationTask (x :Number, y :Number, time :Number, xEasingFn :Function,
        yEasingFn :Function, disp :DisplayObject = null)
    {
        super(x, y, time, null, disp);
        _xEasingFn = xEasingFn;
        _yEasingFn = yEasingFn;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean
    {
        if (0 == _elapsedTime) {
            _lc = getLocationTarget(obj);
            _fromX = _lc.x;
            _fromY = _lc.y;
        }

        _elapsedTime = Math.min(_elapsedTime + dt, _totalTime);
        _lc.x = _xEasingFn(_fromX, _toX, _elapsedTime, _totalTime);
        _lc.y = _yEasingFn(_fromY, _toY, _elapsedTime, _totalTime);

        return (_elapsedTime >= _totalTime);
    }

    override public function clone () :ObjectTask
    {
        return new ComplexLocationTask(_toX, _toY, _totalTime, _xEasingFn, _yEasingFn, _display);
    }

    protected var _xEasingFn :Function;
    protected var _yEasingFn :Function;
}

}
