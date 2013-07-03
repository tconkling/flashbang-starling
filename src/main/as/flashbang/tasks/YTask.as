//
// flashbang

package flashbang.tasks {

import starling.display.DisplayObject;

public class YTask extends LocationTask
{
    public function YTask (y :Number, time :Number = 0, easingFn :Function = null, target :DisplayObject = null) {
        super(0, y, time, easingFn, target);
    }

    override protected function updateValues () :void {
        if (isNaN(_fromY)) {
            _fromY = _target.y;
        }
        _target.y = interpolate(_fromY, _toY);
    }
}
}
