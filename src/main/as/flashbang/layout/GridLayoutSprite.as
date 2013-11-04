//
// flashbang

package flashbang.layout {

import flash.geom.Rectangle;

import starling.display.DisplayObject;
import starling.utils.HAlign;
import starling.utils.VAlign;

/**
 * A Sprite that arranges its children in a grid.
 * Call layout() after adding or removing children to update the sprite's layout.
 */
public class GridLayoutSprite extends LayoutSprite
{
    public function GridLayoutSprite (hOffset :Number = 2, vOffset :Number = 2,
        maxWidth :Number = 200, maxHeight :Number = 0) {
        _hOffset = hOffset;
        _vOffset = vOffset;
        _maxWidth = maxWidth;
        _maxHeight = maxHeight;

        if (INFO == null) {
            // can't init this at its declaration site; the private LayoutInfo class
            // won't be initialized yet
            INFO = new LayoutInfo();
        }
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

    public function get vOffset () :Number {
        return _vOffset;
    }

    public function set vOffset (val :Number) :void {
        if (_vOffset != val) {
            _vOffset = val;
            _needsLayout = true;
        }
    }

    public function get maxWidth () :Number {
        return _maxWidth;
    }

    public function set maxWidth (val :Number) :void {
        if (_maxWidth != val) {
            _maxWidth = val;
            _needsLayout = true;
        }
    }

    public function get maxHeight () :Number {
        return _maxHeight;
    }

    public function set maxHeight (val :Number) :void {
        if (_maxHeight != val) {
            _maxHeight = val;
            _needsLayout = true;
        }
    }

    public function get colHAlign () :String {
        return _colHAlign;
    }

    public function set colHAlign (val :String) :void {
        if (_colHAlign != val) {
            _colHAlign = val;
            _needsLayout = true;
        }
    }

    public function get rowVAlign () :String {
        return _rowVAlign;
    }

    public function set rowVAlign (val :String) :void {
        if (_rowVAlign != val) {
            _rowVAlign = val;
            _needsLayout = true;
        }
    }

    override protected function doLayout () :void {
        var info :LayoutInfo = INFO;
        info.endIdx = 0;
        info.size = 0;

        if (_maxWidth > 0) {
            // build rows
            while (info.endIdx < this.numChildren) {
                buildRow(info.endIdx, info.size, info);
            }
        } else {
            // build columns
            while (info.endIdx < this.numChildren) {
                buildColumn(info.endIdx, info.size, info);
            }
        }
    }

    protected function buildRow (idx :int, y :Number, info :LayoutInfo) :void {
        var x :Number = 0;
        var maxChildHeight :Number = 0;
        var bounds :Rectangle = null;
        var child :DisplayObject;
        var ii :int;
        var endIdx :int = this.numChildren;
        for (ii = idx; ii < endIdx; ++ii) {
            child = getChildAt(ii);
            child.x = 0;
            child.y = 0;
            bounds = child.getBounds(this, R);
            child.x = -bounds.left + x;
            child.y = -bounds.top + y;
            if (_maxWidth > 0 && x > 0 && x + bounds.width > _maxWidth) {
                // end our row here
                endIdx = ii;
                break;
            }

            maxChildHeight = Math.max(maxChildHeight, bounds.height);
            x += bounds.width + _hOffset;
        }

        if (_rowVAlign != VAlign.TOP) {
            for (ii = idx; ii < endIdx; ++ii) {
                child = getChildAt(ii);
                var height :Number = child.getBounds(this, R).height;
                if (_rowVAlign == VAlign.CENTER) {
                    child.y += (maxChildHeight - height) * 0.5;
                } else {
                    child.y += (maxChildHeight - height);
                }
            }
        }

        info.size += maxChildHeight + _vOffset;
        info.endIdx = endIdx;
    }

    protected function buildColumn (idx :int, x :Number, info :LayoutInfo) :void {
        var y :Number = 0;
        var maxChildWidth :Number = 0;
        var bounds :Rectangle = null;
        var child :DisplayObject;
        var ii :int;
        var endIdx :int = this.numChildren;
        for (ii = idx; ii < endIdx; ++ii) {
            child = getChildAt(ii);
            child.x = 0;
            child.y = 0;
            bounds = child.getBounds(this, R);
            child.x = -bounds.left + x;
            child.y = -bounds.top + y;
            if (_maxHeight > 0 && y > 0 && y + bounds.height > _maxHeight) {
                // end our column here
                endIdx = ii;
                break;
            }

            maxChildWidth = Math.max(maxChildWidth, bounds.width);
            y += bounds.height + _vOffset;
        }

        if (_colHAlign != HAlign.LEFT) {
            for (ii = idx; ii < endIdx; ++ii) {
                child = getChildAt(ii);
                var width :Number = child.getBounds(this, R).width;
                if (_colHAlign == HAlign.CENTER) {
                    child.x += (maxChildWidth - width) * 0.5;
                } else {
                    child.x += (maxChildWidth - width);
                }
            }
        }

        info.size += maxChildWidth + _hOffset;
        info.endIdx = endIdx;
    }

    protected var _hOffset :Number;
    protected var _vOffset :Number;
    protected var _maxWidth :Number;
    protected var _maxHeight :Number;
    protected var _colHAlign :String = "center";
    protected var _rowVAlign :String = "center";

    protected static const R :Rectangle = new Rectangle();
    protected static var INFO :LayoutInfo;
}
}

class LayoutInfo {
    public var endIdx :int;
    public var size :Number;
}
