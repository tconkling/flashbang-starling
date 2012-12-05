//
// Flashbang

package flashbang.input {

import starling.events.Touch;

/**
 * Used with TouchInput to intercept touch events.
 * Return true from any of the listener methods to indicate that the event has been
 * fully handled, and processing should stop.
 */
public interface TouchListener
{
    function onTouchBegin (e :Touch) :Boolean;
    function onTouchMove (e :Touch) :Boolean;
    function onTouchEnd (e :Touch) :Boolean;
}
}
