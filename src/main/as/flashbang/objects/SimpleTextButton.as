//
// flashbang

package flashbang.objects {

import flashbang.util.TextFieldBuilder;

import starling.display.Quad;
import starling.text.TextField;

public class SimpleTextButton extends Button
{
    public function SimpleTextButton (text :String, fontSize :Number = 12, fontName :String = "_sans") {
        _tf = new TextFieldBuilder()
            .text(text)
            .font(fontName)
            .fontSize(fontSize)
            .autoSize()
            .build();
        _tf.x = PADDING;
        _tf.y = PADDING;
        _tf.touchable = false;

        _bg = new Quad(_tf.width + (PADDING * 2), _tf.height + (PADDING * 2));

        _sprite.addChild(_bg);
        _sprite.addChild(_tf);
    }

    override protected function showState (state :String) :void {
        _bg.color = BG_COLORS[state];
        _tf.color = TEXT_COLORS[state];
    }

    protected var _tf :TextField;
    protected var _bg :Quad;

    protected static const PADDING :Number = 4;

    protected static const BG_COLORS :Object = {
        "up": 0x6699CC,
        "down": 0x0F3792,
        "over": 0x6699CC,
        "disabled": 0x939393
    };

    protected static const TEXT_COLORS :Object = {
        "up": 0x0F3792,
        "down": 0x6699CC,
        "over": 0x0F3792,
        "disabled": 0x3B3B3B
    };

}
}
