//
// flashbang

package flashbang.input {

import flash.utils.Dictionary;

import react.UnitSignal;

import starling.events.KeyboardEvent;

/** Redispatches KeyboardEvents as signals */
public class KeyboardSignals implements KeyboardListener {
    /**
     * Creates a KeyboardSignals instance.
     *
     * @param consumeDispatchedEvents if true, KeyboardEvents that result in dispatched signals
     * will be consumed by KeyboardSignals, meaning they will not be passed to other listeners
     * in the current AppMode's KeyboardListener list.
     */
    public function KeyboardSignals (consumeDispatchedEvents :Boolean = false) {
        _consumeDispatchedEvents = consumeDispatchedEvents;
    }

    /** Return a UnitSignal that will be dispatched when the given key is pressed */
    public function keyDown (keycode :uint) :UnitSignal {
        return getKeySignal(_keyDownSignals, keycode, true);
    }

    /** Return a UnitSignal that will be dispatched when the given key is released */
    public function keyUp (keycode :uint) :UnitSignal {
        return getKeySignal(_keyUpSignals, keycode, true);
    }

    public function onKeyboardEvent (e :KeyboardEvent) :Boolean {
        var dict :Dictionary = (e.type == KeyboardEvent.KEY_DOWN ? _keyDownSignals : _keyUpSignals);
        var sig :UnitSignal = getKeySignal(dict, e.keyCode, false);
        if (sig != null && sig.hasConnections) {
            sig.emit();
            return _consumeDispatchedEvents;
        } else {
            return false;
        }
    }

    protected static function getKeySignal (dict :Dictionary, keycode :uint,
        createIfMissing :Boolean) :UnitSignal {

        var sig :UnitSignal = dict[keycode];
        if (sig == null && createIfMissing) {
            sig = new UnitSignal();
            dict[keycode] = sig;
        }
        return sig;
    }

    protected var _consumeDispatchedEvents :Boolean;
    protected var _keyDownSignals :Dictionary = new Dictionary();
    protected var _keyUpSignals :Dictionary = new Dictionary();
}
}
