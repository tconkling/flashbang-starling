//
// Flashbang

package flashbang.objects {

import starling.display.DisplayObject;

import flashbang.GameObject;
import flashbang.components.DisplayComponent;

/**
 * A convenience class that implements DisplayComponent and manages a displayObject directly.
 */
public class SceneObject extends GameObject
    implements DisplayComponent
{
    public function SceneObject (displayObject :DisplayObject = null, name :String = null,
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

    public function get display () :DisplayObject
    {
        return _displayObject;
    }

    protected var _displayObject :DisplayObject;
    protected var _name :String;
    protected var _group :String;
}

}
