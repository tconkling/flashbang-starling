//
// Flashbang

package flashbang.input {

import flashbang.util.LinkedElement;
import flashbang.util.LinkedList;

import react.Registration;

public class MouseWheelInput
{
    public function dispose () :void {
        _listeners.dispose();
        _listeners = null;
    }

    public function handleMouseWheelEvent (event :MouseWheelEvent) :Boolean {
        var handled :Boolean = false;
        try {
            for (var e :LinkedElement = _listeners.beginIteration(); e != null; e = e.next) {
                handled = MouseWheelListener(e.data).onMouseWheelEvent(event);
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
     * Adds a listener to the MouseWheelInput. Listeners are placed on a stack,
     * so the most recently-added listener gets the first chance at each event.
     */
    public function registerListener (l :MouseWheelListener) :Registration {
        return _listeners.pushFront(l);
    }

    /** Removes all listeners from the MouseWheelInput */
    public function removeAllListeners () :void {
        _listeners.clear();
    }

    protected var _listeners :LinkedList = new LinkedList();
}
}

