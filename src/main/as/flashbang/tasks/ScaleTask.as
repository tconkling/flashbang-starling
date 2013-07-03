//
// Flashbang

package flashbang.tasks {

import starling.display.DisplayObject;

public class ScaleTask extends DisplayObjectTask
{
    public function ScaleTask (x :Number, y :Number, time :Number = 0,
        easingFn :Function = null, target :DisplayObject = null) {
        super(time, easingFn, target);
        _toX = x;
        _toY = y;
    }

    override protected function updateValues () :void {
        if (isNaN(_fromX)) {
            _fromX = _target.scaleX;
            _fromY = _target.scaleY;
        }
        _target.scaleX = interpolate(_fromX, _toX);
        _target.scaleY = interpolate(_fromY, _toY);
    }

    protected var _toX :Number;
    protected var _toY :Number;
    protected var _fromX :Number = NaN;
    protected var _fromY :Number = NaN;
}

}
