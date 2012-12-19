//
// flashbang

package flashbang.input {

import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import aspire.util.Arrays;
import aspire.util.Registration;
import aspire.util.Registrations;

public class TouchInput
{
    public function TouchInput (root :DisplayObject)
    {
        _root = root;
    }

    /**
     * Adds a listener to the TouchInput. Listeners are placed on a stack,
     * so the most recently-added listener gets the first chance at each touch event.
     */
    public function registerListener (l :TouchListener) :Registration
    {
        _listeners.unshift(l);
        installTouchListeners();
        return Registrations.createWithFunction(function () :void {
            Arrays.removeFirst(_listeners, l);
            if (_listeners.length == 0) {
                uninstallTouchListeners();
            }
        });
    }

    /** Removes all listeners from the TouchInput */
    public function removeAllListeners () :void
    {
        _listeners = [];
        uninstallTouchListeners();
    }

    /** @return true if the TouchInput is enabled */
    public function get enabled () :Boolean
    {
        return _enabled;
    }

    /**
     * Enable or disable the TouchInput. When disabled, registered listeners will not receive
     * any touch events.
     */
    public function set enabled (enabled :Boolean) :void
    {
        _enabled = enabled;
        if (_enabled) {
            installTouchListeners();
        } else {
            uninstallTouchListeners();
        }
    }

    protected function installTouchListeners () :void
    {
        if (_enabled && !_touchListenersInstalled) {
            _root.addEventListener(TouchEvent.TOUCH, handleTouchEvent);
            _touchListenersInstalled = true;
        }
    }

    protected function uninstallTouchListeners () :void
    {
        if (_touchListenersInstalled) {
            _root.removeEventListener(TouchEvent.TOUCH, handleTouchEvent);
            _touchListenersInstalled = false;
        }
    }

    protected function handleTouchEvent (e :TouchEvent) :void
    {
        var handled :Boolean = false;
        for each (var t :Touch in e.getTouches(_root)) {
            for each (var ml :TouchListener in _listeners.concat()) {// Iterate over a copy
                switch (t.phase) {
                case TouchPhase.BEGAN:
                    handled = ml.onTouchBegin(t);
                    break;
                case TouchPhase.ENDED:
                    handled = ml.onTouchEnd(t);
                    break;
                case TouchPhase.MOVED:
                    handled = ml.onTouchMove(t);
                    break;
                }
                if (handled) {
                    e.stopImmediatePropagation();
                    break;
                }
            }
        }
    }

    protected var _root :DisplayObject;
    protected var _listeners :Array = [];
    protected var _touchListenersInstalled :Boolean;
    protected var _enabled :Boolean = true;
}
}
