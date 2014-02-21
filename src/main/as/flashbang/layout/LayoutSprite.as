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
        _needsLayout = true;
        return super.addChildAt(child, index);
    }

    override public function removeChildAt (index :int, dispose :Boolean = false) :DisplayObject {
        _needsLayout = true;
        return super.removeChildAt(index, dispose);
    }

    public final function layout (force :Boolean = false) :void {
        if (_isLayingOut || (!_needsLayout && !force)) {
            return;
        }
        _needsLayout = false;
        _isLayingOut = true;

        // Recursively lay out our children if they need it.
        for (var ii :int = 0; ii < this.numChildren; ++ii) {
            var layoutChild :LayoutSprite = (getChildAt(ii) as LayoutSprite);
            if (layoutChild != null) {
                layoutChild.layout(force);
            }
        }

        // Layout ourselves.
        doLayout();

        // If our parent is a layout sprite, force it to re-layout, since our size has
        // likely changed.
        var layoutParent :LayoutSprite = (this.parent as LayoutSprite);
        if (layoutParent != null && !layoutParent._isLayingOut) {
            layoutParent.layout(true);
        }

        _isLayingOut = false;
    }

    /** Subclasses override */
    protected function doLayout () :void {
        throw new Error("abstract");
    }

    protected var _needsLayout :Boolean;
    private var _isLayingOut :Boolean;
}
}

