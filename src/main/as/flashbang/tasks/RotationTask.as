//
// Flashbang

package flashbang.tasks {

import starling.display.DisplayObject;

public class RotationTask extends DisplayObjectTask
{
    public function RotationTask (radians :Number, time :Number = 0,
        easingFn :Function = null, target :DisplayObject = null)  {
        super(time, easingFn, target);
        _to = radians;
    }

    override protected function updateValues () :void {
        if (isNaN(_from)) {
            _from = _target.rotation;
        }
        _target.rotation = interpolate(_from, _to);
    }

    protected var _to :Number;
    protected var _from :Number = NaN;
}

}
