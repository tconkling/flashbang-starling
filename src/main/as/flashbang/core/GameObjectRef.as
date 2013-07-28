//
// Flashbang

package flashbang.core {

import aspire.util.Preconditions;

import flashbang.components.DisplayComponent;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;

public class GameObjectRef
{
    public static function Null () :GameObjectRef {
        return NULL;
    }

    /** @return the GameObjectRef for the given GameObject, or GameObjectRef.Null() if obj is null */
    public static function forObject (obj :GameObject = null) :GameObjectRef {
        return (obj != null ? obj.ref : Null());
    }

    /**
     * Attaches the object's display component to the displayList. Returns 'this', for chaining.
     * This is purely a convenience - the client is free to do the attaching whenever.
     */
    public function displayOn (parent :DisplayObjectContainer, index :int = -1) :GameObjectRef {
        Preconditions.checkState(_obj is DisplayComponent, "obj must implement DisplayComponent");
        var disp :DisplayObject = (_obj as DisplayComponent).display;
        Preconditions.checkNotNull(disp,
            "obj must return a non-null displayObject to be attached to a display parent");

        if (index < 0 || index >= parent.numChildren) {
            parent.addChild(disp);
        } else {
            parent.addChildAt(disp, index);
        }

        return this;
    }

    public function destroyObject () :void {
        if (null != _obj) {
            _obj.destroySelf();
        }
    }

    public function get object () :* {
        return _obj;
    }

    public function get isLive () :Boolean {
        return (null != _obj);
    }

    public function get isNull () :Boolean {
        return (null == _obj);
    }

    // managed by ObjectDB
    internal var _obj :GameObjectBase;
    internal var _next :GameObjectRef;
    internal var _prev :GameObjectRef;

    // We expose this through a function (above), rather than directly, because
    // member variable assignments of another class's static member don't work:
    // class Foo { public var ref :GameObjectRef = GameObjectRef.NULL; }
    // (ref will be initialized to null, rather than GameObjectRef.NULL).
    protected static const NULL :GameObjectRef = new GameObjectRef();
}

}
