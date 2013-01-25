//
// Flashbang

package flashbang.tasks {

import starling.display.DisplayObject;

import flashbang.core.GameObject;
import flashbang.core.ObjectTask;

public class AlphaTask extends DisplayObjectTask
{
    public function AlphaTask (alpha :Number, time :Number = 0, easingFn :Function = null,
        disp :DisplayObject = null)
    {
        super(time, easingFn, disp);
        _to = alpha;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean
    {
        if (0 == _elapsedTime) {
            _target = getTarget(obj);
            _from = _target.alpha;
        }

        _elapsedTime += dt;
        _target.alpha = interpolate(_from, _to);
        return (_elapsedTime >= _totalTime);
    }

    override public function clone () :ObjectTask
    {
        return new AlphaTask(_to, _totalTime, _easingFn, _display);
    }

    protected var _to :Number;
    protected var _from :Number;
}

}
