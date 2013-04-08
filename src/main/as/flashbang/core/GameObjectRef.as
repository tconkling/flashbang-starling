//
// Flashbang

package flashbang.core {

public class GameObjectRef
{
    public static function Null () :GameObjectRef {
        return NULL;
    }

    /** @return the GameObjectRef for the given GameObject, or GameObjectRef.Null() if obj is null */
    public static function forObject (obj :GameObject = null) :GameObjectRef {
        return (obj != null ? obj.ref : Null());
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
    internal var _obj :GameObject;
    internal var _next :GameObjectRef;
    internal var _prev :GameObjectRef;

    // We expose this through a function (above), rather than directly, because
    // member variable assignments of another class's static member don't work:
    // class Foo { public var ref :GameObjectRef = GameObjectRef.NULL; }
    // (ref will be initialized to null, rather than GameObjectRef.NULL).
    protected static const NULL :GameObjectRef = new GameObjectRef();
}

}
