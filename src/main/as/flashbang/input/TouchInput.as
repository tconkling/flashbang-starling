//
// flashbang

package flashbang.input {

import flashbang.core.flashbang_internal;
import flashbang.util.LinkedElement;
import flashbang.util.LinkedList;

import react.Registration;

import starling.display.DisplayObjectContainer;
import starling.events.Touch;
import starling.events.TouchProcessor;

use namespace flashbang_internal;

public class TouchInput
{
    public function TouchInput (root :DisplayObjectContainer) {
        _dispatcher = new TouchDispatcher(root);
        _listeners = new LinkedList();
    }

    public function dispose () :void {
        _dispatcher.dispose();
        _dispatcher = null;
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
        var handled :Boolean = false;
        try {
            for (var e :LinkedElement = _listeners.beginIteration(); e != null; e = e.next) {
                handled = TouchListener(e.data).onTouchesUpdated(touches);
                if (handled) {
                    break;
                }
            }
        } finally {
            _listeners.endIteration();
        }

        if (!handled) {
            _dispatcher.dispatchTouches(touches, _ctrlDown, _shiftDown);
        }
    }

    protected var _listeners :LinkedList;
    protected var _dispatcher :TouchDispatcher;

    flashbang_internal static var _ctrlDown :Boolean;
    flashbang_internal static var _shiftDown :Boolean;
}
}

import starling.display.DisplayObjectContainer;
import starling.events.Touch;
import starling.events.TouchProcessor;

class TouchDispatcher extends TouchProcessor {
    public function TouchDispatcher (root :DisplayObjectContainer) {
        super(root.stage);
        this.root = root;
    }

    public function dispatchTouches (touches :Vector.<Touch>, shiftDown :Boolean, ctrlDown :Boolean) :void {
        mCurrentTouches.length = touches.length;
        for (var ii :int = touches.length - 1; ii >= 0; --ii) {
            mCurrentTouches[ii] = touches[ii];
        }
        processTouches(touches, shiftDown, ctrlDown);
    }
}
