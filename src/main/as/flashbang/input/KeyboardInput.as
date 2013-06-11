//
// Flashbang

package flashbang.input {

import react.Registration;
import react.Registrations;

import starling.events.KeyboardEvent;

public class KeyboardInput
{
    public function handleKeyboardEvent (e :KeyboardEvent) :Boolean {
        var handled :Boolean = false;

        if (_listeners.length > 0) {
            for each (var l :KeyboardListener in _listeners.concat()) { // Iterate over a copy
                handled = l.onKeyboardEvent(e);
                if (handled) {
                    break;
                }
            }
        }

        return handled;
    }

    /**
     * Adds a listener to the KeyboardInput. Listeners are placed on a stack,
     * so the most recently-added listener gets the first chance at each event.
     */
    public function registerListener (l :KeyboardListener) :Registration {
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

    /** Removes all listeners from the KeyboardInput */
    public function removeAllListeners () :void {
        _listeners.length = 0;
    }

    protected var _listeners :Vector.<KeyboardListener> = new <KeyboardListener>[];
}
}

