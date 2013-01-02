//
// Flashbang

package flashbang.input {

import starling.events.Touch;

/**
 * Used with TouchInput to intercept touch events.
 * Return true from the listener method to indicate that the event has been
 * fully handled, and processing should stop.
 */
public interface TouchListener
{
    function onTouchesUpdated (touches :Vector.<Touch>) :Boolean;
}
}
