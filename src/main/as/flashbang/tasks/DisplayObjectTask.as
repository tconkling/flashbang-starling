//
// Flashbang

package flashbang.tasks {

import aspire.util.Preconditions;

import flashbang.components.DisplayComponent;

import starling.display.DisplayObject;

public class DisplayObjectTask extends InterpolatingTask
{
    public function DisplayObjectTask (time :Number, easing :Function, target :DisplayObject)  {
        super(time, easing);
        _target = target;
    }

    override protected function added () :void {
        super.added();
        // If we weren't given a target, operate on our parent object
        if (_target == null) {
            var dc :DisplayComponent = this.parent as DisplayComponent;
            Preconditions.checkState(dc != null, "parent does not implement DisplayComponent");
            _target = dc.display;
        }
    }

    protected var _target :DisplayObject;
}
}
