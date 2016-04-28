//
// flashbang

package flashbang.layout {

import flash.geom.Rectangle;

import starling.display.DisplayObject;
import starling.display.Quad;
import starling.utils.Align;

/**
 * A Sprite that arranges its children vertically.
 * Call layout() after adding or removing children to update the sprite's layout.
 */
public class VLayoutSprite extends LayoutSprite
{
    public function VLayoutSprite (vOffset :Number = 0, hAlign :String = "center") {
        _vOffset = vOffset;
        _hAlign = hAlign;
    }

    public function get reversed () :Boolean {
        return _reversed;
    }

    /** If true, then children are laid out bottom-to-top instead of top-to-bottom */
    public function set reversed (val :Boolean) :void {
        if (_reversed != val) {
            _reversed = val;
            _needsLayout = true;
        }
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

    public function addVSpacer (size :Number) :void {
        addVSpacerAt(size, this.numChildren);
    }

    public function addVSpacerAt (size :Number, index :int) :void {
        const spacer :Quad = new Quad(1, size);
        spacer.alpha = 0;
        addChildAt(spacer, index);
    }

    override protected function doLayout () :void {
        var ii :int;
        var child :DisplayObject;

        var maxWidth :Number = 0;
        if (_hAlign != Align.LEFT) {
            for (ii = 0; ii < this.numChildren; ++ii) {
                child = getChildAt(ii);
                if (child.visible) {
                    maxWidth = Math.max(child.width, maxWidth);
                }
            }
        }

        var from :int, to :int, inc :int;
        if (_reversed) {
            from = this.numChildren - 1;
            to = -1;
            inc = -1;
        } else {
            from = 0;
            to = this.numChildren;
            inc = 1;
        }

        var y :Number = 0;
        for (ii = from; ii != to; ii += inc) {
            child = getChildAt(ii);
            if (child.visible) {
                child.x = 0;
                child.y = 0;
                var bounds :Rectangle = child.getBounds(this, R);
                child.y = -bounds.top + y;
                child.x = -bounds.left;
                if (_hAlign == Align.CENTER) {
                    child.x += (maxWidth - bounds.width) * 0.5;
                } else if (_hAlign == Align.RIGHT) {
                    child.x += maxWidth - bounds.width;
                }

                y += bounds.height + _vOffset;
            }
        }
    }

    protected var _vOffset :Number;
    protected var _hAlign :String;
    protected var _reversed :Boolean;

    protected static const R :Rectangle = new Rectangle();
}
}
