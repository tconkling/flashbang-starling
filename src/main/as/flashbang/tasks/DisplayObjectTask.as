//
// Flashbang

package flashbang.tasks {

import starling.display.DisplayObject;

import aspire.util.Preconditions;

import flashbang.core.GameObject;
import flashbang.components.DisplayComponent;

public class DisplayObjectTask extends InterpolatingTask
{
    public function DisplayObjectTask (time :Number, easing :Function, display :DisplayObject)  {
        super(time, easing);
        _target = display;
    }

    protected function getTarget (obj :GameObject) :DisplayObject  {
        var target :DisplayObject = _target;
        if (target == null) {
            var dc :DisplayComponent = obj as DisplayComponent;
            Preconditions.checkState(dc != null, "obj does not implement DisplayComponent");
            target = dc.display;
        }
        return target;
    }

    protected var _target :DisplayObject;
}
}
