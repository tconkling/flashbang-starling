//
// Flashbang

package flashbang.tasks {

import flashbang.core.GameObject;

import starling.display.DisplayObject;

public class AlphaTask extends DisplayObjectTask
{
    public function AlphaTask (alpha :Number, time :Number = 0, easingFn :Function = null,
        disp :DisplayObject = null) {
        super(time, easingFn, disp);
        _to = alpha;
    }

    override protected function updateValues () :void {
        if (isNaN(_from)) {
            _from = _target.alpha;
        }
        _target.alpha = interpolate(_from, _to);
    }

    protected var _to :Number;
    protected var _from :Number = NaN;
}

}
