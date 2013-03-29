//
// Flashbang

package flashbang.tasks {

import aspire.util.Preconditions;

import flashbang.components.DisplayComponent;
import flashbang.core.GameObject;

import starling.display.Sprite;

public class SpriteTask extends InterpolatingTask
{
    public function SpriteTask (time :Number, easing :Function, sprite :Sprite)  {
        super(time, easing);
        _target = sprite;
    }

    protected function getTarget (obj :GameObject) :Sprite  {
        var target :Sprite = _target;
        if (target == null) {
            const dc :DisplayComponent = obj as DisplayComponent;
            Preconditions.checkState(dc != null, "obj does not implement DisplayComponent");
            target = Sprite(dc.display);
        }
        return target;
    }

    protected var _target :Sprite;
}
}

