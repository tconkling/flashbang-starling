//
// Flashbang

package flashbang.tasks {

import starling.display.DisplayObject;

import flashbang.core.GameObject;
import flashbang.core.ObjectTask;

public class VisibleTask extends DisplayObjectTask
{
    public function VisibleTask (visible :Boolean, disp :DisplayObject = null) {
        super(0, null, disp);
        _visible = visible;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean  {
        getTarget(obj).visible = _visible;
        return true;
    }

    protected var _visible :Boolean;
}

}
