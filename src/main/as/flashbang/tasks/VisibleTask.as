//
// Flashbang

package flashbang.tasks {

import aspire.util.Preconditions;

import flashbang.components.DisplayComponent;
import flashbang.core.ObjectTask;

import starling.display.DisplayObject;

public class VisibleTask extends ObjectTask
{
    public function VisibleTask (visible :Boolean, target :DisplayObject = null) {
        _visible = visible;
        _target = target;
    }

    override protected function added () :void {
        // If we weren't given a target, operate on our parent object
        if (_target == null) {
            var dc :DisplayComponent = this.parent as DisplayComponent;
            Preconditions.checkState(dc != null, "parent does not implement DisplayComponent");
            _target = dc.display;
        }
        _target.visible = _visible;
        destroySelf();
    }

    protected var _target :DisplayObject;
    protected var _visible :Boolean;
}

}
