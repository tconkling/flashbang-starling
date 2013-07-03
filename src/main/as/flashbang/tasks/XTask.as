//
// flashbang

package flashbang.tasks {

import starling.display.DisplayObject;

public class XTask extends LocationTask
{
    public function XTask (x :Number, time :Number = 0, easingFn :Function = null, target :DisplayObject = null) {
        super(x, 0, time, easingFn, target);
    }

    override protected function updateValues () :void {
        if (isNaN(_fromX)) {
            _fromX = _target.x;
        }
        _target.x = interpolate(_fromX, _toX);
    }
}
}
