//
// Flashbang

package flashbang.input {

import starling.events.KeyboardEvent;

public interface KeyboardListener
{
    /**
     * Return true to indicate that the event has been fully handled and processing
     * should stop.
     */
    function onKeyboardEvent (k :KeyboardEvent) :Boolean;
}
}
