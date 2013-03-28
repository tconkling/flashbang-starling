//
// flashbang

package flashbang.util.meter {

import aspire.display.ColorUtil;

import flashbang.util.DisplayUtil;

import starling.display.DisplayObject;

public class RectMeter extends SpriteMeterBase
{
    public function RectMeter (width :Number, height :Number) {
        _width = width;
        _height = height;
        _outlineSize = 0;
        _fill = MeterFill.LEFT_TO_RIGHT;

        // update display immediately so that our width/height get set
        updateDisplay();
    }

    override public function set width (val :Number) :void {
        if (_width != val) {
            _width = val;
            updateDisplay();
        }
    }

    override public function set height (val :Number) :void {
        if (_height != val) {
            _height = val;
            updateDisplay();
        }
    }

    public function setSize (width :Number, height :Number) :void {
        if (_width != width || _height != height) {
            _width = width;
            _height = height;
            updateDisplay();
        }
    }

    public function get fill () :MeterFill {
        return _fill;
    }

    public function set fill (val :MeterFill) :void {
        if (_fill != val) {
            _fill = val;
            _needsDisplayUpdate = true;
        }
    }

    public function get outlineSize () :Number {
        return _outlineSize;
    }

    public function set outlineSize (val :Number) :void {
        if (_outlineSize != val) {
            _outlineSize = val;
            _needsDisplayUpdate = true;
        }
    }

    public function get outlineColor () :uint {
        return _outlineColor;
    }

    public function set outlineColor (val :uint) :void {
        if (_outlineColor != val) {
            _outlineColor = val;
            _needsDisplayUpdate = true;
        }
    }

    public function get backgroundColor () :uint {
        return _bgColor;
    }

    public function set backgroundColor (val :uint) :void {
        if (_bgColor != val) {
            _bgColor = val;
            _needsDisplayUpdate = true;
        }
    }

    public function get foregroundColorFull () :uint {
        return _fgColorFull;
    }

    public function set foregroundColorFull (val :uint) :void {
        if (_fgColorFull != val) {
            _fgColorFull = val;
            _needsDisplayUpdate = true;
        }
    }

    public function get foregroundColorEmpty () :uint {
        return _fgColorEmpty;
    }

    public function set foregroundColorEmpty (val :uint) :void {
        if (_fgColorEmpty != val) {
            _fgColorEmpty = val;
            _needsDisplayUpdate = true;
        }
    }

    public function get foregroundColor () :uint {
        return this.foregroundColorFull;
    }

    public function set foregroundColor (val :uint) :void {
        this.foregroundColorEmpty = this.foregroundColorFull = val;
    }

    override protected function updateDisplay () :void {
        removeChildren();

        const metrics :MeterMetrics = MeterMetrics.calculate(this, _width, _height, _fill, METRICS);

        // draw foreground
        if (metrics.fgWidth > 0 && metrics.fgHeight > 0) {
            const fgColor :uint = ColorUtil.blend(_fgColorFull, _fgColorEmpty, this.normalizedValue);
            const fg :DisplayObject = DisplayUtil.fillRect(metrics.fgWidth, metrics.fgHeight, fgColor);
            fg.x = metrics.fgX;
            fg.y = metrics.fgY;
            addChild(fg);
        }

        // draw background
        if (metrics.bgWidth > 0 && metrics.bgHeight > 0) {
            const bg :DisplayObject = DisplayUtil.fillRect(metrics.bgWidth, metrics.bgHeight, _bgColor);
            bg.x = metrics.bgX;
            bg.y = metrics.bgY;
            addChild(bg);
        }

        // draw outline
        if (_outlineSize > 0) {
            addChild(DisplayUtil.lineRect(_width, _height, _outlineColor, _outlineSize));
        }
    }

    protected var _width :Number;
    protected var _height :Number;
    protected var _outlineSize :Number;
    protected var _fill :MeterFill;

    protected var _outlineColor :uint;
    protected var _bgColor :uint;
    protected var _fgColorFull :uint;
    protected var _fgColorEmpty :uint;

    protected static const METRICS :MeterMetrics = new MeterMetrics();
}
}
