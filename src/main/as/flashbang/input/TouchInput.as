//
// flashbang

package flashbang.input {

import flashbang.util.LinkedElement;
import flashbang.util.LinkedList;

import react.Registration;

import starling.display.DisplayObjectContainer;
import starling.events.Touch;
import starling.events.TouchDispatcher;

public class TouchInput
{
    public function TouchInput (root :DisplayObjectContainer) {
        _dispatcher = new TouchDispatcher(root);
        _listeners = new LinkedList();
    }

    public function dispose () :void {
        _dispatcher.dispose();
        _listeners.dispose();
        _dispatcher = null;
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
            _dispatcher.handleTouches(touches);
        }
    }

    protected var _dispatcher :TouchDispatcher;
    protected var _listeners :LinkedList;
}
}
