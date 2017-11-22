//
// Flashbang

package flashbang.core {

import aspire.util.Arrays;
import aspire.util.Map;
import aspire.util.Maps;
import aspire.util.Preconditions;
import aspire.util.maps.ValueComputingMap;

import flashbang.input.KeyboardInput;
import flashbang.input.MouseWheelEvent;
import flashbang.input.MouseWheelInput;
import flashbang.input.TouchInput;
import flashbang.util.Listeners;

import flump.display.MoviePlayer;

import react.Registration;
import react.Registrations;
import react.Signal;
import react.SignalView;
import react.UnitSignal;

import starling.display.DisplayObjectContainer;
import starling.display.Sprite;
import starling.events.KeyboardEvent;
import starling.events.Touch;

public class AppMode
    implements GameObjectContainer
{
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
        _rootObject = new RootObject(this);
    }

    public function get regs () :Listeners {
        return _regs;
    }

    public final function get modeSprite () :Sprite {
        return _modeSprite;
    }

    /** Returns the ModeStack that this AppMode lives in */
    public final function get modeStack () :ModeStack {
        return _modeStack;
    }

    public function get updateBegan () :SignalView {
        return _update;
    }

    public function get willRender () :SignalView {
        return _willRender;
    }

    public function get touchInput () :TouchInput {
        return _touchInput;
    }

    public function get keyboardInput () :KeyboardInput {
        return _keyboardInput;
    }

    public function get mouseWheelInput () :MouseWheelInput {
        return _mouseWheelInput;
    }

    /** Removes the singleton of the given class from the ObjectDB, if it exists. */
    public function destroySingleton (clazz :Class) :void {
        destroyObjectWithId(clazz);
    }

    /** Removes the GameObject with the given id from the ObjectDB, if it exists. */
    public function destroyObjectWithId (id :Object) :void {
        var obj :GameObject = getObjectWithId(id);
        if (null != obj) {
            obj.destroySelf();
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

    /** Returns the singleton object of the given class, or null if no such object exists.  */
    public function getSingleton (clazz :Class) :* {
        return getObjectWithId(clazz);
    }

    /** Returns the object in this mode with the given ID, or null if no such object exists. */
    public function getObjectWithId (id :Object) :* {
        return _idObjects.get(id);
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

    /** @return total time the mode has been running, as measured by calls to update(). */
    public function get time () :Number {
        return _runningTime;
    }

    /** Called when the mode is active and receives touch input. */
    public function handleTouches (touches :Vector.<Touch>) :void {
        _touchInput.handleTouches(touches);
    }

    /** Called when the mode is active and receives a keyboard event. */
    public function handleKeyboardEvent (e :KeyboardEvent) :void {
        _keyboardInput.handleKeyboardEvent(e);
    }

    /** Called when the mode is active and receives a keyboard event. */
    public function handleMouseWheelEvent (e :MouseWheelEvent) :void {
        _mouseWheelInput.handleMouseWheelEvent(e);
    }

    public function addObject (obj :GameObjectBase,
        displayParent :DisplayObjectContainer = null, displayIdx :int = -1) :GameObjectRef {
        return _rootObject.addObject(obj, displayParent, displayIdx);
    }

    public function addNamedObject (name :String, obj :GameObjectBase,
        displayParent :DisplayObjectContainer = null, displayIdx :int = -1) :GameObjectRef {
        return _rootObject.addNamedObject(name, obj, displayParent, displayIdx);
    }

    public function replaceNamedObject (name :String, obj :GameObjectBase,
        displayParent :DisplayObjectContainer = null, displayIdx :int = -1) :GameObjectRef {
        return _rootObject.replaceNamedObject(name, obj, displayParent, displayIdx);
    }

    public function getNamedObject (name :String) :GameObjectBase {
        return _rootObject.getNamedObject(name);
    }

    public function hasNamedObject (name :String) :Boolean {
        return _rootObject.hasNamedObject(name);
    }

    public function removeObject (obj :GameObjectBase) :void {
        _rootObject.removeObject(obj);
    }

    public function removeNamedObjects (name :String) :void {
        _rootObject.removeNamedObjects(name);
    }

    public function get isLiveObject () :Boolean {
        return !_disposed;
    }

    /**
     * Schedules the given function to execute when the mode is active. If the mode is currently
     * active, the function will be executed immediately. This can be useful for asynchronous
     * logic that must execute within the mode.
     */
    public function whenActive (f :Function) :Registration {
        if (_active) {
            f();
            return Registrations.Null();
        } else {
            return _entered.connect(f).once();
        }
    }

    /** Called once per update tick. Updates all objects in the mode. */
    protected function update (dt :Number) :void {
        _runningTime += dt;
        // update all Updatable objects
        _update.emit(dt);
        // update Movies
        _moviePlayer.advanceTime(dt);
    }

    /** Called right before Starling renders the display list. */
    protected function render () :void {
        _willRender.emit();
    }

    /** Called when the mode is added to the mode stack */
    protected function setup () :void {
    }

    /** Called when the mode is removed from the mode stack */
    protected function dispose () :void {
    }

    /** Called when the mode becomes active on the mode stack */
    protected function enter () :void {
    }

    /** Called when the mode becomes inactive on the mode stack */
    protected function exit () :void {
    }

    /** Called when an object is registered with the mode */
    protected function registerObject (obj :GameObjectBase) :void {
    }

    internal function setupInternal (modeStack :ModeStack) :void {
        _modeStack = modeStack;
        _touchInput = new TouchInput(_modeSprite);
        _moviePlayer = new MoviePlayer(_modeSprite);
        setup();
    }

    internal function disposeInternal () :void {
        Preconditions.checkState(!_disposed, "already disposed");
        _disposed = true;

        dispose();

        _rootObject.disposeInternal();
        _rootObject = null;

        _idObjects = null;
        _groupedObjects = null;

        _regs.close();
        _regs = null;

        _modeStack = null;

        _touchInput.dispose();
        _touchInput = null;

        _keyboardInput.dispose();
        _keyboardInput = null;

        _mouseWheelInput.dispose();
        _mouseWheelInput = null;

        _moviePlayer.dispose();
        _moviePlayer = null;

        _modeSprite.removeFromParent(/*dispose=*/true);
        _modeSprite = null;
    }

    internal function enterInternal () :void {
        _modeSprite.touchable = true;
        _active = true;
        enter();
        _entered.emit();
    }

    internal function exitInternal () :void {
        _modeSprite.touchable = false;
        _active = false;
        exit();
    }

    internal function updateInternal (dt :Number) :void {
        update(dt);
        _updateComplete.emit();
    }

    internal function renderInternal () :void {
        render();
    }

    internal function registerObjectInternal (obj :GameObjectBase) :void {
        // Handle IDs
        var ids :Array = obj.ids;
        if (ids.length > 0) {
            _regs.add(obj.destroyed.connect(function () :void {
                for each (var id :Object in ids) {
                    _idObjects.remove(id);
                }
            }));
            for each (var id :Object in ids) {
                var existing :GameObject = _idObjects.put(id, obj);
                Preconditions.checkState(null == existing,
                    "two objects with the same ID added to the AppMode",
                    "id", id, "new", obj, "existing", existing);
            }
        }

        // Handle groups
        var groups :Array = obj.groups;
        if (groups.length > 0) {
            _regs.add(obj.destroyed.connect(function () :void {
                // perform group removal at the end of an update, so that
                // group iteration is safe during the update
                _updateComplete.connect(function () :void {
                    for each (var group :Object in groups) {
                        Arrays.removeFirst(_groupedObjects.get(group), obj.ref);
                    }
                }).once();

            }));
            for each (var group :Object in groups) {
                (_groupedObjects.get(group) as Array).push(obj.ref);
            }
        }

        // Handle Updatable and Renderable
        var updatable :Updatable = (obj as Updatable);
        if (updatable != null) {
            obj.regs.add(_update.connect(updatable.update));
        }

        var renderable :Renderable = (obj as Renderable);
        if (renderable != null) {
            obj.regs.add(_willRender.connect(renderable.willRender));
        }

        registerObject(obj);
    }

    protected const _update :Signal = new Signal(Number);
    protected const _willRender :UnitSignal = new UnitSignal();
    protected const _updateComplete :UnitSignal = new UnitSignal();
    protected const _entered :UnitSignal = new UnitSignal();

    protected var _modeSprite :Sprite = new Sprite();
    protected var _modeStack :ModeStack;
    protected var _touchInput :TouchInput;
    protected var _keyboardInput :KeyboardInput = new KeyboardInput();
    protected var _mouseWheelInput :MouseWheelInput = new MouseWheelInput();
    protected var _moviePlayer :MoviePlayer;

    protected var _runningTime :Number = 0;

    protected var _rootObject :RootObject;

    protected var _idObjects :Map = Maps.newMapOf(Object); // <Object,GameObject>
    protected var _groupedObjects :Map = ValueComputingMap.newArrayMapOf(Object);

    protected var _regs :Listeners = new Listeners();

    protected var _active :Boolean;
    protected var _disposed :Boolean;
}

}
