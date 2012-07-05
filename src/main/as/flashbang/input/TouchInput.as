//
// flashbang

package flashbang.input {

import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import com.threerings.util.Arrays;
import com.threerings.util.Registration;
import com.threerings.util.Registrations;

public class TouchInput
{
    public function TouchInput (root :DisplayObject)
    {
        _root = root;
    }

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

    public function removeAllListeners () :void
    {
        _listeners = [];
        uninstallTouchListeners();
    }

    public function get enabled () :Boolean {
        return _enabled;
    }

    public function set enabled (enabled :Boolean) :void {
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
