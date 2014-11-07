//
// flashbang

package flashbang.objects {

import aspire.util.MathUtil;

import flashbang.util.DisplayUtil;

import starling.display.Quad;
import starling.display.Sprite;

public class SimpleCheckbox extends Checkbox
{
    public function SimpleCheckbox (width :Number, fgColor :uint = 0x0, bgColor :uint = 0xffffff,
        disabledColor :uint = 0x3B3B3B) {

        width = Math.max(width, 10);

        _fgColor = fgColor;
        _disabledColor = disabledColor;

        _outline = DisplayUtil.fillRect(width, width, fgColor);
        _container.addChild(_outline);

        _bg = DisplayUtil.fillRect(width - 4, width - 4, bgColor);
        _bg.x = 2;
        _bg.y = 2;
        _container.addChild(_bg);

        // draw an X
        var xLineLength :Number = Math.sqrt(2 * (width - 8) * (width - 8));
        _check = drawX(xLineLength, fgColor);
        _check.x = width * 0.5;
        _check.y = width * 0.5;
        _container.addChild(_check);

        _sprite.addChild(_container);
    }

    override protected function showCheckboxState (buttonState :String, val :Boolean) :void {
        _check.visible = val;

        // recolor
        var color :uint = (buttonState == DISABLED ? _disabledColor : _fgColor);
        _outline.color = color;
        for each (var child :Quad in _check) {
            child.color = color;
        }

        _container.y = (buttonState == DOWN ? 2 : 0);
    }

    protected static function drawX (lineLength :Number, color :uint) :Sprite {
        var container :Sprite = new Sprite();
        var line :Quad;

        line = DisplayUtil.fillRect(lineLength, 2, color);
        line.pivotX = line.width * 0.5;
        line.pivotY = line.height * 0.5;
        line.rotation = MathUtil.toRadians(45);
        container.addChild(line);

        line = DisplayUtil.fillRect(lineLength, 2, color);
        line.pivotX = line.width * 0.5;
        line.pivotY = line.height * 0.5;
        line.rotation = MathUtil.toRadians(-45);
        container.addChild(line);

        return container;
    }

    protected var _container :Sprite = new Sprite();
    protected var _outline :Quad;
    protected var _bg :Quad;
    protected var _check :Sprite = new Sprite();

    protected var _fgColor :uint;
    protected var _disabledColor :uint;
}
}
