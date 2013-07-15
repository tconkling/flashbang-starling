//
// Flashbang

package flashbang.input {

import flashbang.util.LinkedElement;
import flashbang.util.LinkedList;

import react.Registration;

import starling.events.KeyboardEvent;

public class KeyboardInput
{
    public function dispose () :void {
        _listeners.dispose();
        _listeners = null;
    }

    public function handleKeyboardEvent (k :KeyboardEvent) :Boolean {
        var handled :Boolean = false;
        try {
            for (var e :LinkedElement = _listeners.beginIteration(); e != null; e = e.next) {
                handled = KeyboardListener(e.data).onKeyboardEvent(k);
                if (handled) {
                    break;
                }
            }
        } finally {
            _listeners.endIteration();
        }

        return handled;
    }

    /**
     * Adds a listener to the KeyboardInput. Listeners are placed on a stack,
     * so the most recently-added listener gets the first chance at each event.
     */
    public function registerListener (l :KeyboardListener) :Registration {
        return _listeners.pushFront(l);
    }

    /** Removes all listeners from the KeyboardInput */
    public function removeAllListeners () :void {
        _listeners.clear();
    }

    protected var _listeners :LinkedList = new LinkedList();
}
}

