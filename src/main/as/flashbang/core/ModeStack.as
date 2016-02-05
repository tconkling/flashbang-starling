//
// Flashbang

package flashbang.core {

import aspire.util.Preconditions;

import flashbang.input.MouseWheelEvent;

import react.UnitSignal;

import starling.display.Sprite;
import starling.events.KeyboardEvent;
import starling.events.Touch;

/**
 * Contains all of the app's AppMode objects. Only the top-most mode in the stack gets updates
 * and other events - all other modes are inactive.
 */
public class ModeStack
{
    public const topModeChanged :UnitSignal = new UnitSignal();
    public const disposed :UnitSignal = new UnitSignal();

    public function ModeStack (parentSprite :Sprite) {
        parentSprite.addChild(_topSprite);
    }

    /**
     * Returns the number of modes currently on the mode stack. Be aware that this value might be
     * about to change if mode transitions have been queued that have not yet been processed.
     */
    public function get length () :int {
        return _modeStack.length;
    }

    /**
     * Returns the top mode on the mode stack, or null
     * if the stack is empty.
     */
    public final function get topMode () :AppMode {
        return (_modeStack.length > 0 ? _modeStack[_modeStack.length - 1] : null);
    }

    /**
     * Applies the specify mode transition to the mode stack.
     * (Mode changes take effect between game updates.)
     */
    public function doModeTransition (type :ModeTransition, mode :AppMode = null, index :int = 0)
        :void
    {
        if (type.requiresMode && mode == null) {
            throw new Error("mode must be non-null for " + type);
        }

        var transition :PendingTransition = new PendingTransition();
        transition.type = type;
        transition.mode = mode;
        transition.index = index;
        _pendingModeTransitionQueue.push(transition);
    }

    /**
     * Inserts a mode into the stack at the specified index. All modes
     * at and above the specified index will move up in the stack.
     * (Mode changes take effect between game updates.)
     *
     * @param mode the AppMode to add
     * @param index the stack position to add the mode at.
     * You can use a negative integer to specify a position relative
     * to the top of the stack (for example, -1 is the top of the stack).
     */
    public function insertMode (mode :AppMode, index :int) :void {
        doModeTransition(ModeTransition.INSERT, mode, index);
    }

    /**
     * Removes a mode from the stack at the specified index. All
     * modes above the specified index will move down in the stack.
     * (Mode changes take effect between game updates.)
     *
     * @param index the stack position to add the mode at.
     * You can use a negative integer to specify a position relative
     * to the top of the stack (for example, -1 is the top of the stack).
     */
    public function removeMode (index :int) :void {
        doModeTransition(ModeTransition.REMOVE, null, index);
    }

    /**
     * Pops the top mode from the stack, if the modestack is not empty, and pushes
     * a new mode in its place.
     * (Mode changes take effect between game updates.)
     */
    public function changeMode (mode :AppMode) :void {
        doModeTransition(ModeTransition.CHANGE, mode);
    }

    /**
     * Pushes a mode to the mode stack.
     * (Mode changes take effect between game updates.)
     */
    public function pushMode (mode :AppMode) :void {
        doModeTransition(ModeTransition.PUSH, mode);
    }

    /**
     * Pops the top mode from the mode stack.
     * (Mode changes take effect between game updates.)
     */
    public function popMode () :void {
        doModeTransition(ModeTransition.REMOVE, null, -1);
    }

    /**
     * Pops all modes from the mode stack.
     * Mode changes take effect before game updates.
     */
    public function popAllModes () :void {
        doModeTransition(ModeTransition.UNWIND);
    }

    /**
     * Pops modes from the stack until the specified mode is reached.
     * If the specified mode is not reached, it will be pushed to the top
     * of the mode stack.
     * Mode changes take effect before game updates.
     */
    public function unwindToMode (mode :AppMode) :void {
        doModeTransition(ModeTransition.UNWIND, mode);
    }

    public function update (dt :Number) :void {
        if (_pendingModeTransitionQueue.length > 0) {
            // handleModeTransition generates a lot of garbage in memory, avoid calling it on
            // updates where it will NOOP anyway.
            handleModeTransitions();
        }

        // update the top mode
        if (_modeStack.length > 0) {
            _modeStack[_modeStack.length - 1].updateInternal(dt);
        }
    }

    /**
     * Called when the viewport receives touches.
     * By default it forwards the touches to its active mode.
     */
    public function handleTouches (touches :Vector.<Touch>) :void {
        if (_modeStack.length > 0) {
            _modeStack[_modeStack.length - 1].handleTouches(touches);
        }
    }

    /**
     * Called when the viewport receives a keyboard event.
     * By default, it forwards the event to its active mode.
     */
    public function handleKeyboardEvent (e :KeyboardEvent) :void {
        if (_modeStack.length > 0) {
            _modeStack[_modeStack.length - 1].handleKeyboardEvent(e);
        }
    }

    /**
     * Called when the viewport receives a MouseWheelEvent.
     * By default, it forwards the event to its active mode.
     */
    public function handleMouseWheelEvent (e :MouseWheelEvent) :void {
        if (_modeStack.length > 0) {
            _modeStack[_modeStack.length - 1].handleMouseWheelEvent(e);
        }
    }

    internal function handleModeTransitions () :void {
        if (_pendingModeTransitionQueue.length <= 0) {
            return;
        }

        var initialTopMode :AppMode = this.topMode;
        var self :ModeStack = this;

        function doPushMode (newMode :AppMode) :void {
            if (null == newMode) {
                throw new Error("Can't push a null mode to the mode stack");
            }

            _modeStack.push(newMode);
            _topSprite.addChild(newMode.modeSprite);

            newMode.setupInternal(self);
        }

        function doInsertMode (newMode :AppMode, index :int) :void {
            if (null == newMode) {
                throw new Error("Can't insert a null mode in the mode stack");
            }

            if (index < 0) {
                index = _modeStack.length + index;
            }
            index = Math.max(index, 0);
            index = Math.min(index, _modeStack.length);

            _modeStack.splice(index, 0, newMode);
            _topSprite.addChildAt(newMode.modeSprite, index);

            newMode.setupInternal(self);
        }

        function doRemoveMode (index :int) :void {
            if (_modeStack.length == 0) {
                throw new Error("Can't remove a mode from an empty stack");
            }

            if (index < 0) {
                index = _modeStack.length + index;
            }

            index = Math.max(index, 0);
            index = Math.min(index, _modeStack.length - 1);

            // if the top mode is removed, make sure it's exited first
            var mode :AppMode = _modeStack[index];
            if (mode == initialTopMode) {
                initialTopMode.exitInternal();
                initialTopMode = null;
            }

            mode.disposeInternal();
            _modeStack.removeAt(index);
        }

        // create a new _pendingModeTransitionQueue right now
        // so that we can properly handle mode transition requests
        // that occur during the processing of the current queue
        var transitionQueue :Vector.<PendingTransition> = _pendingModeTransitionQueue;
        _pendingModeTransitionQueue = new <PendingTransition>[];

        for each (var transition :PendingTransition in transitionQueue) {
            var mode :AppMode = transition.mode;
            switch (transition.type) {
            case ModeTransition.PUSH:
                doPushMode(mode);
                break;

            case ModeTransition.INSERT:
                doInsertMode(mode, transition.index);
                break;

            case ModeTransition.REMOVE:
                doRemoveMode(transition.index);
                break;

            case ModeTransition.CHANGE:
                // a pop followed by a push
                if (null != this.topMode) {
                    doRemoveMode(-1);
                }
                doPushMode(mode);
                break;

            case ModeTransition.UNWIND:
                // pop modes until we find the one we're looking for
                while (_modeStack.length > 0 && this.topMode != mode) {
                    doRemoveMode(-1);
                }

                Preconditions.checkState(this.topMode == mode || _modeStack.length == 0);

                if (_modeStack.length == 0 && null != mode) {
                    doPushMode(mode);
                }
                break;
            }
        }

        var topMode :AppMode = this.topMode;
        if (topMode != initialTopMode) {
            if (null != initialTopMode) {
                initialTopMode.exitInternal();
            }

            if (null != topMode) {
                topMode.enterInternal();
            }
            topModeChanged.emit();
        }
    }

    internal function clearModeStackNow () :void {
        _pendingModeTransitionQueue.length = 0;
        if (_modeStack.length > 0) {
            popAllModes();
            handleModeTransitions();
        }
    }

    internal function dispose () :void {
        clearModeStackNow();
        _modeStack = null;
        _pendingModeTransitionQueue = null;
        _topSprite.removeFromParent(/*dispose=*/true);
        _topSprite = null;
    }

    protected var _topSprite :Sprite = new Sprite();
    protected var _modeStack :Vector.<AppMode> = new <AppMode>[];
    protected var _pendingModeTransitionQueue :Vector.<PendingTransition> = new <PendingTransition>[];
}
}

import flashbang.core.AppMode;
import flashbang.core.ModeTransition;

class PendingTransition
{
    public var mode :AppMode;
    public var type :ModeTransition;
    public var index :int;
}
