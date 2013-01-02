//
// flashbang

package flashbang.input {

import starling.events.Touch;

/**
 * A TouchListener that acts on a single touch ID
 */
public interface PointerListener extends TouchListener
{
    function onPointerStart (touch :Touch) :Boolean;
    function onPointerMove (touch :Touch) :Boolean;
    function onPointerEnd (touch :Touch) :Boolean;
    function onPointerHover (touch :Touch) :Boolean;
}
}
