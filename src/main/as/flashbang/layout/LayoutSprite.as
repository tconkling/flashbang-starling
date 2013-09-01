//
// flashbang

package flashbang.layout {

import starling.display.DisplayObject;
import starling.display.Sprite;

/**
 * A base class for Sprites that arrange their children automatically.
 */
public class LayoutSprite extends Sprite
{
    override public function addChildAt (child :DisplayObject, index :int) :DisplayObject {
        super.addChildAt(child, index);
        _needsLayout = true;
        return child;
    }

    override public function removeChildAt (index :int, dispose :Boolean = false) :DisplayObject {
        var child :DisplayObject = super.removeChildAt(index, dispose);
        _needsLayout = true;
        return child;
    }

    public final function layout (force :Boolean = false) :void {
        if (!_needsLayout && !force) {
            return;
        }
        _needsLayout = false;
        doLayout();

        // If our parent is a layout sprite, tell it to layout as well.
        if (this.parent is LayoutSprite) {
            LayoutSprite(this.parent).layout(true);
        }
    }

    /** Subclasses override */
    protected function doLayout () :void {
        throw new Error("abstract");
    }

    protected var _needsLayout :Boolean;
}
}

