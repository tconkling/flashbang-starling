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

    /** Constructs a new PointerAdapter */
    public function PointerAdapter (consumeOtherTouches :Boolean = true) {
        this.consumeOtherTouches = consumeOtherTouches;
    }

    public function onTouchesUpdated (touches :Vector.<Touch>) :Boolean {
        if (_curTouchId < 0) {
            _curTouchId = touches[0].id;
        }

        var foundTouch :Boolean = false;
        var handled :Boolean = false;
        for each (var touch :Touch in touches) {
            if (touch.id == _curTouchId) {
                switch (touch.phase) {
                case TouchPhase.BEGAN: handled = onPointerStart(touch); break;
                case TouchPhase.MOVED: handled = onPointerMove(touch); break;
                // reset our touchID
                case TouchPhase.ENDED: handled = onPointerEnd(touch); _curTouchId = -1; break;
                case TouchPhase.HOVER: handled = onPointerHover(touch); break;
                case TouchPhase.STATIONARY: break;
                }

                foundTouch = true;
                break;
            }
        }

        if (!foundTouch) {
            _curTouchId = -1;
        }

        return handled || this.consumeOtherTouches;
    }

    public function onTouchesPreempted (touches :Vector.<Touch>) :void {
        for each (var touch :Touch in touches) {
            if (_curTouchId < 0 || touch.id == _curTouchId) {
                onPointerPreempted(touch);
                break;
            }
        }
    }

    public function onPointerStart (touch :Touch) :Boolean { return true; }
    public function onPointerMove (touch :Touch) :Boolean { return true; }
    public function onPointerEnd (touch :Touch) :Boolean { return true; }
    public function onPointerHover (touch :Touch) :Boolean { return true; }
    public function onPointerPreempted (touch :Touch) :void {}

    protected var _curTouchId :int = -1;
}
}
