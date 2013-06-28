//
// flashbang

package flashbang.input {

import aspire.ui.KeyboardCodes;
import aspire.util.Log;

import flashbang.core.Flashbang;

import starling.events.KeyboardEvent;

/**
 * A KeyboardListener that records keyDown and keyUp events to allow for polling of the
 * keyboard state.
 */
public class KeyboardState
    implements KeyboardListener
{
    public function onKeyboardEvent (e :KeyboardEvent) :Boolean {
        if (e.keyCode < _keydownTimes.length) {
            // if this is a keyDown event, record the time of the event
            _keydownTimes[e.keyCode] = (e.type == KeyboardEvent.KEY_DOWN ? Flashbang.app.time : 0);
        } else {
            log.warning("Unrecognized keyCode", "keyCode", e.keyCode, "charCode", e.charCode);
        }

        // We're just recording state, so we return false to allow other KeyboardListeners to
        // process the event
        return false;
    }

    /** Clears the keyDown status for all keys */
    public function clear () :void {
        for (var ii :int = 0; ii < _keydownTimes.length; ++ii) {
            _keydownTimes[ii] = 0;
        }
    }

    /** Returns true if the given key is currently down */
    public function isKeyDown (keyCode :uint) :Boolean {
        return (keyCode < _keydownTimes.length ? _keydownTimes[keyCode] > 0 : false);
    }

    /** Returns the number of seconds that the given key has been held down, or 0 if the key is not down */
    public function getKeyDownTime (keyCode :uint) :Number {
        if (keyCode >= _keydownTimes.length) {
            return 0;
        }

        var start :Number = _keydownTimes[keyCode];
        return (start > 0 ? Flashbang.app.time - start : 0);
    }

    protected var _keydownTimes :Vector.<Number> = new Vector.<Number>(MAX_KEYCODE + 1, true);

    protected static const log :Log = Log.getLog(KeyboardState);

    protected static const MAX_KEYCODE :uint = KeyboardCodes.QUOTE; // 222
}
}
