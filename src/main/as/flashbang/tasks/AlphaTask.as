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

    override public function update (dt :Number, obj :GameObject) :Boolean {
        if (0 == _elapsedTime) {
            _target = getTarget(obj);
            _from = _target.alpha;
        }

        _elapsedTime += dt;
        _target.alpha = interpolate(_from, _to);
        return (_elapsedTime >= _totalTime);
    }

    protected var _to :Number;
    protected var _from :Number;
}

}
