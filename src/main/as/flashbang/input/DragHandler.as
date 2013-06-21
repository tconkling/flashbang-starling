//
// flashbang

package flashbang.input {

import flash.geom.Point;

public interface DragHandler extends TouchListener
{
    /** Returns the initial global location of the touch that began the drag */
    function get startLoc () :Point;

    /** Returns the current global location of the drag touch */
    function get currentLoc () :Point;
}
}
