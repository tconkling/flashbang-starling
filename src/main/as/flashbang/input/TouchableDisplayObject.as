//
// flashbang

package flashbang.input {

import flashbang.util.EventSignal;

import react.SignalView;

import starling.display.DisplayObject;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

internal class TouchableDisplayObject
    implements Touchable
{
    public function TouchableDisplayObject (disp :DisplayObject) {
        _displayObject = disp;
    }

    public function get target () :DisplayObject {
        return _displayObject;
    }

    public function get touchEvent () :SignalView {
        if (_touchEvent == null) {
            _touchEvent = new EventSignal(_displayObject, TouchEvent.TOUCH);
        }
        return _touchEvent;
    }

    public function get hoverBegan () :SignalView {
        return getHoverSignals().began;
    }

    public function get hoverMoved () :SignalView {
        return getHoverSignals().moved;
    }

    public function get hoverEnded () :SignalView {
        return getHoverSignals().ended;
    }

    public function get touchBegan () :SignalView {
        return getFilteredTouchSignal(TouchPhase.BEGAN);
    }

    public function get touchMoved () :SignalView {
        return getFilteredTouchSignal(TouchPhase.MOVED);
    }

    public function get touchStationary () :SignalView {
        return getFilteredTouchSignal(TouchPhase.STATIONARY);
    }

    public function get touchEnded () :SignalView {
        return getFilteredTouchSignal(TouchPhase.ENDED);
    }

    protected function getHoverSignals () :HoverSignals {
        if (_hoverSignals == null) {
            _hoverSignals = new HoverSignals(_displayObject, EventSignal(this.touchEvent));
        }
        return _hoverSignals;
    }

    protected function getFilteredTouchSignal (phase :String) :SignalView {
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

}

import flashbang.util.EventSignal;

import react.Signal;
import react.UnitSignal;

import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

class HoverSignals {
    public const began :Signal = new Signal(Touch);
    public const moved :Signal = new Signal(Touch);
    public const ended :UnitSignal = new UnitSignal();

    public function HoverSignals (disp :DisplayObject, touchEventSignal :EventSignal) {
        _disp = disp;
        touchEventSignal.connect(onTouchEvent);
    }

    protected function onTouchEvent (e :TouchEvent) :void {
        var touch :Touch = e.getTouch(_disp, TouchPhase.HOVER);
        if (touch != null) {
            if (!_hovered) {
                _hovered = true;
                this.began.emit(touch);
            } else {
                this.moved.emit(touch);
            }
        } else if (_hovered && !e.interactsWith(_disp)) {
            _hovered = false;
            this.ended.emit();
        }
    }

    protected var _disp :DisplayObject;
    protected var _hovered :Boolean;
}

class FilteredTouchSignal extends Signal {
    public function FilteredTouchSignal (disp :DisplayObject, touchEventSignal :EventSignal, phase :String) {
        super(Touch);
        _disp = disp;
        _phase = phase;
        touchEventSignal.connect(onTouchEvent);
    }

    protected function onTouchEvent (e :TouchEvent) :void {
        for each (var touch :Touch in e.getTouches(_disp, _phase)) {
            emit(touch);
        }
    }

    protected var _disp :DisplayObject;
    protected var _phase :String;
}
