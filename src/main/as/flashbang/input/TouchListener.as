//
// Flashbang

package flashbang.input {

import starling.events.Touch;

public interface TouchListener
{
    /**
     * Process touch events. Touches that are fully handled - and thus should not be passed to
     * other listeners for further processing - should be removed from the Vector.
     */
    function onTouchesUpdated (touches :Vector.<Touch>) :void;
}
}
