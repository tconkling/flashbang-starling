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

    /**
     * If a TouchListener higher in the stack consumes a touch input, this function will be called
     * to notify this listener of the pre-emption.
     *
     * A Button, for example, will begin processing a touch sequence when it receives a touch-down event
     * in its bounds - it will change its state and consume all touch input until it gets a
     * corresponding touch-up event. If another TouchListener, higher in the stack, begins consuming
     * touch input while the Button is in its "touch tracking" mode, the Button will be notified
     * that its touch tracking has been pre-empted, so that it can revert back to its default state.
     */
    function onTouchesPreempted (touches :Vector.<Touch>) :void;
}
}
