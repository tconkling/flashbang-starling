//
// flashbang

package flashbang.util.meter {

public class MeterMetrics
{
    public var fgWidth :Number;
    public var fgHeight :Number;
    public var fgX :Number;
    public var fgY :Number;

    public var bgWidth :Number;
    public var bgHeight :Number;
    public var bgX :Number;
    public var bgY :Number;

    /** Calculates the metrics for drawing a meter */
    public static function calculate (meter :Meter, fillWidth :Number, fillHeight :Number,
        fill :MeterFill = null, out :MeterMetrics = null) :MeterMetrics {

        out = (out || new MeterMetrics());
        fill = (fill || MeterFill.LEFT_TO_RIGHT);
        const denom :Number = (meter.maxValue - meter.minValue);
        const normalizedVal :Number = (denom != 0 ? (meter.value - meter.minValue) / denom : 0);

        switch (fill) {
        case MeterFill.LEFT_TO_RIGHT:
            out.fgWidth = fillWidth * normalizedVal;
            out.fgHeight = fillHeight;
            out.fgX = 0;
            out.fgY = 0;

            out.bgWidth = fillWidth - out.fgWidth;
            out.bgHeight = fillHeight;
            out.bgX = out.fgWidth;
            out.bgY = 0;
            break;

        case MeterFill.RIGHT_TO_LEFT:
            out.fgWidth = fillWidth * normalizedVal;
            out.fgHeight = fillHeight;
            out.fgX = fillWidth - out.fgWidth;
            out.fgY = 0;

            out.bgWidth = fillWidth - out.fgWidth;
            out.bgHeight = fillHeight;
            out.bgX = 0;
            out.bgY = 0;
            break;

        case MeterFill.TOP_TO_BOTTOM:
            out.fgWidth = fillWidth;
            out.fgHeight = fillHeight * normalizedVal;
            out.fgX = 0;
            out.fgY = 0;

            out.bgWidth = fillWidth;
            out.bgHeight = fillHeight - out.fgHeight;
            out.bgX = 0;
            out.bgY = out.fgHeight;
            break;

        case MeterFill.BOTTOM_TO_TOP:
            out.fgWidth = fillWidth;
            out.fgHeight = fillHeight * normalizedVal;
            out.fgX = 0;
            out.fgY = fillHeight - out.fgHeight;

            out.bgWidth = fillWidth;
            out.bgHeight = fillHeight - out.fgHeight;
            out.bgX = 0;
            out.bgY = 0;
            break;
        }

        return out;
    }
}
}
