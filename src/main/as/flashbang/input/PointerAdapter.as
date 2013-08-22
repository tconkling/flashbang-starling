//
// flashbang

package flashbang.input {

import starling.events.Touch;
import starling.events.TouchPhase;

/**
 * A PointerListener implementation with stubs provided for each method.
 */
public class PointerAdapter
    implements PointerListener
{
    /** If true, the PointerAdapter will consume unrelated touches. */
    public var consumeOtherTouches :Boolean;

    /**
     * Constructs a new PointerAdapter
     *
     * @param consumeAllTouches if true, unrelated touches are consumed by the PointerAdapter,
     * so that they will not be passed to other listeners for further processing.
     */
    public function PointerAdapter (consumeOtherTouches :Boolean = true) {
        this.consumeOtherTouches = consumeOtherTouches;
    }

    public function onTouchesUpdated (touches :Vector.<Touch>) :Boolean {
        if (_curTouchId < 0) {
            _curTouchId = touches[0].id;
        }

        var foundTouch :Boolean = false;
        var handled :Boolean = false;
        for (var ii :int = 0; ii < touches.length && !foundTouch; ++ii) {
            var touch :Touch = touches[ii];
            if (touch.id == _curTouchId) {
                foundTouch = true;
                switch (touch.phase) {
                case TouchPhase.BEGAN: handled = onPointerStart(touch); break;
                case TouchPhase.MOVED: handled = onPointerMove(touch); break;
                // reset our touchID
                case TouchPhase.ENDED: handled = onPointerEnd(touch); _curTouchId = -1; break;
                case TouchPhase.HOVER: handled = onPointerHover(touch); break;
                case TouchPhase.STATIONARY: break;
                }
            }
        }

        if (!foundTouch) {
            _curTouchId = -1;
        }

        return handled || this.consumeOtherTouches;
    }

    public function onPointerStart (touch :Touch) :Boolean { return true; }
    public function onPointerMove (touch :Touch) :Boolean { return true; }
    public function onPointerEnd (touch :Touch) :Boolean { return true; }
    public function onPointerHover (touch :Touch) :Boolean { return true; }

    protected var _curTouchId :int = -1;
}
}
