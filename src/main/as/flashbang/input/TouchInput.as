//
// flashbang

package flashbang.input {

import flash.geom.Point;

import flashbang.core.flashbang_internal;
import flashbang.util.LinkedElement;
import flashbang.util.LinkedList;

import react.Registration;

import starling.core.starling_internal;
import starling.display.DisplayObjectContainer;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

use namespace starling_internal;
use namespace flashbang_internal;

public class TouchInput
{
    public function TouchInput (root :DisplayObjectContainer) {
        HOVERING_TOUCH_DATA = new <HoveringTouchData>[];
        _root = root;
        _listeners = new LinkedList();
    }

    public function dispose () :void {
        _listeners.dispose();
        _listeners = null;
    }

    /**
     * Adds a listener to the TouchInput. Listeners are placed on a stack,
     * so the most recently-added listener gets the first chance at each touch event.
     */
    public function registerListener (l :TouchListener) :Registration {
        return _listeners.pushFront(l);
    }

    /** Removes all listeners from the TouchInput */
    public function removeAllListeners () :void {
        _listeners.clear();
    }

    public function handleTouches (touches :Vector.<Touch>) :void {
        try {
            for (var e :LinkedElement = _listeners.beginIteration(); e != null; e = e.next) {
                TouchListener(e.data).onTouchesUpdated(touches);
                if (touches.length == 0) {
                    break;
                }
            }
        } finally {
            _listeners.endIteration();
        }

        if (touches.length > 0) {
            dispatchTouchEvent(touches);
        }
    }

    protected function dispatchTouchEvent (touches :Vector.<Touch>) :void {
        HOVERING_TOUCH_DATA.length = 0;
        var touch :Touch;

        // the same touch event will be dispatched to all targets;
        // the 'dispatch' method will make sure each bubble target is visited only once.
        var touchEvent :TouchEvent = new TouchEvent(TouchEvent.TOUCH, touches, _shiftDown, _ctrlDown);

        // hit test our updated touches
        for each (touch in touches) {
            if (!touch.updated) {
                continue;
            }

            // hovering touches need special handling (see below)
            if (touch.phase == TouchPhase.HOVER && touch.target) {
                var hoverData :HoveringTouchData = new HoveringTouchData();
                hoverData.touch = touch;
                hoverData.target = touch.target;
                hoverData.bubbleChain = touch.bubbleChain;
                HOVERING_TOUCH_DATA[HOVERING_TOUCH_DATA.length] = hoverData;
            }

            if (touch.phase == TouchPhase.HOVER || touch.phase == TouchPhase.BEGAN) {
                P.setTo(touch.globalX, touch.globalY);
                touch.setTarget(_root.hitTest(P, true));
            }
        }

        // if the target of a hovering touch changed, we dispatch the event to the previous
        // target to notify it that it's no longer being hovered over.
        for each (var touchData :HoveringTouchData in HOVERING_TOUCH_DATA) {
            if (touchData.touch.target != touchData.target) {
                touchEvent.dispatch(touchData.bubbleChain);
            }
        }

        // dispatch events for the rest of our updated touches
        for each (touch in touches) {
            if (touch.updated) {
                touch.dispatchEvent(touchEvent);
            }
        }
    }

    protected var _root :DisplayObjectContainer;
    protected var _listeners :LinkedList;

    /** Updated by FlashbangApp */
    flashbang_internal static var _shiftDown :Boolean;
    flashbang_internal static var _ctrlDown :Boolean;

    /** Helper object */
    private static var HOVERING_TOUCH_DATA :Vector.<HoveringTouchData>;
    private static const P :Point = new Point();
}
}

import starling.display.DisplayObject;
import starling.events.EventDispatcher;
import starling.events.Touch;

class HoveringTouchData {
    public var touch :Touch;
    public var target :DisplayObject;
    public var bubbleChain :Vector.<EventDispatcher>;
}
