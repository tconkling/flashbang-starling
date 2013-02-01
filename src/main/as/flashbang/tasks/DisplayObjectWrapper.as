//
// Flashbang

package flashbang.tasks {

import starling.display.DisplayObject;

import flashbang.components.DisplayComponent;
import flashbang.components.LocationComponent;

public class DisplayObjectWrapper
    implements DisplayComponent, LocationComponent
{
    public static function create (disp :DisplayObject) :DisplayObjectWrapper {
        return (disp != null ? new DisplayObjectWrapper(disp) : NULL_WRAPPER);
    }

    public function get isNull () :Boolean  {
        return (_disp == null);
    }

    public function get display () :DisplayObject {
        return _disp;
    }

    public function get x () :Number {
        return _disp.x;
    }

    public function set x (val :Number) :void {
        _disp.x = val;
    }

    public function get y () :Number {
        return _disp.y;
    }

    public function set y (val :Number) :void {
        _disp.y = val;
    }

    /**
     * @private
     */
    public function DisplayObjectWrapper (disp :DisplayObject) {
        _disp = disp;
    }

    protected var _disp :DisplayObject;

    protected static const NULL_WRAPPER :DisplayObjectWrapper = new DisplayObjectWrapper(null);
}

}
