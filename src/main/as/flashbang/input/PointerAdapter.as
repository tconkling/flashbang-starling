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
    public var consumeAllTouches :Boolean;

    /**
     * Constructs a new PointerAdapter
     *
     * @param consumeAllTouches if true, unrelated touches are consumed by the PointerAdapter,
     * so that they will not be passed to other listeners for further processing.
     */
    public function PointerAdapter (consumeAllTouches :Boolean = true) {
        this.consumeAllTouches = consumeAllTouches;
    }

    public function onTouchesUpdated (touches :Vector.<Touch>) :void {
        if (_curTouchId < 0) {
            _curTouchId = touches[0].id;
        }

        var foundTouch :Boolean;
        for (var ii :int = 0; ii < touches.length; ++ii) {
            var touch :Touch = touches[ii];
            if (touch.id != _curTouchId) {
                continue;
            }

            foundTouch = true;
            if (touch.updated) {
                var handled :Boolean = false;
                switch (touch.phase) {
                case TouchPhase.BEGAN: handled = onPointerStart(touch); break;
                case TouchPhase.MOVED: handled = onPointerMove(touch); break;
                // reset our touchID
                case TouchPhase.ENDED: handled = onPointerEnd(touch); _curTouchId = -1; break;
                case TouchPhase.HOVER: handled = onPointerHover(touch); break;
                case TouchPhase.STATIONARY: break;
                }

                if (handled && !consumeAllTouches) {
                    if (ii == touches.length - 1) {
                        touches.pop();
                    } else {
                        touches.splice(ii, 1);
                    }
                }
            }

            break;
        }

        if (this.consumeAllTouches) {
            touches.length = 0;
        }
    }

    public function onPointerStart (touch :Touch) :Boolean { return true; }
    public function onPointerMove (touch :Touch) :Boolean { return true; }
    public function onPointerEnd (touch :Touch) :Boolean { return true; }
    public function onPointerHover (touch :Touch) :Boolean { return true; }

    protected var _curTouchId :int = -1;
}
}
