//
// Flashbang

package flashbang.objects {

import starling.display.DisplayObject;

import flashbang.GameObject;
import flashbang.components.DisplayComponent;
import flashbang.input.TouchUtil;
import flashbang.input.Touchable;

import org.osflash.signals.ISignal;

/**
 * A convenience class that implements DisplayComponent and manages a displayObject directly.
 */
public class SceneObject extends GameObject
    implements DisplayComponent, Touchable
{
    public function SceneObject (displayObject :DisplayObject, name :String = null,
        group :String = null)
    {
        _displayObject = displayObject;
        _name = name;
        _group = group;
    }

    override public function get objectNames () :Array
    {
        return _name == null ? [] : [ _name ];
    }

    override public function get objectGroups () :Array
    {
        return _group == null ? [] : [ _group ];
    }

    public final function get display () :DisplayObject
    {
        return _displayObject;
    }

    public function get touchEvent () :ISignal
    {
        return getTouchable().touchEvent;
    }

    public function get touchBegan () :ISignal
    {
        return getTouchable().touchBegan;
    }

    public function get touchMoved () :ISignal
    {
        return getTouchable().touchMoved;
    }

    public function get touchEnded () :ISignal
    {
        return getTouchable().touchEnded;
    }
    
    protected function getTouchable () :Touchable {
        if (_touchable == null) {
            _touchable = TouchUtil.createTouchable(_displayObject);
        }
        return _touchable;
    }

    protected var _displayObject :DisplayObject;
    protected var _name :String;
    protected var _group :String;
    protected var _touchable :Touchable; // lazily instantiated

    protected static const BEGAN :int = 0;
    protected static const MOVED :int = 1;
    protected static const ENDED :int = 2;

    protected static const NUM_PHASES :int = ENDED + 1;
}

}

import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchEvent;

import flashbang.util.EventSignal;

import org.osflash.signals.Signal;

class FilteredTouchSignal extends Signal {
    public function FilteredTouchSignal (disp :DisplayObject, touchEventSignal :EventSignal,
        phase :String) {

        super(Touch);
        touchEventSignal.add(function (e :TouchEvent) :void {
            var touch :Touch = e.getTouch(disp, phase);
            if (touch != null) {
                dispatch(touch);
            }
        });
    }
}
