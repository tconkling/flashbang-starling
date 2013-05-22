//
// flashbang

package flashbang.input {

import starling.display.DisplayObject;

public class TouchSignals
{
    /** Creates a Touchable interface for the given DisplayObject */
    public static function forDisp (disp :DisplayObject) :Touchable {
        return new TouchableDisplayObject(disp);
    }
}
}

import flashbang.input.Touchable;
import flashbang.util.EventSignal;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

class TouchableDisplayObject
    implements Touchable
{
    public function TouchableDisplayObject (disp :DisplayObject) {
        _displayObject = disp;
    }

    public function get touchEvent () :ISignal {
        if (_touchEvent == null) {
            _touchEvent = new EventSignal(_displayObject, TouchEvent.TOUCH);
        }
        return _touchEvent;
    }

    public function get hoverBegan () :ISignal {
        return getHoverSignals().began;
    }

    public function get hoverEnded () :ISignal {
        return getHoverSignals().ended;
    }

    public function get touchBegan () :ISignal {
        return getFilteredTouchSignal(TouchPhase.BEGAN);
    }

    public function get touchMoved () :ISignal {
        return getFilteredTouchSignal(TouchPhase.MOVED);
    }

    public function get touchStationary () :ISignal {
        return getFilteredTouchSignal(TouchPhase.STATIONARY);
    }

    public function get touchEnded () :ISignal {
        return getFilteredTouchSignal(TouchPhase.ENDED);
    }

    protected function getHoverSignals () :HoverSignals {
        if (_hoverSignals == null) {
            _hoverSignals = new HoverSignals(_displayObject, EventSignal(this.touchEvent));
        }
        return _hoverSignals;
    }

    protected function getFilteredTouchSignal (phase :String) :ISignal {
        if (_filteredTouchSignals == null) {
            _filteredTouchSignals = new Vector.<FilteredTouchSignal>(NUM_PHASES, true);
        }
        var idx :int;
        switch (phase) {
        case TouchPhase.BEGAN: idx = BEGAN; break;
        case TouchPhase.MOVED: idx = MOVED; break;
        case TouchPhase.STATIONARY: idx = STATIONARY; break;
        case TouchPhase.ENDED: idx = ENDED; break;
        default:
            throw new Error("Unrecognized TouchPhase '" + phase + "'");
        }

        var sig :FilteredTouchSignal = _filteredTouchSignals[idx];
        if (sig == null) {
            sig = new FilteredTouchSignal(_displayObject, EventSignal(this.touchEvent), phase);
            _filteredTouchSignals[idx] = sig;
        }
        return sig;
    }

    protected static const BEGAN :int = 0;
    protected static const MOVED :int = 1;
    protected static const STATIONARY :int = 2;
    protected static const ENDED :int = 3;

    protected static const NUM_PHASES :int = ENDED + 1;

    protected var _displayObject :DisplayObject;
    protected var _touchEvent :EventSignal; // lazily instantiated
    protected var _filteredTouchSignals :Vector.<FilteredTouchSignal>; // lazily instantiated
    protected var _hoverSignals :HoverSignals; // lazily instantiated
}

class HoverSignals {
    public const began :Signal = new Signal(Touch);
    public const ended :Signal = new Signal();

    public function HoverSignals (disp :DisplayObject, touchEventSignal :EventSignal) {
        var hovered :Boolean = false;
        touchEventSignal.add(function (e :TouchEvent) :void {
            var touch :Touch = null;
            if (!hovered && (touch = e.getTouch(disp, TouchPhase.HOVER)) != null) {
                hovered = true;
                began.dispatch(touch);
            } else if (hovered) {// && !e.interactsWith(disp)) {
                if (!e.interactsWith(disp)) {
                    hovered = false;
                    ended.dispatch();
                }
            }
        });
    }
}

class FilteredTouchSignal extends Signal {
    public function FilteredTouchSignal (disp :DisplayObject, touchEventSignal :EventSignal,
        phase :String) {

        super(Touch);
        touchEventSignal.add(function (e :TouchEvent) :void {
            for each (var touch :Touch in e.getTouches(disp, phase)) {
                dispatch(touch);
            }
        });
    }
}

