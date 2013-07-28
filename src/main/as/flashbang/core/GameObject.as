//
// Flashbang

package flashbang.core {

import aspire.util.Preconditions;

public class GameObject extends GameObjectBase
    implements GameObjectContainer
{
    public function addObject (obj :GameObjectBase) :GameObjectRef {
        return addObjectInternal(obj, null, false);
    }

    public function addNamedObject (name :String, obj :GameObjectBase) :GameObjectRef {
        return addObjectInternal(obj, name, false);
    }

    public function replaceNamedObject (name :String, obj :GameObjectBase) :GameObjectRef {
        return addObjectInternal(obj, name, true);
    }

    public function getNamedObject (name :String) :GameObjectBase {
        var cur :GameObjectRef = _children;
        while (cur != null) {
            if (cur._obj != null && cur._obj._name == name) {
                return cur._obj;
            }
            cur = cur._next;
        }
        return null;
    }

    public function hasNamedObject (name :String) :Boolean {
        return getNamedObject(name) != null;
    }

    public function removeObject (obj :GameObjectBase) :void {
        Preconditions.checkArgument(obj._parent == this, "We don't own this object");

        // We may be in the middle of being removed ourselves, in which case this object
        // will be removed automatically.
        if (this.wasRemoved) {
            return;
        }

        // remove from the list
        var ref :GameObjectRef = obj._ref;
        var prev :GameObjectRef = ref._prev;
        var next :GameObjectRef = ref._next;

        if (null != prev) {
            prev._next = next;
        } else {
            // if prev is null, ref was the head of the list
            Preconditions.checkState(ref == _children);
            _children = next;
        }

        if (null != next) {
            next._prev = prev;
        }

        // object performs cleanup
        obj.removedInternal();
    }

    public function removeNamedObjects (name :String) :void {
        removeObjects(function (obj :GameObjectBase) :Boolean {
            return obj._name == name;
        });
    }

    protected function removeObjects (pred :Function) :void {
        var cur :GameObjectRef = _children;
        while (cur != null) {
            var next :GameObjectRef = cur._next;
            var obj :GameObjectBase = cur._obj;
            if (obj != null && pred(obj)) {
                removeObject(obj);
            }
            cur = next;
        }
    }

    internal function addObjectInternal (obj :GameObjectBase,
        name :String, replaceExisting :Boolean) :GameObjectRef {

        // Object initialization happens here.
        // Uninitialization happens in GameObjectBase.removedInternal

        Preconditions.checkState(!this.wasRemoved, "cannot add to an object that's been removed");
        Preconditions.checkArgument(obj._ref == null, "cannot re-parent GameObjects");

        if (name != null && replaceExisting) {
            removeNamedObjects(name);
        }

        // create a new GameObjectRef
        var ref :GameObjectRef = new GameObjectRef();
        ref._obj = obj;

        // add the ref to the list
        var oldListHead :GameObjectRef = _children;
        _children = ref;

        if (null != oldListHead) {
            ref._next = oldListHead;
            oldListHead._prev = ref;
        }

        // object name
        obj._name = name;
        obj._parent = this;
        obj._ref = ref;

        if (_mode != null) {
            registerObject(obj);
        } else {
            if (_pendingChildren == null) {
                _pendingChildren = new Vector.<GameObjectRef>();
            }
            _pendingChildren.push(ref);
        }

        return ref;
    }

    internal function registerObject (obj :GameObjectBase) :void {
        _mode.registerObjectInternal(obj);
        obj._mode = _mode;
        obj.addedInternal();
    }

    override internal function addedInternal () :void {
        super.addedInternal();
        if (_pendingChildren != null) {
            for each (var ref :GameObjectRef in _pendingChildren) {
                registerObject(ref._obj);
            }
        }
        _pendingChildren = null;
    }

    override internal function removedInternal () :void {
        // null out ref immediately - so that we're not considered "live"
        // while children are being removed - rather than waiting for
        // GameObjectBase.removedInternal to do it at the end of the function
        _ref._obj = null;

        var cur :GameObjectRef = _children;
        _children = null;
        while (cur != null) {
            var next :GameObjectRef = cur._next;
            if (cur._obj != null) {
                // call removedInternal directly - we don't need to tear down
                // our child list piece by piece
                cur._obj.removedInternal();
            }
            cur = next;
        }

        super.removedInternal();
    }

    override internal function disposeInternal () :void {
        _ref._obj = null;
        // dispose our children
        var cur :GameObjectRef = _children;
        _children = null;
        while (cur != null) {
            var next :GameObjectRef = cur._next;
            if (cur._obj != null) {
                cur._obj.disposeInternal();
            }
            cur = next;
        }

        super.disposeInternal();
    }

    // our child list head
    protected var _children :GameObjectRef;
    protected var _pendingChildren :Vector.<GameObjectRef>;
}

}
