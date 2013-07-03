//
// Flashbang

package flashbang.tasks {

import aspire.util.Preconditions;

import flashbang.components.DisplayComponent;
import flashbang.components.LocationComponent;

import starling.display.DisplayObject;

public class LocationTask extends InterpolatingTask
{
    public function LocationTask (x :Number, y :Number, time :Number = 0,
        easingFn :Function = null, target :DisplayObject = null) {
        super(time, easingFn);
        _toX = x;
        _toY = y;
        if (target != null) {
            _target = new DisplayObjectWrapper(target);
        }
    }

    override protected function added () :void {
        super.added();
        // If we weren't given a target, operate on our parent object
        if (_target == null) {
            _target = this.parent as LocationComponent;
            if (_target == null) {
                var dc :DisplayComponent = this.parent as DisplayComponent;
                var disp :DisplayObject = dc.display;
                if (disp != null) {
                    _target = new DisplayObjectWrapper(disp);
                }
            }
            Preconditions.checkState(_target != null,
                "parent does not implement LocationComponent");
        }
    }

    override protected function updateValues () :void {
        if (isNaN(_fromX)) {
            _fromX = _target.x;
            _fromY = _target.y;
        }
        _target.x = interpolate(_fromX, _toX);
        _target.y = interpolate(_fromY, _toY);
    }

    protected var _toX :Number;
    protected var _toY :Number;
    protected var _fromX :Number = NaN;
    protected var _fromY :Number = NaN;

    protected var _target :LocationComponent;
}

}
