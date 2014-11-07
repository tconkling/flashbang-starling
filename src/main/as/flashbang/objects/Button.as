//
// flashbang

package flashbang.objects {

import flash.geom.Point;

import flashbang.components.Disableable;
import flashbang.core.Flashbang;
import flashbang.input.Input;
import flashbang.input.PointerListener;
import flashbang.resource.SoundResource;
import flashbang.tasks.FunctionTask;
import flashbang.tasks.SerialTask;
import flashbang.tasks.TimedTask;

import react.Registration;
import react.UnitSignal;

import starling.display.Sprite;
import starling.events.Touch;

/**
 * A button base class. Abstract.
 */
public class Button extends SpriteObject
    implements Disableable
{
    public static const DEFAULT_DOWN_SOUND :String = "sfx_button_down";

    /** Fired when the button is clicked */
    public const clicked :UnitSignal = new UnitSignal();

    public function Button (sprite :Sprite = null) {
        super(sprite);
    }

    public function get enabled () :Boolean {
        return (_state != DISABLED);
    }

    public function set enabled (val :Boolean) :void {
        if (val != this.enabled) {
            setState(val ? UP : DISABLED);
        }
    }

    /**
     * Simulates a click on the button. If it's not disabled, the button will fire the
     * clicked signal and show a short down-up animation.
     */
    public function click () :void {
        if (this.enabled) {
            this.clicked.emit();

            // We can be destroyed as the result of the clicked signal, so ensure we're still
            // live before proceeding
            if (this.isLiveObject && _state != DOWN) {
                addObject(new SerialTask(
                    new FunctionTask(function () :void { showState(DOWN); }),
                    new TimedTask(0.1),
                    new FunctionTask(function () :void { showState(_state); })));
            }
        }
    }

    /** Subclasses must override this to display the appropriate state */
    protected function showState (state :String) :void {
        throw new Error("abstract");
    }

    override protected function added () :void {
        showState(_state);

        this.hoverBegan.connect(onHoverBegan);
        this.hoverEnded.connect(onHoverEnded);
        this.touchBegan.connect(onTouchBegan);
    }

    protected function onHoverBegan () :void {
        if (_state != DISABLED) {
            this.pointerOver = true;
        }
    }

    protected function onHoverEnded () :void {
        if (_state != DISABLED) {
            this.pointerOver = false;
        }
    }

    protected function onTouchBegan () :void {
        if (this.enabled && _captureReg == null) {
            if (_pointerListener == null) {
                _pointerListener = Input.newPointerListener()
                    .onPointerMove(this.onPointerMove)
                    .onPointerEnd(this.onPointerEnd)
                    .build();
            }
            _captureReg = this.regs.add(this.mode.touchInput.registerListener(_pointerListener));
            _pointerDown = true;
            _pointerOver = true;
            updateState();
        }
    }

    protected function cancelCapture () :void {
        if (_captureReg != null) {
            _captureReg.close();
            _captureReg = null;
        }
    }

    protected function onPointerMove (touch :Touch) :void {
        this.pointerOver = hitTest(touch);
    }

    protected function onPointerEnd (touch :Touch) :void {
        _pointerDown = false;
        _pointerOver = hitTest(touch);
        updateState();
        cancelCapture();
        // emit the signal after doing everything else, because a signal handler could change
        // our state
        if (_pointerOver) {
            this.clicked.emit();
        }
    }

    protected function set pointerDown (val :Boolean) :void {
        if (_pointerDown != val) {
            _pointerDown = val;
            updateState();
        }
    }

    protected function set pointerOver (val :Boolean) :void {
        if (_pointerOver != val) {
            _pointerOver = val;
            updateState();
        }
    }

    protected function updateState () :void {
        if (_state == DISABLED) {
            return;
        }

        if (_pointerDown) {
            setState(_pointerOver ? DOWN : UP);
        } else {
            setState(_pointerOver ? OVER : UP);
        }
    }

    protected function setState (newState :String) :void {
        if (_state != newState) {
            var oldState :String = _state;
            _state = newState;
            if (_state == DISABLED) {
                cancelCapture();
            }
            showState(_state);
            playStateTransitionSound(oldState, _state);
        }
    }

    protected function hitTest (touch :Touch) :Boolean {
        P.setTo(touch.globalX, touch.globalY);
        return (_sprite.hitTest(_sprite.globalToLocal(P, P), true) != null);
    }

    /**
     * Plays a sound associated with a state transition.
     * By default, it plays the sound named "button_down", if it exists, when transitioning
     * to the DOWN state. Subclasses can override to customize the behavior.
     */
    protected function playStateTransitionSound (fromState :String, toState :String) :void {
        if (toState == DOWN) {
            var sound :SoundResource = SoundResource.get(DEFAULT_DOWN_SOUND);
            if (sound != null) {
                Flashbang.audio.playSound(sound);
            }
        }
    }

    protected var _state :String = "up";
    protected var _pointerOver :Boolean;
    protected var _pointerDown :Boolean;
    protected var _captureReg :Registration;
    protected var _pointerListener :PointerListener;

    protected static const UP :String = "up";
    protected static const DOWN :String = "down";
    protected static const OVER :String = "over";
    protected static const DISABLED :String = "disabled";

    private static const P :Point = new Point();
}
}
