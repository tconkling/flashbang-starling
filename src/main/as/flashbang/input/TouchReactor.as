//
// Flashbang

package flashbang.input {

import starling.events.Touch;

/**
 * A TouchListener implementation that returns true (i.e. "handled") for every TouchEvent
 */
public class TouchReactor
    implements TouchListener
{
    public function onTouchBegin (e :Touch) :Boolean { return true; }
    public function onTouchMove (e :Touch) :Boolean { return true; }
    public function onTouchEnd (e :Touch) :Boolean { return true; }
}
}
