//
// flashbang

package flashbang.objects {

import flashbang.util.TextFieldBuilder;

import starling.display.Quad;
import starling.text.TextField;

public class SimpleTextButton extends Button
{
    public function SimpleTextButton (text :String, fontSize :Number = 12) {
        _tf = new TextFieldBuilder()
            .text(text)
            .font("_sans")
            .fontSize(fontSize)
            .autoSizeSingleLine()
            .build();
        _tf.x = PADDING;
        _tf.y = PADDING;

        _bg = new Quad(_tf.width + (PADDING * 2), _tf.height + (PADDING * 2));

        _sprite.addChild(_bg);
        _sprite.addChild(_tf);
    }

    override protected function showState (state :int) :void {
        _bg.color = BG_COLORS[state];
        _tf.color = TEXT_COLORS[state];
    }

    protected var _tf :TextField;
    protected var _bg :Quad;

    protected static const PADDING :Number = 4;

    protected static const BG_COLORS :Vector.<uint> = new <uint>[
        0x6699CC,   // up
        0x0F3792,   // down
        0x6699CC,   // over
        0x939393,   // disabled
    ];

    protected static const TEXT_COLORS :Vector.<uint> = new <uint>[
        0x0F3792,   // up
        0x6699CC,   // down
        0x0F3792,   // over
        0x3B3B3B,   // disabled
    ];

}
}
