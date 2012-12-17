//
// Flashbang - a framework for creating Flash games

package flashbang.debug {

import starling.display.DisplayObject;
import starling.text.TextField;
import starling.utils.HAlign;

import flashbang.components.DisplayComponent;

public class FramerateView extends Framerate
    implements DisplayComponent
{
    public function FramerateView (normalColor :uint = 0x0000ff, slowColor :uint = 0xff0000,
        outlineColor :uint = 0xffffff, slowFps :Number = 15)
    {
        super(1000);

        _normalColor = normalColor;
        _slowColor = slowColor;
        _slowFps = slowFps;

        _tf = new TextField(150, 15, "", "Verdana", 8);
        _tf.hAlign = HAlign.LEFT;
    }

    override protected function update (dt :Number) :void
    {
        super.update(dt);

        var text :String =
            "" + Math.round(this.fpsCur) +
            " (Avg=" + Math.round(this.fpsMean) +
            " Min=" + Math.round(this.fpsMin) +
            " Max=" + Math.round(this.fpsMax) + ")";

        _tf.text = text;
        _tf.color = (this.fpsMean > _slowFps ? _normalColor : _slowColor);
    }

    public function get display () :DisplayObject
    {
        return _tf;
    }

    protected var _normalColor :uint;
    protected var _slowColor :uint;
    protected var _slowFps :Number;

    protected var _tf :TextField;
}

}


