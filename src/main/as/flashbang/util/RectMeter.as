//
// flashbang

package flashbang.util {

import starling.display.DisplayObject;

import aspire.display.ColorUtil;

public class RectMeter extends MeterBase
{
    public function RectMeter (width :Number, height :Number) {
        _width = width;
        _height = height;
        _outlineSize = 0;
        _fill = MeterFill.LEFT_TO_RIGHT;
        
        // update display immediately so that our width/height get set
        updateDisplay();
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
        var normalizedVal :Number = this.normalizedValue;
        
        var fgStart :Number = 0;
        var fgSize :Number = 0;
        var bgStart :Number = 0;
        var bgSize :Number = 0;
        var vertical :Boolean =
            (_fill == MeterFill.TOP_TO_BOTTOM || _fill == MeterFill.BOTTOM_TO_TOP);
        
        switch (_fill) {
        case MeterFill.LEFT_TO_RIGHT:
            fgSize = normalizedVal * _width;
            bgSize = _width - fgSize;
            fgStart = 0;
            bgStart = fgSize;
            break;
        
        case MeterFill.RIGHT_TO_LEFT:
            fgSize = normalizedVal * _width;
            bgSize = _width - fgSize;
            fgStart = bgSize;
            bgStart = 0;
            break;
        
        case MeterFill.TOP_TO_BOTTOM:
            fgSize = normalizedVal * _height;
            bgSize = _height - fgSize;
            fgStart = 0;
            bgStart = fgSize;
            break;
        
        case MeterFill.BOTTOM_TO_TOP:
            fgSize = normalizedVal * _height;
            bgSize = _height - fgSize;
            fgStart = bgSize;
            bgStart = 0;
            break;
        }
        
        _sprite.removeChildren();
        
        // draw foreground
        var x :Number = 0;
        var y :Number = 0;
        var w :Number = 0;
        var h :Number = 0;
        if (fgSize > 0) {
            if (vertical) {
                x = 0;
                y = fgStart;
                w = _width;
                h = fgSize;
            } else {
                x = fgStart;
                y = 0;
                w = fgSize;
                h = _height;
            }
            
            var fgColor :uint = ColorUtil.blend(_fgColorFull, _fgColorEmpty, normalizedVal);
            var fg :DisplayObject = DisplayUtil.fillRect(w, h, fgColor);
            fg.x = x;
            fg.y = y;
            _sprite.addChild(fg);
        }
        
        // draw background
        if (bgSize > 0) {
            if (vertical) {
                x = 0;
                y = bgStart;
                w = _width;
                h = fgSize;
            } else {
                x = bgStart;
                y = 0;
                w = bgSize;
                h = _height;
            }
            
            var bg :DisplayObject = DisplayUtil.fillRect(w, h, _bgColor);
            bg.x = x;
            bg.y = y;
            _sprite.addChild(bg);
        }
        
        // draw outline
        if (_outlineSize > 0) {
            _sprite.addChild(DisplayUtil.lineRect(_width, _height, _outlineColor, _outlineSize));
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
}
}
