//
// flashbang

package flashbang.input {

import react.Registration;
import react.Registrations;

import starling.display.DisplayObjectContainer;
import starling.events.Touch;
import starling.events.TouchDispatcher;

public class TouchInput
{
    public function TouchInput (root :DisplayObjectContainer) {
        _dispatcher = new TouchDispatcher(root);
    }

    public function dispose () :void {
        _dispatcher.dispose();
        _dispatcher = null;
        _listeners = null;
    }

    /**
     * Adds a listener to the TouchInput. Listeners are placed on a stack,
     * so the most recently-added listener gets the first chance at each touch event.
     */
    public function registerListener (l :TouchListener) :Registration {
        _listeners.unshift(l);
        return Registrations.createWithFunction(function () :void {
            for (var ii :int = _listeners.length - 1; ii >= 0; --ii) {
                if (_listeners[ii] == l) {
                    _listeners.splice(ii, 1);
                    break;
                }
            }
        });
    }

    /** Removes all listeners from the TouchInput */
    public function removeAllListeners () :void {
        _listeners.length = 0;
    }

    public function handleTouches (touches :Vector.<Touch>) :void {
        var handled :Boolean = false;

        if (_listeners.length > 0) {
            for each (var l :TouchListener in _listeners.concat()) { // Iterate over a copy
                l.onTouchesUpdated(touches);
                if (touches.length == 0) {
                    break;
                }
            }
        }

        if (touches.length > 0) {
            _dispatcher.handleTouches(touches);
        }
    }

    protected var _dispatcher :TouchDispatcher;
    protected var _listeners :Vector.<TouchListener> = new <TouchListener>[];
}
}
