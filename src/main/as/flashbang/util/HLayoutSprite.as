//
// flashbang

package flashbang.util {

import flash.geom.Rectangle;

import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.utils.VAlign;

/**
 * A Sprite that arranges its children horizontally.
 * Call layout() after adding or removing children to update the sprite's layout.
 */
public class HLayoutSprite extends Sprite
{
    public function HLayoutSprite (hOffset :Number = 2, vAlign :String = "center") {
        _hOffset = hOffset;
        _vAlign = vAlign;
    }

    public function get hOffset () :Number {
        return _hOffset;
    }

    public function set hOffset (val :Number) :void {
        if (_hOffset != val) {
            _hOffset = val;
            _needsLayout = true;
        }
    }

    public function get vAlign () :String {
        return _vAlign;
    }

    public function set vAlign (val :String) :void {
        if (_vAlign != val) {
            _vAlign = val;
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

    public function layout () :void {
        if (!_needsLayout) {
            return;
        }
        _needsLayout = false;

        var ii :int;
        var maxHeight :Number = 0;
        if (_vAlign != VAlign.TOP) {
            for (ii = 0; ii < this.numChildren; ++ii) {
                maxHeight = Math.max(getChildAt(ii).height, maxHeight);
            }
        }

        var x :Number = 0;
        for (ii = 0; ii < this.numChildren; ++ii) {
            var child :DisplayObject = getChildAt(ii);
            child.x = 0;
            child.y = 0;
            var bounds :Rectangle = child.getBounds(this, R);
            child.x = -bounds.left + x;
            child.y = -bounds.top;
            if (_vAlign == VAlign.CENTER) {
                child.y += (maxHeight - child.height) * 0.5;
            } else if (_vAlign == VAlign.BOTTOM) {
                child.y += maxHeight - child.height;
            }

            x += bounds.width + _hOffset;
        }
    }

    protected var _hOffset :Number;
    protected var _vAlign :String;
    protected var _needsLayout :Boolean;

    protected static const R :Rectangle = new Rectangle();
}
}
