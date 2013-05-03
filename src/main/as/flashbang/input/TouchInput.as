//
// flashbang

package flashbang.input {

import starling.display.DisplayObjectContainer;
import starling.events.Touch;
import starling.events.TouchDispatcher;

import aspire.util.Registration;
import aspire.util.Registrations;

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
            for each (var l :TouchListener in _listeners.concat()) {// Iterate over a copy
                handled = l.onTouchesUpdated(touches);
                if (handled) {
                    break;
                }
            }
        }

        if (!handled) {
            _dispatcher.handleTouches(touches);
        }
    }

    protected var _dispatcher :TouchDispatcher;
    protected var _listeners :Vector.<TouchListener> = new <TouchListener>[];
}
}
