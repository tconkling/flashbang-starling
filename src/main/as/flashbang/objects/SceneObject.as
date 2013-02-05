//
// Flashbang

package flashbang.objects {

import starling.display.DisplayObject;

import flashbang.core.GameObject;
import flashbang.components.DisplayComponent;
import flashbang.input.TouchSignals;
import flashbang.input.Touchable;

/**
 * A convenience class that implements DisplayComponent and manages a displayObject directly.
 */
public class SceneObject extends GameObject
    implements DisplayComponent
{
    public function SceneObject (displayObject :DisplayObject, name :String = null,
        group :String = null)
    {
        _displayObject = displayObject;
        _name = name;
        _group = group;
    }

    /** Convenience function that returns a Touchable interface for the DisplayObject */
    public function get touchSignals () :Touchable {
        if (_touchable == null) {
            _touchable = TouchSignals.forDisp(_displayObject);
        }
        return _touchable;
    }

    override public function get objectIds () :Array {
        return _name == null ? [] : [ _name ];
    }

    override public function get objectGroups () :Array {
        return _group == null ? [] : [ _group ];
    }

    public final function get display () :DisplayObject {
        return _displayObject;
    }

    protected var _displayObject :DisplayObject;
    protected var _name :String;
    protected var _group :String;

    protected var _touchable :Touchable; // lazily instantiated
}

}
