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
     * @param touchId the touchId to operate on. All onPointer methods will receive
     * only touches with this ID.
     *
     * @param consumeAllTouches if true, unrelated touches are consumed by the PointerAdapter,
     * so that they will not be passed to other listeners for further processing.
     */
    public function PointerAdapter (touchId :int = 0, consumeOtherTouches :Boolean = true) {
        _touchId = touchId;
        this.consumeOtherTouches = consumeOtherTouches;
    }

    public function onTouchesUpdated (touches :Vector.<Touch>) :void {
        for (var ii :int = 0; ii < touches.length; ++ii) {
            var touch :Touch = touches[ii];
            if (touch.updated) {
                var handled :Boolean = false;
                if (touch.id == _touchId) {
                    switch (touch.phase) {
                    case TouchPhase.BEGAN: handled = onPointerStart(touch); break;
                    case TouchPhase.MOVED: handled = onPointerMove(touch); break;
                    case TouchPhase.ENDED: handled = onPointerEnd(touch); break;
                    case TouchPhase.HOVER: handled = onPointerHover(touch); break;
                    default: break;
                    }
                } else {
                    handled = this.consumeOtherTouches;
                }

                if (handled) {
                    if (ii == touches.length - 1) {
                        touches.pop();
                    } else {
                        touches.splice(ii, 1);
                    }
                    --ii;
                }
            }
        }
    }

    public function onPointerStart (touch :Touch) :Boolean { return true; }
    public function onPointerMove (touch :Touch) :Boolean { return true; }
    public function onPointerEnd (touch :Touch) :Boolean { return true; }
    public function onPointerHover (touch :Touch) :Boolean { return true; }

    protected var _touchId :int;
}
}
