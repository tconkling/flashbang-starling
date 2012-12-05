//
// Flashbang

package flashbang.tasks {

import starling.display.DisplayObject;

import aspire.util.Preconditions;

import flashbang.GameObject;
import flashbang.components.DisplayComponent;

public class DisplayObjectTask extends InterpolatingTask
{
    public function DisplayObjectTask (time :Number, easing :Function, display :DisplayObject)
    {
        super(time, easing);
        _display = display;
    }

    protected function getTarget (obj :GameObject) :DisplayObject
    {
        var display :DisplayObject = _display;
        if (display == null) {
            var dc :DisplayComponent = obj as DisplayComponent;
            Preconditions.checkState(dc != null, "obj does not implement DisplayComponent");
            display = dc.display;
        }
        return display;
    }

    protected var _display :DisplayObject;

    protected var _target :DisplayObject;
}
}
