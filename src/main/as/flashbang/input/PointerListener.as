//
// flashbang

package flashbang.input {

import starling.events.Touch;

/** A TouchListener that acts only on the "primary" touch */
public interface PointerListener extends TouchListener
{
    function onPointerStart (touch :Touch) :Boolean;
    function onPointerMove (touch :Touch) :Boolean;
    function onPointerEnd (touch :Touch) :Boolean;
    function onPointerHover (touch :Touch) :Boolean;
    function onPointerPreempted (touch :Touch) :void;
}
}
