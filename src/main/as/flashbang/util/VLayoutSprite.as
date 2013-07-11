//
// flashbang

package flashbang.util {

import flash.geom.Rectangle;

import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.utils.HAlign;

/**
 * A Sprite that arranges its children vertically.
 * Call layout() after adding or removing children to update the sprite's layout.
 */
public class VLayoutSprite extends Sprite
{
    public function VLayoutSprite (vOffset :Number = 2, hAlign :String = "center") {
        _vOffset = vOffset;
        _hAlign = hAlign;
    }

    public function get vOffset () :Number {
        return _vOffset;
    }

    public function set vOffset (val :Number) :void {
        if (_vOffset != val) {
            _vOffset = val;
            _needsLayout = true;
        }
    }

    public function get hAlign () :String {
        return _hAlign;
    }

    public function set hAlign (val :String) :void {
        if (_hAlign != val) {
            _hAlign = val;
            _needsLayout = true;
        }
    }

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

    public function layout (force :Boolean = false) :void {
        if (!_needsLayout && !force) {
            return;
        }
        _needsLayout = false;

        var ii :int;
        var maxWidth :Number = 0;
        if (_hAlign != HAlign.LEFT) {
            for (ii = 0; ii < this.numChildren; ++ii) {
                maxWidth = Math.max(getChildAt(ii).width, maxWidth);
            }
        }

        var y :Number = 0;
        for (ii = 0; ii < this.numChildren; ++ii) {
            var child :DisplayObject = getChildAt(ii);
            child.x = 0;
            child.y = 0;
            var bounds :Rectangle = child.getBounds(this, R);
            child.y = -bounds.top + y;
            child.x = -bounds.left;
            if (_hAlign == HAlign.CENTER) {
                child.x += (maxWidth - child.width) * 0.5;
            } else if (_hAlign == HAlign.RIGHT) {
                child.x += maxWidth - child.width;
            }

            y += bounds.height + _vOffset;
        }
    }

    protected var _vOffset :Number;
    protected var _hAlign :String;
    protected var _needsLayout :Boolean;

    protected static const R :Rectangle = new Rectangle();
}
}
