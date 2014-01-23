//
// flashbang

package flashbang.layout {

import flash.geom.Rectangle;

import starling.display.DisplayObject;
import starling.display.Quad;
import starling.utils.HAlign;

/**
 * A Sprite that arranges its children vertically.
 * Call layout() after adding or removing children to update the sprite's layout.
 */
public class VLayoutSprite extends LayoutSprite
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

    public function addVSpacer (size :Number) :void {
        const spacer :Quad = new Quad(1, size);
        spacer.visible = false;
        addChild(spacer);
    }

    override protected function doLayout () :void {
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

    protected static const R :Rectangle = new Rectangle();
}
}
