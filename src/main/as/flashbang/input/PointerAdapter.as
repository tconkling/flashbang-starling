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
    /**
     * If true, the PointerAdapter will report all touches as handled, instead of just touches
     * with the supplied touchId.
     */
    public var consumeAllTouches :Boolean;

    /**
     * Constructs a new PointerAdapter
     *
     * @param touchId the touchId to operate on. All onPointer methods will receive
     * only touches with this ID.
     *
     * @param consumeAllTouches if true, all touch events are reported as "handled"
     * by the adapter, rather than just those related to the specified touchId.
     */
    public function PointerAdapter (touchId :int = 0, consumeAllTouches :Boolean = true) {
        _touchId = touchId;
        this.consumeAllTouches = consumeAllTouches;
    }

    public function onTouchesUpdated (touches :Vector.<Touch>) :Boolean {
        var handled :Boolean;
        for each (var touch :Touch in touches) {
            if (touch.updated && touch.id == _touchId) {
                switch (touch.phase) {
                case TouchPhase.BEGAN: handled = onPointerStart(touch); break;
                case TouchPhase.MOVED: handled = onPointerMove(touch); break;
                case TouchPhase.ENDED: handled = onPointerEnd(touch); break;
                case TouchPhase.HOVER: handled = onPointerHover(touch); break;
                default: break;
                }
            }
            if (handled) {
                break;
            }
        }

        return handled || this.consumeAllTouches;
    }

    public function onPointerStart (touch :Touch) :Boolean { return true; }
    public function onPointerMove (touch :Touch) :Boolean { return true; }
    public function onPointerEnd (touch :Touch) :Boolean { return true; }
    public function onPointerHover (touch :Touch) :Boolean { return true; }

    protected var _touchId :int;
}
}
