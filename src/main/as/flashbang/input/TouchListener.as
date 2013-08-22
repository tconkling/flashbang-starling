//
// Flashbang

package flashbang.input {

import starling.events.Touch;

public interface TouchListener
{
    /**
     * Process touch events.
     * Return true to indicate that the event has been fully handled and processing should stop.
     */
    function onTouchesUpdated (touches :Vector.<Touch>) :Boolean;
}
}
