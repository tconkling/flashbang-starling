//
// Flashbang

package flashbang.objects {

import starling.display.DisplayObject;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import flashbang.GameObject;
import flashbang.components.DisplayComponent;
import flashbang.input.Touchable;
import flashbang.util.EventSignal;

import org.osflash.signals.ISignal;

/**
 * A convenience class that implements DisplayComponent and manages a displayObject directly.
 */
public class SceneObject extends GameObject
    implements DisplayComponent, Touchable
{
    public function SceneObject (displayObject :DisplayObject, name :String = null,
        group :String = null)
    {
        _displayObject = displayObject;
        _name = name;
        _group = group;
    }

    override public function get objectNames () :Array
    {
        return _name == null ? [] : [ _name ];
    }

    override public function get objectGroups () :Array
    {
        return _group == null ? [] : [ _group ];
    }

    public final function get display () :DisplayObject
    {
        return _displayObject;
    }

    public function get touchEvent () :ISignal
    {
        if (_touchEvent == null) {
            _touchEvent = new EventSignal(_displayObject, TouchEvent.TOUCH);
        }
        return _touchEvent;
    }

    public function get touchBegan () :ISignal
    {
        return getFilteredTouchSignal(TouchPhase.BEGAN);
    }

    public function get touchMoved () :ISignal
    {
        return getFilteredTouchSignal(TouchPhase.MOVED);
    }

    public function get touchEnded () :ISignal
    {
        return getFilteredTouchSignal(TouchPhase.ENDED);
    }

    protected function getFilteredTouchSignal (phase :String) :ISignal
    {
        if (_filteredTouchSignals == null) {
            _filteredTouchSignals = new Vector.<FilteredTouchSignal>(NUM_PHASES, true);
        }
        var idx :int;
        switch (phase) {
        case TouchPhase.BEGAN: idx = BEGAN; break;
        case TouchPhase.MOVED: idx = MOVED; break;
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

    protected var _displayObject :DisplayObject;
    protected var _name :String;
    protected var _group :String;
    protected var _touchEvent :EventSignal; // lazily instantiated
    protected var _filteredTouchSignals :Vector.<FilteredTouchSignal>; // lazily instantiated

    protected static const BEGAN :int = 0;
    protected static const MOVED :int = 1;
    protected static const ENDED :int = 2;

    protected static const NUM_PHASES :int = ENDED + 1;
}

}

import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchEvent;

import flashbang.util.EventSignal;

import org.osflash.signals.Signal;

class FilteredTouchSignal extends Signal {
    public function FilteredTouchSignal (disp :DisplayObject, touchEventSignal :EventSignal,
        phase :String) {

        super(Touch);
        touchEventSignal.add(function (e :TouchEvent) :void {
            var touch :Touch = e.getTouch(disp, phase);
            if (touch != null) {
                dispatch(touch);
            }
        });
    }
}
