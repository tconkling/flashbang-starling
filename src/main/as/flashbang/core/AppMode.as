//
// Flashbang

package flashbang.core {

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Sprite;
import starling.events.KeyboardEvent;
import starling.events.Touch;

import aspire.util.Arrays;
import aspire.util.Map;
import aspire.util.Maps;
import aspire.util.Preconditions;
import aspire.util.maps.ValueComputingMap;

import flashbang.components.DisplayComponent;
import flashbang.input.TouchInput;
import flashbang.util.ListenerRegistrations;

import org.osflash.signals.Signal;

public class AppMode
    implements Updatable
{
    /** Dispatched when a key is pressed while this mode is active */
    public const keyDown :Signal = new Signal(KeyboardEvent);
    /** Dispatched when a key is released while this mode is active */
    public const keyUp :Signal = new Signal(KeyboardEvent);

    /**
     * A convenience function that converts an Array of GameObjectRefs into an array of GameObjects.
     * The resultant Array will not have any null objects, so it may be smaller than the Array
     * that was passed in.
     */
    public static function getObjects (objectRefs :Array) :Array {
        // Array.map would be appropriate here, except that the resultant
        // Array might contain fewer entries than the source.

        var objs :Array = [];
        for each (var ref :GameObjectRef in objectRefs) {
            if (!ref.isNull) {
                objs.push(ref.object);
            }
        }

        return objs;
    }

    public function AppMode () {
        _modeSprite.touchable = false;
    }

    public final function get modeSprite () :Sprite {
        return _modeSprite;
    }

    /** Returns the Viewport that this AppMode lives in */
    public final function get viewport () :Viewport {
        return _viewport;
    }

    public function get touchInput () :TouchInput {
        return _touchInput;
    }

    /**
     * Adds a GameObject to the ObjectDB. The GameObject must not be owned by another ObjectDB.
     *
     * If obj is a SceneObject and displayParent is not null, the function will attach
     * obj's displayObject to displayParent.
     */
    public function addObject (obj :GameObject, displayParent :DisplayObjectContainer = null,
        displayIdx :int = -1) :GameObjectRef
    {
        Preconditions.checkArgument(obj._ref == null,
            "obj must never have belonged to another AppMode");

        if (displayParent != null) {
            obj.attachToDisplayList(displayParent, displayIdx);
        }

        // create a new GameObjectRef
        var ref :GameObjectRef = new GameObjectRef();
        ref._obj = obj;

        // add the ref to the list
        var oldListHead :GameObjectRef = _listHead;
        _listHead = ref;

        if (null != oldListHead) {
            ref._next = oldListHead;
            oldListHead._prev = ref;
        }

        // initialize object
        obj._mode = this;
        obj._ref = ref;

        // does the object have names?
        for each (var objectName :String in obj.objectNames) {
            var existing :GameObject = _namedObjects.put(objectName, obj);
            Preconditions.checkState(null == existing,
                "two objects with the same name added to the AppMode",
                "name", objectName, "new", obj, "existing", existing);
        }

        // add this object to the groups it belongs to
        for each (var groupId :Object in obj.objectGroups) {
            _groupedObjects.get(groupId).push(ref);
        }

        obj.addedToModeInternal();

        ++_objectCount;

        return ref;
    }

    /** Removes a GameObject from the ObjectDB. */
    public function destroyObjectNamed (name :String) :void {
        var obj :GameObject = getObjectNamed(name);
        if (null != obj) {
            destroyObject(obj.ref);
        }
    }

    /** Removes all GameObjects in the given group from the ObjectDB. */
    public function destroyObjectsInGroup (groupId :Object) :void {
        for each (var ref :GameObjectRef in getObjectRefsInGroup(groupId)) {
            if (!ref.isNull) {
                ref.object.destroySelf();
            }
        }
    }

    /** Removes a GameObject from the ObjectDB. */
    public function destroyObject (ref :GameObjectRef) :void {
        if (null == ref) {
            return;
        }

        var obj :GameObject = ref.object;

        if (null == obj) {
            return;
        }

        if (obj is DisplayComponent) {
            // if the object is attached to a DisplayObject, and if that
            // DisplayObject is in a display list, remove it from the display list
            // so that it will no longer be drawn to the screen
            var disp :DisplayObject = DisplayComponent(obj).display;
            if (null != disp) {
                if (disp.parent != null) {
                    disp.removeFromParent(/*dispose=*/true);
                } else {
                    disp.dispose();
                }
            }
        }

        // the ref no longer points to the object
        ref._obj = null;

        // does the object have a name?
        for each (var objectName :String in obj.objectNames) {
            _namedObjects.remove(objectName);
        }

        // object group removal takes place in finalizeObjectRemoval()

        obj.removedFromModeInternal();
        obj.cleanupInternal();

        if (null == _objectsPendingRemoval) {
            _objectsPendingRemoval = new <GameObject>[];
        }

        // the ref will be unlinked from the objects list
        // at the end of the update()
        _objectsPendingRemoval.push(obj);

        --_objectCount;
    }

    /** Returns the object in this mode with the given name, or null if no such object exists. */
    public function getObjectNamed (name :String) :GameObject {
        return (_namedObjects.get(name) as GameObject);
    }

    /**
     * Returns an Array containing the object refs of all the objects in the given group.
     * This Array must not be modified by client code.
     *
     * Note: the returned Array will contain null object refs for objects that were destroyed
     * this frame and haven't yet been cleaned up.
     */
    public function getObjectRefsInGroup (groupId :Object) :Array {
        return _groupedObjects.get(groupId);
    }

    /**
     * Returns an Array containing the GameObjects in the given group.
     * The returned Array is instantiated by the function, and so can be
     * safely modified by client code.
     *
     * This function is not as performant as getObjectRefsInGroup().
     */
    public function getObjectsInGroup (groupId :Object) :Array {
        return getObjects(getObjectRefsInGroup(groupId));
    }

    /** Called once per update tick. Updates all objects in the mode. */
    public function update (dt :Number) :void {
        beginUpdate(dt);
        endUpdate(dt);
        _runningTime += dt;
    }

    /**
     * Guarantees that the "second" GameObject will have its update logic run after "first"
     * during the update loop.
     */
    public function setUpdateOrder (first :GameObject, second :GameObject) :void {
        Preconditions.checkArgument(second.mode == this && first.mode == this,
            "GameObject doesn't belong to this AppMode");
        Preconditions.checkArgument(second.isLiveObject && first.isLiveObject,
            "GameObject is not live");

        // unlink second from the list
        unlink(second);

        // relink it directly after first
        var firstRef :GameObjectRef = first._ref;
        var secondRef :GameObjectRef = second._ref;
        var nextRef :GameObjectRef = firstRef._next;

        firstRef._next = secondRef;
        secondRef._prev = firstRef;
        secondRef._next = nextRef;
        if (nextRef != null) {
            nextRef._prev = secondRef;
        }
    }

    /** Returns the number of live GameObjects in this ObjectDB. */
    public function get objectCount () :uint {
        return _objectCount;
    }

    /**
     * Returns the number of seconds this ObjectDB has been running, as measured by calls to
     * update().
     */
    public function get runningTime () :Number {
        return _runningTime;
    }

    /** Called when the mode is active and receives touch input. */
    public function handleTouches (touches :Vector.<Touch>) :void {
        _touchInput.handleTouches(touches);
    }

    /** Called when a key is pressed while this mode is active */
    public function onKeyDown (keyEvent :KeyboardEvent) :void {
        this.keyDown.dispatch(keyEvent);
    }

    /** Called when a key is released while this mode is active */
    public function onKeyUp (keyEvent :KeyboardEvent) :void {
        this.keyUp.dispatch(keyEvent);
    }

    /** Updates all objects in the mode. */
    protected function beginUpdate (dt :Number) :void {
        // update all objects

        var ref :GameObjectRef = _listHead;
        while (null != ref) {
            var obj :GameObject = ref._obj;
            if (null != obj) {
                obj.updateInternal(dt);
            }

            ref = ref._next;
        }
    }

    /** Removes dead objects from the object list at the end of an update. */
    protected function endUpdate (dt :Number) :void {
        // clean out all objects that were destroyed during the update loop

        if (null != _objectsPendingRemoval) {
            for each (var obj :GameObject in _objectsPendingRemoval) {
                finalizeObjectRemoval(obj);
            }

            _objectsPendingRemoval = null;
        }
    }

    /** Removes a single dead object from the object list. */
    protected function finalizeObjectRemoval (obj :GameObject) :void {
        Preconditions.checkState(null != obj._ref && null == obj._ref._obj);

        // unlink the object ref
        unlink(obj);

        // remove the object from the groups it belongs to
        // (we do this here, rather than in destroyObject(),
        // because client code might be iterating an
        // object group Array when destroyObject is called)
        var ref :GameObjectRef = obj._ref;
        for each (var groupId :Object in obj.objectGroups) {
            var wasInArray :Boolean = Arrays.removeFirst(_groupedObjects.get(groupId), ref);
            Preconditions.checkState(wasInArray,
                "destroyed GameObject is returning different object groups than it did on creation",
                "obj", obj);
        }

        obj._mode = null;
    }

    /**
     * Unlinks the GameObject from the db's linked list of objects. This happens during
     * object removal. It generally should not be called directly.
     */
    protected function unlink (obj :GameObject) :void {
        var ref :GameObjectRef = obj._ref;

        var prev :GameObjectRef = ref._prev;
        var next :GameObjectRef = ref._next;

        if (null != prev) {
            prev._next = next;
        } else {
            // if prev is null, ref was the head of the list
            Preconditions.checkState(ref == _listHead);
            _listHead = next;
        }

        if (null != next) {
            next._prev = prev;
        }
    }

    /** Called when the mode is added to the mode stack */
    protected function setup () :void {
    }

    /** Called when the mode is removed from the mode stack */
    protected function destroy () :void {
    }

    /** Called when the mode becomes active on the mode stack */
    protected function enter () :void {
    }

    /** Called when the mode becomes inactive on the mode stack */
    protected function exit () :void {
    }

    internal function setupInternal (viewport :Viewport) :void {
        _viewport = viewport;
        _touchInput = new TouchInput(_modeSprite);
        setup();
    }

    internal function destroyInternal () :void {
        Preconditions.checkState(!_destroyed, "already destroyed");
        _destroyed = true;

        destroy();

        var ref :GameObjectRef = _listHead;
        while (null != ref) {
            if (!ref.isNull) {
                var obj :GameObject = ref._obj;
                ref._obj = null;
                obj.cleanupInternal();
            }

            ref = ref._next;
        }

        _listHead = null;
        _objectCount = 0;
        _objectsPendingRemoval = null;
        _namedObjects = null;
        _groupedObjects = null;

        _regs.cancel();
        _regs = null;

        _viewport = null;

        _touchInput.shutdown();
        _touchInput = null;

        _modeSprite.removeFromParent(/*dispose=*/true);
        _modeSprite = null;
    }

    internal function enterInternal () :void {
        _modeSprite.touchable = true;
        enter();
    }

    internal function exitInternal () :void {
        _modeSprite.touchable = false;
        exit();
    }

    protected var _modeSprite :Sprite = new Sprite();
    protected var _viewport :Viewport;
    protected var _touchInput :TouchInput;

    protected var _runningTime :Number = 0;

    protected var _listHead :GameObjectRef;
    protected var _objectCount :uint;

    protected var _objectsPendingRemoval :Vector.<GameObject>;

    /** stores a mapping from String to Object */
    protected var _namedObjects :Map = Maps.newMapOf(String);

    protected var _groupedObjects :Map = ValueComputingMap.newArrayMapOf(Object);

    protected var _regs :ListenerRegistrations = new ListenerRegistrations();

    protected var _destroyed :Boolean;
}

}
