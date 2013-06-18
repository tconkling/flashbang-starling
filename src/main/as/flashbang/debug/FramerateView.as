//
// Flashbang - a framework for creating Flash games

package flashbang.debug {

import flashbang.components.DisplayComponent;
import flashbang.util.TextFieldBuilder;

import starling.display.DisplayObject;
import starling.text.TextField;

public class FramerateView extends Framerate
    implements DisplayComponent
{
    /**
     * If true, the average, minimum, and maximum framerate over the last second are also
     * displayed in addition to the current framerate.
     */
    public var extendedData :Boolean = false;

    /** The text color to use when the framerate is above the "slow" threshold */
    public var normalColor :uint = 0x00ff00;

    /** The text color to use when the framerate is at or below the "slow" threshold */
    public var slowColor :uint = 0xff0000;

    /** The framerate threshold below which the text will be colored with "slowColor" */
    public var slowFps :Number = 15;

    public function FramerateView () {
        super(1000);
        _tf = new TextFieldBuilder()
            .font("_sans")
            .fontSize(8)
            .touchable(false)
            .autoSize()
            .build();
    }

    public function get display () :DisplayObject {
        return _tf;
    }

    public function get textField () :TextField {
        return _tf;
    }

    override public function update (dt :Number) :void {
        super.update(dt);

        var text :String;
        if (this.extendedData) {
            text = "" + Math.round(this.fpsCur) +
                   " (Avg=" + Math.round(this.fpsMean) +
                   " Min=" + Math.round(this.fpsMin) +
                   " Max=" + Math.round(this.fpsMax) + ")";
        } else {
            text = "" + Math.round(this.fpsMean);
        }

        _tf.text = text;
        _tf.color = (this.fpsMean > this.slowFps ? this.normalColor : this.slowColor);
    }

    protected var _tf :TextField;
}

}


