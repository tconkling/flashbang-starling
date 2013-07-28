//
// flashbang

package flashbang.core {

import aspire.util.ClassUtil;
import aspire.util.StringUtil;

import flashbang.components.DisplayComponent;
import flashbang.util.Listeners;

import react.SignalView;
import react.UnitSignal;

import starling.display.DisplayObject;

public class GameObjectBase
{
    public function get destroyed () :SignalView {
        if (_destroyed == null) {
            _destroyed = new UnitSignal();
        }
        return _destroyed;
    }

    /** Subclasses can return true to have their class automatically used as an object ID */
    public function get isSingleton () :Boolean {
        return false;
    }

    /**
     * Returns the IDs of this object. (Objects can have multiple IDs.)
     * Two objects in the same mode cannot have the same ID.
     * Objects cannot change their IDs once added to a mode. An ID can be any object;
     * though it's common to use Classes and Strings.
     * <code>
     * override public function get ids () :Array {
     *     return [ "Hello", MyClass ].concat(super.ids);
     * }
     * </code>
     */
    public function get ids () :Array {
        return (this.isSingleton ? [ ClassUtil.getClass(this) ] : EMPTY_ARRAY);
    }

    /**
     * Override to return the groups that this object belongs to. E.g.:
     * <code>
     * override public function get groups () :Array {
     *     return [ "Foo", MyClass ].concat(super.groups);
     * }
     * </code>
     */
    public function get groups () :Array {
        return EMPTY_ARRAY;
    }

    /**
     * Returns the unique GameObjectRef that stores a reference to this GameObject.
     */
    public final function get ref () :GameObjectRef {
        return _ref;
    }

    public final function get parent () :GameObjectContainer {
        return _parent;
    }

    /**
     * Returns the AppMode that this object is contained in.
     */
    public final function get mode () :AppMode {
        return _mode;
    }

    /**
     * Returns the Viewport that this object is a part of
     */
    public final function get viewport () :Viewport {
        return _mode.viewport;
    }

    /**
     * Returns true if the object is in an AppMode and is "live"
     * (not pending removal from the database)
     */
    public final function get isLiveObject () :Boolean {
        return (_ref != null && _ref._obj != null);
    }

    /**
     * Removes the GameObject from its parent.
     * If a subclass needs to cleanup after itself after being destroyed, it should do
     * so either in removedFromDb or dispose.
     */
    public final function destroySelf () :void {
        if (_parent != null) {
            _parent.removeObject(this);
        }
    }

    public function get regs () :Listeners {
        if (_regs == null) {
            _regs = new Listeners();
        }
        return _regs;
    }

    public function toString () :String {
        return StringUtil.simpleToString(this, [ "ids", "groups" ]);
    }

    /**
     * Called immediately after the GameObject has been added to an AppMode.
     * (Subclasses can override this to do something useful.)
     */
    protected function added () :void {
    }

    /**
     * Called immediately after the GameObject has been removed from an AppMode.
     *
     * removedFromDB is not called when the GameObject's AppMode is removed from the mode stack.
     * For logic that must be run in this instance, see {@link #dispose}.
     *
     * (Subclasses can override this to do something useful.)
     */
    protected function removed () :void {
    }

    /**
     * Called after the GameObject has been removed from the active AppMode, or if the
     * object's containing AppMode is removed from the mode stack.
     *
     * If the GameObject is removed from the active AppMode, {@link #removedFromDB}
     * will be called before destroyed.
     *
     * {@link #dispose} should be used for logic that must be always be run when the GameObject is
     * destroyed (disconnecting event listeners, releasing resources, etc).
     *
     * (Subclasses can override this to do something useful.)
     */
    protected function dispose () :void {
    }

    internal function addedInternal () :void {
        added();
    }

    internal function removedInternal () :void {
        _ref._obj = null;
        _parent = null;
        _mode = null;

        // If we have a DisplayObject, remove it from the displayList.
        // We do *not* dispose of the DisplayObject: that is up to the implementing object.
        // SceneObject does this automatically in destroy().
        if (this is DisplayComponent) {
            var disp :DisplayObject = DisplayComponent(this).display;
            if (null != disp) {
                disp.removeFromParent();
            }
        }

        removed();
        if (_destroyed != null) {
            _destroyed.emit();
        }
        disposeInternal();
    }

    internal function disposeInternal () :void {
        _ref._obj = null;
        dispose();
        if (_regs != null) {
            _regs.close();
            _regs = null;
        }
    }

    internal function get wasRemoved () :Boolean {
        return (_ref != null && _ref._obj == null);
    }

    // lazily instantiated
    private var _regs :Listeners;
    private var _destroyed :UnitSignal;

    internal var _name :String;
    internal var _ref :GameObjectRef;
    internal var _parent :GameObjectContainer;
    internal var _mode :AppMode;

    protected static const EMPTY_ARRAY :Array = [];
}
}
