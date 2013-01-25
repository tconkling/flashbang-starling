//
// flashbang

package flashbang.tasks {

import starling.display.DisplayObject;

import aspire.util.Preconditions;

import flashbang.core.GameObject;
import flashbang.core.ObjectTask;
import flashbang.components.LocationComponent;

public class XTask extends DisplayObjectTask
{
    public function XTask (x :Number, time :Number = 0, easingFn :Function = null,
        disp :DisplayObject = null)
    {
        super(time, easingFn, disp);
        _toX = x;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean
    {
        if (0 == _elapsedTime) {
            _lc = getLocationTarget(obj);
            _fromX = _lc.x;
        }

        _elapsedTime += dt;

        _lc.x = interpolate(_fromX, _toX);

        return (_elapsedTime >= _totalTime);
    }

    override public function clone () :ObjectTask
    {
        return new XTask(_toX, _totalTime, _easingFn, _display);
    }

    protected function getLocationTarget (obj :GameObject) :LocationComponent
    {
        var display :DisplayObject = super.getTarget(obj);
        if (display != null) {
            return new DisplayObjectWrapper(display);
        }
        var lc :LocationComponent = obj as LocationComponent;
        Preconditions.checkState(lc != null, "obj does not implement LocationComponent");
        return lc;
    }

    protected var _toX :Number;
    protected var _fromX :Number;

    protected var _lc :LocationComponent;
}
}
